import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/time_tracking_provider.dart';
import '../providers/task_provider.dart';
import '../services/task_service.dart';
import 'modern_background.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeTrackingProvider>(
      builder: (context, timeProvider, child) {
        return Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 350,
              maxHeight: 350,
            ),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: GlassCard(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                borderRadius: 200,
                opacity: 0.2,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Círculo de progresso de fundo (cinza)
                    CustomPaint(
                      size: const Size(300, 300),
                      painter: CircularProgressPainter(
                        progress: 1.0,
                        color: Colors.white.withValues(alpha: 0.3),
                        strokeWidth: 8,
                      ),
                    ),
                    
                    // Círculo de progresso principal (branco brilhante)
                    CustomPaint(
                      size: const Size(300, 300),
                      painter: CircularProgressPainter(
                        progress: _getProgressValue(timeProvider),
                        color: Colors.white,
                        strokeWidth: 8,
                      ),
                    ),
                    
                    // Conteúdo central
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Texto de contexto
                        if (timeProvider.isTimerRunning)
                          Text(
                            timeProvider.currentRunningTimer?.description ?? 'Trabalhando',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        else
                          Text(
                            'Pronto para começar',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        
                        const SizedBox(height: 8),
                        
                        // Label "FOCUS"
                        const Text(
                          'FOCUS',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Timer principal
                        Text(
                          timeProvider.formattedCurrentDuration,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'monospace',
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Tempo adicional (como o "00:00" menor da imagem)
                        Text(
                          _getSubTime(timeProvider),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 16,
                            fontFamily: 'monospace',
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Contador de sessões/tarefas
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              _getSessionCount(timeProvider).toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    // Botão de controle posicionado na parte inferior
                    Positioned(
                      bottom: 16,
                      child: GestureDetector(
                        onTap: () {
                          if (timeProvider.isTimerRunning) {
                            timeProvider.stopTimer();
                          } else {
                            _showStartTimerDialog(context);
                          }
                        },
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: timeProvider.isTimerRunning 
                                ? const Color(0xFFFF453A) 
                                : const Color(0xFF34C759), // Verde quando parado
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (timeProvider.isTimerRunning 
                                    ? const Color(0xFFFF453A) 
                                    : const Color(0xFF34C759)).withValues(alpha: 0.3),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Icon(
                            timeProvider.isTimerRunning ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showStartTimerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const StartTimerDialog(),
    );
  }

  // Funções auxiliares para o timer widget
  double _getProgressValue(timeProvider) {
    if (!timeProvider.isTimerRunning) return 0.0;
    
    // Calcula progresso baseado no tempo decorrido
    // Considera 25 minutos como 100% (técnica Pomodoro)
    const maxSeconds = 25 * 60; // 25 minutos em segundos
    final elapsedSeconds = timeProvider.currentDuration;
    final progress = (elapsedSeconds / maxSeconds).clamp(0.0, 1.0);
    
    return progress;
  }

  String _getSubTime(timeProvider) {
    if (!timeProvider.isTimerRunning) return '00:00';
    
    // Mostra tempo até próxima pausa (25 min)
    const maxSeconds = 25 * 60; // 25 minutos em segundos
    final elapsedSeconds = timeProvider.currentDuration;
    final remainingSeconds = (maxSeconds - elapsedSeconds).clamp(0, maxSeconds);
    
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  int _getSessionCount(timeProvider) {
    // Retorna número de sessões completadas hoje
    return timeProvider.timeEntries
        .where((entry) {
          final today = DateTime.now();
          final entryDate = entry.startTime;
          return entryDate.year == today.year &&
                 entryDate.month == today.month &&
                 entryDate.day == today.day;
        })
        .length;
  }
}

class StartTimerDialog extends StatefulWidget {
  const StartTimerDialog({super.key});

  @override
  State<StartTimerDialog> createState() => _StartTimerDialogState();
}

class _StartTimerDialogState extends State<StartTimerDialog> {
  final _descriptionController = TextEditingController();
  Task? _selectedTask;

  @override
  void initState() {
    super.initState();
    // Carregar tarefas quando o dialog for aberto
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks();
    });
    
    // Listener para atualizar a interface quando o texto mudar
    _descriptionController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.95),
          title: const Text('Iniciar Cronômetro'),
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
          content: SizedBox(
            width: double.maxFinite,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 400),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descrição do trabalho',
                        hintText: 'O que você está fazendo?',
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Dropdown para seleção de tarefa
                    if (taskProvider.isLoading)
                      const CircularProgressIndicator()
                    else if (taskProvider.pendingTasks.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.grey),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Nenhuma tarefa pendente encontrada.',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // Navegar para a tela de tarefas
                                  Navigator.pushNamed(context, '/tasks');
                                },
                                icon: const Icon(Icons.add_task),
                                label: const Text('Criar Nova Tarefa'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selecione uma tarefa',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<Task>(
                            value: _selectedTask,
                            decoration: InputDecoration(
                              hintText: 'Selecione uma tarefa para trabalhar...',
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            items: [
                              ...taskProvider.pendingTasks.map((task) {
                                return DropdownMenuItem<Task>(
                                  value: task,
                                  child: Container(
                                    constraints: const BoxConstraints(minHeight: 50),
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        // Indicador de prioridade
                                        Container(
                                          width: 4,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: _getPriorityColor(task.priority),
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Conteúdo da tarefa
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                task.title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              if (task.description != null && task.description!.isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2),
                                                  child: Text(
                                                    task.description!,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                            onChanged: (Task? task) {
                              setState(() {
                                _selectedTask = task;
                              });
                            },
                            isExpanded: true,
                            menuMaxHeight: 300,
                            selectedItemBuilder: (BuildContext context) {
                              return taskProvider.pendingTasks.map<Widget>((Task task) {
                                return Container(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 3,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: _getPriorityColor(task.priority),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          task.title,
                                          style: const TextStyle(fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList();
                            },
                          ),
                          const SizedBox(height: 8),
                          if (_selectedTask == null && _descriptionController.text.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.blue[200]!),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Uma nova tarefa será criada automaticamente com esta descrição.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: _canStartTimer(taskProvider) ? () async {
                try {
                  String taskId;
                  String description;
                  
                  if (_selectedTask != null) {
                    // Usar tarefa selecionada
                    taskId = _selectedTask!.id!;
                    description = _descriptionController.text.isNotEmpty 
                        ? _descriptionController.text 
                        : 'Trabalhando em: ${_selectedTask!.title}';
                  } else {
                    // Se não há tarefa selecionada, criar uma tarefa temporária
                    final taskDescription = _descriptionController.text.isNotEmpty 
                        ? _descriptionController.text 
                        : 'Trabalho sem tarefa específica';
                    
                    // Criar uma tarefa temporária primeiro usando o service diretamente
                    final taskRequest = CreateTaskRequest(
                      title: taskDescription.length > 50 
                          ? '${taskDescription.substring(0, 47)}...'
                          : taskDescription,
                      description: taskDescription,
                      priority: TaskPriority.medium,
                    );
                    
                    final createdTask = await TaskService.createTask(taskRequest);
                    taskId = createdTask.id!;
                    description = taskDescription;
                    
                    // Atualizar a lista de tarefas no provider
                    if (context.mounted) {
                      await context.read<TaskProvider>().loadTasks();
                    }
                  }
                  
                  if (context.mounted) {
                    await context.read<TimeTrackingProvider>().startTimer(
                      taskId,
                      description: description,
                    );
                  }
                  
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao iniciar cronômetro: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              } : null,
              child: const Text('Iniciar'),
            ),
          ],
        );
      },
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }

  bool _canStartTimer(TaskProvider taskProvider) {
    // Pode iniciar se há pelo menos uma descrição (para criar tarefa automaticamente) 
    // OU uma tarefa foi selecionada
    return _descriptionController.text.trim().isNotEmpty || _selectedTask != null;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}

// Classe para desenhar o círculo de progresso personalizado
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 6.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Configuração do pincel
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Desenha o arco de progresso
    const startAngle = -math.pi / 2; // Começa no topo
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is CircularProgressPainter &&
           (oldDelegate.progress != progress ||
            oldDelegate.color != color ||
            oldDelegate.strokeWidth != strokeWidth);
  }
}

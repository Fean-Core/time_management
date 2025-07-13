import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_tracking_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/timer_widget.dart';

class TimeTrackingScreen extends StatelessWidget {
  const TimeTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rastreamento de Tempo'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<TimeTrackingProvider>(
        builder: (context, timeProvider, child) {
          if (timeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (timeProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(timeProvider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => timeProvider.loadTimeEntries(),
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => timeProvider.loadTimeEntries(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timer Principal
                  const TimerWidget(),
                  const SizedBox(height: 20),

                  // Estatísticas Rápidas
                  if (timeProvider.timeEntries.isNotEmpty) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Icon(Icons.timer, color: Colors.blue),
                                const SizedBox(height: 4),
                                Text(
                                  '${timeProvider.timeEntries.length}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('Registros'),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(Icons.schedule, color: Colors.green),
                                const SizedBox(height: 4),
                                Text(
                                  _formatTotalTime(timeProvider.timeEntries),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('Total'),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(Icons.today, color: Colors.orange),
                                const SizedBox(height: 4),
                                Text(
                                  _getTodayCount(timeProvider.timeEntries).toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('Hoje'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Lista de Entradas de Tempo
                  const Text(
                    'Histórico de Tempo',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  if (timeProvider.timeEntries.isEmpty)
                    const Center(
                      child: Column(
                        children: [
                          Icon(Icons.timer_off, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('Nenhum registro de tempo encontrado'),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: timeProvider.timeEntries.length,
                      itemBuilder: (context, index) {
                        final entry = timeProvider.timeEntries[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: entry.endTime == null 
                                  ? Colors.green 
                                  : Colors.blue,
                              child: Icon(
                                entry.endTime == null 
                                    ? Icons.play_arrow 
                                    : Icons.schedule,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(entry.description ?? 'Sem descrição'),
                            subtitle: Text(
                              '${_formatDateTime(entry.startTime)}${entry.endTime != null ? ' - ${_formatDateTime(entry.endTime!)}' : ' (Em andamento)'}\nDuração: ${entry.formattedDuration}',
                            ),
                            isThreeLine: true,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _showDeleteConfirmation(context, entry.id ?? ''),
                            ),
                            onTap: () => _showTimeEntryDetails(context, entry),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatTotalTime(List<dynamic> entries) {
    num totalMinutes = 0;
    for (var entry in entries) {
      totalMinutes += entry.elapsedTime.inMinutes;
    }
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  int _getTodayCount(List<dynamic> entries) {
    final today = DateTime.now();
    return entries.where((entry) {
      return entry.startTime.year == today.year &&
             entry.startTime.month == today.month &&
             entry.startTime.day == today.day;
    }).length;
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _showDeleteConfirmation(BuildContext context, String entryId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja excluir este registro de tempo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TimeTrackingProvider>().deleteTimeEntry(entryId);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _showTimeEntryDetails(BuildContext context, dynamic entry) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Consumer<TaskProvider>(
            builder: (context, taskProvider, child) {
              // Buscar a tarefa relacionada ao time entry
              final task = entry.taskId != null 
                  ? taskProvider.getTaskById(entry.taskId!)
                  : null;
              
              return Container(
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 55, 81, 151), // azul escuro
                      Color.fromARGB(255, 106, 158, 241), // azul médio
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Título principal - Nome da tarefa ou descrição
                      Text(
                        task?.title ?? 'Detalhes do Registro',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      
                      // Descrição
                      Text(
                        entry.description ?? (task?.description ?? 'Sem descrição'),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      
                      // Círculo com duração e estrela
                      Stack(
                        clipBehavior: Clip.none, // Permite que a estrela seja exibida fora dos limites
                        alignment: Alignment.center,
                        children: [
                          // Círculo principal
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color.fromARGB(255, 245, 241, 11), // amarelo
                                width: 6,
                              ),
                              color: const Color(0xFF1E3A8A),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _getDurationPercentage(entry),
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    entry.formattedDuration,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Estrela decorativa na borda inferior direita
                          Positioned(
                            bottom: -10,
                            right: 40,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 245, 241, 11),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.outlined_flag,
                                color: Color(0xFF1E3A8A),
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Informações detalhadas - Tempo total da tarefa
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A8A).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF59E0B),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.hourglass_full,
                                color: Color(0xFF1E3A8A),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tempo Total da Tarefa:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    _getTaskTotalTime(task),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '+${_getTaskTotalPoints(task)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Informações de tempo registrado
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A8A).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Color(0xFF06B6D4),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.timer,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tempo Registrado:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    entry.formattedDuration,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF06B6D4),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '+${_getTimePoints(entry)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Mostrar informações da tarefa se disponível
                      if (task != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E3A8A).withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF8B5CF6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.task_alt,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Tarefa:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    Text(
                                      task.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (task.description != null && task.description!.isNotEmpty)
                                      Text(
                                        task.description!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white60,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getPriorityColor(task.priority),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _getPriorityText(task.priority),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 32),
                      
                      // Botão Continuar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF59E0B),
                            foregroundColor: const Color(0xFF1E3A8A),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Continuar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _getDurationPercentage(dynamic entry) {
    // Calcula uma "porcentagem" baseada na duração (exemplo: cada hora = 25%)
    final hours = entry.elapsedTime.inHours;
    final minutes = entry.elapsedTime.inMinutes;
    
    if (hours > 0) {
      return '${(hours * 25).clamp(0, 100)}%';
    } else if (minutes > 0) {
      return '${(minutes * 2).clamp(0, 100)}%';
    } else {
      return '10%';
    }
  }

  String _getTimePoints(dynamic entry) {
    // Pontos baseados no tempo registrado
    final hours = entry.elapsedTime.inHours;
    return '${(hours * 10 + 20).round()}';
  }

  String _getTaskTotalTime(dynamic task) {
    // Calcula o tempo total da tarefa desde a criação até a conclusão
    if (task == null || task.createdAt == null) {
      return 'N/A';
    }
    
    final startTime = task.createdAt!;
    final endTime = task.isCompleted && task.updatedAt != null 
        ? task.updatedAt!
        : DateTime.now();
    
    final duration = endTime.difference(startTime);
    
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h ${duration.inMinutes % 60}m';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  String _getTaskTotalPoints(dynamic task) {
    // Pontos baseados no tempo total da tarefa
    if (task == null || task.createdAt == null) {
      return '0';
    }
    
    final startTime = task.createdAt!;
    final endTime = task.isCompleted && task.updatedAt != null 
        ? task.updatedAt!
        : DateTime.now();
    
    final duration = endTime.difference(startTime);
    final hours = duration.inHours;
    
    // Pontuação baseada na duração total e prioridade
    int basePoints = (hours * 5).round();
    
    // Bonus por prioridade
    if (task.priority != null) {
      switch (task.priority.toString()) {
        case 'TaskPriority.high':
          basePoints = (basePoints * 1.5).round();
          break;
        case 'TaskPriority.medium':
          basePoints = (basePoints * 1.2).round();
          break;
        case 'TaskPriority.low':
          basePoints = (basePoints * 1.0).round();
          break;
      }
    }
    
    // Bonus se a tarefa foi concluída
    if (task.isCompleted) {
      basePoints += 50;
    }
    
    return basePoints.toString();
  }

  Color _getPriorityColor(dynamic priority) {
    switch (priority.toString()) {
      case 'TaskPriority.high':
        return const Color(0xFFEF4444);
      case 'TaskPriority.medium':
        return const Color(0xFFF59E0B);
      case 'TaskPriority.low':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _getPriorityText(dynamic priority) {
    switch (priority.toString()) {
      case 'TaskPriority.high':
        return 'Alta';
      case 'TaskPriority.medium':
        return 'Média';
      case 'TaskPriority.low':
        return 'Baixa';
      default:
        return 'N/A';
    }
  }
}

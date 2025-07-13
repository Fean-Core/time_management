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
                              onPressed: () => _showDeleteConfirmation(context, entry.id),
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
    int totalMinutes = 0;
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
                      Color.fromARGB(255, 16, 80, 255), // azul escuro
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
                      
                      // Círculo com duração
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
                        child: Stack(
                          children: [
                            Center(
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
                            // Estrela decorativa centralizada na parte superior
                            Positioned(
                              top: 8,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 245, 241, 11),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.star,
                                    color: Color(0xFF1E3A8A),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Informações detalhadas
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
                                Icons.star,
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
                                    'Tempo Registrado:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    entry.formattedDuration,
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
                                '+${_getDurationPoints(entry)}',
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
                      
                      // Informações de data
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
                                Icons.schedule,
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
                                    'Período:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    '${_formatDateTime(entry.startTime)}${entry.endTime != null ? ' - ${_formatDateTime(entry.endTime!)}' : ' (Em andamento)'}',
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

  String _getDurationPoints(dynamic entry) {
    // Pontos baseados na duração
    final minutes = entry.elapsedTime.inMinutes;
    return '${(minutes * 0.5).round()}';
  }

  String _getTimePoints(dynamic entry) {
    // Pontos baseados no tempo registrado
    final hours = entry.elapsedTime.inHours;
    return '${(hours * 10 + 20).round()}';
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

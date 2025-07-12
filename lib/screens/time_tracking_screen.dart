import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_tracking_provider.dart';
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
                  
                  // Histórico de Registros
                  Text(
                    'Histórico de Tempo',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  if (timeProvider.timeEntries.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.timer_off, size: 48, color: Colors.grey),
                              SizedBox(height: 10),
                              Text('Nenhum registro de tempo encontrado'),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    for (final entry in timeProvider.timeEntries)
                      Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: entry.isRunning 
                                ? Colors.green 
                                : Colors.blue,
                            child: Icon(
                              entry.isRunning ? Icons.play_arrow : Icons.stop,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(entry.description ?? 'Sem descrição'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Duração: ${entry.formattedDuration}',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'Início: ${_formatDateTime(entry.startTime)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              if (entry.endTime != null)
                                Text(
                                  'Fim: ${_formatDateTime(entry.endTime!)}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                            ],
                          ),
                          trailing: entry.isRunning 
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _showDeleteConfirmation(
                                    context, 
                                    entry.id!,
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
}

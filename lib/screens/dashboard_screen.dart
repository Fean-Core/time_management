import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/time_tracking_provider.dart';
import '../widgets/timer_widget.dart';
import '../widgets/task_summary_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<TaskProvider>().loadTasks();
          await context.read<TimeTrackingProvider>().loadTimeEntries();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timer Widget
              const TimerWidget(),
              const SizedBox(height: 20),

              // Quick Stats
              Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  return Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Tarefas Pendentes',
                          taskProvider.pendingTasks.length.toString(),
                          Icons.pending_actions,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatCard(
                          'Concluídas',
                          taskProvider.completedTasks.length.toString(),
                          Icons.check_circle,
                          Colors.green,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),

              Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  return Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Urgentes',
                          taskProvider.urgentTasks.length.toString(),
                          Icons.priority_high,
                          Colors.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatCard(
                          'Atrasadas',
                          taskProvider.overdueTasks.length.toString(),
                          Icons.schedule,
                          Colors.deepOrange,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              // Tarefas Urgentes
              Text(
                'Tarefas Urgentes',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 600, // Largura máxima aumentada
                    minWidth: 350, // Largura mínima garantida
                  ),
                  child: Consumer<TaskProvider>(
                    builder: (context, taskProvider, child) {
                      final urgentTasks = taskProvider.urgentTasks;

                      if (urgentTasks.isEmpty) {
                        return const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('Nenhuma tarefa urgente! 🎉'),
                          ),
                        );
                      }

                      return Column(
                        children: urgentTasks.take(3).map((task) {
                          return TaskSummaryCard(task: task);
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

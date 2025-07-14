import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/time_tracking_provider.dart';
import '../widgets/timer_widget.dart';
import '../widgets/task_summary_card.dart';
import '../widgets/modern_background.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Fundo transparente para mostrar o ModernBackground
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
              // Espaçamento do topo
              const SizedBox(height: 40),
              
              // Título da tela
              GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.dashboard,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Dashboard',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Timer Widget
              const TimerWidget(),
              const SizedBox(height: 20),

              // Quick Stats
              Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  return Row(
                    children: [
                      Expanded(
                        child: SimpleCard(
                          padding: const EdgeInsets.all(16),
                          child: _buildStatContent(
                            'Tarefas Pendentes',
                            taskProvider.pendingTasks.length.toString(),
                            Icons.pending_actions,
                            Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SimpleCard(
                          padding: const EdgeInsets.all(16),
                          child: _buildStatContent(
                            'Concluídas',
                            taskProvider.completedTasks.length.toString(),
                            Icons.check_circle,
                            Colors.green,
                          ),
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
                        child: SimpleCard(
                          padding: const EdgeInsets.all(16),
                          child: _buildStatContent(
                            'Urgentes',
                            taskProvider.urgentTasks.length.toString(),
                            Icons.priority_high,
                            Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SimpleCard(
                          padding: const EdgeInsets.all(16),
                          child: _buildStatContent(
                            'Atrasadas',
                            taskProvider.overdueTasks.length.toString(),
                            Icons.schedule,
                            Colors.deepOrange,
                          ),
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

  Widget _buildStatContent(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

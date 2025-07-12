import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/task_provider.dart';
import '../providers/time_tracking_provider.dart';
import '../models/task.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedPeriod = 'Semana';

  @override
  void initState() {
    super.initState();
    // Carregar dados após o frame inicial para ter acesso ao contexto
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDataForPeriod();
    });
  }

  Future<void> _loadDataForPeriod() async {
    // Recarregar dados baseado no período selecionado
    if (mounted) {
      final taskProvider = context.read<TaskProvider>();
      final timeProvider = context.read<TimeTrackingProvider>();
      
      await taskProvider.loadTasks();
      await timeProvider.loadTimeEntries();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            initialValue: _selectedPeriod,
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
              });
              // Recarregar dados quando o período mudar
              if (mounted) {
                _loadDataForPeriod();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Dia', child: Text('Dia')),
              const PopupMenuItem(value: 'Semana', child: Text('Semana')),
              const PopupMenuItem(value: 'Mês', child: Text('Mês')),
            ],
          ),
        ],
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
              // Resumo Geral
              _buildSummaryCards(),
              const SizedBox(height: 20),
              
              // Gráfico de Tarefas por Prioridade
              _buildPriorityChart(),
              const SizedBox(height: 20),
              
              // Gráfico de Produtividade por Dia
              _buildProductivityChart(),
              const SizedBox(height: 20),
              
              // Estatísticas Detalhadas
              _buildDetailedStats(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Consumer2<TaskProvider, TimeTrackingProvider>(
      builder: (context, taskProvider, timeProvider, child) {
        // Filtrar dados baseado no período selecionado
        final filteredTimeEntries = _getFilteredTimeEntries(timeProvider.timeEntries);
        
        final totalTasks = taskProvider.tasks.length;
        final completedTasks = taskProvider.completedTasks.length;
        final totalTime = filteredTimeEntries.fold<int>(
          0, 
          (sum, entry) => sum + ((entry.duration ?? 0) as int),
        );
        
        final completionRate = totalTasks > 0 
            ? (completedTasks / totalTasks * 100).round() 
            : 0;

        return Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Taxa de Conclusão',
                '$completionRate%',
                Icons.trending_up,
                Colors.green,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSummaryCard(
                'Tempo Total',
                _formatDuration(totalTime),
                Icons.timer,
                Colors.blue,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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

  Widget _buildPriorityChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribuição de Tarefas por Prioridade',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                final priorityData = _getPriorityData(taskProvider.tasks);
                
                if (priorityData.isEmpty) {
                  return const Center(
                    child: Text('Nenhum dado disponível'),
                  );
                }

                return SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: priorityData.map((data) {
                        return PieChartSectionData(
                          value: data['value'].toDouble(),
                          title: '${data['value']}',
                          color: data['color'],
                          radius: 80,
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductivityChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Produtividade - $_selectedPeriod',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Consumer<TimeTrackingProvider>(
              builder: (context, timeProvider, child) {
                final filteredEntries = _getFilteredTimeEntries(timeProvider.timeEntries);
                
                return SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return _getBottomTitle(value.toInt());
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text('${value.toInt()}h');
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _getProductivityData(filteredEntries),
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedStats() {
    return Consumer2<TaskProvider, TimeTrackingProvider>(
      builder: (context, taskProvider, timeProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estatísticas Detalhadas',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildStatRow('Total de Tarefas', taskProvider.tasks.length.toString()),
                _buildStatRow('Tarefas Concluídas', taskProvider.completedTasks.length.toString()),
                _buildStatRow('Tarefas Pendentes', taskProvider.pendingTasks.length.toString()),
                _buildStatRow('Tarefas Urgentes', taskProvider.urgentTasks.length.toString()),
                _buildStatRow('Tarefas Atrasadas', taskProvider.overdueTasks.length.toString()),
                const Divider(),
                _buildStatRow('Registros de Tempo', timeProvider.timeEntries.length.toString()),
                _buildStatRow(
                  'Tempo Médio por Tarefa', 
                  _formatDuration(_getAverageTimePerTask(timeProvider.timeEntries)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getPriorityData(List<Task> tasks) {
    final Map<TaskPriority, int> priorityCount = {};
    final Map<TaskPriority, Color> priorityColors = {
      TaskPriority.low: Colors.green,
      TaskPriority.medium: Colors.orange,
      TaskPriority.high: Colors.red,
    };

    for (final task in tasks) {
      priorityCount[task.priority] = (priorityCount[task.priority] ?? 0) + 1;
    }

    return priorityCount.entries.map((entry) {
      return {
        'priority': entry.key,
        'value': entry.value,
        'color': priorityColors[entry.key],
      };
    }).toList();
  }

  List<FlSpot> _getProductivityData(List timeEntries) {
    // Obter dados dos últimos 7 dias baseados no período selecionado
    final now = DateTime.now();
    final spots = <FlSpot>[];
    
    int daysToShow = 7;
    switch (_selectedPeriod) {
      case 'Dia':
        daysToShow = 1;
        break;
      case 'Semana':
        daysToShow = 7;
        break;
      case 'Mês':
        daysToShow = 30;
        break;
    }
    
    // Agrupar registros por dia
    final Map<int, double> dailyHours = {};
    
    for (int i = 0; i < daysToShow; i++) {
      final date = now.subtract(Duration(days: daysToShow - 1 - i));
      final dayStart = DateTime(date.year, date.month, date.day);
      final dayEnd = dayStart.add(const Duration(days: 1));
      
      // Calcular total de horas para este dia
      double totalHours = 0;
      for (var entry in timeEntries) {
        if (entry.startTime.isAfter(dayStart) && entry.startTime.isBefore(dayEnd)) {
          totalHours += (entry.duration ?? 0) / 3600.0; // Converter segundos para horas
        }
      }
      
      dailyHours[i] = totalHours;
    }
    
    // Converter para FlSpots
    for (int i = 0; i < daysToShow; i++) {
      spots.add(FlSpot(i.toDouble(), dailyHours[i] ?? 0));
    }
    
    // Se não há dados, mostrar linha plana em zero
    if (spots.every((spot) => spot.y == 0)) {
      return List.generate(daysToShow, (index) => FlSpot(index.toDouble(), 0));
    }
    
    return spots;
  }

  List<dynamic> _getFilteredTimeEntries(List<dynamic> timeEntries) {
    final now = DateTime.now();
    DateTime startDate;
    
    switch (_selectedPeriod) {
      case 'Dia':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'Semana':
        startDate = now.subtract(Duration(days: now.weekday - 1)); // Segunda-feira
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        break;
      case 'Mês':
        startDate = DateTime(now.year, now.month, 1);
        break;
      default:
        startDate = now.subtract(const Duration(days: 7));
    }
    
    return timeEntries.where((entry) {
      return entry.startTime.isAfter(startDate);
    }).toList();
  }

  int _getAverageTimePerTask(List timeEntries) {
    if (timeEntries.isEmpty) return 0;
    final totalTime = timeEntries.fold<int>(0, (sum, entry) => sum + (entry.duration ?? 0) as int);
    return (totalTime / timeEntries.length).round();
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  Widget _getBottomTitle(int dayIndex) {
    final now = DateTime.now();
    int daysToShow = 7;
    
    switch (_selectedPeriod) {
      case 'Dia':
        daysToShow = 1;
        break;
      case 'Semana':
        daysToShow = 7;
        break;
      case 'Mês':
        daysToShow = 30;
        break;
    }
    
    if (dayIndex < 0 || dayIndex >= daysToShow) {
      return const Text('');
    }
    
    final date = now.subtract(Duration(days: daysToShow - 1 - dayIndex));
    
    if (_selectedPeriod == 'Dia') {
      return Text('${date.hour}h');
    } else if (_selectedPeriod == 'Semana') {
      const weekDays = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
      return Text(weekDays[date.weekday % 7]);
    } else {
      return Text('${date.day}/${date.month}');
    }
  }
}

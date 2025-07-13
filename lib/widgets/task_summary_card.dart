import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskSummaryCard extends StatelessWidget {
  final Task task;

  const TaskSummaryCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getPriorityColor(task.priority),
          child: Icon(
            _getPriorityIcon(task.priority),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w500,
            color: task.isCompleted ? Colors.grey : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null && task.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  task.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: task.isCompleted ? Colors.grey : null,
                  ),
                ),
              ),
            if (task.deadline != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: _isOverdue(task.deadline!) ? Colors.red : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(task.deadline!),
                      style: TextStyle(
                        fontSize: 12,
                        color: _isOverdue(task.deadline!) ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mostrar indicador de atraso se necessário
            if (!task.isCompleted && task.deadline != null && _isOverdue(task.deadline!))
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'ATRASADO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            // Checkbox principal
            Checkbox(
              value: task.isCompleted,
              onChanged: (bool? value) {
                if (value != null) {
                  _toggleTaskCompletion(context);
                }
              },
              activeColor: Colors.green,
            ),
            // Menu de opções
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) => _handleMenuAction(context, value),
                itemBuilder: (context) => [
                if (!task.isCompleted) 
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 8),
                        Text('Editar'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Excluir', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                ],
              ),
          
          ],
        ),
        onTap: () => _showTaskDetails(context),
      ),
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

  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Icons.low_priority;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.high:
        return Icons.priority_high;
    }
  }

  bool _isOverdue(DateTime deadline) {
    return deadline.isBefore(DateTime.now());
  }

  void _toggleTaskCompletion(BuildContext context) async {
    if (task.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro: Tarefa sem ID válido'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final taskProvider = context.read<TaskProvider>();
      await taskProvider.toggleTaskCompletion(task.id!);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              task.isCompleted 
                ? 'Tarefa marcada como pendente'
                : 'Tarefa concluída com sucesso!',
            ),
            backgroundColor: task.isCompleted ? Colors.orange : Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao alterar status da tarefa: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'edit':
        _showEditTaskDialog(context);
        break;
      case 'delete':
        _showDeleteConfirmationDialog(context);
        break;
    }
  }

  void _showTaskDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (task.description != null && task.description!.isNotEmpty) ...[
                const Text('Descrição:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(task.description!),
                const SizedBox(height: 16),
              ],
              const Text('Prioridade:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(_getPriorityIcon(task.priority), color: _getPriorityColor(task.priority)),
                  const SizedBox(width: 8),
                  Text(_getPriorityDisplayName(task.priority)),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(task.isCompleted ? 'Concluída' : 'Pendente'),
              if (task.deadline != null) ...[
                const SizedBox(height: 16),
                const Text('Prazo:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(task.deadline!),
                  style: TextStyle(
                    color: _isOverdue(task.deadline!) ? Colors.red : null,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
          if (!task.isCompleted)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _toggleTaskCompletion(context);
              },
              child: const Text('Concluir'),
            ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context) {
    // TODO: Implementar dialog de edição
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade de edição será implementada em breve'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    if (task.id == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja excluir a tarefa "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteTask(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTask(BuildContext context) async {
    if (task.id == null) return;

    try {
      final taskProvider = context.read<TaskProvider>();
      await taskProvider.deleteTask(task.id!);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tarefa excluída com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir tarefa: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getPriorityDisplayName(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Baixa';
      case TaskPriority.medium:
        return 'Média';
      case TaskPriority.high:
        return 'Alta';
    }
  }
}

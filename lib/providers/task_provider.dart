import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();
  List<Task> get pendingTasks => _tasks.where((task) => !task.isCompleted).toList();
  
  List<Task> get urgentTasks => _tasks
      .where((task) => !task.isCompleted && task.priority == TaskPriority.high)
      .toList();

  List<Task> get overdueTasks => _tasks
      .where((task) => 
          !task.isCompleted && 
          task.deadline != null && 
          task.deadline!.isBefore(DateTime.now()))
      .toList();

  Future<void> loadTasks() async {
    _setLoading(true);
    _setError(null);
    
    try {
      _tasks = await TaskService.getTasks();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createTask(CreateTaskRequest request) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final newTask = await TaskService.createTask(request);
      _tasks.add(newTask);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateTask(String id, UpdateTaskRequest request) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final updatedTask = await TaskService.updateTask(id, request);
      final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTask(String id) async {
    _setLoading(true);
    _setError(null);
    
    try {
      await TaskService.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleTaskCompletion(String id) async {
    try {
      final updatedTask = await TaskService.toggleTaskCompletion(id);
      final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  List<Task> getTasksByPriority(TaskPriority priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  List<Task> getTasksByCategory(String categoryId) {
    return _tasks.where((task) => task.categoryId == categoryId).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Carregar tarefas por filtros específicos
  Future<void> loadTasksByFilter({
    TaskStatus? status,
    TaskPriority? priority,
    String? categoryId,
  }) async {
    _setLoading(true);
    _setError(null);
    
    try {
      _tasks = await TaskService.getTasks(
        status: status,
        priority: priority,
        categoryId: categoryId,
      );
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Carregar tarefas atrasadas
  Future<void> loadOverdueTasks() async {
    _setLoading(true);
    _setError(null);
    
    try {
      final overdueTasks = await TaskService.getOverdueTasks();
      _tasks = overdueTasks;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Carregar tarefas de hoje
  Future<void> loadTodayTasks() async {
    _setLoading(true);
    _setError(null);
    
    try {
      final todayTasks = await TaskService.getTodayTasks();
      _tasks = todayTasks;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Concluir tarefa
  Future<void> completeTask(String id) async {
    try {
      final updatedTask = await TaskService.completeTask(id);
      final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Carregar estatísticas
  Future<Map<String, dynamic>?> loadTasksStats() async {
    try {
      return await TaskService.getTasksStats();
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }
}

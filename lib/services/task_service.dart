import '../models/task.dart';
import 'api_service.dart';

class TaskService {
  static const String endpoint = '/tasks';

  // Obter todas as tarefas do usuário
  static Future<List<Task>> getTasks({
    TaskStatus? status,
    TaskPriority? priority,
    String? categoryId,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      
      if (status != null) {
        queryParams['status'] = status.toString().split('.').last.toUpperCase();
      }
      if (priority != null) {
        queryParams['priority'] = priority.toString().split('.').last.toUpperCase();
      }
      if (categoryId != null) {
        queryParams['categoryId'] = categoryId;
      }

      final response = await ApiService.dio.get(
        endpoint,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      final List<dynamic> data = response.data;
      return data.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar tarefas: $e');
    }
  }

  // Obter tarefa por ID
  static Future<Task> getTaskById(String id) async {
    try {
      final response = await ApiService.dio.get('$endpoint/$id');
      return Task.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao buscar tarefa: $e');
    }
  }

  // Criar nova tarefa
  static Future<Task> createTask(CreateTaskRequest request) async {
    try {
      final response = await ApiService.dio.post(
        endpoint,
        data: request.toJson(),
      );
      return Task.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao criar tarefa: $e');
    }
  }

  // Atualizar tarefa
  static Future<Task> updateTask(String id, UpdateTaskRequest request) async {
    try {
      final response = await ApiService.dio.put(
        '$endpoint/$id',
        data: request.toJson(),
      );
      return Task.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao atualizar tarefa: $e');
    }
  }

  // Deletar tarefa
  static Future<void> deleteTask(String id) async {
    try {
      await ApiService.dio.delete('$endpoint/$id');
    } catch (e) {
      throw Exception('Erro ao deletar tarefa: $e');
    }
  }

  // Obter tarefas por categoria
  static Future<List<Task>> getTasksByCategory(String categoryId) async {
    return getTasks(categoryId: categoryId);
  }

  // Obter tarefas por prioridade
  static Future<List<Task>> getTasksByPriority(TaskPriority priority) async {
    return getTasks(priority: priority);
  }

  // Obter tarefas por status
  static Future<List<Task>> getTasksByStatus(TaskStatus status) async {
    return getTasks(status: status);
  }

  // Alternar conclusão da tarefa
  static Future<Task> toggleTaskCompletion(String id) async {
    try {
      final response = await ApiService.dio.patch('$endpoint/$id/toggle');
      return Task.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao alternar conclusão da tarefa: $e');
    }
  }

  // Marcar tarefa como concluída
  static Future<Task> completeTask(String id) async {
    try {
      final response = await ApiService.dio.patch('$endpoint/$id/complete');
      return Task.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao concluir tarefa: $e');
    }
  }

  // Obter tarefas atrasadas
  static Future<List<Task>> getOverdueTasks() async {
    try {
      final response = await ApiService.dio.get('$endpoint/overdue');
      final List<dynamic> data = response.data;
      return data.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar tarefas atrasadas: $e');
    }
  }

  // Obter tarefas de hoje
  static Future<List<Task>> getTodayTasks() async {
    try {
      final response = await ApiService.dio.get('$endpoint/today');
      final List<dynamic> data = response.data;
      return data.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar tarefas de hoje: $e');
    }
  }

  // Obter estatísticas das tarefas
  static Future<Map<String, dynamic>> getTasksStats() async {
    try {
      final response = await ApiService.dio.get('$endpoint/stats');
      return response.data;
    } catch (e) {
      throw Exception('Erro ao buscar estatísticas das tarefas: $e');
    }
  }
}

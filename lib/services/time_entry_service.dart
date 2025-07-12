import '../models/time_entry.dart';
import 'api_service.dart';

class TimeEntryService {
  static const String endpoint = '/time-entries';

  // Obter todos os registros de tempo do usuário
  static Future<List<TimeEntry>> getTimeEntries({
    String? taskId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      
      if (taskId != null) {
        queryParams['taskId'] = taskId;
      }
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await ApiService.dio.get(
        endpoint,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      final List<dynamic> data = response.data;
      return data.map((json) => TimeEntry.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar registros de tempo: $e');
    }
  }

  // Obter registro de tempo por ID
  static Future<TimeEntry> getTimeEntryById(String id) async {
    try {
      final response = await ApiService.dio.get('$endpoint/$id');
      return TimeEntry.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao buscar registro de tempo: $e');
    }
  }

  // Criar novo registro de tempo
  static Future<TimeEntry> createTimeEntry(CreateTimeEntryRequest request) async {
    try {
      final response = await ApiService.dio.post(
        endpoint,
        data: request.toJson(),
      );
      return TimeEntry.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao criar registro de tempo: $e');
    }
  }

  // Atualizar registro de tempo
  static Future<TimeEntry> updateTimeEntry(String id, UpdateTimeEntryRequest request) async {
    try {
      final response = await ApiService.dio.put(
        '$endpoint/$id',
        data: request.toJson(),
      );
      return TimeEntry.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao atualizar registro de tempo: $e');
    }
  }

  // Deletar registro de tempo
  static Future<void> deleteTimeEntry(String id) async {
    try {
      await ApiService.dio.delete('$endpoint/$id');
    } catch (e) {
      throw Exception('Erro ao deletar registro de tempo: $e');
    }
  }

  // Obter registros de tempo por tarefa
  static Future<List<TimeEntry>> getTimeEntriesByTask(String taskId) async {
    return getTimeEntries(taskId: taskId);
  }

  // Obter registros de tempo por período
  static Future<List<TimeEntry>> getTimeEntriesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return getTimeEntries(startDate: startDate, endDate: endDate);
  }

  // Iniciar cronômetro/timer
  static Future<TimeEntry> startTimer(StartTimerRequest request) async {
    try {
      final response = await ApiService.dio.post(
        '$endpoint/start',
        data: request.toJson(),
      );
      return TimeEntry.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao iniciar cronômetro: $e');
    }
  }

  // Parar cronômetro/timer
  static Future<TimeEntry> stopTimer(String id) async {
    try {
      final response = await ApiService.dio.post('$endpoint/$id/stop');
      return TimeEntry.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao parar cronômetro: $e');
    }
  }

  // Obter cronômetro atual em execução
  static Future<TimeEntry?> getCurrentRunningTimer() async {
    try {
      final response = await ApiService.dio.get('$endpoint/active');
      
      // Verificar se a resposta é válida e não é uma string vazia
      if (response.data != null && 
          response.data is Map<String, dynamic> && 
          response.data.isNotEmpty) {
        return TimeEntry.fromJson(response.data);
      }
      
      // Se for string vazia, null, ou outro tipo, retornar null
      return null;
    } catch (e) {
      // Se o erro for 404 (não encontrado), retornar null ao invés de erro
      if (e.toString().contains('404')) {
        return null;
      }
      throw Exception('Erro ao buscar cronômetro atual: $e');
    }
  }

  // Obter registros de tempo de hoje
  static Future<List<TimeEntry>> getTodayTimeEntries() async {
    try {
      final response = await ApiService.dio.get('$endpoint/today');
      final List<dynamic> data = response.data;
      return data.map((json) => TimeEntry.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar registros de tempo de hoje: $e');
    }
  }

  // Obter tempo total trabalhado em uma tarefa
  static Future<int> getTotalTimeForTask(String taskId) async {
    try {
      final response = await ApiService.dio.get('$endpoint/total-time/$taskId');
      return response.data['totalTime'] ?? 0;
    } catch (e) {
      throw Exception('Erro ao buscar tempo total da tarefa: $e');
    }
  }

  // Obter estatísticas de tempo
  static Future<Map<String, dynamic>> getTimeStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await ApiService.dio.get(
        '$endpoint/stats',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      return response.data;
    } catch (e) {
      throw Exception('Erro ao buscar estatísticas de tempo: $e');
    }
  }
}

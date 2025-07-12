import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/time_entry.dart';
import '../services/time_entry_service.dart';

class TimeTrackingProvider extends ChangeNotifier {
  List<TimeEntry> _timeEntries = [];
  TimeEntry? _currentRunningTimer;
  bool _isLoading = false;
  String? _error;
  
  Timer? _timer;
  int _currentDuration = 0;

  List<TimeEntry> get timeEntries => _timeEntries;
  TimeEntry? get currentRunningTimer => _currentRunningTimer;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isTimerRunning => _currentRunningTimer != null;
  int get currentDuration => _currentDuration;

  String get formattedCurrentDuration {
    final hours = _currentDuration ~/ 3600;
    final minutes = (_currentDuration % 3600) ~/ 60;
    final seconds = _currentDuration % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  Future<void> loadTimeEntries() async {
    _setLoading(true);
    _setError(null);
    
    try {
      _timeEntries = await TimeEntryService.getTimeEntries();
      _currentRunningTimer = await TimeEntryService.getCurrentRunningTimer();
      
      if (_currentRunningTimer != null) {
        _startTimerTick();
      }
      
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> startTimer(String taskId, {String? description}) async {
    _setLoading(true);
    _setError(null);
    
    try {
      // Parar timer atual se existir
      if (_currentRunningTimer != null) {
        await stopTimer();
      }
      
      final request = StartTimerRequest(
        taskId: taskId,
        description: description,
      );
      
      _currentRunningTimer = await TimeEntryService.startTimer(request);
      _currentDuration = 0;
      _startTimerTick();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> stopTimer() async {
    if (_currentRunningTimer == null) return;
    
    _setLoading(true);
    _setError(null);
    
    try {
      final stoppedTimer = await TimeEntryService.stopTimer(_currentRunningTimer!.id!);
      
      // Atualizar lista de entradas
      final index = _timeEntries.indexWhere((entry) => entry.id == stoppedTimer.id);
      if (index != -1) {
        _timeEntries[index] = stoppedTimer;
      } else {
        _timeEntries.add(stoppedTimer);
      }
      
      _currentRunningTimer = null;
      _currentDuration = 0;
      _stopTimerTick();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTimeEntry(String id) async {
    _setLoading(true);
    _setError(null);
    
    try {
      await TimeEntryService.deleteTimeEntry(id);
      _timeEntries.removeWhere((entry) => entry.id == id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  List<TimeEntry> getTimeEntriesByTask(String taskId) {
    return _timeEntries.where((entry) => entry.taskId == taskId).toList();
  }

  int getTotalTimeByTask(String taskId) {
    final entries = getTimeEntriesByTask(taskId);
    return entries.fold(0, (total, entry) => total + (entry.duration ?? 0));
  }

  List<TimeEntry> getTimeEntriesByDateRange(DateTime start, DateTime end) {
    return _timeEntries.where((entry) {
      return entry.startTime.isAfter(start) && entry.startTime.isBefore(end);
    }).toList();
  }

  void _startTimerTick() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentDuration++;
      notifyListeners();
    });
  }

  void _stopTimerTick() {
    _timer?.cancel();
    _timer = null;
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

  // Criar registro de tempo manualmente
  Future<void> createTimeEntry(CreateTimeEntryRequest request) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final newEntry = await TimeEntryService.createTimeEntry(request);
      _timeEntries.add(newEntry);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Atualizar registro de tempo
  Future<void> updateTimeEntry(String id, UpdateTimeEntryRequest request) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final updatedEntry = await TimeEntryService.updateTimeEntry(id, request);
      final index = _timeEntries.indexWhere((entry) => entry.id == updatedEntry.id);
      if (index != -1) {
        _timeEntries[index] = updatedEntry;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Carregar registros de tempo com filtros
  Future<void> loadTimeEntriesWithFilters({
    String? taskId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    _setLoading(true);
    _setError(null);
    
    try {
      _timeEntries = await TimeEntryService.getTimeEntries(
        taskId: taskId,
        startDate: startDate,
        endDate: endDate,
      );
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Carregar registros de hoje
  Future<void> loadTodayTimeEntries() async {
    _setLoading(true);
    _setError(null);
    
    try {
      _timeEntries = await TimeEntryService.getTodayTimeEntries();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Obter tempo total de uma tarefa
  Future<int> getApiTotalTimeForTask(String taskId) async {
    try {
      return await TimeEntryService.getTotalTimeForTask(taskId);
    } catch (e) {
      _setError(e.toString());
      return 0;
    }
  }

  // Carregar estatísticas de tempo
  Future<Map<String, dynamic>?> loadTimeStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      return await TimeEntryService.getTimeStats(
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      _setError(e.toString());
      return null;
    }
  }
}

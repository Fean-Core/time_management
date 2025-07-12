import 'package:flutter/foundation.dart' hide Category;
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Obter categorias mais usadas
  List<Category> get mostUsedCategories => _categories.take(5).toList();

  Future<void> loadCategories() async {
    _setLoading(true);
    _setError(null);
    
    try {
      _categories = await CategoryService.getCategories();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createCategory(CreateCategoryRequest request) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final newCategory = await CategoryService.createCategory(request);
      _categories.add(newCategory);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateCategory(String id, UpdateCategoryRequest request) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final updatedCategory = await CategoryService.updateCategory(id, request);
      final index = _categories.indexWhere((cat) => cat.id == updatedCategory.id);
      if (index != -1) {
        _categories[index] = updatedCategory;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteCategory(String id) async {
    _setLoading(true);
    _setError(null);
    
    try {
      // Verificar se pode deletar
      final canDelete = await CategoryService.canDeleteCategory(id);
      if (!canDelete) {
        _setError('Não é possível deletar categoria que possui tarefas associadas');
        return;
      }

      await CategoryService.deleteCategory(id);
      _categories.removeWhere((category) => category.id == id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadMostUsedCategories({int limit = 5}) async {
    try {
      final mostUsed = await CategoryService.getMostUsedCategories(limit: limit);
      // Atualizar apenas as informações das categorias existentes
      for (final category in mostUsed) {
        final index = _categories.indexWhere((cat) => cat.id == category.id);
        if (index == -1) {
          _categories.add(category);
        }
      }
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Category> getCategoriesByName(String searchTerm) {
    return _categories
        .where((category) => 
            category.name.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
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
}

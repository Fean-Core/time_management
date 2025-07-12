import '../models/category.dart';
import 'api_service.dart';

class CategoryService {
  static const String endpoint = '/categories';

  // Obter todas as categorias do usuário
  static Future<List<Category>> getCategories() async {
    try {
      final response = await ApiService.dio.get(endpoint);
      final List<dynamic> data = response.data;
      return data.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar categorias: $e');
    }
  }

  // Obter categoria por ID
  static Future<Category> getCategoryById(String id) async {
    try {
      final response = await ApiService.dio.get('$endpoint/$id');
      return Category.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao buscar categoria: $e');
    }
  }

  // Criar nova categoria
  static Future<Category> createCategory(CreateCategoryRequest request) async {
    try {
      final response = await ApiService.dio.post(
        endpoint,
        data: request.toJson(),
      );
      return Category.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao criar categoria: $e');
    }
  }

  // Atualizar categoria
  static Future<Category> updateCategory(
    String id,
    UpdateCategoryRequest request,
  ) async {
    try {
      final response = await ApiService.dio.put(
        '$endpoint/$id',
        data: request.toJson(),
      );
      return Category.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao atualizar categoria: $e');
    }
  }

  // Deletar categoria
  static Future<void> deleteCategory(String id) async {
    try {
      await ApiService.dio.delete('$endpoint/$id');
    } catch (e) {
      throw Exception('Erro ao deletar categoria: $e');
    }
  }

  // Obter categorias mais usadas
  static Future<List<Category>> getMostUsedCategories({int limit = 5}) async {
    try {
      final response = await ApiService.dio.get(
        '$endpoint/most-used',
        queryParameters: {'limit': limit},
      );
      final List<dynamic> data = response.data;
      return data.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar categorias mais usadas: $e');
    }
  }

  // Verificar se categoria pode ser deletada (não tem tarefas)
  static Future<bool> canDeleteCategory(String id) async {
    try {
      final response = await ApiService.dio.get('$endpoint/$id/can-delete');
      return response.data['canDelete'] ?? false;
    } catch (e) {
      throw Exception('Erro ao verificar se categoria pode ser deletada: $e');
    }
  }
}

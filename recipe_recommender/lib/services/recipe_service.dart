import '../constants/api_endpoints.dart';
import 'api_service.dart';

class RecipeService {
  static Future<List<Map<String, dynamic>>> getRecipes() async {
    final response = await ApiService.get(ApiEndpoints.getRecipes);
    return List<Map<String, dynamic>>.from(response['data']);
  }

  static Future<Map<String, dynamic>> getSurpriseRecipe() async {
    final response = await ApiService.get(ApiEndpoints.surpriseMe);
    return response['data'];
  }
}

import 'package:flutter/material.dart';
import '../services/recipe_service.dart';
 
class RecipeProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _recipes = [];
  Map<String, dynamic>? _surpriseRecipe;
 
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get recipes => _recipes;
  Map<String, dynamic>? get surpriseRecipe => _surpriseRecipe;
 
  Future<void> fetchRecipes() async {
    _setLoading(true);
    _errorMessage = null;
 
    try {
      _recipes = await RecipeService.getRecipes();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }
 
  Future<void> fetchSurpriseRecipe() async {
    _setLoading(true);
    _errorMessage = null;
 
    try {
      _surpriseRecipe = await RecipeService.getSurpriseRecipe();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }
 
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
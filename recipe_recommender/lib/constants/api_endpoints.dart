class ApiEndpoints {
  static const String baseUrl = 'http://localhost:8000/api';
 
  // Authentication Endpoints
  static const String register = '$baseUrl/register';
  static const String login = '$baseUrl/login';
 
  // Recipe Endpoints
  static const String getRecipes = '$baseUrl/recipes';
  static const String surpriseMe = '$baseUrl/surprise';
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_recommender/constants/api_endpoints.dart';
 
class SurpriseMeScreen extends StatelessWidget {
  const SurpriseMeScreen({super.key});
 
  Future<Map<String, dynamic>?> _fetchSurpriseRecipe() async {
    try {
      final response = await http.get(Uri.parse(ApiEndpoints.surpriseMe));
 
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          return responseData['data'];
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surprise Me'),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _fetchSurpriseRecipe(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data == null) {
              return const Text('No surprise recipe found.');
            } else {
              final recipe = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        recipe['image_url'] ??
                            'https://via.placeholder.com/300',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        recipe['title'] ?? 'Unknown Recipe',
                        style: const TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Cuisine: ${recipe['cuisine'] ?? 'Unknown'}',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Ingredients:',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      ..._buildIngredientList(recipe['ingredients']),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Instructions:',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        recipe['instructions'] ?? 'No instructions provided.',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
 
  List<Widget> _buildIngredientList(dynamic ingredients) {
    if (ingredients is String) {
      return ingredients
          .split(',')
          .map((ingredient) => Text('- ${ingredient.trim()}'))
          .toList();
    } else if (ingredients is List) {
      return ingredients.map((ingredient) => Text('- $ingredient')).toList();
    } else {
      return [const Text('No ingredients available')];
    }
  }
}
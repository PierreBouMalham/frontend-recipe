import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _userId;
  String? _selectedCuisine;
  String? _selectedDifficulty;
  String? _selectedDietary;
  bool _isLoading = true; // Added loading state
  List<dynamic>? _recipes; // Cache recipes to avoid multiple fetches

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    int? userId = prefs.getInt('userId'); // Load user ID from storage

    if (!isLoggedIn || userId == null) {
      Navigator.pushReplacementNamed(
          context, '/login'); // Redirect unauthorized users
    } else {
      setState(() {
        _userId = userId;
      });
      await _loadUserPreferences(); // Fetch user preferences after ID is set
      await _fetchRecipes(); // Fetch initial recipes
    }
  }

  Future<void> _loadUserPreferences() async {
    if (_userId == null) return;

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/userPreferences?userId=$_userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _selectedCuisine = data['data']['preferred_cuisine'] ?? 'Any';
          _selectedDifficulty = data['data']['preferred_difficulty'] ?? 'Any';
          _selectedDietary = data['data']['dietary_restriction'] ?? 'Any';
        });
      }
    } catch (e) {
      print("Error fetching user preferences: $e");
    }
  }

  Future<void> _fetchRecipes() async {
    if (_userId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/recipes?userId=$_userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _recipes = data['data'] as List<dynamic>;
        });
      } else {
        setState(() {
          _recipes = [];
        });
      }
    } catch (e) {
      print("Error fetching recipes: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _openSettings() async {
    final result = await Navigator.pushNamed(context, '/settings');
    if (result == true) {
      // Refresh recipes if settings were updated
      await _loadUserPreferences();
      await _fetchRecipes();
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userId'); // Remove user ID on logout
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _fetchSurpriseRecipe() async {
    if (_userId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/surprise?userId=$_userId'),
      );

      if (response.statusCode == 200) {
        final recipe = jsonDecode(response.body)['data'];
        Navigator.pushNamed(
          context,
          '/recipeDetail',
          arguments: recipe,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No surprise recipe found!')),
        );
      }
    } catch (e) {
      print("Error fetching surprise recipe: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle), // Shuffle icon for "Surprise Me"
            onPressed: _fetchSurpriseRecipe,
            tooltip: 'Surprise Me',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings, // Open settings with refresh logic
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // Logout and redirect
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Show loader while fetching
            )
          : _recipes == null || _recipes!.isEmpty
              ? const Center(
                  child: Text('No recipes found.'),
                )
              : ListView.builder(
                  itemCount: _recipes!.length,
                  itemBuilder: (context, index) {
                    final recipe = _recipes![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/recipeDetail',
                          arguments: recipe,
                        );
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(recipe['title']),
                          subtitle: Text(
                              '${recipe['cuisine']} - ${recipe['difficulty']} - ${recipe['dietary_restriction']}'),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

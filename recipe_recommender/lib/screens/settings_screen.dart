import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int? _userId;
  String? _selectedCuisine = 'Any';
  String? _selectedDifficulty = 'Any';
  String? _selectedDietary = 'Any';

  final List<String> cuisines = [
    'Any',
    'Lebanese',
    'Indian',
    'Italian',
    'American',
    'Chinese'
  ];
  final List<String> difficulties = ['Any', 'Easy', 'Medium', 'Hard'];
  final List<String> dietaryOptions = [
    'Any',
    'Vegan',
    'Vegetarian',
    'Gluten-Free'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('userId'); // Get user ID from storage
    });

    if (_userId != null) {
      _loadUserPreferences();
    }
  }

  Future<void> _loadUserPreferences() async {
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

  Future<void> _saveSettings() async {
    if (_userId == null) return;

    final response = await http.post(
      Uri.parse('http://localhost:8000/api/updatePreferences'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": _userId,
        "preferred_cuisine": _selectedCuisine,
        "preferred_difficulty": _selectedDifficulty,
        "dietary_restriction": _selectedDietary,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved successfully!')),
      );
      Navigator.pop(context, true); // Signal success to HomeScreen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving settings')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCuisine,
              decoration: const InputDecoration(
                labelText: 'Preferred Cuisine',
                border: OutlineInputBorder(),
              ),
              items: cuisines
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedCuisine = value),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedDifficulty,
              decoration: const InputDecoration(
                labelText: 'Preferred Difficulty',
                border: OutlineInputBorder(),
              ),
              items: difficulties
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedDifficulty = value),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedDietary,
              decoration: const InputDecoration(
                labelText: 'Dietary Restriction',
                border: OutlineInputBorder(),
              ),
              items: dietaryOptions
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedDietary = value),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class Recipe {
  final int id;
  final String title;
  final String cuisine;
  final List<String> ingredients;
  final String instructions;
  final String imageUrl;
  final String difficulty;
  final int prepTime;
  final int cookTime;

  Recipe({
    required this.id,
    required this.title,
    required this.cuisine,
    required this.ingredients,
    required this.instructions,
    required this.imageUrl,
    required this.difficulty,
    required this.prepTime,
    required this.cookTime,
  });

  // Factory constructor for creating a Recipe from JSON
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      cuisine: json['cuisine'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: json['instructions'],
      imageUrl: json['image_url'],
      difficulty: json['difficulty'],
      prepTime: json['prep_time'],
      cookTime: json['cook_time'],
    );
  }

  // Convert a Recipe to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'cuisine': cuisine,
      'ingredients': ingredients,
      'instructions': instructions,
      'image_url': imageUrl,
      'difficulty': difficulty,
      'prep_time': prepTime,
      'cook_time': cookTime,
    };
  }
}

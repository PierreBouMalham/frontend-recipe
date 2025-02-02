class User {
  final int id;
  final String username;
  final String email;
 
  User({
    required this.id,
    required this.username,
    required this.email,
  });
 
  // Factory constructor for creating a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }
 
  // Convert a User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }
}
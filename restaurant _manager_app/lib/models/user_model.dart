class User {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['prenom'] ?? '',
      lastName: json['nom'] ?? '',
      email: json['email'] ?? '',
      phone: json['num_tel']?.toString() ?? '',
    );
  }
}

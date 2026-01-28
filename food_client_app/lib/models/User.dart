class User {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String? tel;
  final String? adresse;
  final String? token;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    this.tel,
    this.adresse,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
      tel: json['tel'],
      adresse: json['adresse'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'tel': tel,
      'adresse': adresse,
      'token': token,
    };
  }
}

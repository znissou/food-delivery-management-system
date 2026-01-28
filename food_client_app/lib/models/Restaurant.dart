class Restaurant {
  final int id;
  final String nom;
  final String adresse;
  final String tel;
  final String status;
  final String? imageUrl;

  Restaurant({
    required this.id,
    required this.nom,
    required this.adresse,
    required this.tel,
    required this.status,
    this.imageUrl,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nom: json['nom'] ?? '',
      adresse: json['adresse'] ?? '',
      tel: json['tel'] ?? '',
      status: json['status'] ?? 'closed',
      imageUrl: json['image_url'], // Assuming API might return this
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'adresse': adresse,
      'tel': tel,
      'status': status,
      'image_url': imageUrl,
    };
  }
}

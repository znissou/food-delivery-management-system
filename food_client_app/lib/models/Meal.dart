class Meal {
  final int id;
  final String nom;
  final double prix;
  final String ingredients;
  final int restaurantId;
  final String? imageUrl;

  Meal({
    required this.id,
    required this.nom,
    required this.prix,
    required this.ingredients,
    required this.restaurantId,
    this.imageUrl,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nom: json['nom'] ?? '',
      prix: json['prix'] is double ? json['prix'] : double.parse(json['prix'].toString()),
      ingredients: json['ingredients'] ?? '',
      restaurantId: json['id_restaurant'] is int ? json['id_restaurant'] : int.parse(json['id_restaurant'].toString()),
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prix': prix,
      'ingredients': ingredients,
      'id_restaurant': restaurantId,
      'image_url': imageUrl,
    };
  }
}

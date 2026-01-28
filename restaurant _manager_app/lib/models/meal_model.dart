class Meal {
  final int id;
  final String name;
  final double price;
  final String ingredients;
  final String isAvailable;
  final int? categoryId;

  Meal({
    required this.id,
    required this.name,
    required this.price,
    this.ingredients = '',
    required this.isAvailable,
    this.categoryId,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['ID'] is int ? json['ID'] : int.tryParse(json['ID']?.toString() ?? '0') ?? 0,
      name: json['nom'] ?? '',
      price: json['prix'] is num ? (json['prix'] as num).toDouble() : double.tryParse(json['prix']?.toString() ?? '0') ?? 0.0,
      ingredients: json['ingredients'] ?? '',
      isAvailable: json['disponible']?.toString() ?? '',
      categoryId: json['categorie'] is int ? json['categorie'] : int.tryParse(json['categorie']?.toString() ?? '0'),
    );
  }
}

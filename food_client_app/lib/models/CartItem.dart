class CartItem {
  final int mealId;
  final String name;
  final double price;
  int quantity;
  final String? imageUrl;

  CartItem({
    required this.mealId,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.imageUrl,
  });

  double get totalPrice => price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      mealId: json['meal_id'] is int ? json['meal_id'] : int.parse(json['meal_id'].toString()),
      name: json['name'] ?? '',
      price: json['price'] is double ? json['price'] : double.parse(json['price'].toString()),
      quantity: json['quantity'] is int ? json['quantity'] : int.parse(json['quantity'].toString()),
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meal_id': mealId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'image_url': imageUrl,
    };
  }
}

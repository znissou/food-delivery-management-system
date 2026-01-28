class Order {
  final int id;
  final String restaurantName;
  final double total;
  final String status;
  final String adresse;
  final String createdAt;

  Order({
    required this.id,
    required this.restaurantName,
    required this.total,
    required this.status,
    required this.adresse,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      restaurantName: json['restaurant'] ?? '',
      total: json['total'] is double ? json['total'] : double.parse(json['total'].toString()),
      status: json['status'] ?? 'pending',
      adresse: json['adresse'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant': restaurantName,
      'total': total,
      'status': status,
      'adresse': adresse,
      'created_at': createdAt,
    };
  }
}

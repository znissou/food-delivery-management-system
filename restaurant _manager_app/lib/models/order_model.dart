class Order {
  final int id;
  final double totalPrice;
  final String customerFirstName;
  final String customerLastName;
  final int status;
  final String address;
  final String phone;

  Order({
    required this.id,
    required this.totalPrice,
    required this.customerFirstName,
    required this.customerLastName,
    required this.status,
    required this.address,
    required this.phone,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      totalPrice: json['prix_totale'] is num ? (json['prix_totale'] as num).toDouble() : double.tryParse(json['prix_totale']?.toString() ?? '0') ?? 0.0,
      customerFirstName: json['prenom'] ?? '',
      customerLastName: json['nom'] ?? '',
      status: json['etat'] is int ? json['etat'] : int.tryParse(json['etat']?.toString() ?? '0') ?? 0,
      address: json['adresse'] ?? '',
      phone: json['tel']?.toString() ?? '',
    );
  }
}

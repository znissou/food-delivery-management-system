class Restaurant {
  final int id;
  final String name;
  final String address;
  final String phone;
  final int status; // 1 = open, 0 = closed

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.status,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['ID'] is int ? json['ID'] : int.tryParse(json['ID']?.toString() ?? '0') ?? 0,
      name: json['nom'] ?? '',
      address: json['adresse'] ?? '',
      phone: json['tel']?.toString() ?? '',
      status: json['etat'] is int ? json['etat'] : int.tryParse(json['etat']?.toString() ?? '0') ?? 0,
    );
  }

  bool get isOpen => status == 1;
}

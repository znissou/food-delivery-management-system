import 'package:flutter/material.dart';
import 'package:food_client/services/api_service.dart';
import 'package:food_client/models/CartItem.dart';
import 'package:food_client/models/ApiResponse.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late Future<ApiResponse<List<CartItem>>> _detailsFuture;
  int? _orderId;
  final ApiService _apiService = ApiService();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _orderId = args['id'] as int;
        _detailsFuture = _apiService.getOrderDetails(_orderId!);
        _initialized = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized || _orderId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("Missing arguments")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Détails Commande #$_orderId")),
      body: FutureBuilder<ApiResponse<List<CartItem>>>(
        future: _detailsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            if (snapshot.data!.hasError) {
              return Center(child: Text('Error: ${snapshot.data!.error}'));
            }

            final items = snapshot.data!.data!;
            if (items.isEmpty) {
              return const Center(child: Text("Aucun détail disponible."));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, index) {
                final item = items[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text("${item.name} x ${item.quantity}", style: const TextStyle(fontSize: 18))),
                    Text("${item.totalPrice} DA", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                );
              },
            );
          }
          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }
}

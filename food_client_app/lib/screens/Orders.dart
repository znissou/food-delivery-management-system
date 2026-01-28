import 'package:flutter/material.dart';
import 'package:food_client/services/api_service.dart';
import 'package:food_client/services/auth_service.dart';
import 'package:food_client/models/Order.dart';
import 'package:food_client/models/ApiResponse.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<ApiResponse<List<Order>>> _ordersFuture;
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService(); // Added instance
  bool _isLoggedIn = false;
  bool _isLoadingAuth = true;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final loggedIn = await _authService.isLoggedIn();
    setState(() {
      _isLoggedIn = loggedIn;
      _isLoadingAuth = false;
    });

    if (loggedIn) {
      _refresh();
    }
  }

  void _refresh() {
    setState(() {
      _ordersFuture = _apiService.getOrders(); // Used instance
    });
  }

  void goLogin() {
    Navigator.of(context).pushNamed('/login').then((_) => _checkLogin());
  }

  void goOrder(int id) {
    Navigator.of(context).pushNamed('/order', arguments: {'id': id});
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingAuth) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_isLoggedIn) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Veuillez vous connecter pour voir vos commandes"),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: goLogin, child: const Text("Se connecter")),
          ],
        ),
      );
    }

    return Scaffold(
      body: FutureBuilder<ApiResponse<List<Order>>>(
        future: _ordersFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            if (snapshot.data!.hasError) {
              return Center(child: Text('Error: ${snapshot.data!.error}'));
            }

            final orders = snapshot.data!.data!;
            if (orders.isEmpty) {
              return const Center(child: Text("Aucune commande trouvée."));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: orders.length,
              separatorBuilder: (ctx, index) => const Divider(),
              itemBuilder: (_, index) {
                final order = orders[index];
                return ListTile(
                  title: Text(order.restaurantName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text("${order.total} DA"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                  onTap: () => goOrder(order.id),
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

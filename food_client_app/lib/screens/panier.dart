import 'package:flutter/material.dart';
import 'package:food_client/services/api_service.dart';
import 'package:food_client/services/auth_service.dart';
import 'package:food_client/models/CartItem.dart';
import 'package:food_client/models/ApiResponse.dart';
import 'package:food_client/utils/helpers.dart';
import 'package:food_client/utils/constants.dart';

class PanierPage extends StatefulWidget {
  const PanierPage({super.key});

  @override
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  late Future<ApiResponse<List<CartItem>>> _cartFuture;
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final loggedIn = await _authService.isLoggedIn();
    setState(() {
      _isLoggedIn = loggedIn;
    });

    if (loggedIn) {
      _refresh();
    }
  }

  void _refresh() {
    setState(() {
      _cartFuture = _apiService.getCart();
    });
  }

  void _updateQuantity(int mealId, int currentQty, int change) async {
    final newQty = currentQty + change;
    if (newQty < 1) return;

    setState(() => _isLoading = true);
    final response = await _apiService.updateCart(mealId, newQty);
    setState(() => _isLoading = false);

    if (response.error == null) {
      _refresh();
    } else {
      AppHelpers.showSnackBar(context, response.error!, isError: true);
    }
  }

  void _removeItem(int mealId) async {
    setState(() => _isLoading = true);
    final response = await _apiService.removeFromCart(mealId);
    setState(() => _isLoading = false);

    if (response.error == null) {
      _refresh();
    } else {
      AppHelpers.showSnackBar(context, response.error!, isError: true);
    }
  }

  void _checkout() async {
    TextEditingController addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Valider la commande"),
        content: TextField(
          controller: addressController,
          decoration: const InputDecoration(hintText: "Entrez votre adresse de livraison"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () async {
              if (addressController.text.isEmpty) {
                AppHelpers.showSnackBar(context, "Veuillez entrer une adresse", isError: true);
                return;
              }
              Navigator.pop(context); // Close dialog

              setState(() => _isLoading = true);
              final response = await _apiService.createOrder(addressController.text);
              setState(() => _isLoading = false);

              if (response.error == null) {
                AppHelpers.showSnackBar(context, "Commande créée avec succès !");
                _refresh(); // Cart should be empty now
              } else {
                AppHelpers.showSnackBar(context, response.error!, isError: true);
              }
            },
            child: const Text("Confirmer"),
          ),
        ],
      ),
    );
  }

  void goLogin() {
    Navigator.of(context).pushNamed('/login').then((_) => _checkLogin());
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Veuillez vous connecter pour voir votre panier"),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: goLogin, child: const Text("Se connecter")),
          ],
        ),
      );
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: FutureBuilder<ApiResponse<List<CartItem>>>(
        future: _cartFuture,
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
              return const Center(child: Text("Votre panier est vide."));
            }

            double total = items.fold(0, (sum, item) => sum + item.totalPrice);

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(10),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, index) {
                      final item = items[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage('${ApiConstants.baseUrl}/repas/image/${item.mealId}'),
                          backgroundColor: Colors.grey[200],
                          onBackgroundImageError: (_, __) => const Icon(Icons.fastfood),
                        ),
                        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${item.price} DA x ${item.quantity}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${item.totalPrice} DA",
                              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeItem(item.mealId),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(
                            "$total DA",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _checkout,
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15), backgroundColor: AppColors.primary),
                          child: const Text("Valider la commande", style: TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }
}

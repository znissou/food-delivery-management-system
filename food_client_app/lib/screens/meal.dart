import 'package:flutter/material.dart';
import 'package:food_client/services/api_service.dart';
import 'package:food_client/utils/constants.dart';
import 'package:food_client/utils/helpers.dart';

class MealPage extends StatefulWidget {
  const MealPage({super.key});

  @override
  _MealPageState createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  int _quantity = 1;
  bool _isLoading = false;

  Map<String, dynamic>? _args;
  bool _initialized = false;
  final ApiService _apiService = ApiService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _args = args;
        _initialized = true;
      }
    }
  }

  void _addToCart() async {
    if (_args == null) return;

    setState(() => _isLoading = true);

    final mealId = _args!['id'] as int;
    final response = await _apiService.addToCart(mealId, _quantity);

    setState(() => _isLoading = false);

    if (mounted) {
      if (response.error == null) {
        AppHelpers.showSnackBar(context, "Repas ajouté au panier !");
        Navigator.pop(context);
      } else {
        // Handle 404/Duplicate logic if specific message needed, currently generic error.
        // Old code checked for 404 to say "Added already". ApiService returns success or error string.
        AppHelpers.showSnackBar(context, response.error!, isError: true);
      }
    }
  }

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized || _args == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("Missing arguments")),
      );
    }

    final id = _args!['id'];
    final name = _args!['name'] as String;
    final price = (_args!['price'] as num).toDouble();
    final ingredients = _args!['ingredients'] as String;

    final totalPrice = price * _quantity;

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                '${ApiConstants.baseUrl}/repas/image/$id',
                fit: BoxFit.cover,
                errorBuilder: (ctx, _, __) => Container(
                  color: Colors.grey,
                  child: const Icon(Icons.fastfood, size: 100, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const SizedBox(height: 10),
                  Text("Ingrédients:", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(ingredients, style: const TextStyle(fontSize: 16, color: Colors.black54)),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${totalPrice.toStringAsFixed(2)} DA", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            IconButton(onPressed: _decrement, icon: const Icon(Icons.remove)),
                            Text("$_quantity", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(onPressed: _increment, icon: const Icon(Icons.add)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _addToCart,
            icon: const Icon(Icons.add_shopping_cart),
            label: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Ajouter au panier", style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          ),
        ),
      ),
    );
  }
}

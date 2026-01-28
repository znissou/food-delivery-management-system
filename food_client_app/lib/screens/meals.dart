import 'package:flutter/material.dart';
import 'package:food_client/services/api_service.dart';
import 'package:food_client/models/Meal.dart';
import 'package:food_client/models/ApiResponse.dart';
import 'package:food_client/utils/constants.dart';

class MealsPage extends StatefulWidget {
  const MealsPage({super.key});

  @override
  _MealsPageState createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  late Future<ApiResponse<List<Meal>>> _mealsFuture;
  late int _restaurantId;
  String? _restaurantName;
  bool _initialized = false;
  final ApiService _apiService = ApiService(); // Added instance

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _restaurantId = args['id'] as int;
        _restaurantName = args['nom'] as String?;
        _mealsFuture = _apiService.getMeals(_restaurantId); // Used instance
        _initialized = true;
      }
    }
  }

  void _refresh() {
    setState(() {
      _mealsFuture = _apiService.getMeals(_restaurantId); // Used instance
    });
  }

  void viewMeal(BuildContext context, Meal meal) {
    Navigator.of(context).pushNamed('/meal', arguments: {'id': meal.id, 'name': meal.nom, 'price': meal.prix, 'ingredients': meal.ingredients});
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("Missing arguments")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_restaurantName ?? 'Meals')),
      body: FutureBuilder<ApiResponse<List<Meal>>>(
        future: _mealsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            if (snapshot.data!.hasError) {
              return Center(child: Text('Error: ${snapshot.data!.error}'));
            }

            final meals = snapshot.data!.data!;
            if (meals.isEmpty) {
              return const Center(child: Text("No meals available."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: meals.length,
              itemBuilder: (_, index) {
                final meal = meals[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    onTap: () => viewMeal(context, meal),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage('${ApiConstants.baseUrl}/repas/image/${meal.id}'),
                      backgroundColor: Colors.grey[200],
                      radius: 30,
                      onBackgroundImageError: (_, __) => const Icon(Icons.fastfood),
                    ),
                    title: Text(meal.nom, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          "${meal.prix} DA",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
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

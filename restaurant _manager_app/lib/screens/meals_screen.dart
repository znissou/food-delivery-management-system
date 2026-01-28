import 'package:flutter/material.dart';
import 'package:manager_app/models/meal_model.dart';
import 'package:manager_app/services/meal_service.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({Key? key}) : super(key: key);

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final MealService _mealService = MealService();
  late Future<List<Meal>> _mealsFuture;

  @override
  void initState() {
    super.initState();
    _refreshMeals();
  }

  void _refreshMeals() {
    setState(() {
      _mealsFuture = _mealService.getMeals();
    });
  }

  Future<void> _updatePrice(int id) async {
    final TextEditingController priceController = TextEditingController();
    await showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                "mise a jour le prix",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                      labelText: "Nouveau prix", hintText: "ex:100"),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 70),
              FloatingActionButton.extended(
                  onPressed: () async {
                    if (priceController.text.isNotEmpty) {
                      await _mealService.updatePrice(
                          id, double.tryParse(priceController.text) ?? 0);
                      _refreshMeals();
                      Navigator.pop(context);
                    }
                  },
                  label: const Text("Changer")),
              const SizedBox(height: 200),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateAvailability(int id) async {
    final TextEditingController availabilityController = TextEditingController();
    await showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                "mise a jour disponabilité ",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: availabilityController,
                  decoration: const InputDecoration(
                      labelText: "Disponibe", hintText: "ex:10"),
                  keyboardType: TextInputType.text, // Kept as text to match original
                ),
              ),
              const SizedBox(height: 70),
              FloatingActionButton.extended(
                  onPressed: () async {
                    if (availabilityController.text.isNotEmpty) {
                      await _mealService.updateAvailability(
                          id, availabilityController.text);
                      _refreshMeals();
                      Navigator.pop(context);
                    }
                  },
                  label: const Text("Changer")),
              const SizedBox(height: 200),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteMeal(int id) async {
    await _mealService.deleteMeal(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('repas suprimé'),
    ));
    _refreshMeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Meal>>(
        future: _mealsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
             // Fallback for empty list or parse error if API returns something unexpected
             return Center(child: Text("Erreur: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun repas"));
          } else {
            return ListView.separated(
              itemBuilder: (_, index) {
                 final meal = snapshot.data![index];
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: ListTile(
                        title: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 30),
                              child: Text(
                                meal.name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 30),
                            Text(
                              "${meal.price} DA",
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black45),
                            ),
                            const SizedBox(width: 30),
                            Text(
                              "${meal.isAvailable} ",
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black45),
                            ),
                            const Text(
                              "disponible",
                              style: TextStyle(color: Colors.black45),
                            )
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              meal.name,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.transparent), // Hidden placeholder to match layout?
                            ),
                            const SizedBox(width: 30),
                            IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.lightBlueAccent),
                                onPressed: () => _updatePrice(meal.id)),
                            const SizedBox(width: 60),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.lightBlueAccent,
                              ),
                              onPressed: () => _updateAvailability(meal.id),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () => _deleteMeal(meal.id),
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (_, __) => const Divider(),
              itemCount: snapshot.data!.length,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/meal/add').then((_) {
             _refreshMeals();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

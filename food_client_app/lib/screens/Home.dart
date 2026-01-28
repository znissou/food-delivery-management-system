import 'package:food_client/models/Restaurant.dart';
import 'package:food_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:food_client/services/api_service.dart';
import 'package:food_client/models/ApiResponse.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<ApiResponse<List<Restaurant>>> _restaurantsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _restaurantsFuture = _apiService.getRestaurants();
  }

  void _refresh() {
    setState(() {
      _restaurantsFuture = _apiService.getRestaurants();
    });
  }

  void viewMeals(BuildContext context, Restaurant restaurant) {
    Navigator.of(context).pushNamed('/meals', arguments: {'nom': restaurant.nom, 'id': restaurant.id});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<ApiResponse<List<Restaurant>>>(
        future: _restaurantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${snapshot.error}'),
                ElevatedButton(onPressed: _refresh, child: const Text('Retry')),
              ],
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.data!.error}'),
                  ElevatedButton(onPressed: _refresh, child: const Text('Retry')),
                ],
              );
            }

            final restaurants = snapshot.data!.data!;
            if (restaurants.isEmpty) {
              return const Text("No restaurants available.");
            }

            return RefreshIndicator(
              onRefresh: () async => _refresh(),
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: restaurants.length,
                itemBuilder: (ctx, index) {
                  final restaurant = restaurants[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: InkWell(
                      onTap: () => viewMeals(context, restaurant),
                      borderRadius: BorderRadius.circular(15),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage('${ApiConstants.baseUrl}/restaurant/image/${restaurant.id}'),
                              backgroundColor: Colors.grey[200],
                              radius: 30,
                              onBackgroundImageError: (_, __) => const Icon(Icons.restaurant),
                            ),
                            title: Text(restaurant.nom, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            trailing: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: restaurant.status == 'open' ? Colors.green : Colors.red),
                              child: const SizedBox(width: 10, height: 10),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                                    const SizedBox(width: 5),
                                    Expanded(child: Text(restaurant.adresse)),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.phone, size: 16, color: Colors.grey),
                                    const SizedBox(width: 5),
                                    Text(restaurant.tel),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const Text("Something went wrong");
        },
      ),
    );
  }
}

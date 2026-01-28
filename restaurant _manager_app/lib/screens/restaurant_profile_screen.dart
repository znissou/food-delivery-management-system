import 'package:flutter/material.dart';
import 'package:manager_app/models/restaurant_model.dart';
import 'package:manager_app/services/restaurant_service.dart';
import 'package:manager_app/utils/constants.dart';

class RestaurantProfileScreen extends StatefulWidget {
  const RestaurantProfileScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantProfileScreen> createState() => _RestaurantProfileScreenState();
}

class _RestaurantProfileScreenState extends State<RestaurantProfileScreen> {
  final RestaurantService _restaurantService = RestaurantService();
  late Future<Restaurant> _restaurantFuture;

  @override
  void initState() {
    super.initState();
    _refreshRestaurant();
  }

  void _refreshRestaurant() {
    setState(() {
      _restaurantFuture = _restaurantService.getRestaurant();
    });
  }

  Future<void> _updateAddress() async {
    final TextEditingController addressController = TextEditingController();
    await showModalBottomSheet(
      context: context,
      builder: (ctx) => SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              "Changer Adresse",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Nouvelle Adresse"),
              ),
            ),
            const SizedBox(height: 70),
            FloatingActionButton.extended(
              onPressed: () async {
                if (addressController.text.isNotEmpty) {
                  await _restaurantService.updateAddress(addressController.text);
                  _refreshRestaurant();
                  Navigator.pop(context);
                }
              },
              label: const Text("Changer"),
            ),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }

  Future<void> _updatePhone() async {
    final TextEditingController phoneController = TextEditingController();
    await showModalBottomSheet(
      context: context,
      builder: (ctx) => SingleChildScrollView(
        child: Column(
          children: [
             const SizedBox(height: 30),
            const Text(
              "Changer le numéro de telephone",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Nouveau numéro", hintText: "ex:0775******"),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 70),
            FloatingActionButton.extended(
              onPressed: () async {
                if (phoneController.text.isNotEmpty) {
                  await _restaurantService.updatePhone(phoneController.text);
                  _refreshRestaurant();
                  Navigator.pop(context);
                }
              },
              label: const Text("Changer"),
            ),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }

  Future<void> _updateState(bool isOpen) async {
    await _restaurantService.updateState(isOpen ? 1 : 0);
    _refreshRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Restaurant>(
      future: _restaurantFuture,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Erreur: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("Aucune donnée"));
        } else {
          final restaurant = snapshot.data!;
          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  CircleAvatar(
                     backgroundImage: NetworkImage("${Constants.apiBaseUrl}/restaurant/image/${restaurant.id}"),
                     radius: 50,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Text(
                      restaurant.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.blue),
                    title: const Text("Adresse"),
                    subtitle: Text(restaurant.address.isNotEmpty ? restaurant.address : "ajouter l'adresse de restaurant"),
                    trailing: IconButton(icon: const Icon(Icons.edit), onPressed: _updateAddress),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone, color: Colors.blue),
                    title: const Text("Telephone"),
                    subtitle: Text("0${restaurant.phone.isNotEmpty ? restaurant.phone : 'ajouter le telephone de restaurant'}"),
                    trailing: IconButton(icon: const Icon(Icons.edit), onPressed: _updatePhone),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: restaurant.isOpen ? Colors.green : Colors.red,
                      radius: 10,
                    ),
                    title: const Text('Etat'),
                    subtitle: Text(restaurant.isOpen ? "ouvert" : "fermé"),
                    trailing: TextButton(
                      child: Text(restaurant.isOpen ? "fermer" : "ouvrire"),
                      onPressed: () => _updateState(!restaurant.isOpen),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

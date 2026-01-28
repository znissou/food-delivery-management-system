import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manager_app/models/meal_model.dart';
import 'package:manager_app/services/storage_service.dart';
import 'package:manager_app/utils/constants.dart';

class MealService {
  final StorageService _storage = StorageService();

  Future<List<Meal>> getMeals() async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('No token found');

    final url = Uri.parse('${Constants.apiBaseUrl}/repas/restaurant');
    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Meal.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<void> createMeal(String name, String ingredients, double price, int categoryId, String? imagePath) async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('No token found');

    final url = Uri.parse('${Constants.apiBaseUrl}/repas/create');
    
    var request = http.MultipartRequest('POST', url)
      ..fields['nom'] = name
      ..fields['ingredients'] = ingredients
      ..fields['prix'] = price.toString()
      ..fields['ID_categorie'] = categoryId.toString()
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json';

    if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to create meal: ${response.statusCode}');
    }
  }

  Future<void> deleteMeal(int id) async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('No token found');

    final url = Uri.parse('${Constants.apiBaseUrl}/repas/delete');
    await http.post(
      url,
      headers: {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: {'id': id.toString()},
    );
  }

  Future<void> updatePrice(int id, double price) async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('No token found');

    final url = Uri.parse('${Constants.apiBaseUrl}/repas/update/prix');
    await http.post(
      url,
      headers: {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: {
        'id': id.toString(),
        'prix': price.toString(),
      },
    );
  }

  Future<void> updateAvailability(int id, String isAvailable) async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('No token found');

    final url = Uri.parse('${Constants.apiBaseUrl}/repas/update/disponible');
    await http.post(
      url,
      headers: {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: {
        'id': id.toString(),
        'disponible': isAvailable,
      },
    );
  }
}

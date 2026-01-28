import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:food_client/models/Restaurant.dart';
import 'package:food_client/models/Meal.dart';
import 'package:food_client/models/Order.dart';
import 'package:food_client/models/ApiResponse.dart';
import 'package:food_client/models/User.dart';
import 'package:food_client/models/CartItem.dart';
import 'package:food_client/utils/constants.dart';
import 'package:food_client/services/storage_service.dart';

class ApiService {
  final StorageService _storageService = StorageService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {'Content-type': 'application/x-www-form-urlencoded', 'Accept': 'application/json', if (token != null) 'Authorization': 'Bearer $token'};
  }

  Future<Map<String, String>> _getJsonHeaders() async {
    final token = await _storageService.getToken();
    return {'Content-Type': 'application/json', 'Accept': 'application/json', if (token != null) 'Authorization': 'Bearer $token'};
  }

  // --- Auth ---

  Future<ApiResponse<User>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
        headers: await _getHeaders(),
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final user = User.fromJson(data); // Assuming API returns user data with token
        // If API only returns token, we might need to fetch profile separately or handle it
        // Based on old code, it returns {token: "..."}
        // Let's assume we need to handle token saving in AuthService, this just returns raw response or we map what we can.
        // Actually, looking at old code: login returns {token: ...}
        // We will return a User object if possible, or just the data needed.
        // For now let's return the simplified User with token.
        return ApiResponse.success(
          User(
            id: 0, // Placeholder
            nom: '',
            prenom: '',
            email: email,
            token: data['token'],
          ),
        );
      } else {
        return ApiResponse.error('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResponse.error('Error: $e');
    }
  }

  Future<ApiResponse<User>> register(String nom, String prenom, String email, String password, String adresse, String tel) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.signup}'),
        headers: await _getHeaders(),
        body: {'nom': nom, 'prenom': prenom, 'email': email, 'password': password, 'adresse': adresse, 'tel': tel},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        return ApiResponse.success(User(id: 0, nom: nom, prenom: prenom, email: email, token: data['token']));
      } else if (response.statusCode == 403) {
        return ApiResponse.error('Account already exists');
      } else {
        return ApiResponse.error('Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResponse.error('Error: $e');
    }
  }

  // --- Restaurants ---

  Future<ApiResponse<List<Restaurant>>> getRestaurants() async {
    try {
      final response = await http.get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.restaurants}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final restaurants = data.map((e) => Restaurant.fromJson(e)).toList();
        return ApiResponse.success(restaurants);
      } else {
        return ApiResponse.error('Failed to load restaurants');
      }
    } catch (e) {
      return ApiResponse.error('Error: $e');
    }
  }

  // --- Meals ---

  Future<ApiResponse<List<Meal>>> getMeals(int restaurantId) async {
    try {
      final response = await http.get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.meals}/$restaurantId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final meals = data.map((e) => Meal.fromJson(e)).toList();
        return ApiResponse.success(meals);
      } else {
        return ApiResponse.error('Failed to load meals');
      }
    } catch (e) {
      return ApiResponse.error('Error: $e');
    }
  }

  // --- Cart ---
  // Assuming cart is managed server-side based on the prompt's functions,
  // but usually it's local. The prompt asked for `ApiService.getCart()`, so I assume there's an API.

  Future<ApiResponse<List<CartItem>>> getCart() async {
    try {
      final response = await http.post(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.cartGet}'), headers: await _getHeaders());
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final items = data.map((e) => CartItem.fromJson(e)).toList();
        return ApiResponse.success(items);
      } else {
        return ApiResponse.error('Failed to load cart');
      }
    } catch (e) {
      return ApiResponse.error('Error: $e');
    }
  }

  Future<ApiResponse<bool>> addToCart(int mealId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.cartAdd}'),
        headers: await _getHeaders(),
        body: {'meal_id': mealId.toString(), 'quantity': quantity.toString()},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(true);
      } else {
        return ApiResponse.error('Failed to add to cart');
      }
    } catch (e) {
      return ApiResponse.error('Error: $e');
    }
  }

  Future<ApiResponse<bool>> updateCart(int mealId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.cartUpdate}'),
        headers: await _getHeaders(),
        body: {'meal_id': mealId.toString(), 'quantite': quantity.toString()},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(true);
      } else {
        return ApiResponse.error('Failed to update cart');
      }
    } catch (e) {
      return ApiResponse.error('Error: $e');
    }
  }

  Future<ApiResponse<bool>> removeFromCart(int mealId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.cartRemove}'),
        headers: await _getHeaders(),
        body: {'meal_id': mealId.toString()},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(true);
      } else {
        return ApiResponse.error('Failed to remove from cart');
      }
    } catch (e) {
      return ApiResponse.error('Error: $e');
    }
  }

  // --- Orders ---

  Future<ApiResponse<List<Order>>> getOrders() async {
    try {
      final response = await http.post(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.ordersGet}'), headers: await _getHeaders());
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final orders = data.map((e) => Order.fromJson(e)).toList();
        return ApiResponse.success(orders);
      } else {
        return ApiResponse.error('Failed to load orders');
      }
    } catch (e) {
      return ApiResponse.error('Error: $e');
    }
  }

  Future<ApiResponse<bool>> createOrder(String address) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.orderCreate}'),
        headers: await _getHeaders(),
        body: {'adresse': address},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(true);
      } else {
        return ApiResponse.error('Failed to create order');
      }
    } catch (e) {
      return ApiResponse.error('Error: $e');
    }
  }

  Future<ApiResponse<List<CartItem>>> getOrderDetails(int orderId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.orderDetails}'),
        headers: await _getHeaders(),
        body: {'id_commande': orderId.toString()},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final items = data
            .map(
              (json) => CartItem(
                mealId: 0,
                name: json['nom'] ?? '',
                price: json['prix'] is double ? json['prix'] : (json['prix'] as num).toDouble(),
                quantity: json['quantite'] ?? 1,
              ),
            )
            .toList();
        return ApiResponse.success(items);
      } else {
        return ApiResponse.error('Failed to load order details');
      }
    } catch (e) {
      return ApiResponse.error('Error: $e');
    }
  }

  // --- User ---
  Future<ApiResponse<User>> getUserProfile() async {
    try {
      final response = await http.get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userProfile}'), headers: await _getHeaders());
      if (response.statusCode == 200) {
        return ApiResponse.success(User.fromJson(json.decode(response.body)));
      } else {
        return ApiResponse.error('Failed to load profile');
      }
    } catch (e) {
      return ApiResponse.error('Error: $e');
    }
  }

  Future<ApiResponse<bool>> updateProfile(String field, String value) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userUpdate}/$field'),
        headers: await _getHeaders(),
        body: {field: value},
      );
      if (response.statusCode == 200) {
        return ApiResponse.success(true);
      } else {
        return ApiResponse.error('Failed to update profile');
      }
    } catch (e) {
      return ApiResponse.error('Error: $e');
    }
  }
}

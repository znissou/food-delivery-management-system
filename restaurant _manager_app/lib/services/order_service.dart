import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manager_app/models/order_model.dart';
import 'package:manager_app/services/storage_service.dart';
import 'package:manager_app/utils/constants.dart';

class OrderService {
  final StorageService _storage = StorageService();

  Future<List<Order>> getOrders() async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('No token found');

    final url = Uri.parse('${Constants.apiBaseUrl}/commande/get/restaurant');
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
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<List<dynamic>> getOrderDetails(int orderId) async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('No token found');

    final url = Uri.parse('${Constants.apiBaseUrl}/commande/getorder');
    final response = await http.post(
      url,
      headers: {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: {'id_commande': orderId.toString()},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load order details');
    }
  }

  Future<bool> updateOrderState(int orderId, int state) async {
    final token = await _storage.getToken();
    if (token == null) return false;

    final url = Uri.parse('${Constants.apiBaseUrl}/commande/update/etat');
    final response = await http.post(
      url,
      headers: {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: {
        'id': orderId.toString(),
        'etat': state.toString(),
      },
    );

    return response.statusCode == 200;
  }
}

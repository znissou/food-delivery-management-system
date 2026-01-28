import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manager_app/models/restaurant_model.dart';
import 'package:manager_app/services/storage_service.dart';
import 'package:manager_app/utils/constants.dart';

class RestaurantService {
  final StorageService _storage = StorageService();

  Future<Restaurant> getRestaurant() async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('No token found');

    final url = Uri.parse('${Constants.apiBaseUrl}/restaurant/get');
    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Restaurant.fromJson(data);
    } else {
      throw Exception('Failed to load restaurant profile');
    }
  }

  Future<bool> updateAddress(String address) async {
    return _postUpdate('${Constants.apiBaseUrl}/restaurant/update/adresse', {'adresse': address});
  }

  Future<bool> updatePhone(String phone) async {
    return _postUpdate('${Constants.apiBaseUrl}/restaurant/update/telephone', {'tel': phone});
  }

  Future<bool> updateState(int state) async {
    return _postUpdate('${Constants.apiBaseUrl}/restaurant/update/etat', {'etat': state.toString()});
  }

  Future<bool> _postUpdate(String url, Map<String, String> body) async {
    final token = await _storage.getToken();
    if (token == null) return false;

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: body,
    );
    return response.statusCode == 200;
  }
}

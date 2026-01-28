import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manager_app/models/user_model.dart';
import 'package:manager_app/services/storage_service.dart';
import 'package:manager_app/utils/constants.dart';

class UserService {
  final StorageService _storage = StorageService();

  Future<User> getManager() async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('No token found');

    final url = Uri.parse('${Constants.apiBaseUrl}/manager/get');
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
      return User.fromJson(data);
    } else {
      throw Exception('Failed to load manager profile');
    }
  }

  Future<bool> updateEmail(String email) async {
    return _postUpdate('${Constants.apiBaseUrl}/manager/update/email', {'email': email});
  }

  Future<bool> updatePhone(String phone) async {
    return _postUpdate('${Constants.apiBaseUrl}/manager/update/telephone', {'tel': phone});
  }

  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    return _postUpdate('${Constants.apiBaseUrl}/manager/update/password', {
      'expassword': oldPassword,
      'password': newPassword,
    });
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

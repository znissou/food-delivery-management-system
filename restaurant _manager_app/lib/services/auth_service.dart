import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manager_app/services/storage_service.dart';
import 'package:manager_app/utils/constants.dart';

class LoginResult {
  final bool success;
  final int statusCode;
  LoginResult({required this.success, required this.statusCode});
}

class AuthService {
  final StorageService _storage = StorageService();

  Future<LoginResult> login(String email, String password) async {
    final url = Uri.parse('${Constants.apiBaseUrl}/login/manager');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await _storage.saveToken(data['token'].toString());
          return LoginResult(success: true, statusCode: 200);
        }
      }
      return LoginResult(success: false, statusCode: response.statusCode);
    } catch (e) {
      return LoginResult(success: false, statusCode: 500);
    }
  }

  Future<void> logout() async {
    await _storage.clear();
  }

  Future<bool> isLoggedIn() async {
    return _storage.hasToken();
  }
}

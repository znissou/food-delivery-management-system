import 'package:food_client/services/api_service.dart';
import 'package:food_client/services/storage_service.dart';
import 'package:food_client/models/ApiResponse.dart';
import 'package:food_client/models/User.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  Future<ApiResponse<User>> login(String email, String password) async {
    final response = await _apiService.login(email, password);
    if (response.data != null && response.data!.token != null) {
      await _storageService.saveToken(response.data!.token!);
    }
    return response;
  }

  Future<ApiResponse<User>> register(String nom, String prenom, String email, String password, String adresse, int tel) async {
    final response = await _apiService.register(nom, prenom, email, password, adresse, tel.toString());
    if (response.data != null && response.data!.token != null) {
      await _storageService.saveToken(response.data!.token!);
    }
    return response;
  }

  Future<void> logout() async {
    await _storageService.clearToken();
  }

  Future<bool> isLoggedIn() async {
    return await _storageService.hasToken();
  }
}

import 'package:flutter/material.dart';
import 'package:food_client/services/api_service.dart';
import 'package:food_client/services/auth_service.dart';
import 'package:food_client/models/User.dart';
import 'package:food_client/models/ApiResponse.dart';
import 'package:food_client/utils/helpers.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<ApiResponse<User>> _profileFuture;
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final loggedIn = await _authService.isLoggedIn();
    setState(() {
      _isLoggedIn = loggedIn;
    });

    if (loggedIn) {
      _refresh();
    }
  }

  void _refresh() {
    setState(() {
      _profileFuture = _apiService.getUserProfile();
    });
  }

  void _updateField(String field, String currentValue) {
    TextEditingController controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Modifier $field"),
        content: TextField(controller: controller),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final response = await _apiService.updateProfile(field, controller.text);
              if (response.error == null) {
                AppHelpers.showSnackBar(context, "Mise à jour réussie");
                _refresh();
              } else {
                AppHelpers.showSnackBar(context, response.error!, isError: true);
              }
            },
            child: const Text("Enregistrer"),
          ),
        ],
      ),
    );
  }

  void goLogin() {
    Navigator.of(context).pushNamed('/login').then((_) => _checkLogin());
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Veuillez vous connecter pour voir votre profil"),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: goLogin, child: const Text("Se connecter")),
          ],
        ),
      );
    }

    return Scaffold(
      body: FutureBuilder<ApiResponse<User>>(
        future: _profileFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            if (snapshot.data!.hasError) {
              return Center(child: Text('Error: ${snapshot.data!.error}'));
            }

            final user = snapshot.data!.data!;
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
                const SizedBox(height: 20),
                _buildProfileItem("Nom", user.nom, "nom"),
                _buildProfileItem("Prénom", user.prenom, "prenom"),
                _buildProfileItem("Email", user.email, "email"),
                _buildProfileItem("Téléphone", user.tel ?? "", "tel"),
                _buildProfileItem("Adresse", user.adresse ?? "", "adresse"),
              ],
            );
          }
          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }

  Widget _buildProfileItem(String label, String value, String fieldKey) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        subtitle: Text(value, style: const TextStyle(fontSize: 18, color: Colors.black87)),
        trailing: const Icon(Icons.edit, color: Colors.blue),
        onTap: () => _updateField(fieldKey, value),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:manager_app/models/user_model.dart';
import 'package:manager_app/services/auth_service.dart';
import 'package:manager_app/services/user_service.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    _refreshUser();
  }

  void _refreshUser() {
    setState(() {
      _userFuture = _userService.getManager();
    });
  }

  Future<void> _updateEmail() async {
    final TextEditingController emailController = TextEditingController();
    await showModalBottomSheet(
      context: context,
      builder: (ctx) => SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text("Changer l'email", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Nouveau email", hintText: "ex:manager@gmail.com"),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(height: 70),
            FloatingActionButton.extended(
              onPressed: () async {
                 if (emailController.text.isNotEmpty){
                   await _userService.updateEmail(emailController.text);
                   _refreshUser(); 
                   Navigator.pop(context);
                 }
              }, 
              label: const Text("Changer")
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
            const Text("Changer le numéro de telephone", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
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
                 if (phoneController.text.isNotEmpty){
                   await _userService.updatePhone(phoneController.text);
                   _refreshUser(); 
                   Navigator.pop(context);
                 }
              }, 
              label: const Text("Changer")
            ),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }

  Future<void> _updatePassword() async {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController exPasswordController = TextEditingController();
    await showModalBottomSheet(
      context: context,
      builder: (ctx) => SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text("Changer le mot de passe", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Nouveau password"),
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: exPasswordController,
                decoration: const InputDecoration(labelText: "ancien password"),
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
            const SizedBox(height: 70),
            FloatingActionButton.extended(
              onPressed: () async {
                 if (passwordController.text.isNotEmpty && exPasswordController.text.isNotEmpty){
                   await _userService.updatePassword(exPasswordController.text, passwordController.text);
                   Navigator.pop(context);
                 }
              }, 
              label: const Text("Changer")
            ),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _userFuture,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
           return Center(child: Text("Erreur: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
           return const Center(child: Text("Aucune donnée"));
        } else {
          final user = snapshot.data!;
          return Center(
             child: SingleChildScrollView(
                child: Column(
                   children: [
                      const SizedBox(height: 40),
                      Container(
                        margin: const EdgeInsets.all(20),
                        child: Text(
                          "${user.firstName} ${user.lastName}",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ListTile(
                         leading: const Icon(Icons.location_on, color: Colors.blue),
                         title: const Text("E-mail"),
                         subtitle: Text(user.email.isNotEmpty ? user.email : 'ajouter votre e-mail'),
                         trailing: IconButton(icon: const Icon(Icons.edit), onPressed: _updateEmail),
                      ),
                      ListTile(
                         leading: const Icon(Icons.phone, color: Colors.blue),
                         title: const Text("Telephone"),
                         subtitle: Text("0${user.phone.isNotEmpty ? user.phone : 'ajouter votre numéro de telephone'}"),
                         trailing: IconButton(icon: const Icon(Icons.edit), onPressed: _updatePhone),
                      ),
                       ListTile(
                         leading: const Icon(Icons.admin_panel_settings_sharp, color: Colors.blue),
                         title: const Text("Mot de passe"),
                         subtitle: const Text("******"),
                         trailing: IconButton(icon: const Icon(Icons.edit), onPressed: _updatePassword),
                      ),
                      const SizedBox(height: 30),
                      FloatingActionButton.extended(
                        onPressed: _logout,
                         label: const Text("Déconnecter"),
                         backgroundColor: Colors.red,
                      ),
                   ],
                ),
             ),
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:food_client/services/auth_service.dart';
import 'package:food_client/utils/helpers.dart';
import 'package:food_client/utils/constants.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void goHome(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Authentification"),
          leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => goHome(context)),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Connecter"),
              Tab(text: "S'inscrire"),
            ],
          ),
        ),
        body: TabBarView(children: [LoginTab(), SignupTab()]),
      ),
    );
  }
}

class LoginTab extends StatefulWidget {
  @override
  _LoginTabState createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  final AuthService _authService = AuthService();

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      AppHelpers.showSnackBar(context, "Veuillez remplir tous les champs", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final response = await _authService.login(_emailController.text, _passwordController.text);

    setState(() => _isLoading = false);

    if (response.error == null) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else {
      if (mounted) {
        AppHelpers.showSnackBar(context, response.error!, isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "Email", hintText: "ex:anis@gmail.com", prefixIcon: Icon(Icons.email)),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: "Mot de passe",
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            obscureText: _obscurePassword,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 15)),
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("LOGIN", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class SignupTab extends StatefulWidget {
  @override
  _SignupTabState createState() => _SignupTabState();
}

class _SignupTabState extends State<SignupTab> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final AuthService _authService = AuthService();

  void _signup() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      AppHelpers.showSnackBar(context, "Veuillez remplir tous les champs obligatoires", isError: true);
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      AppHelpers.showSnackBar(context, "Les mots de passe ne correspondent pas", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final response = await _authService.register(
      _lastNameController.text,
      _firstNameController.text,
      _emailController.text,
      _passwordController.text,
      _addressController.text,
      int.tryParse(_phoneController.text) ?? 0,
    );

    setState(() => _isLoading = false);

    if (response.error == null) {
      if (mounted) {
        AppHelpers.showSnackBar(context, "Inscription réussie!");
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else {
      if (mounted) {
        AppHelpers.showSnackBar(context, response.error!, isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: _firstNameController,
            decoration: const InputDecoration(labelText: "Prénom", prefixIcon: Icon(Icons.person)),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _lastNameController,
            decoration: const InputDecoration(labelText: "Nom", prefixIcon: Icon(Icons.person_outline)),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email)),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: "Téléphone", prefixIcon: Icon(Icons.phone)),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: "Adresse", prefixIcon: Icon(Icons.location_on)),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: "Mot de passe",
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            obscureText: _obscurePassword,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: "Confirmer mot de passe",
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
            ),
            obscureText: _obscureConfirmPassword,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _signup,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 15)),
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("S'INSCRIRE", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

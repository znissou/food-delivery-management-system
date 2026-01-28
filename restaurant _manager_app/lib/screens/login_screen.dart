import 'package:flutter/material.dart';
import 'package:manager_app/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    if (await _authService.isLoggedIn()) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    final result = await _authService.login(email, password);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    if (result.success) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else {
      if (mounted) {
        setState(() {
          if (result.statusCode == 400) {
            _errorMessage = 'Mot de passe incorrect';
          } else if (result.statusCode == 401) {
            _errorMessage = "Ce compte n'existe pas";
          } else {
            _errorMessage = "Erreur de connexion";
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("S'Authentifier"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "email",
                  hintText: "ex:anis@gmail.com",
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "mot de pass",
                  hintText: "entrer le mot de pass ici",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: !_isPasswordVisible,
              ),
              const SizedBox(height: 30),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Container(
                  margin: const EdgeInsets.all(20),
                  child: FloatingActionButton.extended(
                    onPressed: _handleLogin,
                    label: const Text("login"),
                  ),
                ),
              if (_errorMessage.isNotEmpty)
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:food_client/screens/Home.dart';
import 'package:food_client/screens/meals.dart';
import 'package:food_client/screens/meal.dart';
import 'package:food_client/screens/Orders.dart';
import 'package:food_client/screens/Order.dart';
import 'package:food_client/screens/panier.dart';
import 'package:food_client/screens/profile.dart';
import 'package:food_client/screens/login_signup.dart';
import 'package:food_client/utils/constants.dart';
import 'package:food_client/services/auth_service.dart';

void main() {
  runApp(const AtelierApp());
}

class AtelierApp extends StatelessWidget {
  const AtelierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atelier Restaurant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, primary: AppColors.primary, secondary: AppColors.accent),
        appBarTheme: const AppBarTheme(centerTitle: true, backgroundColor: AppColors.primary, foregroundColor: Colors.white),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/login': (context) => const LoginPage(),
        '/orders': (context) => OrdersPage(),
        '/cart': (context) => PanierPage(),
        '/profile': (context) => ProfilePage(),
      },
      onGenerateRoute: _generateRoute,
    );
  }

  static Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/meals':
        return MaterialPageRoute(builder: (context) => MealsPage(), settings: settings);
      case '/meal':
        return MaterialPageRoute(builder: (context) => MealPage(), settings: settings);
      case '/order':
        return MaterialPageRoute(builder: (context) => OrderPage(), settings: settings);
      case '/home':
        return MaterialPageRoute(builder: (context) => const MainPage());
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentPageIndex = 0;
  bool _isLoggedIn = false;
  final AuthService _authService = AuthService();

  final List<Widget> _pages = [HomePage(), OrdersPage(), PanierPage(), ProfilePage()];

  final List<String> _pageTitles = ['Restaurants', 'Commandes', 'Panier', 'Profile'];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final loggedIn = await _authService.isLoggedIn();
    setState(() {
      _isLoggedIn = loggedIn;
    });
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    setState(() {
      _isLoggedIn = false;
    });
    // Reset to home tab
    setState(() {
      _currentPageIndex = 0;
    });
  }

  void _navigateToLogin() {
    Navigator.of(context).pushNamed('/login').then((_) {
      _checkLoginStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_currentPageIndex]),
        actions: [
          IconButton(
            icon: Icon(_isLoggedIn ? Icons.logout : Icons.login),
            onPressed: () {
              if (_isLoggedIn) {
                _handleLogout();
              } else {
                _navigateToLogin();
              }
            },
          ),
        ],
      ),
      body: _pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Restaurants'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Commandes'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Panier'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
      ),
    );
  }
}

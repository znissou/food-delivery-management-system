import 'package:flutter/material.dart';
import 'package:manager_app/screens/meals_screen.dart';
import 'package:manager_app/screens/orders_screen.dart';
import 'package:manager_app/screens/restaurant_profile_screen.dart';
import 'package:manager_app/screens/user_profile_screen.dart';
import 'package:manager_app/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final AuthService _authService = AuthService();

  final List<Widget> _pages = [
    const RestaurantProfileScreen(),
    const MealsScreen(),
    const OrdersScreen(),
    const UserProfileScreen(),
  ];

  final List<String> _titles = ['Restaurant', 'Repas', 'Commandes', 'Profile'];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: CircleAvatar(
              child: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: _logout,
              ),
            ),
          )
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed, // Ensure usage of colors
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            // backgroundColor: Colors.blue, // Fixed type doesn't need this per item usually, but keeping color
            label: "Restaurant",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: "Repas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            label: "Commandes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        selectedItemColor: Colors.blue, 
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

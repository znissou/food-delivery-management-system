import 'package:flutter/material.dart';
import 'package:manager_app/screens/add_meal_screen.dart';
import 'package:manager_app/screens/home_screen.dart';
import 'package:manager_app/screens/login_screen.dart';
import 'package:manager_app/screens/order_details_screen.dart';

void main() {
  runApp(const AtelierApp());
}

class AtelierApp extends StatelessWidget {
  const AtelierApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/order': (context) => const OrderDetailsScreen(),
        '/meal/add': (context) => const AddMealScreen(),
      },
      title: 'Restaurant Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

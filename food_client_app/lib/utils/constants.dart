import 'package:flutter/material.dart';

class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  
  // Auth
  static const String login = '/login/client';
  static const String signup = '/singup';
  
  // Restaurants & Meals
  static const String restaurants = '/restaurants';
  static const String meals = '/meals'; // + /{restaurantId}
  static const String meal = '/meal'; // + /{mealId}
  static const String restaurantImage = '/restaurant/image'; // + /{id}
  
  // Cart
  static const String cartGet = '/panier/get';
  static const String cartAdd = '/panier/add';
  static const String cartUpdate = '/panier/update';
  static const String cartRemove = '/panier/remove';
  
  // Orders
  static const String orderCreate = '/commande/create';
  static const String ordersGet = '/commande/get';
  static const String orderDetails = '/commande/getorder';
  
  // User
  static const String userProfile = '/client';
  static const String userUpdate = '/client/update';
}

class AppColors {
  static const Color primary = Colors.deepOrange;
  static const Color accent = Colors.orangeAccent;
  static const Color background = Colors.white;
  static const Color text = Colors.black87;
  static const Color error = Colors.redAccent;
  static const Color success = Colors.green;
}

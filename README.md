# 🍔 Food Orders Management and Delivery System

## 📖 Overview

This repository contains a complete food delivery management system developed as a Bachelor's thesis project at **University of Constantine 2, Algeria** (June 2021). The system enables **clients to browse multiple restaurants, order meals, and track deliveries**, while **restaurant managers can manage their menus and process orders** through dedicated mobile applications.

### System Component

This repository consists of **four main components**:

1. **📱 `food_client_app/`** - Android client application (Flutter)
2. **📱 `restaurant_manager_app/`** - Android manager application (Flutter)
3. **⚙️ `laravel_backend/`** - REST API backend server (Laravel 7)
4. **📄 `Mémoire-de-licence.pdf`** - Complete thesis document (French)

---

## 🏗️ System Architecture

<img src="https://github.com/user-attachments/assets/5433d52e-a8b0-4a69-9000-6036a6d78f8e" 
     alt="System Architecture Diagram" 
     width="700" />

The system follows a **client-server architecture** with three layers:

### Backend Layer (Laravel 7)
- **RESTful API** for data management
- **MySQL database** for persistent storage
- **JWT/Sanctum authentication** for secure access
- **Apache HTTP server** on XAMPP

### Client Application (Flutter/Android)
- Browse multiple restaurants and their menus
- Add items to cart (supports multiple restaurants)
- Place orders with delivery address
- Track order status in real-time
- Manage user profile

### Manager Application (Flutter/Android)
- Manage restaurant details (1 restaurant per manager)
- Add/edit/delete menu items with images
- View and process incoming orders
- Accept/refuse orders with stock validation
- Update order status (pending → confirmed → preparing → delivered)

---

## 📂 Repository Structure

```
├── food_client_app/              # Flutter Android app for clients
│   ├── lib/
│   │   ├── models/              # Data models
│   │   ├── screens/             # UI screens
│   │   ├── services/            # API services
│   │   └── widgets/             # Reusable components
│   ├── pubspec.yaml
│   └── README.md
│
├── restaurant_manager_app/       # Flutter Android app for managers
│   ├── lib/
│   │   ├── models/
│   │   ├── screens/
│   │   ├── services/
│   │   └── widgets/
│   ├── pubspec.yaml
│   └── README.md
│
├── laravel_backend/              # Laravel 7 REST API
│   ├── app/
│   │   ├── Http/
│   │   │   ├── Controllers/    # API controllers
│   │   │   └── Middleware/
│   │   └── Models/             # Eloquent models
│   ├── database/
│   │   └── migrations/         # Database schema
│   ├── routes/
│   │   └── api.php            # API routes
│   ├── composer.json
│   └── README.md
│
└── Mémoire-de-licence.pdf       # Complete thesis (62 pages, French)
```

---

## ✨ Key Features

### For Clients 👥
- **User Authentication**: Secure registration and login
- **Restaurant Discovery**: Browse all available restaurants with open/closed status
- **Menu Browsing**: View categorized menus with dish images and ingredients
- **Shopping Cart**: Add items from multiple restaurants
- **Order Placement**: Specify delivery address and confirm order
- **Order Tracking**: Monitor order status with color-coded states
- **Profile Management**: Update personal information, phone, email, password

### For Managers 🏪
- **Restaurant Management**: Update restaurant info (phone, address, status)
- **Menu Management**: Add/edit/delete dishes with images and ingredients
- **Order Processing**: View incoming orders with client contact details
- **Stock Management**: Set available quantities, validate stock before accepting orders
- **Order Status Control**: Accept/refuse orders, update preparation status
- **Profile Management**: Manage manager account details

### Backend Features ⚙️
- **Multi-Restaurant Support**: System handles multiple independent restaurants
- **Smart Order Splitting**: Cart items from different restaurants create separate orders
- **Stock Validation**: Real-time availability checks during order placement
- **Automatic Stock Updates**: Decrement quantities when orders are accepted
- **Image Management**: Automatic resize and storage of meal/restaurant images
- **API Security**: Token-based authentication with Laravel Sanctum

---

## 🛠️ Technology Stack

### Mobile Apps (Flutter)
- **Framework**: Flutter 2.x
- **Language**: Dart
- **Platform**: Android
- **IDE**: Android Studio
- **State Management**: Provider/setState
- **HTTP Client**: http package
- **Image Handling**: image_picker

### Backend (Laravel)
- **Framework**: Laravel 7.0
- **Language**: PHP 7.2+
- **Database**: MySQL 5.7+
- **Authentication**: Laravel Sanctum
- **Image Processing**: Intervention Image
- **Server**: Apache (XAMPP)
- **API Format**: JSON REST

### Design & Modeling
- **UML Diagrams**: Draw.io
- **API Testing**: Postman
- **Database Admin**: HeidiSQL, phpMyAdmin
- **Design**: Adobe Photoshop, Adobe Illustrator

---

## 🚀 Getting Started

### Prerequisites

- **For Backend**:
  - PHP 7.2.5+
  - MySQL 5.7+
  - Composer
  - XAMPP (or Apache + MySQL)

- **For Mobile Apps**:
  - Flutter SDK 2.x+
  - Android Studio
  - Android SDK (API level 21+)
  - Physical device or emulator

### Installation

#### 1. Backend Setup

```bash
cd laravel_backend

# Install dependencies
composer install

# Configure environment
cp .env.example .env
php artisan key:generate

# Update .env with your database credentials
# DB_DATABASE=food_delivery
# DB_USERNAME=your_username
# DB_PASSWORD=your_password

# Run migrations
php artisan migrate

# Link storage
php artisan storage:link

# Start server
php artisan serve
# API runs at http://localhost:8000
```

#### 2. Client App Setup

```bash
cd food_client_app

# Get dependencies
flutter pub get

# Update API base URL in lib/services/api_service.dart
# Change to your backend IP (e.g., http://192.168.1.x:8000)

# Run app
flutter run
```

#### 3. Manager App Setup

```bash
cd restaurant_manager_app

# Get dependencies
flutter pub get

# Update API base URL in lib/services/api_service.dart

# Run app
flutter run
```

---

## 📱 Application Screenshots

### Client App Interfaces
- **Authentication**: Login/Register screens
- **Restaurants List**: Browse all restaurants with status indicators
- **Menu View**: Categorized dishes with prices and images
- **Dish Details**: Full information with ingredients
- **Shopping Cart**: Review items before checkout
- **Order History**: Track past and current orders with status colors

### Manager App Interfaces
- **Dashboard**: Restaurant overview
- **Menu Management**: Add/edit dishes with image upload
- **Orders List**: Incoming orders with client details
- **Order Details**: Line items and delivery information
- **Profile**: Manage restaurant and account settings

---

## 📚 Academic Context

### Thesis Information

**Title**: Développement d'une application mobile pour la gestion des commandes des Restaurants  
**Authors**: Anis ZOUAGHI, Ayoub BOUCHELAGHEM  
**Supervisor**: Dr. Hamza DJEBLI  
**Institution**: University Abdel Hamid Mehri Constantine 2  
**Faculty**: Faculty of New Technologies of Information and Communication  
**Department**: Fundamental Computer Science and Applications  
**Degree**: Bachelor's in Computer Science (License)  
**Option**: Information Technologies  
**Date**: June 2021  

### Thesis Contents (62 pages)

1. **Chapter I**: Theoretical Foundations (E-business, E-commerce, B2C model)
2. **Chapter II**: Requirements Analysis and Specifications (Use cases, actors, functional/non-functional requirements)
3. **Chapter III**: System Design (UML diagrams: class, sequence, activity, navigation)
4. **Chapter IV**: Implementation (Architecture, tools, database design, interface screenshots)

The complete thesis document (\`Mémoire-de-licence.pdf\`) is included in this repository.


---

## 📜 License

This project is open-sourced under the [MIT License](LICENSE).

---

## 👥 Authors

**Anis ZOUAGHI** | **Ayoub BOUCHELAGHEM**

*Bachelor's Thesis Project*  
University Abdel Hamid Mehri Constantine 2, Algeria  
Department of Computer Science  
June 2021

---

## 🙏 Acknowledgments

- **Dr. Hamza DJEBLI** - Project supervisor
- **Faculty of NTIC** - University of Constantine 2
- **Department of Computer Science** - For guidance and support

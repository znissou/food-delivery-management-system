# 🍔 Food Orders Management and Delivery Backend API

Laravel 7 REST API backend for a multi-restaurant food delivery platform with two Android mobile apps: **Client App** for customers and **Manager App** for restaurant owners.

![Class Diagram](https://github.com/user-attachments/assets/b193d476-7ea2-40eb-a5a1-7a0743e79ea8)

---

## 📱 Overview

This backend supports a food delivery ecosystem with **multiple restaurants**:
- **Client App**: Browse multiple restaurants, add items to cart, place orders across different restaurants, track order status
- **Manager App**: Each manager controls their own restaurant (1:1 relationship), manages menu, processes orders for their restaurant only
- **Tech Stack**: Laravel 7, MySQL, Laravel Sanctum (token-based authentication), Eloquent ORM

---

## 🏗️ Architecture & Database

### User System

**Client**
- Fields: `id`, `nom`, `prenom`, `email`, `tel`, `password`, `adresse`
- Can browse all restaurants, place orders at multiple restaurants
- Has one cart (can contain items from multiple restaurants)
- Has many orders

**Manager**
- Fields: `id`, `nom`, `prenom`, `email`, `num_tel`, `password`, `adresse`
- Each manager is linked to **one restaurant** (Manager ID = Restaurant ID)
- Manages only their own restaurant's menu and orders

### Core Entities

**Restaurant**
- Fields: `ID` (primary key, matches manager ID), `nom`, `tel`, `adresse`, `etat` (active/inactive)
- **Key Relationship**: Restaurant ID = Manager ID (1:1 mapping)
- Has many dishes (repas) and receives orders from multiple clients

**Repas (Dish/Meal)**
- Fields: `ID`, `nom`, `ingredients`, `prix`, `disponible` (available quantity), `ID_restaurant`, `ID_categorie`
- Belongs to one restaurant and one category
- Has an image stored at `storage/public/images/meal/{id}.png`

**Categorie**
- Fields: `ID`, `nom`
- Groups dishes (e.g., Pizza, Burgers, Desserts)

**Commande (Order)**
- Fields: `ID`, `id_client`, `id_restaurant`, `adresse_livraison`, `prix_totale`, `etat` (order status)
- One order belongs to one client and one restaurant
- Has many line items (lignes)
- **Multi-restaurant logic**: When client checks out cart with items from multiple restaurants, system creates separate orders per restaurant

**Ligne (Order Line Item)**
- Fields: `id`, `id_commande`, `id_repas`, `quantite`
- Links order to dishes with quantities

**Panier (Shopping Cart)**
- Fields: `id`, `id_client`, `id_repas`, `quantite`
- Clients can add dishes from different restaurants to cart
- On checkout, cart is split into separate orders per restaurant

---

## 🛠️ Installation

### Requirements

- PHP 7.2.5+
- MySQL 5.7+ or MariaDB 10.2+
- Composer
- Laravel 7.x
- GD or Imagick extension (for image processing)

### Setup

```bash
git clone https://github.com/yourusername/food-delivery-backend.git
cd food-delivery-backend

composer install

cp .env.example .env
php artisan key:generate
```

Configure `.env`:

```env
APP_NAME="Food Delivery API"
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=food_delivery
DB_USERNAME=your_username
DB_PASSWORD=your_password
```

Run migrations and start:

```bash
php artisan migrate
php artisan storage:link
php artisan serve
```

API available at: `http://localhost:8000/api`

---

## 🔐 Authentication

- **Laravel Sanctum** token-based authentication
- Passwords hashed with `Hash::make()`
- Token required in header: `Authorization: Bearer {token}`

### Auth Endpoints

**Register Client**
```http
POST /api/register
Content-Type: application/json

{
  "email": "client@example.com",
  "password": "password123",
  "nom": "Doe",
  "prenom": "John",
  "tel": "+213555123456",
  "adresse": "Algiers, Algeria"
}

Response 201:
{
  "token": "1|abc123..."
}
```

**Client Login**
```http
POST /api/login/client
Content-Type: application/json

{
  "email": "client@example.com",
  "password": "password123"
}

Response 200:
{
  "token": "2|xyz789..."
}
```

**Manager Login**
```http
POST /api/login/manager
Content-Type: application/json

{
  "email": "manager@restaurant.com",
  "password": "password123"
}

Response 200:
{
  "token": "3|def456..."
}
```

---

## 📡 API Endpoints

### Client Profile Management

All endpoints require `Authorization: Bearer {token}` header.

**Get Profile**
```http
GET /api/client
Response: Client data with 'success' flag
```

**Update Phone**
```http
PUT /api/client/tel
Body: {"tel": "+213666789012"}
Response: {"success": true, "message": "Telephone updated successfully"}
```

**Update Email**
```http
PUT /api/client/email
Body: {"email": "newemail@example.com"}
Response: {"success": true, "message": "Email updated successfully"}
```

**Update Password**
```http
PUT /api/client/password
Body: {
  "expassword": "oldpass123",
  "password": "newpass456"
}
Response: {"success": true, "message": "Password updated successfully"}
```

**Update Address**
```http
PUT /api/client/adresse
Body: {"adresse": "New address"}
Response: {"success": true, "message": "Address updated successfully"}
```

---

### Restaurant & Menu (Client View)

**List All Restaurants**
```http
GET /api/restaurants
Response: Array of all restaurants with their details
```

**Get Restaurant Dishes (by category)**
```http
GET /api/restaurants/{restaurantId}/repas
Response: Dishes grouped by categories for the restaurant
```

**Get Dish Image**
```http
GET /api/repas/{id}/image
Response: PNG image file
```

---

### Shopping Cart (Client)

Cart can contain items from **multiple restaurants**. System tracks `id_client`, `id_repas`, and `quantite`.

**Add Item to Cart**
```http
POST /api/panier/add
Body: {
  "id": 5,  // repas ID
  "quantite": 2
}
Response 201: "tout va bien"
```

**View Cart**
```http
GET /api/panier
Response: Array of cart items with dish details and restaurant IDs
[
  {
    "quantite": 2,
    "id_repa": 5,
    "id_restaurant": 1,
    "nom": "Margherita Pizza",
    "prix": 800
  }
]
```

**Update Item Quantity**
```http
PUT /api/panier/update
Body: {
  "id": 5,  // repas ID
  "quantite": 3
}
Response 200: "done!"
```

**Remove Item from Cart**
```http
DELETE /api/panier/destroy
Body: {"id": 5}  // repas ID
Response 200: "done"
```

---

### Order Management (Client)

**Create Order from Cart**
```http
POST /api/commande/add
Body: {"adresse": "123 Delivery Street, Algiers"}

Logic:
- Validates dish availability (quantite <= disponible)
- Groups cart items by restaurant
- Creates separate order (Commande) for each restaurant
- Creates line items (Ligne) for each dish
- Calculates prix_totale per order
- Clears cart after successful order creation

Response 200: "done!"
Response 400: "{dish name} non disponible" (if out of stock)
```

**View My Orders**
```http
GET /api/commande
Response: Array of client's orders with restaurant names
[
  {
    "ID": 1,
    "id_client": 5,
    "id_restaurant": 2,
    "adresse_livraison": "123 Delivery St",
    "prix_totale": 1600,
    "etat": 0,
    "restaurant": "Pizza Palace"
  }
]
```

**Get Order Details (Line Items)**
```http
POST /api/commande/order
Body: {"id_commande": 1}
Response: Array of dishes in the order with quantities
```

---

### Manager - Restaurant Management

Manager can only manage their own restaurant (where Restaurant.ID = Manager.ID).

**Get My Restaurant**
```http
GET /api/restaurant
Response: Restaurant details for authenticated manager
```

**Update Restaurant Status**
```http
PUT /api/restaurant/etat
Body: {"etat": 1}  // 1=active, 0=inactive
Response 200
```

**Update Restaurant Phone**
```http
PUT /api/restaurant/tel
Body: {"tel": "+213555999888"}
Response 200: "done!"
```

**Update Restaurant Address**
```http
PUT /api/restaurant/adresse
Body: {"adresse": "New restaurant address"}
Response 200: "done!"
```

**Get Restaurant Image**
```http
GET /api/restaurant/{id}/image
Response: PNG image file
```

---

### Manager - Menu Management

**Get My Restaurant's Menu**
```http
GET /api/repas
Response: All dishes for manager's restaurant (ID_restaurant = manager ID)
```

**Add New Dish**
```http
POST /api/repas/add
Content-Type: multipart/form-data

Body:
- nom: "Chicken Burger"
- ingredients: "Chicken, lettuce, tomato"
- prix: 650
- image: (file upload)

Logic:
- Creates dish with ID_restaurant = manager's ID
- ID_categorie defaults to 1
- Resizes image to height 200px (maintains aspect ratio)
- Saves image as storage/public/images/meal/{meal_id}.png

Response 201: Meal object
```

**Update Dish Price**
```http
PUT /api/repas/prix
Body: {
  "id": 5,
  "prix": 750
}
Response 200
```

**Update Dish Availability**
```http
PUT /api/repas/disponible
Body: {
  "id": 5,
  "disponible": 20
}
Response 200
```

**Delete Dish**
```http
DELETE /api/repas/destroy
Body: {"id": 5}
Response 200
```

---

### Manager - Order Processing

**View Restaurant Orders**
```http
GET /api/commande/restaurant
Response: Orders for manager's restaurant with client details
[
  {
    "tel": "+213555123456",
    "prenom": "John",
    "nom": "Doe",
    "prix_totale": 1600,
    "adresse": "123 Delivery St",
    "etat": 0,
    "id": 1
  }
]
```

**Update Order Status**
```http
PUT /api/commande/etat
Body: {
  "id": 1,
  "etat": 2
}

Order States:
- 0: Pending
- 1: Confirmed
- 2: Accepted (decrements dish disponible by order quantity)
- 3+: Custom states (delivered, cancelled, etc.)

Logic:
- When etat = 2 (accepted), system validates availability
- Decrements disponible quantity for each dish in order
- Returns error if any dish is out of stock

Response 200: "done!"
Response 400: "repas non disponible"
```

---

### Manager Profile Management

**Get Manager Profile**
```http
GET /api/manager
Response: Manager details
```

**Update Manager Email**
```http
PUT /api/manager/email
Body: {"email": "newemail@example.com"}

Logic: Also updates Token table's 'name' field
Response 200: "done!"
```

**Update Manager Phone**
```http
PUT /api/manager/tel
Body: {"tel": "+213666789012"}
Response 200: "done!"
```

**Update Manager Password**
```http
PUT /api/manager/password
Body: {
  "expassword": "oldpassword",
  "password": "newpassword"
}

Note: Password comparison uses == not Hash::check() (potential security issue)
Response 200: "done!"
Response 400: "mot de passe incorrect"
```

---

## 🔑 Key Features & Business Logic

### Multi-Restaurant Cart to Order Flow

1. Client adds dishes from multiple restaurants to cart (Panier table)
2. Cart items stored as: `id_client`, `id_repas`, `quantite`
3. On checkout (`POST /api/commande/add`):
   - System joins Panier with Repas table
   - Orders by `ID_restaurant` to group items
   - Creates separate `Commande` for each restaurant
   - For each order:
     - Creates `Ligne` entries for each dish
     - Calculates `prix_totale` = sum(prix × quantite)
   - Clears entire cart after successful order creation

### Restaurant-Manager Relationship

- **Critical**: `Restaurant.ID` must equal `Manager.ID`
- When manager creates a dish: `ID_restaurant` = `$request->user()->id`
- When manager views orders: `WHERE id_restaurant = manager_id`
- This 1:1 mapping enforces single restaurant per manager

### Stock Management

- Each dish has `disponible` field (available quantity)
- Order creation validates: `quantite <= disponible`
- When manager accepts order (etat=2):
  - System decrements `disponible` by order quantity
  - Validates stock before accepting
  - Rejects if insufficient stock

---

## 🧪 Testing Examples

**Register and Login**
```bash
# Register client
curl -X POST http://localhost:8000/api/register   -H "Content-Type: application/json"   -d '{"email":"test@example.com","password":"pass123","nom":"Test","prenom":"User","tel":"+213555000111","adresse":"Algiers"}'

# Login
curl -X POST http://localhost:8000/api/login/client   -H "Content-Type: application/json"   -d '{"email":"test@example.com","password":"pass123"}'
```

**Browse and Order**
```bash
TOKEN="your_token_here"

# List restaurants
curl -X GET http://localhost:8000/api/restaurants   -H "Authorization: Bearer $TOKEN"

# Add to cart
curl -X POST http://localhost:8000/api/panier/add   -H "Authorization: Bearer $TOKEN"   -H "Content-Type: application/json"   -d '{"id":1,"quantite":2}'

# Checkout
curl -X POST http://localhost:8000/api/commande/add   -H "Authorization: Bearer $TOKEN"   -H "Content-Type: application/json"   -d '{"adresse":"123 Main St, Algiers"}'
```

---

## 🐛 Known Issues & Notes

1. **Manager Password Update**: Uses plain text comparison (`==`) instead of `Hash::check()` - security risk
2. **Category System**: Hardcoded to `ID_categorie = 1` when creating dishes
3. **Image Format**: Only PNG supported, hardcoded extension `.png`
4. **Error Messages**: Mix of French and English responses
5. **Restaurant CRUD**: No endpoints for creating/deleting restaurants via API (likely done via seeder/migration)

---

## 📜 License

This project is open-sourced under the [MIT License](LICENSE).

---

**Built for multi-restaurant food delivery | Laravel 7 + Android Apps**

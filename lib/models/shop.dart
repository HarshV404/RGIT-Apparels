import 'package:flutter/material.dart';
import 'package:rgit_apparels/models/product.dart';

class Shop extends ChangeNotifier {
  final List<Product> _shop = [
    // Product 1
    Product(
      name: "Polo T-shirt",
      price: 499,
      description: "A classic, collared T-shirt with a buttoned placket, offering a smart-casual look",
      imagePath: 'lib/images/t-shirt4.webp',
    ),
    // Product 2
    Product(
      name: "Blackweight Hoodie",
      price: 899,
      description: "Heavyweight hoodie with a cozy, relaxed fit and front pocket; perfect for layering.",
      imagePath: 'lib/images/t-shirt1.webp',
    ),
    // Product 3
    Product(
      name: "Modern Sweatshirt",
      price: 699,
      description: "Soft, crewneck pullover ideal for warmth and comfort; a versatile, casual staple",
      imagePath: 'lib/images/t-shirt2.webp',
    ),
    // Product 4
    Product(
      name: "LightWeight Jersey",
      price: 399,
      description: "Lightweight, breathable top often used in sports; comfortable and moisture-wicking.",
      imagePath: 'lib/images/t-shirt3.webp',
    ),
    // Product 5
    Product(
      name: "LightWeight Jersey",
      price: 399,
      description: "Lightweight, breathable top often used in sports; comfortable and moisture-wicking.",
      imagePath: 'lib/images/t-shirt4.webp',
    ),
  ];

  // User's cart
  final List<Product> _cart = [];

  // Favourites list (private to prevent direct manipulation)
  final List<Product> _favourites = [];

  // Get list of products in the shop
  List<Product> get shop => _shop;

  // Get list of products in the cart
  List<Product> get cart => _cart;

  // Get list of favourite products
  List<Product> get favourites => List.unmodifiable(_favourites);

  // Add item to the cart and notify listeners
  void addToCart(Product item) {
    _cart.add(item);
    notifyListeners(); // Notify listeners to update the UI
  }

  // Remove item from the cart and notify listeners
  void removeFromCart(Product item) {
    _cart.remove(item);
    notifyListeners(); // Notify listeners to update the UI
  }

  // Calculate the total price of items in the cart
  double getTotalPrice() {
    return _cart.fold(0, (total, item) => total + item.price);
  }

  // Add product to favourites if not already in the list
  void addToFavourites(Product product) {
    if (!_favourites.contains(product)) {
      _favourites.add(product);
      notifyListeners(); // Notify listeners to update the UI
    }
  }

  // Remove product from favourites
  void removeFromFavourites(Product product) {
    _favourites.remove(product);
    notifyListeners(); // Notify listeners to update the UI
  }
}
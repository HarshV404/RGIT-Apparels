import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgit_apparels/components/bottom_nav_bar.dart';
import 'package:rgit_apparels/components/my_drawer.dart';
import 'package:rgit_apparels/components/my_product_tile.dart';
import 'package:rgit_apparels/models/shop.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int _selectedIndex = 1; // Shop is selected by default

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to respective page based on selected index
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home_page');
        break;
      case 1:
        Navigator.pushNamed(context, '/categories_page');
        break;
      case 2:
        Navigator.pushNamed(context, '/fav_page');
        break;
      case 3:
        Navigator.pushNamed(context, '/customize_page');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<Shop>().shop;
    final cartItemCount = context.watch<Shop>().cart.length;

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text("Shop Page"),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/cart_page'),
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
              if (cartItemCount > 0) // Show badge only if items are in cart
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding:
                        const EdgeInsets.all(6), // Padding for circular look
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle, // Circular shape
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.2 * 255).toInt()),
                          spreadRadius: 1,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18, // Minimum width to ensure circular shape
                      minHeight: 18, // Minimum height to ensure circular shape
                    ),
                    child: Text(
                      '$cartItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12, // Slightly larger text
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
      drawer: MyDrawer(),
      body: ListView(
        children: [
          const SizedBox(height: 25),
          Center(
            child: Text(
              "Pick From Selected List Of Premium Products",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          SizedBox(
            height: 550,
            child: products.isNotEmpty
                ? ListView.builder(
                    itemCount: products.length,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(15),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return MyProductTile(product: product);
                    },
                  )
                : const Center(
                    child: Text("No products available"),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavbar(),
    );
  }
}

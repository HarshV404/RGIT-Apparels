import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgit_apparels/components/my_drawer.dart';
import 'package:rgit_apparels/models/shop.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int _selectedIndex = 2; // Categories is selected by default

  // Sample category data with two more items
  final List<Map<String, String>> categories = [
    {"image": "lib/images/tshirts.png", "name": "T-Shirts"},
    {"image": "lib/images/hoodies.webp", "name": "Hoodies"},
    {"image": "lib/images/jackets.png", "name": "Jackets"},
    {"image": "lib/images/shorts.png", "name": "Shorts"},
    {"image": "lib/images/jersey.png", "name": "Jerseys"}, // New Category
    {"image": "lib/images/jersey2.png", "name": "Full Kits"}, // New Category
  ];

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
        Navigator.pushNamed(context, '/shop_page');
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
    final cartItemCount = context.watch<Shop>().cart.length;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text("Categories Page"),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/cart_page'),
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.2 * 255).toInt()),
                          spreadRadius: 1,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '$cartItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of tiles in a row
            crossAxisSpacing: 10, // Horizontal spacing
            mainAxisSpacing: 10, // Vertical spacing
            childAspectRatio: 3 / 4, // Adjust for image proportions
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                // Handle tile tap (e.g., navigate to category-specific page)
                print('Tapped on ${category['name']}');
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                color: Colors.grey[300], // Set background color to light grey
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                        child: Image.asset(
                          category['image']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        category['name']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.grey[200],
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black54),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt, color: Colors.black54),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.black54),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.design_services, color: Colors.black54),
            label: 'Customize',
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:rgit_apparels/models/product.dart';
import 'package:rgit_apparels/models/shop.dart';

class FavPage extends StatelessWidget {
  const FavPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the list of favourite products
    final favourites = context.watch<Shop>().favourites;

    return Scaffold(
      // Set background color of the page to white
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Set AppBar color to white and text color to dark
        backgroundColor: Colors.white,
        elevation: 0, // Optional: removes shadow under the AppBar
        iconTheme: const IconThemeData(
            color: Colors.black), // Change icon color to black
        // Center the title horizontally
        title: const Text(
          'Favourites',
          style: TextStyle(
            fontSize: 24, // Increase font size
            fontWeight: FontWeight.bold, // Make it bold for better visibility
            color: Colors.black, // Set the title color to black
          ),
        ),
        centerTitle: true, // This centers the title horizontally
      ),
      body: favourites.isEmpty
          ? const Center(child: Text('No favourites yet'))
          : ListView.builder(
              itemCount: favourites.length,
              itemBuilder: (context, index) {
                final product = favourites[index];
                return ListTile(
                  leading: Image.asset(product.imagePath),
                  title: Text(product.name),
                  subtitle: Text('₹${product.price.toStringAsFixed(2)}'),
                );
              },
            ),
    );
  }
}

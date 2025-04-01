import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgit_apparels/models/product.dart';
import 'package:rgit_apparels/models/shop.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  void removeItemFromCart(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Remove This Item From Your Cart?"),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<Shop>().removeFromCart(product);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void payButtonPressed(BuildContext context) {
    final cart = context.read<Shop>().cart;
    final totalPrice = context.read<Shop>().getTotalPrice();

    final List<Map<String, dynamic>> items = cart.map((product) {
      return {
        "name": product.name,
        "quantity": 1,
        "price": product.price.toStringAsFixed(2),
        "currency": "USD",
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Shop>().cart;
    final totalPrice = context.watch<Shop>().getTotalPrice();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text("Cart Page"),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Column(
        children: [
          Expanded(
            child: cart.isEmpty
                ? const Center(child: Text("Your cart is Empty..."))
                : ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text("₹${item.price.toStringAsFixed(2)}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => removeItemFromCart(context, item),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Total: ₹${totalPrice.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(40.0),
          //   child: cart.isNotEmpty
          //       ? MyButton(
          //           onTap: () => payButtonPressed(context),
          //           child: const Text(
          //             "Pay Now",
          //             style: TextStyle(
          //               color: Colors.white,
          //               fontWeight: FontWeight.bold,
          //               fontSize: 18,
          //             ),
          //           ),
          //           style: ElevatedButton.styleFrom(
          //             padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          //             backgroundColor: Colors.blue,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(10),
          //             ),
          //           ),
          //         )
          //       : const SizedBox.shrink(),
          // ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgit_apparels/models/product.dart';
import 'package:rgit_apparels/models/shop.dart';

class MyProductTile extends StatefulWidget {
  final Product product;
  const MyProductTile({super.key, required this.product});

  @override
  _MyProductTileState createState() => _MyProductTileState();
}

class _MyProductTileState extends State<MyProductTile> {
  bool _isFavourite = false; // Track favourite state

  void addToCart(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Add This Item To Your Cart?"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<Shop>().addToCart(widget.product);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void toggleFavourite() {
    setState(() {
      _isFavourite = !_isFavourite;
    });

    if (_isFavourite) {
      context.read<Shop>().addToFavourites(widget.product);
    } else {
      context.read<Shop>().removeFromFavourites(widget.product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(25),
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  child: Image.asset(widget.product.imagePath),
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((0.7 * 255).toInt()),  // Background for contrast
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.2 * 255).toInt()),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isFavourite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavourite ? Colors.red : Colors.black,
                      size: 30,  // Larger icon
                    ),
                    onPressed: toggleFavourite,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            widget.product.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            widget.product.description,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${widget.product.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () => addToCart(context),
                  icon: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
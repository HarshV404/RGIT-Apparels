import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String imagePath;
  final String categoryName;
  final VoidCallback onTap;

  const CategoryTile({
    super.key,
    required this.imagePath,
    required this.categoryName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE), // Light grey color for the tile
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(220, 235, 233, 233).withAlpha((0.3 * 255).toInt()),
              blurRadius: 6,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                categoryName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Text color for better contrast
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
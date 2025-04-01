import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final Widget child;

  const MyButton({super.key, required this.onTap, required this.child, required ButtonStyle style});

    @override
    Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25), // Margin
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(10), // Padding
          child: child,
        ),
      ),
    );
  }
}
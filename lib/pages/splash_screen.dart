import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rgit_apparels/pages/intro_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      setState(() {
        _opacity = 0.0;
      });
    });
    Timer(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const IntroPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(seconds: 60),
        child: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Center(
            child: Image.asset(
              'lib/images/logo.png', // Replace with your image path
              width: 400,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}
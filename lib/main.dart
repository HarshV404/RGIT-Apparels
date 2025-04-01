import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgit_apparels/auth/auth_page.dart';
import 'package:rgit_apparels/models/shop.dart';
import 'package:rgit_apparels/pages/cart_page.dart';
import 'package:rgit_apparels/pages/customize_page.dart';
import 'package:rgit_apparels/pages/fav_page.dart';
import 'package:rgit_apparels/pages/home_page.dart';
import 'package:rgit_apparels/pages/intro_page.dart';
import 'package:rgit_apparels/pages/shop_page.dart';
import 'package:rgit_apparels/pages/splash_screen.dart';
import 'package:rgit_apparels/themes/light_mode.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      ChangeNotifierProvider<Shop>(
      create:(context) => Shop(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: lightMode,
      routes: {
        '/splash_screen':(context) => const SplashScreen(),
        '/intro_page':(context) => const IntroPage(),
        '/auth_page':(context) => const AuthPage(),
        '/shop_page':(context) => const ShopPage(),
        '/cart_page':(context) => const CartPage(),
        '/home_page':(context) => const HomePage(),
        '/fav-page':(context) => const FavPage(),
        'customize_page':(context) => const CustomizePage(),
      },
    );
  }
}
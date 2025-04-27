import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rgit_apparels/auth/auth_page.dart';
import 'package:rgit_apparels/models/shop.dart';
import 'package:rgit_apparels/pages/cart_widget.dart';
import 'package:rgit_apparels/pages/chatbot_page.dart';
import 'package:rgit_apparels/pages/customize_page.dart';
import 'package:rgit_apparels/pages/favourite_widget.dart';
import 'package:rgit_apparels/pages/home_widget.dart';
import 'package:rgit_apparels/pages/intro_page.dart';
import 'package:rgit_apparels/pages/profile_page.dart';
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
      home: const HomeWidget(),
      theme: lightMode,
      routes: {
        '/intro_page':(context) => const IntroPage(),
        '/auth_page':(context) => const AuthPage(),
        '/cart_page':(context) => const MyCartWidget(),
        '/home_page':(context) => const HomeWidget(),
        '/fav-page':(context) => const FavouriteWidget(),
        '/profile_page':(context) => const ProfilePage(),
        '/chat_page':(context) => const ChatbotPage(),
        'customize_page':(context) => const CustomizePage(),
      },
    );
  }
}
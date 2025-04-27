// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

Future<void> logout() async {
  await FirebaseAuth.instance.signOut();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  // Current selected menu item index
  int _selectedIndex = 1; // Default to Home Page
  
  // Menu items list
  final List<Map<String, dynamic>> _menuItems = [
    {
      'icon': Icons.person_outline,
      'title': 'Profile',
    },
    {
      'icon': Icons.home_outlined,
      'title': 'Home Page',
    },
    {
      'icon': Icons.shopping_cart_outlined,
      'title': 'My Cart',
    },
    {
      'icon': Icons.favorite_border,
      'title': 'Favorite',
    },
    {
      'icon': Icons.shopping_bag_outlined,
      'title': 'Orders',
    },
    {
      'icon': Icons.notifications_outlined,
      'title': 'Notifications',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Get device size
    final Size screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color.fromRGBO(26, 36, 47, 1), // Dark background
        ),
        child: Stack(
          children: [
            // Status bar area (for demonstration)
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: screenSize.width,
                height: 44,
                color: const Color.fromRGBO(26, 36, 47, 1),
              ),
            ),
            
            // User profile and menu items area
            Positioned(
              top: 98,
              left: 20,
              child: SizedBox(
                width: 165,
                height: 642,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User profile section
                    _buildUserProfileSection(),
                    
                    const SizedBox(height: 30),
                    
                    // Menu items list
                    ..._menuItems.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> item = entry.value;
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                          
                          // Navigation logic based on menu item
                          switch (item['title']) {
                            case 'Profile':
                              Navigator.pushNamed(context, '/profile_page');
                              break;
                            case 'Home Page':
                              Navigator.pushNamed(context, '/home_page');
                              break;
                            case 'My Cart':
                              Navigator.pushNamed(context, '/cart_page');
                              break;
                            case 'Favorite':
                              Navigator.pushNamed(context, '/favorite_page');
                              break;
                            case 'Orders':
                              Navigator.pushNamed(context, '/orders_page');
                              break;
                            case 'Notifications':
                              Navigator.pushNamed(context, '/notifications_page');
                              break;
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 34),
                          child: Row(
                            children: [
                              Icon(
                                item['icon'],
                                color: _selectedIndex == index 
                                    ? const Color.fromRGBO(91, 158, 225, 1) 
                                    : Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 24),
                              Text(
                                item['title'],
                                style: GoogleFonts.poppins(
                                  color: _selectedIndex == index 
                                      ? const Color.fromRGBO(91, 158, 225, 1) 
                                      : Colors.white,
                                  fontSize: 16,
                                  fontWeight: _selectedIndex == index 
                                      ? FontWeight.w500 
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    
                    const SizedBox(height: 20),
                    
                    // Divider
                    Container(
                      width: 147,
                      height: 1,
                      color: const Color.fromRGBO(112, 123, 129, 0.3),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Sign out button
                    GestureDetector(
                      onTap: logout,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 24),
                          Text(
                            'Sign Out',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Tilted homepage preview
            Positioned(
              top: 124,
              right: -100, // Positioned to be partially off-screen
              child: Transform.rotate(
                angle: 6.62 * (math.pi / 180), // Slight rotation as in original
                child: Container(
                  width: 277,
                  height: 600,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: const DecorationImage(
                      image: AssetImage('lib/images/home_preview.png'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileSection() {
    return SizedBox(
      width: 165,
      height: 154,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile image
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(223, 239, 255, 1),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('lib/images/profile.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Greeting text
          Text(
            'Hey, 👋',
            style: GoogleFonts.poppins(
              color: const Color.fromRGBO(112, 123, 129, 1),
              fontSize: 20,
              fontWeight: FontWeight.normal,
              height: 1.4,
            ),
          ),
          
          // Username text
          Text(
            'RGIT Student',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.normal,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
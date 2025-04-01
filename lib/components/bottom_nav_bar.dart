import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavbar extends StatelessWidget {
  const MyBottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
            color: Colors.white,
            backgroundColor: Colors.black,
            activeColor: Colors.white,
            tabActiveBorder: Border.all(color: Colors.white),
            tabBackgroundColor: Colors.grey.shade800,
            padding: const EdgeInsets.all(12),
            gap: 8,
            onTabChange: (index) {
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, '/home_page');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/cart_page');
                  break;
                case 2:
                  Navigator.pushNamed(context, '/fav_page');
                  break;
                case 3:
                  Navigator.pushNamed(context, '/customize_page');
                  break;
              }
            },
            tabs: const [
              GButton(
                icon: Icons.home, 
                text: 'Home',
              ),
              GButton(
                icon: Icons.shopping_bag_rounded, 
                text: 'Cart',
              ),
              GButton(
                icon: Icons.favorite, 
                text: 'Favorites',
              ),
              GButton(
                icon: Icons.design_services, 
                text: 'Customize',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

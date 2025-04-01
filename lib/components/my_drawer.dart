import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rgit_apparels/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Icon(
                  Icons.shopping_bag,
                  size: 72,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(height: 25),
              MyListTile(
                  text: "Shop",
                  icon: Icons.home,
                  onTap: () => {Navigator.pushNamed(context, '/shop_page')}),
              MyListTile(
                  text: "Cart",
                  icon: Icons.shopping_cart,
                  onTap: () {
                    Navigator.pushNamed(context, '/cart_page');
                  }),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: MyListTile(
                text: "Logout",
                icon: Icons.logout,
                onTap: () {
                  FirebaseAuth.instance.signOut();
                }
            ),
          ),
        ],
      ),
    );
  }
}

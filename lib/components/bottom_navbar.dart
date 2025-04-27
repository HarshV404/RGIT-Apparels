import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    this.currentIndex = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: 75,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(context, Icons.home, 0, currentIndex == 0 ? const Color(0xFF1A242F) : const Color(0xFF707B81)),
            _buildNavItem(context, Icons.favorite_border, 1, currentIndex == 1 ? const Color(0xFF1A242F) : const Color(0xFF707B81)),
            _buildCenterButton(context),
            _buildNavItem(context, Icons.notifications_none, 3, currentIndex == 3 ? const Color(0xFF1A242F) : const Color(0xFF707B81)),
            _buildNavItem(context, Icons.person_outline, 4, currentIndex == 4 ? const Color(0xFF1A242F) : const Color(0xFF707B81)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, int index, Color color) {
    return GestureDetector(
      onTap: () {
        onTap(index);
        _navigateToScreen(context, index);
      },
      child: Icon(icon, color: color),
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: GestureDetector(
        onTap: () {
          onTap(2);
          _navigateToScreen(context, 2);
        },
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF5B9EE1),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5B9EE1).withOpacity(0.6),
                offset: const Offset(0, 8),
                blurRadius: 24,
              ),
            ],
          ),
          child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, int index) {
    // Clear the navigation stack and navigate to the selected screen
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home_page');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/fav-page');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/cart_page');
        break;
      case 3:
        // Assuming notifications might be part of customization
        Navigator.pushReplacementNamed(context, 'customize_page');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile_page');
        break;
    }
  }
}
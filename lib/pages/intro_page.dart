import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rgit_apparels/auth/main_page.dart';
import 'dart:async';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  // Page controller for the PageView
  final PageController _pageController = PageController();
  
  // Current page index
  int _currentPage = 0;
  
  // Timer for auto-sliding
  Timer? _timer;
  
  // List of onboarding pages data
  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Start Journey\nWith RGIT',
      'subtitle': 'Smart, Gorgeous & Fashionable Collection',
      'image': 'lib/images/sneaker1.png',
    },
    {
      'title': 'Follow Latest\nStyle Clothes',
      'subtitle': 'High Quality Apparels For Your Wardrobe',
      'image': 'lib/images/apparel2.png',
    },
    {
      'title': 'College Merch\nRGIT 2025',
      'subtitle': 'Exclusive Collection For RGIT Students',
      'image': 'lib/images/apparel3.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the auto-slide timer
    _startAutoSlide();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // Method to start auto-sliding
  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _pages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get device size to make image sizing responsive
    final Size screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 249, 250, 1),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(
                    _pages[index]['title'],
                    _pages[index]['subtitle'],
                    _pages[index]['image'],
                    screenSize,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: index == _currentPage ? 35 : 8,
                        height: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: index == _currentPage
                              ? const Color.fromRGBO(91, 158, 225, 1)
                              : const Color.fromRGBO(229, 238, 247, 1),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Action button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_currentPage < _pages.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeIn,
                            );
                          } else {
                            // Navigate to the main page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainPage(),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color.fromRGBO(91, 158, 225, 1),
                          ),
                          child: Text(
                            _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(String title, String subtitle, String imagePath, Size screenSize) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section with increased size
          Expanded(
            flex: 3, // Increased flex to give more space to the image
            child: Stack(
              children: [
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(164, 205, 246, 1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Centered image with increased size
                Align(
                  alignment: Alignment.center,
                  child: Hero(
                    tag: imagePath,
                    child: Container(
                      height: screenSize.height * 0.4, // 40% of screen height
                      width: screenSize.width * 0.8, // 80% of screen width
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(imagePath),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(91, 158, 225, 1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Text content
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(26, 36, 47, 1),
                    height: 1, // Line height adjustment for the title
                  ),
                ),
                const SizedBox(height: k20),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: const Color.fromRGBO(112, 123, 129, 1),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// For better maintainability, define constants
const double k20 = 20.0;
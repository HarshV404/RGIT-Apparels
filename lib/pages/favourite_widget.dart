import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FavouriteWidget extends StatefulWidget {
  const FavouriteWidget({super.key});

  @override
  State<FavouriteWidget> createState() => _FavouriteWidgetState();
}

class _FavouriteWidgetState extends State<FavouriteWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Favourite',
          style: TextStyle(
            color: Color(0xFF1A242F),
            fontFamily: 'Airbnb Cereal App',
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/back_arrow.svg'),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/images/filter_icon.svg'),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // First row of product cards
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildProductCard(
                      image: 'assets/images/Pngitem_555064222.png',
                      isBestSeller: true,
                      name: 'Nike Jordan',
                      price: 58.7,
                      colors: const [Color(0xFFFDFFA7), Color(0xFF6CCFC0)],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildProductCard(
                      image: 'assets/images/Nikezoomwinflo3831561001mensrunningshoes11550187236tiyyje6l87_prev_ui1.png',
                      isBestSeller: true,
                      name: 'Nike Air Max',
                      price: 37.8,
                      colors: const [Color(0xFF91CAFF), Color(0xFF646A7E)],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Second row of product cards
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildProductCard(
                      image: 'assets/images/Nikeah8050110air_max_2701e_prev_ui2.png',
                      isBestSeller: true,
                      name: 'Nike Club Max',
                      price: 47.7,
                      colors: const [Color(0xFF1685D4), Color(0xFFF6C854)],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildProductCard(
                      image: 'assets/images/Pngaaa.png',
                      isBestSeller: true,
                      name: 'Nike Air Max',
                      price: 57.6,
                      colors: const [Color(0xFF7DDBDA), Color(0xFF5F6ACA)],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard({
    required String image,
    required bool isBestSeller,
    required String name,
    required double price,
    required List<Color> colors,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          SizedBox(
            height: 120,
            child: Center(
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Product info
          if (isBestSeller)
            const Text(
              'Best Seller',
              style: TextStyle(
                color: Color(0xFF5B9EE1),
                fontFamily: 'Airbnb Cereal App',
                fontSize: 12,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(
              color: Color(0xFF1A242F),
              fontFamily: 'Airbnb Cereal App',
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 12),
          
          // Price and color options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${price.toStringAsFixed(1)}',
                style: const TextStyle(
                  color: Color(0xFF1A242F),
                  fontFamily: 'Airbnb Cereal App',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Row(
                children: colors.map((color) => _buildColorOption(color)).toList(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Favorite button
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: const Color(0xFFF8F9FA),
                ),
                padding: const EdgeInsets.all(6),
                child: SvgPicture.asset(
                  'assets/images/heart_icon.svg',
                  width: 16,
                  height: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: const Color(0xFFF8F9FA),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
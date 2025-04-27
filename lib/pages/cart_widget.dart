import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class MyCartWidget extends StatelessWidget {
  const MyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(),
            // Cart Items List
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildCartItem(
                      image: 'lib/images/Nikeepicreactflyknitskybluerunningshoes1_prev_ui1.png',
                      title: 'Nike Club Max',
                      price: 64.95,
                      size: 'L',
                      bgSvg: 'lib/images/rectangle797.svg',
                      angle: 17.87,
                    ),
                    const SizedBox(height: 30),
                    _buildCartItem(
                      image: 'lib/images/Pngaaa.png',
                      title: 'Nike Air Max 200',
                      price: 64.95,
                      size: 'XL',
                      bgSvg: 'lib/images/rectangle798.svg',
                      angle: -165.39,
                    ),
                    const SizedBox(height: 30),
                    _buildCartItem(
                      image: 'lib/images/Pngaaa1.png',
                      title: 'Nike Air Max',
                      price: 64.95,
                      size: 'XXL',
                      bgSvg: 'lib/images/rectangle799.svg',
                      angle: -27.88,
                    ),
                  ],
                ),
              ),
            ),
            // Checkout Panel
            _buildCheckoutPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.all(15),
            child: SvgPicture.asset(
              'lib/images/vector175stroke.svg',
              width: 24,
              height: 24,
            ),
          ),
          const Spacer(),
          const Text(
            'My Cart',
            style: TextStyle(
              color: Color(0xFF1A242F),
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 94), // Maintains original spacing
        ],
      ),
    );
  }

  Widget _buildCartItem({
    required String image,
    required String title,
    required double price,
    required String size,
    required String bgSvg,
    required double angle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image
        SizedBox(
          width: 87,
          height: 85,
          child: Stack(
            children: [
              SvgPicture.asset(bgSvg),
              Positioned.fill(
                child: Transform.rotate(
                  angle: angle * (math.pi / 180),
                  child: Image.asset(
                    image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Product Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1A242F),
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$$price',
                style: const TextStyle(
                  color: Color(0xFF1A242F),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              // Quantity Controls
              Row(
                children: [
                  _buildQuantityButton(Icons.remove, Colors.white),
                  const SizedBox(width: 16),
                  const Text(
                    '1',
                    style: TextStyle(
                      color: Color(0xFF101817),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildQuantityButton(Icons.add, const Color(0xFF5B9EE1)),
                ],
              ),
            ],
          ),
        ),
        // Size and Delete
        Column(
          children: [
            Text(
              size,
              style: const TextStyle(
                color: Color(0xFF1A242F),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            IconButton(
              icon: SvgPicture.asset('lib/images/vector.svg'),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantityButton(IconData icon, Color bgColor) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 12,
        color: bgColor == Colors.white ? Colors.black : Colors.white,
      ),
    );
  }

  Widget _buildCheckoutPanel() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Subtotal and Shipping
          _buildPriceRow('Subtotal', '\$1250.00'),
          const SizedBox(height: 16),
          _buildPriceRow('Shopping', '\$40.90'),
          const SizedBox(height: 24),
          // Divider
          const Divider(),
          const SizedBox(height: 16),
          // Total
          _buildPriceRow('Total Cost', '\$1690.99', isTotal: true),
          const SizedBox(height: 24),
          // Checkout Button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B9EE1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              minimumSize: const Size(double.infinity, 0),
            ),
            child: const Text(
              'Checkout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? const Color(0xFF1A242F) : const Color(0xFF707B81),
            fontSize: isTotal ? 20 : 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF1A242F),
            fontSize: isTotal ? 20 : 18,
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rgit_apparels/services/firestore_services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductDetailsWidget extends StatefulWidget {
  final String productId;
  
  const ProductDetailsWidget({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailsWidget> createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _selectedSize = '40';
  bool _isLoading = false;
  bool _isFavorite = false;
  
  String getCurrentUserId() {
    final user = _auth.currentUser;
    return user?.uid ?? 'current_user';
  }

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    try {
      final userId = getCurrentUserId();
      final isFavorite = await _firestoreService.isProductInFavorites(userId, widget.productId);
      setState(() {
        _isFavorite = isFavorite;
      });
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestoreService.getProductById(widget.productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Product not found'));
          }
          
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final productName = data['name'] ?? 'Unknown Product';
          final brand = data['brand'] ?? '';
          final price = data['price']?.toString() ?? '0.00';
          final description = data['description'] ?? 'No description available';
          final imagePath = data['imagePath'] ?? '';
          final tag = data['tag'] ?? 'Best Seller';
          
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Color(0xFFF8F9FA),
            ),
            child: Stack(
              children: <Widget>[
                // Status bar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: Container(
                      margin: const EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.white,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: Color(0xFF1A242F),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    title: Text(
                      '$brand Shoes',
                      style: const TextStyle(
                        color: Color(0xFF1A242F),
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    centerTitle: true,
                    actions: [
                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white,
                        ),
                        child: IconButton(
                          icon: _isFavorite
                              ? SvgPicture.asset(
                                  'assets/images/heart_filled_icon.svg',
                                  width: 20,
                                  height: 20,
                                  color: Colors.red,
                                )
                              : SvgPicture.asset(
                                  'assets/images/heart_icon.svg',
                                  width: 20,
                                  height: 20,
                                ),
                          onPressed: () => _toggleFavorite(),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Rest of the product details page remains the same...
                // (Keep all the existing Positioned widgets for product image, details, etc.)
                
                // Product image
                Positioned(
                  top: 112,
                  left: 32,
                  right: 32,
                  child: SizedBox(
                    height: 202,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 65,
                          child: Center(
                            child: imagePath.isNotEmpty
                                ? Image.network(
                                    imagePath,
                                    fit: BoxFit.contain,
                                    errorBuilder: (ctx, error, _) => Icon(
                                      Icons.image_not_supported,
                                      size: 80,
                                      color: Colors.grey[400],
                                    ),
                                  )
                                : Icon(
                                    Icons.image_not_supported,
                                    size: 80,
                                    color: Colors.grey[400],
                                  ),
                          ),
                        ),
                        // Selection indicator with dots
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF5B9EE1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 110),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x665B9EE1),
                                      offset: Offset(0, 6),
                                      blurRadius: 16,
                                    ),
                                  ],
                                  color: Color(0xFF5B9EE1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 110),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF5B9EE1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Product details section
                Positioned(
                  top: 330,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product title section
                                Text(
                                  tag,
                                  style: const TextStyle(
                                    color: Color(0xFF5B9EE1),
                                    fontSize: 14,
                                    height: 1.29,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  productName,
                                  style: const TextStyle(
                                    color: Color(0xFF1A242F),
                                    fontSize: 24,
                                    height: 1.17,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '\$$price',
                                  style: const TextStyle(
                                    color: Color(0xFF1A242F),
                                    fontSize: 20,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  description,
                                  style: const TextStyle(
                                    color: Color(0xFF707B81),
                                    fontSize: 14,
                                    height: 1.57,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Gallery section
                                const Text(
                                  'Gallery',
                                  style: TextStyle(
                                    color: Color(0xFF1A242F),
                                    fontSize: 18,
                                    height: 1.22,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _buildGalleryItem(imagePath, -165.43),
                                      const SizedBox(width: 16),
                                      _buildGalleryItem(imagePath, 14.5),
                                      const SizedBox(width: 16),
                                      _buildGalleryItem(imagePath, 14.5),
                                    ],
                                  ),
                                ),
                                
                                // Size selection section
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Size',
                                      style: TextStyle(
                                        color: Color(0xFF1A242F),
                                        fontSize: 18,
                                        height: 1.22,
                                      ),
                                    ),
                                    Row(
                                      children: const [
                                        Text(
                                          'EU',
                                          style: TextStyle(
                                            color: Color(0xFF1A242F),
                                            fontSize: 14,
                                            height: 1.43,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'US',
                                          style: TextStyle(
                                            color: Color(0xFF707B81),
                                            fontSize: 14,
                                            height: 1.43,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'UK',
                                          style: TextStyle(
                                            color: Color(0xFF707B81),
                                            fontSize: 14,
                                            height: 1.43,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                
                                // Size options
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _buildSizeOption('38', _selectedSize == '38'),
                                      const SizedBox(width: 13),
                                      _buildSizeOption('39', _selectedSize == '39'),
                                      const SizedBox(width: 13),
                                      _buildSizeOption('40', _selectedSize == '40'),
                                      const SizedBox(width: 13),
                                      _buildSizeOption('41', _selectedSize == '41'),
                                      const SizedBox(width: 13),
                                      _buildSizeOption('42', _selectedSize == '42'),
                                      const SizedBox(width: 13),
                                      _buildSizeOption('43', _selectedSize == '43'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                        
                        // Bottom price and add to cart section
                        Container(
                          height: 94,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x1F8AAAD1),
                                offset: Offset(-1.5, 0),
                                blurRadius: 4,
                              ),
                            ],
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Price',
                                    style: TextStyle(
                                      color: Color(0xFF707B81),
                                      fontSize: 16,
                                      height: 1.25,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '\$$price',
                                    style: const TextStyle(
                                      color: Color(0xFF1A242F),
                                      fontSize: 20,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                              _isLoading
                                  ? const CircularProgressIndicator(color: Color(0xFF5B9EE1))
                                  : ElevatedButton(
                                      onPressed: () => _addToCart(widget.productId),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF5B9EE1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                      ),
                                      child: const Text(
                                        'Add To Cart',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          height: 1.22,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final userId = getCurrentUserId();
      if (_isFavorite) {
        await _firestoreService.removeFromFavorites(userId, widget.productId);
      } else {
        await _firestoreService.addToFavorites(userId, widget.productId);
      }
      
      setState(() {
        _isFavorite = !_isFavorite;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites'),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Keep all the existing helper methods (_buildGalleryItem, _buildSizeOption, _addToCart)
  Widget _buildGalleryItem(String imagePath, double rotationAngle) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Positioned(
            top: rotationAngle.abs() > 90 ? 12 : 22,
            left: 3,
            child: Transform.rotate(
              angle: rotationAngle * math.pi / 180,
              child: Container(
                width: 45,
                height: 22,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x296A6D71),
                      offset: Offset(0, 8),
                      blurRadius: 12,
                    ),
                  ],
                  image: imagePath.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(imagePath),
                          fit: BoxFit.contain,
                        )
                      : null,
                ),
                child: imagePath.isEmpty
                    ? Icon(
                        Icons.image_not_supported,
                        size: 20,
                        color: Colors.grey[400],
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeOption(String size, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = size;
        });
      },
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.5),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Color(0x665B9EE1),
                    offset: Offset(0, 8),
                    blurRadius: 16,
                  ),
                ]
              : null,
          color: isSelected ? const Color(0xFF5B9EE1) : const Color(0xFFF8F9FA),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF707B81),
              fontFamily: 'Airbnb Cereal App',
              fontSize: 16,
              height: 1.25,
            ),
          ),
        ),
      ),
    );
  }
  
  void _addToCart(String productId) async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final userId = getCurrentUserId();
      await _firestoreService.addToCart(userId, productId);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added to cart')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding to cart: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
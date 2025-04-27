import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rgit_apparels/pages/home_widget.dart';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rgit_apparels/services/firestore_services.dart';

class MyCartWidget extends StatefulWidget {
  const MyCartWidget({super.key});

  @override
  State<MyCartWidget> createState() => _MyCartWidgetState();
}

class _MyCartWidgetState extends State<MyCartWidget> {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  double _subtotal = 0.0;
  double _shipping = 40.90;
  bool _isLoading = false;
  
  String getCurrentUserId() {
    final user = _auth.currentUser;
    return user?.uid ?? 'current_user'; // Fallback for testing
  }

  Future<void> _updateCartItemQuantity(String cartItemId, int newQuantity) async {
    if (newQuantity <= 0) {
      // Remove item if quantity becomes zero or negative
      await _firestoreService.removeFromCart(getCurrentUserId(), cartItemId);
    } else {
      // Update quantity
      await _firestoreService.updateCartItemQuantity(getCurrentUserId(), cartItemId, newQuantity);
    }
  }

  Future<void> _removeCartItem(String cartItemId) async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      await _firestoreService.removeFromCart(getCurrentUserId(), cartItemId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item removed from cart')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing item: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Calculate subtotal from cart items
  double _calculateSubtotal(List<DocumentSnapshot> cartItems) {
    double total = 0.0;
    for (var item in cartItems) {
      final data = item.data() as Map<String, dynamic>;
      
      // Get price directly from cart item if available
      final price = data.containsKey('price') 
          ? (double.tryParse(data['price']?.toString() ?? '0') ?? 0.0) 
          : 0.0;
      
      final quantity = data['quantity'] ?? 1;
      total += price * quantity;
    }
    return total;
  }

  void _checkout() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Process checkout logic here
      final userId = getCurrentUserId();
      
      // Get the current cart items for the total calculation
      final cartSnapshot = await _firestoreService.getUserCartItemsOnce(userId);
      final cartItems = cartSnapshot.docs;
      final subtotal = _calculateSubtotal(cartItems);
      final total = subtotal + _shipping;
      
      // Create order details
      final orderDetails = {
        'subtotal': subtotal,
        'shipping': _shipping,
        'total': total,
        // Add more details as needed
      };
      
      // Process the checkout
      await _firestoreService.processCheckout(userId, orderDetails);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );
      
      // Navigate back to home
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeWidget()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checkout error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestoreService.getUserCartItems(getCurrentUserId()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Your cart is empty'));
                  }
                  
                  final cartItems = snapshot.data!.docs;
                  
                  // Calculate and update subtotal when cart data changes
                  _subtotal = _calculateSubtotal(cartItems);
                  
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        ...cartItems.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final productId = data['productId'];
                          final quantity = data['quantity'] ?? 1;
                          
                          return FutureBuilder<DocumentSnapshot>(
                            future: _firestoreService.getProductById(productId),
                            builder: (context, productSnapshot) {
                              if (!productSnapshot.hasData) {
                                return const SizedBox(
                                  height: 85,
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                              
                              if (productSnapshot.hasError || 
                                  !productSnapshot.data!.exists) {
                                return const SizedBox();
                              }
                              
                              final productData = productSnapshot.data!.data() 
                                  as Map<String, dynamic>;
                              
                              // Get price from product data
                              final price = double.tryParse(
                                productData['price']?.toString() ?? '0'
                              ) ?? 0.0;
                              
                              // Update price in cart item if missing
                              // This ensures we have pricing data in the cart items
                              if (!data.containsKey('price')) {
                                _firestoreService.updateCartItemPrice(
                                  getCurrentUserId(), 
                                  doc.id, 
                                  price
                                );
                              }
                                  
                              return Column(
                                children: [
                                  _buildCartItem(
                                    cartItemId: doc.id,
                                    image: productData['imagePath'] ?? '',
                                    title: productData['name'] ?? 'Unknown Product',
                                    price: price,
                                    size: data['size'] ?? 'M',
                                    bgSvg: _getBackgroundSvg(productData['brand']),
                                    angle: _getAngle(productData['name'] ?? ''),
                                    quantity: quantity,
                                  ),
                                  const SizedBox(height: 30),
                                ],
                              );
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Checkout panel with latest subtotal
            StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.getUserCartItems(getCurrentUserId()),
              builder: (context, snapshot) {
                double subtotal = 0.0;
                
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  subtotal = _calculateSubtotal(snapshot.data!.docs);
                }
                
                return _buildCheckoutPanel(subtotal);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getBackgroundSvg(String? brand) {
    // Map brands to background SVGs
    switch (brand?.toLowerCase() ?? '') {
      case 'nike':
        return 'lib/images/rectangle797.svg';
      case 'adidas':
        return 'lib/images/rectangle798.svg';
      case 'puma':
        return 'lib/images/rectangle799.svg';
      default:
        return 'lib/images/rectangle797.svg';
    }
  }

  double _getAngle(String productName) {
    // Create a deterministic angle based on product name
    if (productName.contains('Air Max')) {
      return -27.88;
    } else if (productName.contains('Club')) {
      return 17.87;
    } else {
      return -165.39;
    }
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeWidget()),
                (Route<dynamic> route) => false,
              );
            },
          ),
          const Spacer(),
          const Text(
            'My Cart',
            style: TextStyle(
              color: Color(0xFF1A242F),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 94),
        ],
      ),
    );
  }

  Widget _buildCartItem({
    required String cartItemId,
    required String image,
    required String title,
    required double price,
    required String size,
    required String bgSvg,
    required double angle,
    required int quantity,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 87,
          height: 85,
          child: Stack(
            children: [
              SvgPicture.asset(bgSvg),
              Positioned.fill(
                child: Transform.rotate(
                  angle: angle * (math.pi / 180),
                  child: image.isNotEmpty && image.startsWith('http')
                    ? Image.network(
                        image,
                        fit: BoxFit.contain,
                        errorBuilder: (ctx, error, _) => Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      )
                    : Image.asset(
                        'lib/images/Nikeepicreactflyknitskybluerunningshoes1_prev_ui1.png',
                        fit: BoxFit.contain,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
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
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _updateCartItemQuantity(cartItemId, quantity - 1),
                    child: _buildQuantityButton(Icons.remove, Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    quantity.toString(),
                    style: const TextStyle(
                      color: Color(0xFF101817),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => _updateCartItemQuantity(cartItemId, quantity + 1),
                    child: _buildQuantityButton(Icons.add, Color(0xFF5B9EE1)),
                  ),
                ],
              ),
            ],
          ),
        ),
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
              onPressed: () => _removeCartItem(cartItemId),
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

  Widget _buildCheckoutPanel(double subtotal) {
    final totalCost = subtotal + _shipping;
    
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
          _buildPriceRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          _buildPriceRow('Shipping', '\$${_shipping.toStringAsFixed(2)}'),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          _buildPriceRow('Total Cost', '\$${totalCost.toStringAsFixed(2)}', isTotal: true),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _checkout,
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
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
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
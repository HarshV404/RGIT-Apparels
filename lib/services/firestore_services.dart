import 'package:cloud_firestore/cloud_firestore.dart';

// Update your firestore_services.dart file with these changes:

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ... (keep all existing methods above the processCheckout method)

  // Favorite-related methods (move these outside of processCheckout)
  Future<bool> isProductInFavorites(String userId, String productId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(productId)
          .get();
      return doc.exists;
    } catch (e) {
      throw Exception('Error checking favorites: $e');
    }
  }

  Future<void> addToFavorites(String userId, String productId) async {
    try {
      // First get product details to save in favorites
      final productDoc = await getProductById(productId);
      if (!productDoc.exists) {
        throw Exception('Product not found');
      }
      final productData = productDoc.data() as Map<String, dynamic>;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(productId)
          .set({
            'productId': productId,
            'name': productData['name'] ?? 'Unknown Product',
            'price': productData['price'] ?? 0.0,
            'imagePath': productData['imagePath'] ?? '',
            'brand': productData['brand'] ?? '',
            'addedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('Error adding to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(String userId, String productId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(productId)
          .delete();
    } catch (e) {
      throw Exception('Error removing from favorites: $e');
    }
  }

  Stream<QuerySnapshot> getUserFavorites(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .orderBy('addedAt', descending: true)
        .snapshots();
  }

  // Get store location
  Stream<DocumentSnapshot> getStoreLocation() {
    return _firestore.collection('app_settings').doc('store_location').snapshots();
  }

  // Get brands list from Firestore
  Future<List<String>> getBrandsList() async {
    final snapshot = await _firestore.collection('Brands').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return data['name'] as String? ?? '';
    }).where((name) => name.isNotEmpty).toList();
  }

  // Get popular products by brand
  Stream<QuerySnapshot> getPopularProductsByBrand(String brand, int limit) {
    return _firestore
        .collection('Products')
        .where('brand', isEqualTo: brand)
        .where('isPopular', isEqualTo: true)
        .limit(limit)
        .snapshots();
  }

  // Get new arrivals by brand
  Stream<QuerySnapshot> getNewArrivalsByBrand(String brand, int limit) {
    return _firestore
        .collection('Products')
        .where('brand', isEqualTo: brand)
        .where('isNewArrival', isEqualTo: true)
        .limit(limit)
        .snapshots();
  }

  // Add item to cart (updated to include price)
  Future<void> addToCart(String userId, String productId) async {
    // First get product details to save price
    final productDoc = await getProductById(productId);
    double price = 0.0;
    
    if (productDoc.exists) {
      final productData = productDoc.data() as Map<String, dynamic>;
      price = double.tryParse(productData['price']?.toString() ?? '0') ?? 0.0;
    }
    
    // Check if the item is already in the cart
    final existingCartItem = await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .where('productId', isEqualTo: productId)
        .get();

    if (existingCartItem.docs.isNotEmpty) {
      // Item already exists, increment quantity
      final docId = existingCartItem.docs.first.id;
      final currentQuantity = existingCartItem.docs.first.data()['quantity'] as int? ?? 0;
      
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(docId)
          .update({
        'quantity': currentQuantity + 1,
        'price': price, // Make sure price is updated/saved
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      // Item doesn't exist, add new cart item
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .add({
        'productId': productId,
        'quantity': 1,
        'size': 'M', // Default size
        'price': price, // Save price in cart item
        'addedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Update cart item price (new method)
  Future<void> updateCartItemPrice(String userId, String cartItemId, double price) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(cartItemId)
        .update({
      'price': price,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get user cart items as a stream
  Stream<QuerySnapshot> getUserCartItems(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .snapshots();
  }
  
  // Get user cart items once (not as a stream)
  Future<QuerySnapshot> getUserCartItemsOnce(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .get();
  }
  
  // Get product by ID
  Future<DocumentSnapshot> getProductById(String productId) {
    return _firestore.collection('Products').doc(productId).get();
  }
  
  // Update cart item quantity
  Future<void> updateCartItemQuantity(String userId, String cartItemId, int newQuantity) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(cartItemId)
        .update({
      'quantity': newQuantity,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
  
  // Remove item from cart
  Future<void> removeFromCart(String userId, String cartItemId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(cartItemId)
        .delete();
  }
  
  // Process checkout
  Future<void> processCheckout(String userId, Map<String, dynamic> orderDetails) async {
    // Create a new order document
    final orderRef = await _firestore.collection('orders').add({
      'userId': userId,
      'orderDate': FieldValue.serverTimestamp(),
      'status': 'pending',
      'subtotal': orderDetails['subtotal'],
      'shipping': orderDetails['shipping'],
      'total': orderDetails['total'],
      'address': orderDetails['address'] ?? {},
      'paymentMethod': orderDetails['paymentMethod'] ?? 'card',
    });
    
    // Get all cart items
    final cartItems = await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .get();
    
    // Add each cart item to the order items subcollection
    for (var item in cartItems.docs) {
      final itemData = item.data();
      final productId = itemData['productId'];
      final price = itemData['price'] ?? 0.0; // Use price from cart item
      
      // Get product details
      final productDoc = await getProductById(productId);
      if (productDoc.exists) {
        final productData = productDoc.data() as Map<String, dynamic>;
        
        await orderRef.collection('items').add({
          'productId': productId,
          'productName': productData['name'] ?? 'Unknown Product',
          'price': price, // Use the price from cart item
          'quantity': itemData['quantity'] ?? 1,
          'size': itemData['size'] ?? 'M',
          'brand': productData['brand'] ?? '',
          'imagePath': productData['imagePath'] ?? '',
        });
      }
    }
    
    // Clear the cart after successful checkout
    for (var item in cartItems.docs) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(item.id)
          .delete();
    }
  }
}
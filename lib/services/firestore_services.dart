import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Create a Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get products => _firestore.collection('products');
  CollectionReference get users => _firestore.collection('users');
  CollectionReference get orders => _firestore.collection('orders');
  CollectionReference get appSettings => _firestore.collection('app_settings');
  CollectionReference get brands => _firestore.collection('brands');

  // Store location methods
  Stream<DocumentSnapshot> getStoreLocation() {
    return appSettings.doc('store_location').snapshots();
  }

  // Brand methods
  Future<List<String>> getBrandsList() async {
    try {
      final snapshot = await brands.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['name'] as String;
      }).toList();
    } catch (e) {
      // Return default brands if there's an error
      return ['Nike', 'Adidas', 'Puma', 'Under Armour', 'Reebok'];
    }
  }

  // Product methods with filtering
  Stream<QuerySnapshot> getPopularProductsByBrand(String brand, int limit) {
    return _firestore
        .collection('products')
        .where('brand', isEqualTo: brand)
        .where('isPopular', isEqualTo: true)
        .limit(limit)
        .snapshots();
  }

  Stream<QuerySnapshot> getNewArrivalsByBrand(String brand, int limit) {
    return _firestore
        .collection('products')
        .where('brand', isEqualTo: brand)
        .where('isNewArrival', isEqualTo: true)
        .limit(limit)
        .snapshots();
  }

  // Search products
  Future<QuerySnapshot> searchProducts(String query) {
    // This is a simple implementation. For production, consider using
    // a more sophisticated search solution like Algolia
    return products
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .get();
  }

  // Cart methods
  Stream<QuerySnapshot> getUserCartItems(String userId) {
    return _firestore
        .collection('user_cart')
        .doc(userId)
        .collection('items')
        .snapshots();
  }

  Future<void> addToCart(String userId, String productId) async {
    final cartRef =
        _firestore.collection('user_cart').doc(userId).collection('items');

    // Check if item exists
    final existingItem = await cartRef.doc(productId).get();

    if (existingItem.exists) {
      // Increment quantity if item exists
      final currentData = existingItem.data() as Map<String, dynamic>;
      final currentQuantity = currentData['quantity'] as int? ?? 1;

      await cartRef.doc(productId).update({
        'quantity': currentQuantity + 1,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      // Add new item with quantity 1
      await cartRef.doc(productId).set({
        'productId': productId,
        'quantity': 1,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> removeFromCart(String userId, String productId) {
    return _firestore
        .collection('user_cart')
        .doc(userId)
        .collection('items')
        .doc(productId)
        .delete();
  }

  Future<void> updateCartItemQuantity(
      String userId, String productId, int quantity) {
    return _firestore
        .collection('user_cart')
        .doc(userId)
        .collection('items')
        .doc(productId)
        .update({
      'quantity': quantity,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Favorites methods
  Stream<QuerySnapshot> getUserFavorites(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots();
  }

  Future<void> addToFavorites(String userId, String productId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(productId)
        .set({'productId': productId, 'addedAt': FieldValue.serverTimestamp()});
  }

  Future<void> removeFromFavorites(String userId, String productId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(productId)
        .delete();
  }

  // Product details
  Future<DocumentSnapshot> getProductDetails(String productId) {
    return products.doc(productId).get();
  }

  // Order methods
  Future<DocumentReference> createOrder(
      String userId, Map<String, dynamic> orderData) {
    // Add userId to the order data
    orderData['userId'] = userId;
    orderData['createdAt'] = FieldValue.serverTimestamp();
    orderData['status'] = 'pending';

    return orders.add(orderData);
  }

  Stream<QuerySnapshot> getUserOrders(String userId) {
    return orders
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get a specific order by ID
  Future<DocumentSnapshot> getOrderById(String orderId) {
    return orders.doc(orderId).get();
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:rgit_apparels/components/bottom_navbar.dart';
import 'package:rgit_apparels/services/firestore_services.dart';
import 'package:rgit_apparels/models/shop.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _currentIndex = 0;
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _selectedBrand = 'Nike';
  List<String> _brands = ['Nike', 'Adidas', 'Puma', 'Under Armour', 'Reebok'];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  void _checkAuthentication() {
    final user = _auth.currentUser;
    if (user == null) {
      // Redirect to auth page if not authenticated
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/auth_page');
      });
    }
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _selectBrand(String brand) {
    setState(() {
      _selectedBrand = brand;
    });
  }

  @override
  Widget build(BuildContext context) {
    final shop = Provider.of<Shop>(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 30),
              _buildBrandFilters(),
              const SizedBox(height: 30),
              _buildPopularShoesSection(),
              const SizedBox(height: 30),
              _buildNewArrivalsSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.menu, color: Colors.black),
        ),
      ),
      title: StreamBuilder<DocumentSnapshot>(
        stream: _firestoreService.getStoreLocation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _DefaultLocationWidget();
          }
          
          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return const _DefaultLocationWidget();
          }
          
          final data = snapshot.data!.data() as Map<String, dynamic>?;
          final locationName = data?['name'] ?? 'Mondolibug, Sylhet';
          
          return Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Store location',
                    style: TextStyle(
                      color: Color(0xFF707B81),
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        locationName,
                        style: const TextStyle(
                          color: Color(0xFF1A242F),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        }
      ),
      actions: [
        StreamBuilder<QuerySnapshot>(
          stream: _firestoreService.getUserCartItems(getCurrentUserId()),
          builder: (context, snapshot) {
            int cartCount = 0;
            if (snapshot.hasData) {
              cartCount = snapshot.data!.docs.length;
            }
            
            return Stack(
              alignment: Alignment.topRight,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
                      onPressed: () {
                        Navigator.pushNamed(context, '/cart_page');
                      },
                    ),
                  ),
                ),
                if (cartCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF77165),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            );
          }
        ),
      ],
    );
  }

  String getCurrentUserId() {
    final user = _auth.currentUser;
    return user?.uid ?? 'current_user'; // Fallback for testing
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(Icons.search, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Looking for shoes',
                hintStyle: TextStyle(
                  color: Color(0xFF707B81),
                  fontSize: 14,
                ),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                // Will implement search functionality later
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandFilters() {
    return FutureBuilder<List<String>>(
      future: _firestoreService.getBrandsList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildDefaultBrandFilters();
        }
        
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildDefaultBrandFilters();
        }
        
        // Get brand list from Firestore
        final brands = snapshot.data!;
        
        // Update the stored brands list
        _brands = brands;
        
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: brands.map((brand) {
              final isSelected = brand == _selectedBrand;
              
              if (isSelected) {
                return Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B9EE1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Icon(Icons.check, size: 16),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        brand,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: () => _selectBrand(brand),
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Text(
                      brand,
                      style: const TextStyle(
                        color: Color(0xFF1A242F),
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildDefaultBrandFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _brands.map((brand) {
          final isSelected = brand == _selectedBrand;
          
          if (isSelected) {
            return Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF5B9EE1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(Icons.check, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    brand,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return GestureDetector(
              onTap: () => _selectBrand(brand),
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(
                  brand,
                  style: const TextStyle(
                    color: Color(0xFF1A242F),
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }
        }).toList(),
      ),
    );
  }

  Widget _buildPopularShoesSection() {
    return Column(
      children: [
        _buildSectionHeader('Popular Shoes'),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot>(
          stream: _firestoreService.getPopularProductsByBrand(_selectedBrand, 5),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No popular shoes found'),
              );
            }
            
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.only(right: 21),
                    child: _buildShoeCard(
                      id: doc.id,
                      tag: data['tag'] ?? 'Best Seller',
                      name: data['name'] ?? 'Unknown Shoe',
                      price: data['price']?.toString() ?? '0.00',
                      imagePath: data['imagePath'] ?? 'assets/images/placeholder.png',
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNewArrivalsSection() {
    return Column(
      children: [
        _buildSectionHeader('New Arrivals'),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot>(
          stream: _firestoreService.getNewArrivalsByBrand(_selectedBrand, 1),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No new arrivals',
                          style: TextStyle(
                            color: Color(0xFF5B9EE1),
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Check back soon',
                          style: TextStyle(
                            color: Color(0xFF1A242F),
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            
            final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
            
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['tag'] ?? 'Best Choice',
                        style: const TextStyle(
                          color: Color(0xFF5B9EE1),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data['name'] ?? 'Nike Air Jordan',
                        style: const TextStyle(
                          color: Color(0xFF1A242F),
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '\$${data['price']?.toString() ?? '0.00'}',
                        style: const TextStyle(
                          color: Color(0xFF1A242F),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 142,
                    height: 80,
                    child: data['imagePath'] != null 
                        ? Image.network(
                            data['imagePath'],
                            fit: BoxFit.contain,
                            errorBuilder: (ctx, error, _) => Image.asset(
                              'assets/images/placeholder.png',
                              fit: BoxFit.contain,
                            ),
                          )
                        : Image.asset(
                            'assets/images/placeholder.png',
                            fit: BoxFit.contain,
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1A242F),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: () {
            // Navigate to full list - will implement later
            // Navigator.pushNamed(context, '/product_list', arguments: {'title': title, 'brand': _selectedBrand});
          },
          child: const Text(
            'See all',
            style: TextStyle(
              color: Color(0xFF5B9EE1),
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildShoeCard({
    required String id,
    required String tag,
    required String name,
    required String price,
    required String imagePath,
  }) {
    return Container(
      width: 157,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90,
            alignment: Alignment.center,
            child: imagePath.startsWith('http')
                ? Image.network(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, error, _) => Image.asset(
                      'assets/images/placeholder.png',
                      fit: BoxFit.contain,
                    ),
                  )
                : Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, error, _) => Image.asset(
                      'assets/images/placeholder.png',
                      fit: BoxFit.contain,
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          Text(
            tag,
            style: const TextStyle(
              color: Color(0xFF5B9EE1),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(
              color: Color(0xFF1A242F),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$$price',
                style: const TextStyle(
                  color: Color(0xFF1A242F),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _addToCart(id);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 16,
                    color: Color(0xFF5B9EE1),
                  ),
                ),
              ),
            ],
          ),
        ],
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

class _DefaultLocationWidget extends StatelessWidget {
  const _DefaultLocationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Store location',
              style: TextStyle(
                color: Color(0xFF707B81),
                fontSize: 12,
              ),
            ),
            Row(
              children: [
                Icon(Icons.location_on, size: 14),
                SizedBox(width: 4),
                Text(
                  'Mondolibug, Sylhet',
                  style: TextStyle(
                    color: Color(0xFF1A242F),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
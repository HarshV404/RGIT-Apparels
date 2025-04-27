import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:rgit_apparels/components/bottom_navbar.dart';
import 'package:rgit_apparels/components/my_drawer.dart';
import 'package:rgit_apparels/services/firestore_services.dart';
import 'package:rgit_apparels/models/shop.dart';
import 'package:rgit_apparels/pages/product_details_page.dart';
import 'package:rgit_apparels/components/product_tile.dart';

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
      drawer: DrawerWidget(),
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
    return user?.uid ?? 'current_user';
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
        
        final brands = snapshot.data!;
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
                    child: ProductTile(
                      id: doc.id,
                      tag: data['tag'] ?? 'Best Seller',
                      name: data['name'] ?? 'Unknown Shoe',
                      price: data['price']?.toString() ?? '0.00',
                      imagePath: data['imagePath'] ?? '',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsWidget(
                              productId: doc.id,
                            ),
                          ),
                        );
                      },
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
          stream: _firestoreService.getNewArrivalsByBrand(_selectedBrand, 5),
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
                child: Text('No new arrivals found'),
              );
            }
            
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.only(right: 21),
                    child: ProductTile(
                      id: doc.id,
                      tag: data['tag'] ?? 'New',
                      name: data['name'] ?? 'Unknown Shoe',
                      price: data['price']?.toString() ?? '0.00',
                      imagePath: data['imagePath'] ?? '',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsWidget(
                              productId: doc.id,
                            ),
                          ),
                        );
                      },
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

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1A242F),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            // View all functionality
          },
          child: const Text(
            'View all',
            style: TextStyle(
              color: Color(0xFF707B81),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _DefaultLocationWidget extends StatelessWidget {
  const _DefaultLocationWidget();

  @override
  Widget build(BuildContext context) {
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
                  'Mondolibug, Sylhet',
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
}
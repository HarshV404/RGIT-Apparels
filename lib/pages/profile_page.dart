import 'package:flutter/material.dart';
import 'package:rgit_apparels/pages/home_widget.dart'; // <-- Import your HomePage here

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF1A242F),
            fontSize: 20, // Increased font size
            fontWeight: FontWeight.bold, // Made the text bold
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeWidget()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile Image and Edit Button
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDFEFFF),
                        borderRadius: BorderRadius.circular(45),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/profile.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5B9EE1),
                          borderRadius: BorderRadius.circular(16.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(216, 216, 216, 0.25),
                              offset: Offset(0, 8),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'alisson becker',
                style: TextStyle(
                  color: Color(0xFF1A242F),
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 30),
              // Full Name Field
              _buildProfileField('Full Name', 'Alosson Becker'),
              const SizedBox(height: 16),
              // Email Address Field
              _buildProfileField('Email Address', 'AlossonBecker@gmail.com'),
              const SizedBox(height: 30),
              const Divider(),
              // Payment Info
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.credit_card, color: Color(0xFF1A242F)),
                title: const Text(
                  'Payment Info',
                  style: TextStyle(
                    color: Color(0xFF1A242F),
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF1A242F)),
                onTap: () {},
              ),
              const Divider(),
              // Shipping Address
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.location_on_outlined, color: Color(0xFF1A242F)),
                title: const Text(
                  'Shipping Address',
                  style: TextStyle(
                    color: Color(0xFF1A242F),
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF1A242F)),
                onTap: () {},
              ),
              const SizedBox(height: 60),
              // Delete Account Button
              TextButton.icon(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Account'),
                      content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Delete account logic here
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'DELETE',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(String title, String value) {
    return Column(
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
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1A242F),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
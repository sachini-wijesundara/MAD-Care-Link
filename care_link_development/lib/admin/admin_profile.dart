import 'package:care_link_development/main.dart';
import 'package:flutter/material.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/women/32.jpg',
                ),
                backgroundColor: Colors.grey,
              ),
              const SizedBox(height: 20),
              const Text(
                'System Administrator',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'admin@carelink.com',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              _buildProfileCard(
                title: 'Personal Information',
                icon: Icons.person,
                onTap: () {
                  // Handle personal info
                },
              ),
              _buildProfileCard(
                title: 'Phone Number',
                icon: Icons.phone,
                subtitle: '+94 77 123 4567',
                onTap: () {
                  // Handle phone
                },
              ),
              _buildProfileCard(
                title: 'Address',
                icon: Icons.location_on,
                subtitle: '123 Main Street, Colombo 07',
                onTap: () {
                  // Handle address
                },
              ),
              _buildProfileCard(
                title: 'Role',
                icon: Icons.admin_panel_settings,
                subtitle: 'System Administrator',
                onTap: () {
                  // Handle role
                },
              ),
              _buildProfileCard(
                title: 'Help & Support',
                icon: Icons.help,
                onTap: () {
                  // Handle help
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const DoctorFinderApp(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    String? subtitle,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

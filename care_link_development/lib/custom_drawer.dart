import 'package:care_link_development/all_medical_records.dart';
import 'package:care_link_development/auth/login.dart';
import 'package:care_link_development/help%20center.dart';
import 'package:care_link_development/admin/manage_patient_appointments.dart';
import 'package:care_link_development/medicine_order_screen.dart';
import 'package:care_link_development/doctors/my_doctors.dart';
import 'package:care_link_development/my_appoinments.dart';
import 'package:care_link_development/privacy_policy.dart';
import 'package:care_link_development/providers/user_provider.dart';
import 'package:care_link_development/screens/profile_page.dart';
import 'package:care_link_development/screens/settings.dart';
// For logout functionality
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF316497),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to profile page when avatar is clicked
                      Navigator.of(context).pop(); // Close drawer first
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                    child: ClipOval(
                      child: Container(
                        height: 48,
                        width: 48,
                        color: Color(0xFFB3DFFC),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/carelink_logo_bg.png',
                          image:
                              "https://randomuser.me/api/portraits/men/${context.watch<UserProvider>().currentProfileNumber}.jpg",
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                          placeholderFit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 500),
                          fadeInCurve: Curves.easeIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.watch<UserProvider>().user!.username,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          context.watch<UserProvider>().user!.email,
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, thickness: 0.4),
            const SizedBox(height: 8),

            // Updated drawer items with navigation
            _drawerItem(
              context,
              Icons.person,
              'My Doctors',
              () => _navigateTo(context, const MyDoctorsScreen()),
            ),
            _drawerItem(
              context,
              Icons.description,
              'Medical Records',
              () => _navigateTo(context, const AllRecordsScreen()),
            ),
            _drawerItem(
              context,
              Icons.local_pharmacy,
              'Medicine Orders',
              () => _navigateTo(context, const MedicineOrdersScreen()),
            ),
            _drawerItem(
              context,
              Icons.calendar_month,
              'Appoinmnets',
              () => _navigateTo(context, const MyAppoinmentsScreen()),
            ),
            _drawerItem(
              context,
              Icons.privacy_tip,
              'Privacy & Policy',
              () => _navigateTo(context, const PrivacyPolicyScreen()),
            ),
            _drawerItem(
              context,
              Icons.help_outline,
              'Help Center',
              () => _navigateTo(context, const HelpCenterScreen()),
            ),
            _drawerItem(
              context,
              Icons.settings,
              'Settings',
              () => _navigateTo(context, const SettingsScreen()),
            ),

            const Spacer(),

            // Logout button
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () => _confirmLogout(context),
                child: Row(
                  children: const [
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Updated drawer item with navigation callback
  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.white70,
      ),
      onTap: onTap,
    );
  }

  // Helper method to navigate to a page
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context); // Close the drawer
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  // Logout confirmation dialog
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx); // Close dialog
                  Navigator.pop(context); // Close drawer
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false, // Remove all previous routes
                  );
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}

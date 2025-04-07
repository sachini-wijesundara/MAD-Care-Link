import 'package:care_link_development/main.dart';
import 'package:care_link_development/model/user.dart';
import 'package:care_link_development/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math'; // Add this import at the top

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _showEditProfileDialog() {
    final userProvider = context.read<UserProvider>();
    final TextEditingController addressController = TextEditingController(
      text: userProvider.user?.address,
    );
    final TextEditingController dobController = TextEditingController(
      text: userProvider.user?.dateOfBirth,
    );
    String? selectedBloodType =
        userProvider.user?.bloodType == ""
            ? null
            : userProvider.user?.bloodType;
    final bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: dobController,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      dobController.text =
                          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    suffixIcon: Icon(Icons.location_on),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedBloodType,
                  hint: const Text('Select Blood Type'),
                  decoration: const InputDecoration(
                    labelText: 'Blood Type',
                    suffixIcon: Icon(Icons.bloodtype),
                  ),
                  items:
                      bloodTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                  onChanged: (String? value) {
                    selectedBloodType = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    context.watch<UserProvider>().isLoading
                        ? const Color.fromARGB(100, 0, 59, 115)
                        : const Color(0xFF003B73),
              ),
              onPressed: () async {
                // Validate inputs
                bool isValid = true;
                String errorMessage = '';

                if (addressController.text.trim().isEmpty) {
                  isValid = false;
                  errorMessage = 'Please enter your address';
                } else if (addressController.text.trim().length < 5) {
                  isValid = false;
                  errorMessage = 'Address must be at least 5 characters long';
                }

                if (dobController.text.isEmpty) {
                  isValid = false;
                  errorMessage = 'Please select your date of birth';
                }

                if (selectedBloodType == null) {
                  isValid = false;
                  errorMessage = 'Please select your blood type';
                }

                if (!isValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // If validation passes, update the user
                UserModel updatedUser = UserModel(
                  uid: userProvider.user!.uid,
                  username: userProvider.user!.username,
                  email: userProvider.user!.email,
                  contactNumber: userProvider.user!.contactNumber,
                  address: addressController.text.trim(),
                  bloodType: selectedBloodType ?? "",
                  dateOfBirth: dobController.text,
                );

                await context.read<UserProvider>().updateUserDetails(
                  updatedUser,
                );

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pop(context);
              },
              child:
                  context.watch<UserProvider>().isLoading
                      ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size.width;
    final userProvider = context.read<UserProvider>();
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment(0.0, -0.2),
          colors: [Color(0xFFB3DFFC), Colors.white],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color(0xFF003B73),
          elevation: 0,
          title: const Text(
            'My Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Profile header with avatar
              Container(
                width: screenSize / 2,
                padding: const EdgeInsets.only(top: 20, bottom: 24),
                decoration: const BoxDecoration(
                  color: Color(0xFF003B73),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    // Profile Picture
                    ClipOval(
                      child: Container(
                        height: 150,
                        width: 150,
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
                    const SizedBox(height: 16),
                    // User Name
                    Text(
                      userProvider.user?.username ?? 'Not Available',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // User Email
                    Text(
                      userProvider.user?.email ?? 'Not Available',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Profile Information Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003B73),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Profile Info Cards
                    _buildInfoCard(
                      icon: Icons.phone,
                      title: 'Phone Number',
                      content:
                          userProvider.user?.contactNumber ?? 'Not Available',
                    ),

                    _buildInfoCard(
                      icon: Icons.calendar_today,
                      title: 'Date of Birth',
                      content:
                          userProvider.user?.dateOfBirth == ""
                              ? 'Not Available'
                              : userProvider.user!.dateOfBirth,
                    ),

                    _buildInfoCard(
                      icon: Icons.location_on,
                      title: 'Address',
                      content:
                          userProvider.user?.address == ""
                              ? 'Not Available'
                              : userProvider.user!.address,
                    ),

                    _buildInfoCard(
                      icon: Icons.bloodtype,
                      title: 'Blood Type',
                      content:
                          userProvider.user?.bloodType == ""
                              ? 'Not Available'
                              : userProvider.user!.bloodType,
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            255,
                            255,
                            255,
                          ),
                          foregroundColor: Color(0xFF003B73),
                          side: BorderSide(color: Color(0xFF003B73), width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _showEditProfileDialog,
                        child: const Text('Edit Profile'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003B73),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          context.read<UserProvider>().logout().then(
                            (_) => Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const DoctorFinderApp(),
                              ),
                              (route) => false,
                            ),
                          );
                        },
                        child: const Text('Logout'),
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFB3DFFC).withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF003B73), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
        ],
      ),
    );
  }
}

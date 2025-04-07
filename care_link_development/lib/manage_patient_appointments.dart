import 'package:care_link_development/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManagePatientsScreen extends StatefulWidget {
  const ManagePatientsScreen({super.key});

  @override
  State<ManagePatientsScreen> createState() => _ManagePatientsScreenState();
}

class _ManagePatientsScreenState extends State<ManagePatientsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    Future.microtask(() {
      context.read<UserProvider>().getAllUsers();
    });
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Manage Patients'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment(0.0, -0.2),
            colors: [Color(0xFFB3DFFC), Colors.white],
          ),
        ),
        child:
            context.watch<UserProvider>().isLoading
                ? Scaffold(
                  body: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
                : SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search by name',
                                  prefixIcon: const Icon(Icons.search),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Consumer<UserProvider>(
                          builder: (context, appointmentProvider, child) {
                            final filteredUsers =
                                appointmentProvider.userList
                                    .where(
                                      (user) => user.username
                                          .toLowerCase()
                                          .contains(_searchQuery.toLowerCase()),
                                    )
                                    .toList();

                            if (filteredUsers.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No patients found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            }
                            return ListView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              children:
                                  filteredUsers.map((appointment) {
                                    return Column(
                                      children: [
                                        UserInfoCard(
                                          username: appointment.username,
                                          email: appointment.email,
                                          userId: appointment.uid,
                                          contactNumber:
                                              appointment.contactNumber,
                                        ),
                                        const SizedBox(height: 12),
                                      ],
                                    );
                                  }).toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}

class UserInfoCard extends StatelessWidget {
  final String username;
  final String email;
  final String userId;
  final String contactNumber;

  const UserInfoCard({
    super.key,
    required this.username,
    required this.email,
    required this.userId,
    required this.contactNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Icon(Icons.email, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(email),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text('ID: $userId'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(contactNumber),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

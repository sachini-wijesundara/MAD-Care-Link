import 'package:care_link_development/admin/admin_dashboard.dart';
import 'package:care_link_development/cart.dart';
import 'package:care_link_development/main.dart';
import 'package:care_link_development/providers/appoinment_provider.dart';
import 'package:care_link_development/providers/order_provider.dart';
import 'package:care_link_development/providers/user_provider.dart';
import 'package:care_link_development/screens/profile_page.dart';
import 'package:care_link_development/screens/settings.dart';
import 'package:care_link_development/screens/store.dart';
import 'package:care_link_development/screens/home/find_doctor.dart';
import 'package:care_link_development/widgets/animated_action_card.dart';
import 'package:care_link_development/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:provider/provider.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DoctorHomeScreen(),
    const StoreScreen(),
    const SettingsScreen(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _getUserInfo() async {
    if (context.read<UserProvider>().user == null) {
      await context.read<UserProvider>().getUserData();
      print("Email ${context.read<UserProvider>().user!.email}");
      print("Name ${context.read<UserProvider>().user!.username}");
      print("Phone ${context.read<UserProvider>().user!.contactNumber}");
    }
    await context.read<OrderProvider>().fetchOrders();
    context.read<OrderProvider>().printAllOrders();

    await context.read<AppoinmentProvider>().fetchAppoinments();
    context.read<AppoinmentProvider>().printAllAppoinments();
  }

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return context.watch<UserProvider>().isLoading ||
            context.watch<OrderProvider>().isLoading ||
            context.watch<AppoinmentProvider>().isLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment(0.0, -0.2),
              colors: [Color(0xFFB3DFFC), Colors.white],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            drawer: const CustomDrawer(),
            body:
                _selectedIndex == 0
                    ? buildHomeContent()
                    : _pages[_selectedIndex],
            bottomNavigationBar: ConvexAppBar(
              style: TabStyle.reactCircle,
              backgroundColor: Colors.white,
              color: Colors.grey,
              activeColor: Colors.blue[800],
              items: const [
                TabItem(icon: Icons.home, title: 'Home'),
                TabItem(icon: Icons.shopping_cart, title: 'Store'),
                TabItem(icon: Icons.settings, title: 'Settings'),
                TabItem(icon: Icons.person, title: 'Profile'),
              ],
              initialActiveIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        );
  }

  Widget buildHomeContent() {
    return Stack(
      children: [
        Container(
          height: 160,
          decoration: const BoxDecoration(
            color: Color(0xFF003B73),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello ${context.read<UserProvider>().user!.username}!",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Find Your Doctor",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Builder(
                        builder: (context) {
                          return IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: AnimatedActionCard(
                          label: 'Doctor Channelling',
                          icon: Icons.biotech,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DoctorScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AnimatedActionCard(
                          label: 'Medicine Store',
                          icon: Icons.health_and_safety,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StoreScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Container(
                        height: 180,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/carelink_nw.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Care Link',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                    ],
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const EmptyCartScreen(),
                //       ),
                //     );
                //   },
                //   child: Text('test profile'),
                // ),
                // SizedBox(
                //   width: double.infinity,

                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: const Color(0xFF003B73),
                //       foregroundColor: Colors.white,
                //       padding: const EdgeInsets.symmetric(vertical: 16),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //     ),
                //     onPressed: () {
                //       context.read<UserProvider>().logout().then(
                //         (_) => Navigator.of(context).pushAndRemoveUntil(
                //           MaterialPageRoute(
                //             builder: (context) => const DoctorFinderApp(),
                //           ),
                //           (route) => false,
                //         ),
                //       );
                //     },
                //     child: const Text('Logout'),
                //   ),
                // ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Create a simple HomeContent widget to extract the home screen content
class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(); // This is a placeholder, the actual home content is handled in DoctorHomeScreen
  }
}

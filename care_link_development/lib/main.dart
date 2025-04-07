import 'package:care_link_development/auth/login.dart';
import 'package:care_link_development/providers/appoinment_provider.dart';
import 'package:care_link_development/providers/order_provider.dart';
import 'package:care_link_development/providers/recordes_provider.dart';
import 'package:care_link_development/providers/user_provider.dart';
import 'package:care_link_development/screens/home/dashboard_nw.dart';
import 'package:care_link_development/screens/on_boarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const DoctorFinderApp());
}

class DoctorFinderApp extends StatelessWidget {
  const DoctorFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => AppoinmentProvider()),
        ChangeNotifierProvider(create: (context) => RecordesProvider()),
      ],
      child: MaterialApp(
        title: 'Doctor Finder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF003B73)),
          useMaterial3: true,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              return const DoctorHomeScreen();
            }
            return const OnboardingScreen();
          },
        ),
      ),
    );
  }
}

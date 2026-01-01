import 'package:flutter/material.dart';
import 'screens/admin_dashboard_page.dart';
import 'screens/landing_page.dart';
import 'screens/manage_booking.dart';
import 'screens/profile_page.dart';
import 'screens/registration_page.dart';
import 'screens/tour_package_page.dart';
import 'screens/login_page.dart';
import 'screens/user_dashboard_page.dart';

void main() {
  runApp(TourPackageApp());
}

class TourPackageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tour Package App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[200],
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 9, 71, 122),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Default starting route
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/tourPackages': (context) => TourPackagePage(),
        '/register': (context) => RegistrationPage(),
        '/profile': (context) => ProfilePage(),
        '/adminDashboard': (context) => AdminDashboardPage(),
        '/manageBookings': (context) => ManageBookingPage(),
        '/userDashboard': (context) => UserDashboardPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tour Package App",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 9, 71, 122),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 9, 71, 122),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.tour),
              title: const Text('Tour Packages'),
              onTap: () {
                Navigator.pushNamed(context, '/tourPackages');
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Log In'),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: LandingPage(), // Replace with your landing page content
    );
  }
}

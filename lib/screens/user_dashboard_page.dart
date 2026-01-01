import 'package:flutter/material.dart';
import 'tour_package_page.dart';
import 'manage_booking.dart';
import 'profile_page.dart';
import 'login_page.dart';
import '../services/shared_prefs_service.dart'; // For clearing the user session

class UserDashboardPage extends StatefulWidget {
  @override
  _UserDashboardPageState createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  bool _isLoggedOut = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text('User Dashboard'),
        ),
        backgroundColor:
            const Color.fromARGB(255, 9, 71, 122), // Consistent theme
        automaticallyImplyLeading: false, // Hide the back button
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _isLoggedOut
                ? null // Disable logout if already logged out
                : () async {
                    await SharedPrefsService().clearUserSession();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You have been logged out.'),
                        backgroundColor: Colors.green, // Green snackbar
                      ),
                    );
                    setState(() {
                      _isLoggedOut = true;
                    });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
          ),
        ],
      ),
      backgroundColor:
          const Color(0xFFFDF0D5), // Background color matching Admin Dashboard
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  children: [
                    _buildCard(
                      context,
                      'Tour Packages',
                      Icons.airplanemode_active,
                      TourPackagePage(),
                    ),
                    _buildCard(
                      context,
                      'Manage Bookings',
                      Icons.bookmark,
                      ManageBookingPage(),
                    ),
                    _buildCard(
                      context,
                      'Update Profile',
                      Icons.person,
                      ProfilePage(),
                    ),
                    _buildCard(
                      context,
                      'Log Out',
                      Icons.logout,
                      LoginPage(),
                      isLogOut: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, String title, IconData icon, Widget route,
      {bool isLogOut = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // White card color
        borderRadius: BorderRadius.circular(16), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black26, // Subtle shadow
            blurRadius: 8.0,
            spreadRadius: 1.0,
            offset: Offset(0, 4), // Shadow below the card
          ),
        ],
      ),
      child: InkWell(
        onTap: () async {
          if (isLogOut) {
            await SharedPrefsService().clearUserSession();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You have been logged out.'),
                backgroundColor: Colors.green, // Green snackbar
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => route),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => route),
            );
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: Colors.black, // Black icon for better contrast
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

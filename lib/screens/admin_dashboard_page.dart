import 'package:flutter/material.dart';
import 'all_users_page.dart'; // New page for viewing all users
import 'users_bookings.dart'; // New page for viewing user bookings
import 'login_page.dart'; // Import Login Page to navigate back after logout

class AdminDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          // Center the title in the AppBar
          child: const Text('Admin Dashboard'),
        ),
        automaticallyImplyLeading: false, // Hide the back button
        actions: [
          // Logout Icon
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logout successful'),
                  backgroundColor: Colors.green,
                ),
              );
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              });
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFFDF0D5), // Set background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // 2 columns for card grid
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            // Card for viewing all users
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // White card color
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Subtle shadow color
                    blurRadius: 8.0, // Blur effect
                    spreadRadius: 1.0, // Spread effect
                    offset: Offset(0, 4), // Shadow position
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllUsersPage()),
                  );
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.people,
                            size: 50, color: Colors.black), // Black icon
                        SizedBox(height: 10),
                        Text(
                          'View All Users',
                          style: TextStyle(color: Colors.black), // Black text
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Card for viewing bookings by users
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // White card color
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Subtle shadow color
                    blurRadius: 8.0, // Blur effect
                    spreadRadius: 1.0, // Spread effect
                    offset: Offset(0, 4), // Shadow position
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserBookingsPage()),
                  );
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.book_online,
                            size: 50, color: Colors.black), // Black icon
                        SizedBox(height: 10),
                        Text(
                          'View Bookings',
                          style: TextStyle(color: Colors.black), // Black text
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Card for logging out
            Container(
              decoration: BoxDecoration(
                color: Colors.white, // White card color
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Subtle shadow color
                    blurRadius: 8.0, // Blur effect
                    spreadRadius: 1.0, // Spread effect
                    offset: Offset(0, 4), // Shadow position
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Logout successful'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  });
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.logout,
                            size: 50, color: Colors.black), // Black icon
                        SizedBox(height: 10),
                        Text(
                          'Logout',
                          style: TextStyle(color: Colors.black), // Black text
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

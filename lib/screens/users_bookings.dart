import 'package:flutter/material.dart';
import '../services/db_helper.dart';

class UserBookingsPage extends StatefulWidget {
  @override
  _UserBookingsPageState createState() => _UserBookingsPageState();
}

class _UserBookingsPageState extends State<UserBookingsPage> {
  late Future<List<Map<String, dynamic>>> _userBookings;

  @override
  void initState() {
    super.initState();
    _userBookings = _fetchUserBookings();
  }

  Future<List<Map<String, dynamic>>> _fetchUserBookings() async {
    final bookings = await DBHelper().getUserBookings();
    print('Fetched bookings: $bookings'); // Debug: Inspect the fetched data
    return bookings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Bookings'),
        backgroundColor:
            const Color.fromARGB(255, 9, 71, 122), // Custom blue color
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // Fetching bookings asynchronously
        future: _userBookings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final bookings = snapshot.data;

          if (bookings == null || bookings.isEmpty) {
            return Center(child: Text('No bookings found.'));
          }

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 8, // Adds a subtle shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    leading: Icon(
                      Icons.bookmark, // Icon to represent booking
                      color: const Color.fromARGB(
                          255, 9, 71, 122), // Custom blue color
                    ),
                    title: Text(
                      booking['name'] ??
                          booking['username'] ??
                          'N/A', // Updated field check
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(
                            255, 9, 71, 122), // Custom blue color
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          'Tour Package: ${booking['tourpackage'] ?? 'N/A'}',
                          style: TextStyle(
                              color: Colors.black87), // Styling for details
                        ),
                        Text(
                          'Booking Date: ${booking['bookdate'] ?? 'N/A'}',
                          style: TextStyle(color: Colors.black87),
                        ),
                        Text(
                          'Booking Time: ${booking['booktime'] ?? 'N/A'}',
                          style: TextStyle(color: Colors.black87),
                        ),
                        Text(
                          'Tour Start Date: ${booking['tourstartdate'] ?? 'N/A'}',
                          style: TextStyle(color: Colors.black87),
                        ),
                        Text(
                          'Tour End Date: ${booking['tourenddate'] ?? 'N/A'}',
                          style: TextStyle(color: Colors.black87),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/edit_booking_page.dart';
import '../services/db_helper.dart';
import '../services/shared_prefs_service.dart';

class ManageBookingPage extends StatefulWidget {
  @override
  _ManageBookingPageState createState() => _ManageBookingPageState();
}

class _ManageBookingPageState extends State<ManageBookingPage> {
  late Future<List<Map<String, dynamic>>> _bookingsFuture;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserBookings();
  }

  Future<void> _loadUserBookings() async {
    _userId = await SharedPrefsService().getUserSession();
    if (_userId != null) {
      setState(() {
        _bookingsFuture = DBHelper().getBookingsByUser(_userId!);
      });
    }
  }

  Future<void> _cancelBooking(int bookingId) async {
    await DBHelper().delete('tourbook', 'bookid = ?', [bookingId]);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking canceled successfully!'),
      ),
    );
    _loadUserBookings(); // Refresh bookings after cancellation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage My Bookings'),
        backgroundColor: const Color.fromARGB(255, 9, 71, 122),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching bookings'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No bookings available'),
            );
          }

          final bookings = snapshot.data!;
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Booking ID
                      Text(
                        'Booking ID: ${booking['bookid']}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Tour Title (retrieved from tourpackage column)
                      Text(
                        booking['tourpackage'] ?? 'Unknown Tour',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Divider(
                        thickness: 1.5,
                        color: Colors.black26,
                        height: 12,
                      ),
                      const SizedBox(height: 4),
                      // Booking Date and Time
                      Text(
                        'Booking Date: ${booking['bookdate']} ${booking['booktime']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Number of People (Pax)
                      Text(
                        'Number of Pax: ${booking['nopeople']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Total Price (amount)
                      Text(
                        'Total Amount: MYR ${booking['price'].toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Booking Status (Completed)
                      Text(
                        'Booking Completed',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    onSelected: (value) async {
                      if (value == 'view') {
                        _showBookingDetails(context, booking);
                      } else if (value == 'cancel') {
                        await _cancelBooking(booking['bookid']);
                      } else if (value == 'edit') {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditBookingPage(bookingId: booking['bookid']),
                          ),
                        );
                        if (result == true) {
                          _loadUserBookings();
                        }
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: Text('View Details'),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit Booking'),
                      ),
                      const PopupMenuItem(
                        value: 'cancel',
                        child: Text('Cancel Booking'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Show Booking Details Dialog
  void _showBookingDetails(BuildContext context, Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Booking ID
                Text(
                  'Booking ID: ${booking['bookid']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                // Tour Package
                Text(
                  booking['tourpackage'] ?? 'Unknown Tour',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                // Tour Dates (Check for null and display fallback if necessary)
                Text(
                  'Start Date: ${booking['tourstartdate'] ?? 'Unknown Date'}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  'End Date: ${booking['tourenddate'] ?? 'Unknown Date'}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                // Number of People (Pax)
                Text(
                  'Number of People: ${booking['nopeople']}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                // Total Price
                Text(
                  'Total Price: MYR ${booking['price'].toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                // Additional Info
                Text(
                  'Booking Status: Completed',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const Divider(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

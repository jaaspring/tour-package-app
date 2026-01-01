import 'package:flutter/material.dart';
import 'dart:async';
import 'booking_page.dart';
import '../services/shared_prefs_service.dart'; // Import shared prefs service

// Define a reusable button style for all buttons
final ButtonStyle globalButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromARGB(
      255, 9, 71, 122), // Background color (same as header)
  foregroundColor: Colors.white, // White text color
  padding: const EdgeInsets.symmetric(
    vertical: 16, // Vertical padding for the button
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12), // Rounded corners
  ),
);

class TourPackageDetailPage extends StatefulWidget {
  final String tourCode;

  const TourPackageDetailPage({Key? key, required this.tourCode})
      : super(key: key);

  @override
  _TourPackageDetailPageState createState() => _TourPackageDetailPageState();
}

class _TourPackageDetailPageState extends State<TourPackageDetailPage> {
  int _currentImageIndex = 0;
  int numberOfPeople = 1; // Default to 1 person
  late Timer _timer;

  final Map<String, Map<String, dynamic>> tourDetails = {
    'Tour A': {
      'title': 'Phi Phi Island Paradise',
      'description': 'Explore stunning beaches and crystal clear waters.',
      'price': 299.99,
      'images': ['assets/A1.jpg', 'assets/A2.jpg', 'assets/A3.jpg'],
    },
    'Tour B': {
      'title': 'Krabi Island Hopping Adventure',
      'description': 'Enjoy an exciting island-hopping tour in Krabi.',
      'price': 249.99,
      'images': ['assets/B1.jpg', 'assets/B2.jpg', 'assets/B3.jpg'],
    },
    'Tour C': {
      'title': 'Hong Island 7-Island Adventure',
      'description': 'Discover the breathtaking beauty of Hong Islands.',
      'price': 399.99,
      'images': ['assets/C1.jpg', 'assets/C2.jpg', 'assets/C3.jpg'],
    },
  };

  @override
  void initState() {
    super.initState();
    _startImageSlider();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startImageSlider() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) %
            (tourDetails[widget.tourCode]!['images'] as List<String>).length;
      });
    });
  }

  Future<void> _checkLoginAndBook() async {
    final userId = await SharedPrefsService()
        .getUserSession(); // Check if the user is logged in
    if (userId == null) {
      // If not logged in, show a message and navigate to login page
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to book a tour')),
      );
      Navigator.pushNamed(context, '/login'); 
    } else {
      // If logged in, proceed to the booking page
      final details = tourDetails[widget.tourCode];
      if (details != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingPage(
              tourTitle: details['title'],
              price: details['price'],
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = tourDetails[widget.tourCode];

    if (details == null) {
      return const Scaffold(
        body: Center(child: Text('Tour not found')),
      );
    }

    final images = details['images'] as List<String>;
    final double ratePerPerson = details['price'];
    final double totalPrice = ratePerPerson * numberOfPeople;

    return Scaffold(
      appBar: AppBar(
        title: Text(details['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: PageController(initialPage: _currentImageIndex),
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          images[index],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: images.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => setState(() {
                            _currentImageIndex = entry.key;
                          }),
                          child: Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == entry.key
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Text(
              details['title'],
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            Text(
              details['description'],
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Price per Person Section
            Text(
              'Price per Person',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              "MYR ${ratePerPerson.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),

            // Total Price Section
            Text(
              'Total Price for ${numberOfPeople.toStringAsFixed(0)} person(s)',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              "MYR ${totalPrice.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),

            // No. of People Slider
            Text(
              "No. of People",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Slider(
              value: numberOfPeople.toDouble(),
              min: 1,
              max: 20, // Set the max to 20
              divisions:
                  19, // Divide it into 19 parts to get 1 to 20 as possible values
              label: '$numberOfPeople person(s)',
              activeColor: const Color.fromARGB(255, 9, 71, 122),
              inactiveColor: Colors.grey,
              onChanged: (value) {
                setState(() {
                  numberOfPeople =
                      value.toInt(); // Update number of people as an integer
                });
              },
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _checkLoginAndBook, // Check login before booking
              style:
                  globalButtonStyle, // Use the same style as the login button
              child: const Text(
                'Book Now',
                style: TextStyle(
                  color: Colors.white, // White text for Book Now button
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

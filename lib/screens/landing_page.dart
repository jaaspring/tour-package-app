import 'package:flutter/material.dart';
import 'tour_package_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light grey background
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 260, // Reduced height
                width: 260, // Reduced width
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/tour.jpg', // Ensure this path is correct
                    height: 180, // Adjusted image height
                    width: 180, // Adjusted image width
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Discover Paradise',
                style: TextStyle(
                  color: Colors.black, // Use black text for better contrast
                  fontSize: 36, // Increased font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'One Adventure at a Time',
                style: TextStyle(
                  color: Colors.black, // Use black text for better contrast
                  fontSize: 28, // Increased font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Find your dream destination with ease',
                style: TextStyle(
                  fontSize: 14, // Slightly larger text
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TourPackagePage(),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  width: 260,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 9, 71, 122),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'Tour Package',
                      style: TextStyle(
                        fontSize: 16, // Slightly larger button text
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

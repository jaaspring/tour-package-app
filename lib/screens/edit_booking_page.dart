import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // To format date
import '../services/db_helper.dart';

class EditBookingPage extends StatefulWidget {
  final int bookingId;

  const EditBookingPage({Key? key, required this.bookingId}) : super(key: key);

  @override
  _EditBookingPageState createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  late Map<String, dynamic> _booking;
  String? _selectedTourPackage;
  double _tourPrice = 0.0;
  double numberOfPeople = 1; // Default to 1 person
  final List<String> _tourPackages = [
    'Phi Phi Island Paradise',
    'Krabi Island Hopping Adventure',
    'Hong Island 7-Island Adventure'
  ]; // List of tour packages
  bool _isLoading = true;

  // Prices for each tour package
  final Map<String, double> _tourPrices = {
    'Phi Phi Island Paradise': 299.99,
    'Krabi Island Hopping Adventure': 249.99,
    'Hong Island 7-Island Adventure': 399.99,
  };

  // Date pickers for start and end dates
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _fetchBookingDetails();
  }

  // Fetch booking details by booking ID
  Future<void> _fetchBookingDetails() async {
    try {
      final booking = await DBHelper().getBookingById(widget.bookingId);

      if (booking == null) {
        throw Exception("Booking not found");
      }

      setState(() {
        _booking = booking;

        // Handle null values by providing default values
        _selectedTourPackage =
            booking['tourpackage'] ?? 'Phi Phi Island Paradise';
        _tourPrice = (_tourPrices[_selectedTourPackage] ?? 0.0).toDouble();
        numberOfPeople = (booking['nopeople'] ?? 1).toDouble();

        // Handle null dates by providing default dates
        _startDate = booking['tourstartdate'] != null
            ? DateTime.parse(booking['tourstartdate'])
            : DateTime.now();
        _endDate = booking['tourenddate'] != null
            ? DateTime.parse(booking['tourenddate'])
            : DateTime.now().add(const Duration(days: 1));

        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false; // Stop loading even in case of error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
      print('Error fetching booking details: $error');
    }
  }

  // Update the booking with the new tour package and people count
  // Inside _updateBooking function
  Future<void> _updateBooking() async {
    if (_selectedTourPackage != null &&
        _startDate != null &&
        _endDate != null) {
      try {
        // Calculate the total price based on selected package and number of people
        double totalPrice = _tourPrice * numberOfPeople;

        // Pass the updated values, including the price, to the DBHelper
        await DBHelper().updateBooking(
          widget.bookingId,
          {
            'tourpackage': _selectedTourPackage,
            'nopeople': numberOfPeople,
            'tourstartdate': DateFormat('yyyy-MM-dd').format(_startDate!),
            'tourenddate': DateFormat('yyyy-MM-dd').format(_endDate!),
            'price': totalPrice, // Add price to the update fields
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking updated successfully!')),
        );
        Navigator.pop(context, true); // Return to the previous screen
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
        print('Error updating booking: $error');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all details')),
      );
    }
  }

  // Show date picker and set the selected date
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime initialDate = isStartDate
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? DateTime.now());
    final DateTime firstDate = DateTime(DateTime.now().year - 1);
    final DateTime lastDate = DateTime(DateTime.now().year + 5);

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = selectedDate;
        } else {
          _endDate = selectedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while fetching booking details
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Booking'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Calculate total price
    double totalPrice = _tourPrice * numberOfPeople;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Booking'),
        backgroundColor: const Color.fromARGB(255, 9, 71, 122),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Booking ID
            Text(
              'Booking ID: ${_booking['bookid']}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Tour Package Dropdown
            Text(
              'Select a Tour Package',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedTourPackage,
              items: _tourPackages.map((String tour) {
                return DropdownMenuItem<String>(value: tour, child: Text(tour));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTourPackage = newValue;
                  _tourPrice =
                      (_tourPrices[_selectedTourPackage] ?? 0.0).toDouble();
                });
              },
            ),
            const SizedBox(height: 20),

            // Booking Date
            Text(
              'Booking Date: ${_booking['bookdate']}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),

            // Number of People (Pax)
            Text(
              'Number of People: $numberOfPeople',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            Slider(
              value: numberOfPeople,
              min: 1,
              max: 20,
              divisions: 19,
              label: '$numberOfPeople person(s)',
              activeColor: const Color.fromARGB(255, 9, 71, 122),
              inactiveColor: Colors.grey[400],
              onChanged: (value) {
                setState(() {
                  numberOfPeople = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Price Section
            Text(
              'Price per Person',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              "RM ${_tourPrice.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),

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
              "RM ${totalPrice.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),

            // Start Date Section
            Row(
              children: [
                const Text(
                  'Start Date: ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  _startDate != null
                      ? DateFormat('yyyy-MM-dd').format(_startDate!)
                      : 'Not Selected',
                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, true),
                  color: Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // End Date Section
            Row(
              children: [
                const Text(
                  'End Date: ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  _endDate != null
                      ? DateFormat('yyyy-MM-dd').format(_endDate!)
                      : 'Not Selected',
                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, false),
                  color: Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Save Changes Button
            ElevatedButton(
              onPressed: _updateBooking,
              child: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 9, 71, 122),
                foregroundColor: Colors.white, // White font color
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

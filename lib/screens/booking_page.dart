import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import '../services/shared_prefs_service.dart';
import 'user_dashboard_page.dart';

// Define global button style for consistency
final ButtonStyle globalButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromARGB(255, 9, 71, 122),
  foregroundColor: Colors.white, // White text color
  padding: const EdgeInsets.symmetric(vertical: 16), // Vertical padding
  shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12)), // Rounded corners
);

class BookingPage extends StatefulWidget {
  final String tourTitle; // Title of the selected tour package
  final double price; // Price per person for the selected tour package

  const BookingPage({Key? key, required this.tourTitle, required this.price})
      : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final TextEditingController _startTourDateController =
      TextEditingController(); // Controller for the start tour date
  final TextEditingController _endTourDateController =
      TextEditingController(); // Controller for the end tour date
  double _numberOfPeople = 1; // Default to 1 person
  String? _userId; // Logged-in user's ID
  String? _userName; // Logged-in user's name

  @override
  void initState() {
    super.initState();
    _loadUserSession(); // Load the logged-in user's session details
  }

  // Load the user session to get user ID and name
  Future<void> _loadUserSession() async {
    final userId = await SharedPrefsService().getUserSession();
    if (userId == null) {
      // If no user is logged in, show error and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in!')),
      );
      Navigator.pop(context);
      return;
    }

    // Fetch user details from the database
    final user = await DBHelper().getUserById(int.parse(userId));
    if (user != null && user.containsKey('name')) {
      setState(() {
        _userId = userId;
        _userName = user['name']; // Store user's name
      });
    } else {
      // Show error if user not found in the database
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found in the database!')),
      );
      Navigator.pop(context);
    }
  }

  // Calculate the total price based on the number of people
  double _calculateTotalPrice() {
    return widget.price * _numberOfPeople;
  }

  // Date picker to select the tour dates
  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default to today's date
      firstDate: DateTime.now(), // Minimum selectable date
      lastDate: DateTime(2100), // Maximum selectable date
    );
    if (pickedDate != null) {
      // Format the selected date as YYYY-MM-DD
      final formattedDate =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      controller.text = formattedDate;
    }
  }

  // Confirm and save the booking details
  Future<void> _confirmBooking() async {
    if (!_formKey.currentState!.validate()) {
      // If form validation fails, return early
      return;
    }

    final now = DateTime.now();
    final currentDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final currentTime = "${now.hour}:${now.minute}:${now.second}";
    final totalPrice = _calculateTotalPrice();

    // Insert booking details into the database
    await DBHelper().insert('tourbook', {
      'userid': _userId,
      'bookdate': currentDate,
      'booktime': currentTime,
      'tourstartdate': _startTourDateController.text,
      'tourenddate': _endTourDateController.text,
      'tourpackage': widget.tourTitle,
      'nopeople': _numberOfPeople.toInt(),
      'price': totalPrice,
    });

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Booking confirmed! Total price: MYR ${totalPrice.toStringAsFixed(2)}',
        ),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate to the User Dashboard Page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserDashboardPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final currentTime = "${now.hour}:${now.minute}:${now.second}";

    return Scaffold(
      backgroundColor: Colors.grey[200], // Light grey background
      appBar: AppBar(
        title: Text(
          widget.tourTitle, // Display the selected tour title in the AppBar
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 9, 71, 122),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Associate the form key with the form widget
          child: ListView(
            children: [
              // Display the user's name if available
              if (_userName != null) ...[
                Text(
                  'Hello, $_userName!',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // Booking Date and Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booking Date and Time:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '$currentDate $currentTime',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Start Tour Date
              _buildTextField(
                _startTourDateController,
                'Start Tour Date',
                Icons.calendar_today,
                readOnly: true,
                onTap: () => _selectDate(_startTourDateController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the start tour date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // End Tour Date
              _buildTextField(
                _endTourDateController,
                'End Tour Date',
                Icons.calendar_today,
                readOnly: true,
                onTap: () => _selectDate(_endTourDateController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the end tour date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Number of People Slider
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Number of People:',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  Slider(
                    value: _numberOfPeople,
                    min: 1,
                    max: 20,
                    divisions: 19,
                    label: _numberOfPeople.toStringAsFixed(0),
                    activeColor: const Color.fromARGB(255, 9, 71, 122),
                    inactiveColor: Colors.grey.shade300,
                    onChanged: (value) {
                      setState(() {
                        _numberOfPeople = value;
                      });
                    },
                  ),
                  Text(
                    'Number of People: ${_numberOfPeople.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Total Price
              Text(
                'Total Price: MYR ${_calculateTotalPrice().toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 32),
              // Confirm Booking Button
              GestureDetector(
                onTap: _confirmBooking,
                child: Container(
                  height: 50,
                  width: 260,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 9, 71, 122),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'Confirm Booking',
                      style: TextStyle(
                        fontSize: 16,
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

  // Reusable method to build a styled TextField
  Widget _buildTextField(
    TextEditingController controller,
    String labelText,
    IconData icon, {
    bool obscureText = false,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    void Function()? onTap,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black54),
        prefixIcon: Icon(icon, color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 9, 71, 122),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
      onTap: onTap,
    );
  }
}

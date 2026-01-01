import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import '../services/shared_prefs_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form validation key

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor:
            const Color.fromARGB(255, 9, 71, 122), // Custom blue color
        automaticallyImplyLeading: true, // Show the back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back icon
          onPressed: () {
            Navigator.pop(context); // Go back when tapped
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400, // Set a maximum width for the form
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center content vertically
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center content horizontally
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'User Login'),
                    Tab(text: 'Admin Login'),
                  ],
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: const Color.fromARGB(
                      255, 9, 71, 122), // Blue indicator line
                ),
                const SizedBox(
                    height: 20), // Space between the TabBar and the form
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildLoginForm(context, 'User'), // User login form
                      _buildLoginForm(context, 'Admin'), // Admin login form
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, [String loginType = 'User']) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Form key to control validation
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Username field with user icon
              _buildTextField(usernameController, 'Username', Icons.person),
              const SizedBox(height: 10),
              // Password field with lock icon
              _buildTextField(passwordController, 'Password', Icons.lock,
                  obscureText: true),
              const SizedBox(height: 20),
              // Login Button
              GestureDetector(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    // Proceed only if the form is valid
                    if (loginType == 'Admin') {
                      await _adminLogin(context);
                    } else {
                      await _userLogin(context);
                    }
                  }
                },
                child: Container(
                  height: 50,
                  width: double.infinity, // Make button take full width
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        255, 9, 71, 122), // Blue background
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  child: const Center(
                    child: Text(
                      'Login', // Text for the login button
                      style: TextStyle(
                        fontSize: 16, // Text size
                        color: Colors.white, // White text
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Only show register button for users, not for admins
              if (loginType == 'User')
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/register'); // Navigate to register
                  },
                  child: const Text(
                    'Don\'t have an account? Register here',
                    style: TextStyle(
                      color: Color.fromARGB(255, 9, 71, 122),
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to create a TextField with an icon and custom decoration
  Widget _buildTextField(
      TextEditingController controller, String labelText, IconData icon,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle:
            const TextStyle(color: Colors.black54), // Light color for label
        prefixIcon: Icon(icon, color: Colors.black), // Black icon color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 9, 71, 122),
              width: 2), // Focused border color
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText'; // Custom error message
        }
        return null;
      },
    );
  }

  Future<void> _adminLogin(BuildContext context) async {
    try {
      final admin = await DBHelper().query(
        'administrator',
        where: 'username = ? AND password = ?',
        whereArgs: [usernameController.text, passwordController.text],
      );

      if (admin.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Admin login successful!')),
        );
        Navigator.pushNamed(
            context, '/adminDashboard'); // Navigate to admin dashboard
      } else {
        setState(() {
          usernameController.text = '';
          passwordController.text = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Invalid Admin username or password'),
              backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() {
        usernameController.text = '';
        passwordController.text = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _userLogin(BuildContext context) async {
    try {
      final user = await DBHelper().query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [usernameController.text, passwordController.text],
      );

      if (user.isNotEmpty) {
        // Save the user session
        await SharedPrefsService()
            .setUserSession(user.first['userid'].toString());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User login successful!')),
        );

        // Navigate to user dashboard
        Navigator.pushReplacementNamed(context, '/userDashboard');
      } else {
        setState(() {
          usernameController.text = '';
          passwordController.text = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Invalid username or password'),
              backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() {
        usernameController.text = '';
        passwordController.text = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red),
      );
    }
  }
}

import 'package:flutter/material.dart';
import '../services/db_helper.dart';

final ButtonStyle globalButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromARGB(255, 9, 71, 122), // Custom blue color
  foregroundColor: Colors.white, // White text color
  padding: const EdgeInsets.symmetric(
      vertical: 16), // Vertical padding for the button
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12), // Rounded corners
  ),
);

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Create a GlobalKey to hold the form state
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey, // Link the form with the global key
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Full Name Field with validation
                        _buildTextField(
                            nameController, 'Full Name', Icons.person,
                            validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        }),
                        const SizedBox(height: 16),

                        // Email Field with validation
                        _buildTextField(emailController, 'Email', Icons.email,
                            validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        }),
                        const SizedBox(height: 16),

                        // Phone Field with validation
                        _buildTextField(phoneController, 'Phone', Icons.phone,
                            validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        }),
                        const SizedBox(height: 16),

                        // Username Field with validation
                        _buildTextField(usernameController, 'Username',
                            Icons.account_circle, validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        }),
                        const SizedBox(height: 16),

                        // Password Field with validation
                        _buildTextField(
                            passwordController, 'Password', Icons.lock,
                            obscureText: true, validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        }),
                        const SizedBox(height: 24),

                        // Register Button with custom styling
                        GestureDetector(
                          onTap: () async {
                            // Only register if the form is valid
                            if (_formKey.currentState!.validate()) {
                              await DBHelper().insert('users', {
                                'name': nameController.text,
                                'email': emailController.text,
                                'phone': phoneController.text,
                                'username': usernameController.text,
                                'password': passwordController.text,
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Registration Successful')),
                              );
                              Navigator.pop(
                                  context); // Go back after registration
                            }
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity, // Full width button
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                  255, 9, 71, 122), // Blue background
                              borderRadius:
                                  BorderRadius.circular(20), // Rounded corners
                            ),
                            child: const Center(
                              child: Text(
                                'Register', // Text for the register button
                                style: TextStyle(
                                  fontSize: 16, // Text size
                                  color: Colors.white, // White text
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // "Already have an account?" button with custom blue text
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/login'); // Navigate to login page
                          },
                          child: const Text(
                            'Already have an account? Login here',
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to create a TextField with an icon and custom decoration
  Widget _buildTextField(
      TextEditingController controller, String labelText, IconData icon,
      {bool obscureText = false, String? Function(String?)? validator}) {
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
      validator: validator, // Apply the validator passed in
    );
  }
}

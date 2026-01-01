import 'package:flutter/material.dart';
import '../services/db_helper.dart';
import '../services/shared_prefs_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userId = await SharedPrefsService().getUserSession();
    if (userId != null) {
      final users = await DBHelper()
          .query('users', where: 'userid = ?', whereArgs: [userId]);
      if (users.isNotEmpty) {
        setState(() {
          user = users.first;
          nameController.text = user!['name'];
          usernameController.text = user!['username'];
          emailController.text = user!['email'];
          phoneController.text = user!['phone'];
        });
      }
    }
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      if (user != null) {
        // Check if the password field is empty; if not, validate password length
        String? updatedPassword = passwordController.text.isEmpty
            ? user!['password'] // Keep the old password if the new one is empty
            : passwordController.text;

        await DBHelper().update(
          'users',
          {
            'name': nameController.text,
            'username': usernameController.text,
            'email': emailController.text,
            'phone': phoneController.text,
            'password': updatedPassword, // Update password
          },
          where: 'userid = ?',
          whereArgs: [user!['userid']],
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color.fromARGB(255, 9, 71, 122),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Associate the form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full Name
                _buildTextField(
                  nameController,
                  'Full Name',
                  Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your full name.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Username
                _buildTextField(
                  usernameController,
                  'Username',
                  Icons.account_circle,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your username.";
                    }
                    if (value.length < 3) {
                      return "Username must be at least 3 characters.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email
                _buildTextField(
                  emailController,
                  'Email',
                  Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a valid email address.";
                    }
                    final emailRegex = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    if (!emailRegex.hasMatch(value)) {
                      return "Please enter a valid email address.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone Number
                _buildTextField(
                  phoneController,
                  'Phone',
                  Icons.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your phone number.";
                    }
                    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
                    if (!phoneRegex.hasMatch(value)) {
                      return "Please enter a valid phone number.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password (for updating password)
                _buildTextField(
                  passwordController,
                  'Password',
                  Icons.lock,
                  obscureText: true,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Update Profile Button
                ElevatedButton(
                  onPressed: _updateUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 9, 71, 122), // Button color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Update Profile',
                    style: TextStyle(color: Colors.white), // Button text color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to create a TextField with an icon and custom decoration
  Widget _buildTextField(
      TextEditingController controller, String labelText, IconData icon,
      {bool obscureText = false,
      String? Function(String?)? validator,
      TextInputType? keyboardType,
      bool readOnly = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
            color: Color.fromARGB(255, 9, 71, 122)), // Blue label color
        prefixIcon: Icon(icon,
            color: const Color.fromARGB(255, 0, 0, 0)), // Blue icon color
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

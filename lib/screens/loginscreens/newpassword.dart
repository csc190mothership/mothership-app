import 'package:flutter/material.dart';
import 'package:mothership/functions.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  bool _obscurePassword = true;
  bool _isLoading = false;

  late final TextEditingController _passwordController =
      TextEditingController();
  late final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildPasswordContent(),
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildPasswordContent() {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          children: [
            const Text('Enter new password'),
            const SizedBox(height: 18),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: _obscurePassword,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: _obscurePassword,
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: const Text(
                        'Show Password',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool passwordsMatch = Functions.isPasswordValid(
                    _passwordController.text, _confirmPasswordController.text);
                if (passwordsMatch & !_isLoading) {
                  try {
                    setState(() {
                      _isLoading = true; // Set loading state to false
                    });
                    await Functions.updatePassword(
                        context, _passwordController);
                  } finally {
                    setState(() {
                      _isLoading = false; // Set loading state to false
                    });
                    _passwordController.clear();
                    _confirmPasswordController.clear();
                  }
                } else {
                  // Passwords don't match, show error message
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text(
                            'Invalid password. Password must contain at least 6 characters and must match.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
              ),
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5), // Semi-transparent black color
      child: const Center(
        child: CircularProgressIndicator(), // Circular loading indicator
      ),
    );
  }
}

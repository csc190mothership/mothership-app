import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mothership/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  bool isPasswordValid(String password, String confirmPassword) {
    if (password.isEmpty) {
      return false;
    } else {
      if (password.length < 6) {
        return false;
      } else {
        return password == confirmPassword;
      }
    }
  }

  Future<void> updatePassword() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await supabase.auth.updateUser(
          UserAttributes(password: _passwordController.text.trim()));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password Changed! Login required!')),
        );
        _passwordController.clear();
        _confirmPasswordController.clear();
      }
    } on AuthException catch (error) {
      SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (error) {
      SnackBar(
        content: const Text('Unexpected error occurred'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        await supabase.auth.signOut();
        Navigator.of(context).pushReplacementNamed('/');
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: ListView(
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
            onPressed: () {
              bool passwordsMatch = isPasswordValid(
                  _passwordController.text, _confirmPasswordController.text);
              if (passwordsMatch) {
                _isLoading ? null : updatePassword();
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
            child: Text(_isLoading ? 'Loading' : 'Change Password'),
          ),
        ],
      ),
    );
  }
}

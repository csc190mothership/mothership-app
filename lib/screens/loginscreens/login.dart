import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mothership/functions.dart';
import 'package:mothership/main.dart';
import 'package:mothership/screens/debughome.dart';
import 'package:mothership/screens/loginscreens/register.dart';
import 'package:mothership/screens/loginscreens/resetpassword.dart';
import 'package:page_transition/page_transition.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _redirecting = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final StreamSubscription<AuthState> _authStateSubscription;

  @override
  void initState() {
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        //Functions.isNewUser(context);
        //temporary push while i figure out how i want direction of user to go
        Navigator.push(
          context,
          PageTransition(type: PageTransitionType.fade, child:debugHome())
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Stack(
        children: [
          _buildLoginContent(),
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildLoginContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Login',
              style: TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: _obscurePassword,
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                       Navigator.push(
                          context,
                          PageTransition(type: PageTransitionType.fade, child:RegisterPage())
                        
                        );
                      },
                      child: const Text(
                        'Register?',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(type: PageTransitionType.fade, child:ResetPasswordPage())
                        
                        );
                      },
                      child: const Text(
                        'Reset Password',
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
                if (!Functions.isEmailValid(_emailController.text)) {
                  // Show error message for invalid email format
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Enter a valid email.'),
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
                } else {
                  if (!_isLoading) {
                    try {
                      setState(() {
                        _isLoading = true; // Set loading state to false
                      });
                      await Functions.signInUser(
                          context, _emailController, _passwordController);
                    } finally {
                      setState(() {
                        _isLoading = false; // Set loading state to false
                      });
                      _emailController.clear();
                      _passwordController.clear();
                    }
                  }
                  Navigator.push(
                            context,
                            PageTransition(type: PageTransitionType.fade, child:debugHome())
                          );
                }
              },
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 20),
            const Divider(
              thickness: 2,
            ), // Horizontal line below the "Sign In" button
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (!_isLoading) {
                          setState(() {
                            _isLoading = true; // Set loading state to true
                          });
                          try {
                            // Call the google function from functions.dart
                            await Functions.google(context);
                          } finally {
                            setState(() {
                              _isLoading = false; // Set loading state to false
                            });
                          }
                        }
                      },
                      child: const Text('Google Sign In'),
                    )
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (!Functions.isEmailValid(_emailController.text)) {
                          // Show error message for invalid email format
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text('Enter a valid email.'),
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
                        } else {
                          // Call signInWithEmailLink function with the context and email
                          if (!_isLoading) {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              await Functions.signInWithEmailLink(
                                  context, _emailController);
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                              _emailController.clear();
                            }
                            
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Email Sign In Link'),
                    )
                  ],
                ),
              ],
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

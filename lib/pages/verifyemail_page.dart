import 'package:flutter/material.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finish Registration')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text(
            'Registration Complete! Check your email to verify account!',
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 80,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Go to Login')),
        ],
      ),
    );
  }
}

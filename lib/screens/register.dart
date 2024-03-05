import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextStyle fieldStyle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "Email",
              style: fieldStyle,
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: "Enter your email",
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Password",
              style: fieldStyle,
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: "Enter your password",
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Phone Number",
              style: fieldStyle,
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: "Enter your phone number",
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement registration logic with supabase
                },
                child: const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mothership/functions.dart';
import 'package:mothership/screens/loginscreens/login.dart';
import 'package:mothership/screens/loginscreens/register.dart';
import 'package:page_transition/page_transition.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        Text("Welcome to Mothership!"),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            changePage(context, RegisterPage());
          },
          child: Text("Register"),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            changePage(context, LoginPage());
          },
          child: Text("Login"),
        ),
          ],
        ),
      ),

    );
  }

  void changePage(BuildContext context, Widget Screen) {
  Navigator.push(
                context,
                PageTransition(type: PageTransitionType.fade, child:Screen)
              
              );
}
}

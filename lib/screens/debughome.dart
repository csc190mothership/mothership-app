import 'package:flutter/material.dart';
import 'package:mothership/screens/loginscreens/profile.dart';
import 'package:page_transition/page_transition.dart';
import 'loginscreens/register.dart';

class debugHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mothership"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text("Welcome to Mothership debug home!"),
          ),
          SizedBox(height:10),
          ElevatedButton(
            onPressed: () {
              changePage(context, RegisterPage());
            },
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}


void changePage(BuildContext context, Widget Screen) {
  Navigator.push(
                context,
                PageTransition(type: PageTransitionType.fade, child:Screen)
              
              );
}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mothership/functions.dart';
import 'package:mothership/screens/loginscreens/login.dart';
import 'package:mothership/screens/loginscreens/register.dart';
import 'package:page_transition/page_transition.dart';
import 'package:video_player/video_player.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late VideoPlayerController _controller;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse('https://bradynorum.com/groceries.mp4'));
    _controller.initialize().then((_) {
      _controller.setLooping(true);
      Timer(Duration(milliseconds: 100), () {
        setState(() {
          _controller.play();
          _visible = true;
        });
      });
    });
  }

    @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black,
          ),
          _getVideoBackground(),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome to Mothership!", style:TextStyle(fontSize: 30, color: Colors.white)),
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
        ],
      ),

    );
  }

  void changePage(BuildContext context, Widget Screen) {
    Navigator.push(
                  context,
                  PageTransition(type: PageTransitionType.fade, child:Screen)
                
                );
  }
  _getVideoBackground() {
    return AnimatedOpacity(
      opacity: .6,
      duration: Duration(milliseconds: 1000),
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mothership/screens/cart.dart';
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
  late CartModel _cartModel;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse('https://bradynorum.com/groceries.mp4'));
    _controller.initialize().then((_) {
      _controller.setLooping(true);
      Timer(const Duration(milliseconds: 100), () {
        setState(() {
          _controller.play();
        });
      });
    });

    // Initialize _cartModel
    _cartModel = CartModel();

    // Call fetchCartData after the context is fully initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCartData();
    });
  }

  Future<void> _fetchCartData() async {
    await _cartModel.fetchCartData(context);
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
                Image.asset('assets/images/dairy.png', width: 200),
                const Text("Welcome to Mothership!",
                    style: TextStyle(fontSize: 30, color: Colors.white)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    changePage(context, const RegisterPage());
                  },
                  child: const Text("Register"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    changePage(context, const LoginPage());
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void changePage(BuildContext context, Widget screen) {
    Navigator.push(
        context, PageTransition(type: PageTransitionType.fade, child: screen));
  }

  _getVideoBackground() {
    return AnimatedOpacity(
      opacity: .6,
      duration: const Duration(milliseconds: 1000),
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

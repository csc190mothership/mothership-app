import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mothership/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Functions {
  static Future<void> isNewUser(BuildContext context) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        final data =
            await supabase.from('profiles').select().eq('id', userId).single();
        if (Navigator.canPop(context)) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        if (data['new_user'] == 1) {
          Navigator.of(context).pushReplacementNamed('/account');
        } else {
          Navigator.of(context).pushReplacementNamed('/profile');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unexpected error occurred.')),
      );
      await supabase.auth.signOut();
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  static bool isEmailValid(String email) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  static Future<void> signInWithEmail(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController,
      bool isLoading) async {
    try {
      isLoading = true; // Update isLoading to true

      await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful!')),
      );
      emailController.clear();
      passwordController.clear();
    } on AuthException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Try again. If unsuccessful, account may not exist.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Unexpected error occurred'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      isLoading = false; // Update isLoading to false
    }
  }

  static Future<void> signInWithEmailLink(
      BuildContext context, String email, bool isLoading) async {
    try {
      isLoading = true; // Update isLoading to true

      await supabase.auth.signInWithOtp(
        email: email.trim(),
        emailRedirectTo:
            kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
        shouldCreateUser: false,
      );

      // Show a snackbar to indicate that the email link has been sent
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check your email for a login link!')),
      );
    } on AuthException {
      // Handle authentication exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Try again. If unsuccessful, account may not exist.'),
        ),
      );
    } catch (error) {
      // Handle other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Unexpected error occurred'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      isLoading = false; // Update isLoading to false
    }
  }

  static Future<void> google(BuildContext context, bool isLoading) async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      /// Web Client ID that you registered with Google Cloud.
      const webClientId =
          '357859755210-g0d3308u6esm71v2jthpcflc0p2m430m.apps.googleusercontent.com';

      /// iOS Client ID that you registered with Google Cloud.
      const iosClientId =
          '357859755210-3a8dqcie0ripvib91cqcoiirl1lmfhb0.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      try {
        isLoading = true; // Update isLoading to true
        await supabase.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful!')),
        );
      } on AuthException {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Unable to register. Account may already exist.')),
        );
      } catch (error) {
        SnackBar(
          content: const Text('Unexpected error occurred'),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      } finally {
        isLoading = false; // Update isLoading to false
      }
    }
  }
}

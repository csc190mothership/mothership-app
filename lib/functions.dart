// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mothership/main.dart';
import 'package:mothership/screens/debughome.dart';
import 'package:page_transition/page_transition.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Functions {
  static Future<void> redirect(BuildContext context) async {
    await Future.delayed(Duration.zero);

    final session = supabase.auth.currentSession;
    if (session != null) {
      Navigator.of(context).pushReplacementNamed('/profile');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

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

  static bool isPasswordValid(String password, String confirmPassword) {
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

  static Future<void> signInUser(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) async {
    try {
      await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful!')),
      );
    } on AuthException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email or password incorrect. Try again.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Unexpected error occurred'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  static Future<void> signUpNewUser(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) async {
    try {
      await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
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
    }
  }

  static Future<void> signInWithEmailLink(
    BuildContext context,
    TextEditingController emailController,
  ) async {
    try {
      await supabase.auth.signInWithOtp(
        email: emailController.text.trim(),
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
    }
  }

  static Future<void> google(
    BuildContext context,
  ) async {
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

      if (googleUser == null) {
        // User canceled sign-in process
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign-in canceled.')),
        );
        return;
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      try {
        await supabase.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successful!')),
        );
      } on AuthException {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to continue.')),
        );
      } catch (error) {
        SnackBar(
          content: const Text('Unexpected error occurred'),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    }
  }

  static Future<void> updateUser(
      BuildContext context,
      TextEditingController firstNameController,
      TextEditingController lastNameController,
      TextEditingController genderController,
      TextEditingController addressOneController,
      TextEditingController addressTwoController,
      TextEditingController cityController,
      TextEditingController regionController,
      TextEditingController zipController,
      TextEditingController countryController) async {
    final firstname = firstNameController.text.trim();
    final lastname = lastNameController.text.trim();
    final gender = genderController.text.trim();
    final mainaddress = addressOneController.text.trim();
    final secondaryaddress = addressTwoController.text.trim();
    final city = cityController.text.trim();
    final region = regionController.text.trim();
    final zip = zipController.text.trim();
    final country = countryController.text.trim();
    final userId = supabase.auth.currentUser!.id;

    try {
      await supabase.from('profiles').update({
        'first_name': firstname,
        'last_name': lastname,
        'gender': gender,
        'address_one': mainaddress,
        'address_two': secondaryaddress,
        'city': city,
        'region': region,
        'zip': zip,
        'country': country,
        'new_user': 0,
      }).eq('id', userId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account setup complete!')),
      );
      Navigator.of(context).pushReplacementNamed('/');
    } on AuthException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Try again. If unsuccessful, restart registration process.')),
      );
    } catch (error) {
      SnackBar(
        content: const Text('Unexpected error occurred'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    }
  }

  static Future<Map<String, dynamic>> getInitialProfile(
      BuildContext context) async {
    final Map<String, dynamic> profileData = {};
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      try {
        final data =
            await supabase.from('profiles').select().eq('id', userId).single();

        // Store retrieved data in the map
        profileData['first_name'] = data['first_name'] ?? '';
        profileData['last_name'] = data['last_name'] ?? '';
        profileData['gender'] = data['gender'] ?? '';
        profileData['address_one'] = data['address_one'] ?? '';
        profileData['address_two'] = data['address_two'] ?? '';
        profileData['city'] = data['city'] ?? '';
        profileData['region'] = data['region'] ?? '';
        profileData['zip'] = data['zip'] ?? '';
        profileData['country'] = data['country'] ?? '';
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
    return profileData;
  }

  static Future<void> resetPassword(
      BuildContext context, TextEditingController emailController) async {
    try {
      await supabase.auth.resetPasswordForEmail(
        emailController.text.trim(),
        redirectTo:
            kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check your email to reset password!')),
      );
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
    }
  }

  static Future<void> updatePassword(
      BuildContext context, TextEditingController passwordController) async {
    try {
      await supabase.auth.updateUser(
        UserAttributes(password: passwordController.text.trim()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password Changed! Login required!')),
      );
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
      await supabase.auth.signOut();
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  static Future<void> signOut(BuildContext context) async {
    try {
      await supabase.auth.signOut();
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
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }
}

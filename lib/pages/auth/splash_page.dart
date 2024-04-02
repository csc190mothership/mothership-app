import 'package:flutter/material.dart';
import 'package:mothership/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int mfaOption = 1;

  @override
  void initState() {
    super.initState();
    //_getProfile();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Execute _redirect after the first frame is built
      _redirect(context);
    });
  }

  Future<void> _getProfile() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      final data =
          await supabase.from('profiles').select().eq('id', userId).single();
      if (mounted) {
        setState(() {
          mfaOption = data['mfa_option'];
        });
      }
    }
    return;
  }

  Future<void> _redirect(BuildContext context) async {
    await _getProfile(); // Wait for _getProfile() to complete

    final session = supabase.auth.currentSession;

    if (session == null) {
      // No active session, redirect to login
      Navigator.of(context).pushReplacementNamed('/login');
      return;
    }

    // Assuming mfaOption is properly initialized and accessible
    if (mfaOption == 2) {
      // Navigate to the appropriate page based on MFA assurance level
      final assuranceLevelData =
          supabase.auth.mfa.getAuthenticatorAssuranceLevel();
      if (assuranceLevelData.currentLevel ==
          AuthenticatorAssuranceLevels.aal1) {
        // The user has not setup MFA yet
        // Redirect them to the enrollment page
        Navigator.of(context).pushReplacementNamed('/mfaverify');
      } else {
        // The user has already setup MFA
        // Redirect them to the verify page
        Navigator.of(context).pushReplacementNamed('/mfaverify');
      }
    } else {
      // Navigate to the default page (e.g., profile page)
      Navigator.of(context).pushReplacementNamed('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

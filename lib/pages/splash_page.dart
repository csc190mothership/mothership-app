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
    _getProfile();
    _redirect();
  }

  Future<void> _getProfile() async {
    final userId = supabase.auth.currentUser!.id;
    final data =
        await supabase.from('profiles').select().eq('id', userId).single();
    if (mounted) {
      setState(() {
        if (data['mfa_option'] != null) {
          mfaOption = data['mfa_option'];
        }
      });
    }
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);

    final session = supabase.auth.currentSession;

    if (session == null) {
      Navigator.of(context).pushReplacementNamed('/register');
    }

    if (mfaOption == 2) {
      final assuranceLevelData =
          supabase.auth.mfa.getAuthenticatorAssuranceLevel();

      // The user has not setup MFA yet, so send them to enroll MFA page.
      if (assuranceLevelData.currentLevel ==
          AuthenticatorAssuranceLevels.aal1) {
        await supabase.auth.refreshSession();
        final nextLevel =
            supabase.auth.mfa.getAuthenticatorAssuranceLevel().nextLevel;
        if (nextLevel == AuthenticatorAssuranceLevels.aal2) {
          // The user has already setup MFA, but haven't login via MFA
          // Redirect them to the verify page
          Navigator.of(context).pushReplacementNamed('/mfaverify');
        } else {
          // The user has not yet setup MFA
          // Redirect them to the enrollment page
          Navigator.of(context).pushReplacementNamed('/mfaenroll');
        }
      }
    } else {
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

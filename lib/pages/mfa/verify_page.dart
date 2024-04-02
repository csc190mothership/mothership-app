import 'package:flutter/material.dart';
import 'package:mothership/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MFAVerifyPage extends StatefulWidget {
  const MFAVerifyPage({super.key});

  @override
  State<MFAVerifyPage> createState() => _MFAVerifyPageState();
}

class _MFAVerifyPageState extends State<MFAVerifyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify MFA'),
        actions: [
          TextButton(
            onPressed: () {
              supabase.auth.signOut();
              Navigator.of(context).pushReplacementNamed('/register');
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 24,
        ),
        children: [
          Text(
            'Verification Required',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          const Text('Enter the code shown in your authentication app.'),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              hintText: '000000',
            ),
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            onChanged: (value) async {
              if (value.length != 6) return;

              // kick off the verification process once 6 characters are entered
              try {
                final factorsResponse = await supabase.auth.mfa.listFactors();
                final factor = factorsResponse.totp.first;
                final factorId = factor.id;

                final challenge =
                    await supabase.auth.mfa.challenge(factorId: factorId);
                await supabase.auth.mfa.verify(
                  factorId: factorId,
                  challengeId: challenge.id,
                  code: value,
                );
                await supabase.auth.refreshSession();
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed('/profile');
                }
              } on AuthException catch (error) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(error.message)));
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Unexpected error occurred')));
              }
            },
          ),
          const SizedBox(
            height: 12,
          ),
          //Sign out user
          ElevatedButton(
              onPressed: () async {
                await supabase.auth.signOut();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sign out successful!')));
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
              child: const Text('Sign Out')),
        ],
      ),
    );
  }
}

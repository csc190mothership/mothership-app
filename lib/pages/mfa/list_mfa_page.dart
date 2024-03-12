import 'package:flutter/material.dart';
import 'package:mothership/main.dart';

/// A page that lists the currently signed in user's MFA methods.
///
/// The user can unenroll the factors.
class ListMFAPage extends StatelessWidget {
  ListMFAPage({super.key});

  final _factorListFuture = supabase.auth.mfa.listFactors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List of MFA Factors')),
      body: FutureBuilder(
        future: _factorListFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final response = snapshot.data!;
          final factors = response.all;
          return ListView.builder(
            itemCount: factors.length,
            itemBuilder: (context, index) {
              final factor = factors[index];
              return ListTile(
                title: Text(factor.friendlyName ?? factor.factorType.name),
                subtitle: Text(factor.status.name),
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              'Are you sure you want to delete this factor? You will be signed out of the app upon removing the factor.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/');
                                },
                                child: const Text('cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await supabase.auth.mfa.unenroll(factor.id);
                                  await supabase.auth.signOut();
                                  if (context.mounted) {
                                    Navigator.of(context)
                                        .pushReplacementNamed('/register');
                                  }
                                },
                                child: const Text('delete'),
                              ),
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.delete_outline),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

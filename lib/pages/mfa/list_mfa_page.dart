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
      appBar: AppBar(
        title: const Text('List of MFA Factors'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
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
                              'Are you sure you want to delete this?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  try {
                                    await supabase.auth.mfa.unenroll(factor.id);
                                    await supabase.auth.signOut();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Device signed out!')));
                                    Navigator.pushNamed(context, '/');
                                  } catch (error) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: const Text(
                                          'Unexpected error occurred.'),
                                      backgroundColor:
                                          Theme.of(context).colorScheme.error,
                                    ));
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

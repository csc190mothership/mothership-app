import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mothership/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountSetupPage extends StatefulWidget {
  const AccountSetupPage({super.key});

  @override
  State<AccountSetupPage> createState() => _AccountSetupPageState();
}

class _AccountSetupPageState extends State<AccountSetupPage> {
  bool _isLoading = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _addressOneController = TextEditingController();
  final TextEditingController _addressTwoController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  Future<void> updateUser() async {
    final firstname = _firstNameController.text.trim();
    final lastname = _lastNameController.text.trim();
    final gender = _genderController.text.trim();
    final mainaddress = _addressOneController.text.trim();
    final secondaryaddress = _addressTwoController.text.trim();
    final city = _cityController.text.trim();
    final region = _regionController.text.trim();
    final zip = _zipController.text.trim();
    final country = _countryController.text.trim();
    final userId = supabase.auth.currentUser!.id;
    try {
      setState(() {
        _isLoading = true;
      });
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account setup complete!')),
        );
        Navigator.of(context).pushReplacementNamed('/');
        _firstNameController.clear();
        _lastNameController.clear();
        _genderController.clear();
        _addressOneController.clear();
        _addressTwoController.clear();
        _cityController.clear();
        _regionController.clear();
        _zipController.clear();
        _countryController.clear();
      }
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _genderController.dispose();
    _addressOneController.dispose();
    _addressTwoController.dispose();
    _cityController.dispose();
    _regionController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Account Setup',
                  style: TextStyle(fontSize: 40),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _firstNameController,
                        decoration:
                            const InputDecoration(labelText: 'First Name'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _lastNameController,
                        decoration:
                            const InputDecoration(labelText: 'Last Name'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _genderController,
                  decoration: const InputDecoration(labelText: 'Gender'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _addressOneController,
                  decoration: const InputDecoration(labelText: 'Main Address'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _addressTwoController,
                  decoration:
                      const InputDecoration(labelText: 'Secondary Address'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _cityController,
                        decoration: const InputDecoration(labelText: 'City'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _regionController,
                        decoration: const InputDecoration(labelText: 'Region'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _zipController,
                        decoration: const InputDecoration(labelText: 'Zip'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _countryController,
                        decoration: const InputDecoration(labelText: 'Country'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _isLoading ? null : updateUser();
                  },
                  child: Text(_isLoading ? 'Loading' : 'Finish Setup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mothership/main.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _genderController = TextEditingController();
  final _addressoneController = TextEditingController();
  final _addresstwoController = TextEditingController();
  final _cityController = TextEditingController();
  final _regionController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getInitialProfile();
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    super.dispose();
  }

  Future<void> _getInitialProfile() async {
    final userId = supabase.auth.currentUser!.id;
    final data =
        await supabase.from('profiles').select().eq('id', userId).single();
    setState(() {
      if (data['first_name'] != null) {
        _firstnameController.text = data['first_name'];
      }
      if (data['last_name'] != null) {
        _lastnameController.text = data['last_name'];
      }
      if (data['gender'] != null) {
        _genderController.text = data['gender'];
      }
      if (data['last_name'] != null) {
        _addressoneController.text = data['address_one'];
      }
      if (data['first_name'] != null) {
        _addresstwoController.text = data['address_two'];
      }
      if (data['last_name'] != null) {
        _cityController.text = data['city'];
      }
      if (data['first_name'] != null) {
        _regionController.text = data['region'];
      }
      if (data['last_name'] != null) {
        _zipController.text = data['zip'];
      }
      if (data['first_name'] != null) {
        _countryController.text = data['country'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          TextFormField(
            controller: _firstnameController,
            decoration: const InputDecoration(
              label: Text('First Name'),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _lastnameController,
            decoration: const InputDecoration(
              label: Text('Last Name'),
            ),
          ),
          TextFormField(
            controller: _genderController,
            decoration: const InputDecoration(
              label: Text('Gender'),
            ),
          ),
          TextFormField(
            controller: _addressoneController,
            decoration: const InputDecoration(
              label: Text('Main Address'),
            ),
          ),
          TextFormField(
            controller: _addresstwoController,
            decoration: const InputDecoration(
              label: Text('Secondary Address'),
            ),
          ),
          TextFormField(
            controller: _cityController,
            decoration: const InputDecoration(
              label: Text('City'),
            ),
          ),
          TextFormField(
            controller: _regionController,
            decoration: const InputDecoration(
              label: Text('Region'),
            ),
          ),
          TextFormField(
            controller: _zipController,
            decoration: const InputDecoration(
              label: Text('Zip'),
            ),
          ),
          TextFormField(
            controller: _countryController,
            decoration: const InputDecoration(
              label: Text('Country'),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
              onPressed: () async {
                final firstname = _firstnameController.text.trim();
                final lastname = _lastnameController.text.trim();
                final gender = _genderController.text.trim();
                final mainaddress = _addressoneController.text.trim();
                final secondaryaddress = _addresstwoController.text.trim();
                final city = _cityController.text.trim();
                final region = _regionController.text.trim();
                final zip = _zipController.text.trim();
                final country = _countryController.text.trim();
                final userId = supabase.auth.currentUser!.id;
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
                }).eq('id', userId);
                if (mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Saved!')));
                }
              },
              child: const Text('Save')),
          ElevatedButton(
              onPressed: () async {
                await supabase.auth.signOut();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sign out successful!')));
                  Navigator.of(context).pushReplacementNamed('/register');
                }
              },
              child: const Text('Sign Out')),
        ],
      ),
    );
  }
}

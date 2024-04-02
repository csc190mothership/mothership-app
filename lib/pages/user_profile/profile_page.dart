import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mothership/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _genderController = TextEditingController();
  final _addressoneController = TextEditingController();
  final _addresstwoController = TextEditingController();
  final _cityController = TextEditingController();
  final _regionController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController();
  int selectedOption = 1;

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
    final userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      final data =
          await supabase.from('profiles').select().eq('id', userId).single();
      if (mounted) {
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
          if (data['mfa_option'] != null) {
            selectedOption = data['mfa_option'];
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
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
          const Text('MFA Status:'),
          ListTile(
            title: const Text('Enable'),
            leading: Radio(
                value: 2,
                groupValue: selectedOption,
                activeColor: Colors.red,
                fillColor: MaterialStateProperty.all(Colors.red),
                splashRadius: 20,
                onChanged: (val) {}),
          ),
          ListTile(
            title: const Text('Disable'),
            leading: Radio(
                value: 1,
                groupValue: selectedOption,
                activeColor: Colors.blue,
                fillColor: MaterialStateProperty.all(Colors.blue),
                splashRadius: 25,
                onChanged: (val) {}),
          ),
          //Edit Profile
          ElevatedButton(
              onPressed: () async {
                if (mounted) {
                  Navigator.pushNamed(context, '/editprofile');
                }
              },
              child: const Text('Edit')),
          //Navigate to MFA device list
          ElevatedButton(
              onPressed: () async {
                if (mounted) {
                  Navigator.pushNamed(context, '/listmfa');
                }
              },
              child: const Text('MFA List')),
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

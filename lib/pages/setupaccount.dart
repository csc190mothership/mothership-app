import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mothership/functions.dart';

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
  final TextEditingController _countryController =
      TextEditingController(text: "USA");

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
    return Scaffold(
      body: Stack(
        children: [
          _buildSetupAccountContent(),
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildSetupAccountContent() {
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
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(
                              r'[a-zA-Z]')), // Allow only alphabetical characters
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _lastNameController,
                        decoration:
                            const InputDecoration(labelText: 'Last Name'),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(
                              r'[a-zA-Z]')), // Allow only alphabetical characters
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _genderController,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(
                        r'[a-zA-Z]')), // Allow only alphabetical characters
                  ],
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
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(
                              r'[a-zA-Z\s]')), // Allow alphabetical characters and space
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        maxLength: 2,
                        controller: _regionController,
                        decoration: const InputDecoration(labelText: 'State'),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(
                              r'[a-zA-Z]')), // Allow only alphabetical characters
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        maxLength: 5,
                        controller: _zipController,
                        decoration: const InputDecoration(labelText: 'Zip'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        controller: _countryController,
                        decoration: const InputDecoration(labelText: 'Country'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (!_isLoading) {
                      setState(() {
                        _isLoading = true; // Set loading state to true
                      });
                      try {
                        await Functions.updateUser(
                            context,
                            _firstNameController,
                            _lastNameController,
                            _genderController,
                            _addressOneController,
                            _addressTwoController,
                            _cityController,
                            _regionController,
                            _zipController,
                            _countryController);
                      } finally {
                        setState(() {
                          _isLoading = false; // Set loading state to false
                        });
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
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                  ),
                  child: const Text('Finish Setup'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5), // Semi-transparent black color
      child: const Center(
        child: CircularProgressIndicator(), // Circular loading indicator
      ),
    );
  }
}

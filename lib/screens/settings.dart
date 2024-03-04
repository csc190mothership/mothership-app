import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: [
          settingsHeader("My Account"),
          settingsTile("Profile", (){}),
          settingsTile("Gift Cards", (){}),
          settingsTile("Payment Cards", (){}),
          settingsTile("Addresses", (){}),
          settingsHeader("Your Discounts"),
          settingsTile("Teacher Discount", (){}),
          settingsTile("Military Discount", (){}),
          settingsTile("Hofstra Student Discount", (){}),
          settingsHeader("Security"),
          settingsTile("Password", (){}),
          settingsTile("Wallet Security", (){}),
        ],
      ),
    );
  }

  Widget settingsTile(String title, Function onTap, [bool withDivider = true]) {
    if (withDivider) {
      return Column(children:[ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap as void Function()?,
      ),
      settingsDivider(),
      ]);
    }
    return Column(children:[
      ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap as void Function()?,
      ),
    ]);
  }

  Widget settingsDivider() {
    return const Divider(indent: 10, endIndent: 10);
  }

  Widget settingsHeader(String title) {
    return Column(children:[
      ListTile(
        title: Text(
          title, 
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
          )
        ),
      ),
      settingsDivider(),
    ]);
  }
}
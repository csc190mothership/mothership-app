import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themeprovider.dart';


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
    return 
      ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap as void Function()?,
      );
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


///GENERAL SETTINGS
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          settingsHeader("Application Settings"),
          settingsTile("Appearance", (){pushScreen(const AppearanceSettings());}),
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

  void pushScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

}


//APPEARANCE SETTINGS
class AppearanceSettings extends StatefulWidget {
  const AppearanceSettings({super.key});

  @override
  _AppearanceSettingsState createState() => _AppearanceSettingsState();
}

class _AppearanceSettingsState extends State<AppearanceSettings> {
  var lightnessIcon = Icons.wb_sunny_rounded;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          settingsHeader("Appearance"),
          ListTile(
            title: const Text("Theme"),
            trailing: IconButton(
              icon: Icon(lightnessIcon),
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen:false).toggleTheme();
                if (lightnessIcon == Icons.wb_sunny_rounded) {
                  setState(() {
                    lightnessIcon = Icons.nightlight_round;
                  });
                } else {
                  setState(() {
                    lightnessIcon = Icons.wb_sunny_rounded;
                  });
                }
              },
            ),
          )
          
        ],
      ),
    );
  }
}
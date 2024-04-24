import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
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
          settingsTile("Profile", (){pushScreen(const AccountSettings());}),
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
      PageTransition(type: PageTransitionType.rightToLeft, child:screen)
     
    );
  }

}


//TODO:
//ideally, make a single subpage of settings which displays an array of list items
//OR: make the settings class just chnage the array based on which setting pressed. Probably easier? but would be harder to make look good

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
            onTap: () {
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
            trailing: Icon(lightnessIcon),

          ),
        
          
        ],
      ),
    );
  }
}

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  var email = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          settingsHeader("My Account"),
          settingsTile("Change Email", (){changeSomething(context, email, "Email");}),
          
          
        ],
      ),
    );
  }
}


Future<void> changeSomething(context, varToChange, String name) async {
  var _newItem = "";
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Change $name'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Old $name: '),
              TextField(
                  //later will have to confirm the old value matches.
                  //for now, its just a field.

                  
              
                ),
              Text('New $name: '),
              TextField(
                onChanged: (value) {
                  _newItem = value;
                  //then set the user's value to _newItem
                  //we use variable _newItem because it provides safe exchange to user data
                  //on top of this, we can use this function for other values if needed
                  //hell yea
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Change'),
            onPressed: () {
              varToChange = "new value";
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
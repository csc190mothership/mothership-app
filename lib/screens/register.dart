import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}



class _RegisterState extends State<Register> {

  TextStyle fieldStyle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

  var email = "";
  var password = "";
  var pNumber = "555-867-5309";
  String initialCountry = 'US';
  PhoneNumber number = PhoneNumber(isoCode: 'US');


  @override
  Widget build(BuildContext context) {
    bool isPhoneGood = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //TODO: For all fields, verify that they follow format
            const SizedBox(height: 20),
            Text(
              "Email",
              style: fieldStyle,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Enter your email",
              ),
              onChanged: (value) {
                email = value;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (input) => input!.isValidEmail() ? null : "Enter a valid email",

            ),
            const SizedBox(height: 20),
            Text(
              "Password",
              style: fieldStyle,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Enter your password",
              ),
              onChanged: (value) {
                password = value;

              },
            ),
            const SizedBox(height: 20),
            Text(
              "Phone Number",
              style: fieldStyle,
            ),
            InternationalPhoneNumberInput(
              initialValue: number,
              onInputChanged: (PhoneNumber number) {
                if (isPhoneGood) {
                  pNumber = number.phoneNumber!;
                }
              },
              onInputValidated: (bool value) {
                isPhoneGood = value; 
              },
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement registration logic with supabase
                },
                child: const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension EmailValidator on String {
  //dont even ask
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

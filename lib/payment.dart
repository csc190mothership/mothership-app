// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class Payment {
  Map<String, dynamic>? paymentIntent;
  /*
  Future<void> makePayment(BuildContext context, String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Ikay',
        ),
      );

      await displayPaymentSheet(context);
    } catch (err) {
      throw Exception(err.toString());
    }
  }*/
  /*
  Future<void> uploadOrderData() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        final jsonData = cartItems.map((product) => product.toJson()).toList();
        await supabase
            .from('profiles')
            .update({'cart_items': jsonData}).eq('id', userId);
      }
    } catch (e) {
      //
    }

  }
  */
  Future<void> displayPaymentSheet(BuildContext context) async {
    try {
      
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100.0,
                ),
                SizedBox(height: 10.0),
                Text("Payment Successful!"),
              ],
            ),
          ),
        );

        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error.toString());
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  Text("Payment Failed"),
                ],
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  String calculateAmount(String amount) {
    final calculatedAmount = (double.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}

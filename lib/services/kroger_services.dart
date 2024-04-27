import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import flutter_dotenv
import '../product.dart';
import 'dart:convert';

class KrogerService {
  final Uri tokenUrl = Uri.parse(dotenv.env['API_URI']!);
  final List<String> scopes = ['product.compact'];

  Future<oauth2.Client> authenticate() async {
    final String clientID = dotenv.env['KROGER_CLIENT_ID']!;
    final String clientSecret = dotenv.env['KROGER_CLIENT_SECRET']!;

    return await oauth2.clientCredentialsGrant(
      tokenUrl,
      clientID,
      clientSecret,
      scopes: scopes,
      httpClient: http.Client(),
    );
  }

  Future<List<Product>> fetchProductData(String searchTerm) async {
    final client = await authenticate();
    final Uri apiUrl =
        Uri.parse('https://api.kroger.com/v1/products?filter.term=$searchTerm');
    final response = await client.get(apiUrl);
    List<Product> products = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> items = data['data'];
      products = items.map((itemJson) => Product.fromJson(itemJson)).toList();
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return products;
  }
}

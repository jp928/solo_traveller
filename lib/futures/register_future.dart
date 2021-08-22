import 'dart:convert';
import 'package:http/http.dart' as http;

import 'auth_future.dart';

Future<bool> register(String email, String password) async {
  final response = await http.post(
    Uri.parse('https://solodevelopment.tk/account/register'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    return await auth(email, password);
  } else {
    var message = 'Failed';
    if (response.body.isNotEmpty) {
      Map<String, dynamic> data = jsonDecode(response.body);
      message = data['message'] ?? 'Failed';
    }
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(message);
  }
}
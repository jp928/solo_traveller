import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

Future<bool> register(String email, String password) async {
  final response = await http.post(
    Uri.parse('https://solodevelopment.ml/account/register'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    // return Album.fromJson(jsonDecode(response.body))
    var data = jsonDecode(response.body);
    log('data: $data');
    return true;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}
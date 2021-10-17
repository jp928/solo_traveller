import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solo_traveller/constants/config.dart';
import 'package:solo_traveller/models/auth.dart';

Future<bool> auth(String email, String password) async {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final response = await http.post(
    Uri.parse('${API_URL}auth/token'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    if (response.body.isNotEmpty) {
      Map<String, dynamic> authMap = jsonDecode(response.body);
      var auth = Auth.fromJson(authMap);
      await secureStorage.write(key: 'token', value: auth.token);
      await secureStorage.write(key: 'refreshToken', value: auth.refreshToken);
    }

    return true;
  } else {
    var message = 'Failed';
    if (response.body.isNotEmpty) {
      Map<String, dynamic> data = jsonDecode(response.body);
      message = data['message'] ?? 'Failed';
    }
    throw Exception(message);
  }
}

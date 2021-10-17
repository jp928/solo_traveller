import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:solo_traveller/constants/config.dart';
import 'package:solo_traveller/futures/refresh_token_future.dart';
import 'package:solo_traveller/models/profile.dart';

Future<bool> updateProfile(Profile profile) async {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? token = await secureStorage.read(key: 'token');

  final response = await http.put(
    Uri.parse('${API_URL}account/update_profile'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(profile),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    var message = 'Failed';

    if (response.statusCode == 401) {
      await refreshToken();
      return updateProfile(profile);
    }

    if (response.body.isNotEmpty) {
      Map<String, dynamic> data = jsonDecode(response.body);
      message = data['message'] ?? 'Failed';
    }
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(message);
  }
}

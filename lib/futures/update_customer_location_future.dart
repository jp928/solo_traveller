import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solo_traveller/constants/config.dart';
import 'package:solo_traveller/futures/refresh_token_future.dart';
import 'package:solo_traveller/utilities/parse_jwt.dart';

Future<bool> updateCustomerLocation(Position position) async {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? token = await secureStorage.read(key: 'token');
  var tokenInfo = parseJwt(token!);

  final response = await http.post(
    Uri.parse('${API_URL}user/save_location'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(<String, String>{
      'userId': tokenInfo['sub'],
      'longitude': position.longitude.toString(),
      'latitude': position.latitude.toString(),
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    if (response.statusCode == 401) {
      await refreshToken();
      return updateCustomerLocation(position);
    }

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

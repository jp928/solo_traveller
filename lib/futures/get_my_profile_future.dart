import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solo_traveller/constants/config.dart';
import 'package:solo_traveller/futures/refresh_token_future.dart';
import 'package:solo_traveller/models/profile.dart';
import 'package:solo_traveller/providers/my_cube_user.dart';
import 'package:solo_traveller/utilities/parse_jwt.dart';

Future<Profile> getMyProfile() async {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? token = await secureStorage.read(key: 'token');
  var tokenInfo = parseJwt(token!);
  String userId = tokenInfo['sub'];

  final response = await http.get(
    Uri.parse('${API_URL}user/profile?userId=$userId'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );

  if (response.statusCode == 200 && response.body.isNotEmpty) {
    return Profile.fromJson(json.decode(response.body));
  } else {
    if (response.statusCode == 401) {
      await refreshToken();
      return getMyProfile();
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

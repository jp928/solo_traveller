import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:solo_traveller/futures/refresh_token_future.dart';
import 'package:solo_traveller/utilities/parse_jwt.dart';

Future<bool> createPost(String body, int? imageId, String? userId, String? firstName, String? lastName) async {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? token = await secureStorage.read(key: 'token');

  var tokenInfo;
  var fullName;
  if (firstName == null) {
    tokenInfo = parseJwt(token!);
    fullName = tokenInfo?['fullName'].split(' ');
  }

  final response = await http.post(
    Uri.parse('https://solodevelopment.tk/post/posts'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(<String, String?>{
      'ownerUserId': userId ?? tokenInfo?['sub'],
      'imageId': imageId == null ? null : imageId.toString(),
      'body': body,
      'postTypeId': 'Post',
      'firstName': firstName ?? fullName[0],
      'lastName': lastName ?? fullName[1],
    }),
  );

  if (response.statusCode == 201) {
    return true;

  } else {
    if (response.statusCode == 401) {
      await refreshToken();
      return createPost(body, imageId, userId, firstName, lastName);
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
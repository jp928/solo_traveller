import 'dart:convert';
import 'dart:developer';

import 'package:connectycube_sdk/connectycube_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:provider/src/provider.dart';
import 'dart:io';
import 'package:solo_traveller/futures/refresh_token_future.dart';
import 'package:solo_traveller/providers/my_cube_user.dart';
import 'package:solo_traveller/utilities/parse_jwt.dart';

Future<bool> uploadProfileImage(File image, BuildContext context) async {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? token = await secureStorage.read(key: 'token');

  var tokenInfo;
  if (token != null) {
    tokenInfo = parseJwt(token);
  }

  String userId = tokenInfo?['sub'];
  var uri = Uri.parse('https://solodevelopment.tk/content/upload/profile?userId=$userId');
  final mimeTypeData = lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');

  // Initialize the multipart request
  final imageUploadRequest = http.MultipartRequest('POST', uri);
  imageUploadRequest.headers['Authorization'] = 'Bearer $token';

  // Attach the file in the request
  final file = await http.MultipartFile.fromPath('file', image.path,
      contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
  imageUploadRequest.files.add(file);

  final streamedResponse = await imageUploadRequest.send();
  final response = await http.Response.fromStream(streamedResponse);

  if (response.statusCode == 200) {
    MyCubeUser myCubeUser = context.read<MyCubeUser>();
    Map<String, dynamic> profileImage = jsonDecode(response.body);
    myCubeUser.setProfileImage(profileImage['url']);
    CubeUser? user = myCubeUser.user;
    user?.avatar = profileImage['url'];

    if (user != null) {
      await updateUser(user);
    }

    return true;
  } else {
    var message = 'Failed';

    if (response.statusCode == 401) {
      await refreshToken();
      return uploadProfileImage(image, context);
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
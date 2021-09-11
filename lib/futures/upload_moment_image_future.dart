import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:solo_traveller/futures/refresh_token_future.dart';
import 'package:solo_traveller/utilities/parse_jwt.dart';

Future<bool> uploadMomentImage(File image, String body) async {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? token = await secureStorage.read(key: 'token');

  var tokenInfo;
  if (token != null) {
    tokenInfo = parseJwt(token);
  }

  String userId = tokenInfo?['sub'];
  var uri = Uri.parse('https://solodevelopment.tk/content/upload/momment_image?userId=$userId');
  final mimeTypeData = lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');

  // Initialize the multipart request
  final imageUploadRequest = http.MultipartRequest('POST', uri);
  imageUploadRequest.headers['Authorization'] = 'Bearer $token';
  // imageUploadRequest.fields['body'] = body;
  // imageUploadRequest.fields['ownerUserId'] = userId;
  // final fullName = tokenInfo?['fullName'].split(' ');
  // imageUploadRequest.fields['postTypeId'] = 'Post';
  // imageUploadRequest.fields['firstName'] = fullName[0];
  // imageUploadRequest.fields['lastName'] = fullName[1];

  log(mimeTypeData![0]);
  log(mimeTypeData[1]);
  // Attach the file in the request
  final file = await http.MultipartFile.fromPath('imageData', image.path,
      contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
  imageUploadRequest.files.add(file);

  final streamedResponse = await imageUploadRequest.send();
  log('========================');
  log(userId);
  log(token!);
  final response = await http.Response.fromStream(streamedResponse);
  log(response.body);
  if (response.statusCode == 200) {
    return true;
  } else {
    var message = 'Failed';

    if (response.statusCode == 401) {
      await refreshToken();
      log('here');
      return uploadMomentImage(image, body);
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
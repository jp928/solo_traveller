
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solo_traveller/futures/refresh_token_future.dart';
import 'package:solo_traveller/models/post.dart';

Future<List<Post>> getPosts({ int pageNum = 1, int pageSize = 20}) async {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? token = await secureStorage.read(key: 'token');
  final response = await http.get(
    Uri.parse('https://solodevelopment.tk/post/posts?pageNo=${pageNum.toString()}&pageSize=${pageSize.toString()}'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );

  if (response.statusCode == 200 && response.body.isNotEmpty) {
    List responseList = json.decode(response.body);

    responseList.map((e) => print(e));
    return responseList.map((data) => Post.fromJson(data)).toList();

  } else {
    if (response.statusCode == 401) {
      await refreshToken();
      return getPosts();
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
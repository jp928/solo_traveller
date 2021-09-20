
import 'dart:convert';
import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:solo_traveller/futures/refresh_token_future.dart';
import 'package:solo_traveller/models/person.dart';
import 'package:solo_traveller/models/post.dart';

import 'determine_position_future.dart';

Future<List<Person>> getPeopleNearMe({ int pageNum = 1, int pageSize = 20, String distance = '2000'}) async {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String? token = await secureStorage.read(key: 'token');
  Position position = await determinePosition();

  final response = await http.get(
    Uri.parse('https://solodevelopment.tk/user/people?longitude=${position.longitude.toString()}&latitude=${position.latitude.toString()}&pageIndex=${pageNum.toString()}&pageSize=${pageSize.toString()}&distanceRange=$distance&groupToRow=false&rowItemCount=0'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );

  if (response.statusCode == 200 && response.body.isNotEmpty) {
    List responseList = json.decode(response.body);

    responseList.map((e) => print(e));
    return responseList.map((data) => Person.fromJson(data)).toList();

  } else {
    if (response.statusCode == 401) {
      await refreshToken();
      return getPeopleNearMe(pageNum: pageNum, pageSize: pageSize);
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
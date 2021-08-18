import 'dart:convert';
import 'package:http/http.dart' as http;

class Setting {
  final int minFeedAge;
  final int maxFeedAge;

  Setting(this.maxFeedAge, this.minFeedAge);

  Setting.fromJson(Map<String, dynamic> json)
      : maxFeedAge = json['maxFeedAge'],
        minFeedAge = json['minFeedAge'];

  Map<String, dynamic> toJson() => {
    'maxFeedAge': maxFeedAge,
    'minFeedAge': minFeedAge,
  };
}

class Profile {
  final Setting setting;
  final String firstName;
  final String dateOfBirth;

  Profile(this.firstName, this.dateOfBirth, this.setting);

  Profile.fromJson(Map<String, dynamic> json)
      : setting = json['setting'],
        firstName = json['firstName'],
        dateOfBirth = json['dateOfBirth'];

  Map<String, dynamic> toJson() => {
    'setting': setting,
    'firstName': firstName,
    'dateOfBirth': dateOfBirth,
  };
}

Future<bool> updateProfile(Profile profile) async {
  final response = await http.post(
    Uri.parse('https://solodevelopment.tk/account/update_profile'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(profile),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    Map<String, dynamic> data = jsonDecode(response.body);
    var message = data['message'] ?? 'Failed';
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(message);
  }
}
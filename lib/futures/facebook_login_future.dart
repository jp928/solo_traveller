import 'dart:developer';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<Map<String, dynamic>?> facebookLogin() async {
  final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile

  // loginBehavior is only supported for Android devices, for ios it will be ignored
  // final result = await FacebookAuth.instance.login(
  //   permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link'],
  //   loginBehavior: LoginBehavior
  //       .DIALOG_ONLY, // (only android) show an authentication dialog instead of redirecting to facebook app
  // );

  if (result.status == LoginStatus.success) {
    // get the user data
    // by default we get the userId, email,name and picture
    final userData = await FacebookAuth.instance.getUserData();

    log(userData.toString());


    return userData;
  }

  return null;

}

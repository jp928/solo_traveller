import 'package:connectycube_sdk/connectycube_calls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class MyCubeUser with ChangeNotifier, DiagnosticableTreeMixin {
  String? _email;
  String? _name;
  String? _profileImage;
  CubeUser? _user;

  String? get email => _email;
  String? get name => _name;
  String? get profileImage => _profileImage;
  CubeUser? get user => _user;

  void setEmail(String email) {
    this._email = email;
  }

  void setName(String name) {
    this._name = name;
  }

  void setUser(CubeUser user) {
    this._user = user;
  }

  void setProfileImage(String profileImage) {
    this._profileImage = profileImage;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // properties.add(IntProperty('count', count));
  }
}
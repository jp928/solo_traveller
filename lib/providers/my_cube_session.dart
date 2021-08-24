import 'package:connectycube_sdk/connectycube_calls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class MyCubeSession with ChangeNotifier, DiagnosticableTreeMixin {
  CubeSession? _cubeSession;

  CubeSession? get cubeSession => _cubeSession;

  void setSession(CubeSession cubeSession) {
    this._cubeSession = cubeSession;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // properties.add(IntProperty('count', count));
  }
}
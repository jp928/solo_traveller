import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:solo_traveller/providers/my_cube_session.dart';
import 'package:solo_traveller/providers/my_cube_user.dart';

Future<CubeUser?> createConnectyCubeSession(
    BuildContext context,
    { bool withSignUp = true }) async {
  CubeSettings.instance.isDebugEnabled = true;
  MyCubeUser myCubeUser = context.read<MyCubeUser>();

  CubeUser user = CubeUser(
      email: myCubeUser.email,
      password: myCubeUser.email,
      fullName: myCubeUser.name
  );

  if (withSignUp) {
    user = await signUp(user).onError((error, stackTrace) {
      throw Exception(error.toString());
    }).catchError((e) async {
      Navigator.pop(context);
      await showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Failed'),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          )
      );
    });
  } else {
    user = await signIn(user).onError((error, stackTrace) {
      throw Exception(error.toString());
    })
    .catchError((e) async {
      Navigator.pop(context);
      await showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Failed'),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          )
      );
    });
  }

  myCubeUser.setUser(user);
  user.password = myCubeUser.email;

  if (CubeSessionManager.instance.isActiveSessionValid() &&
      CubeSessionManager.instance.activeSession?.userId != null &&
      CubeSessionManager.instance.activeSession?.userId == user.id) {
     CubeChatConnection.instance.login(user).catchError((error) {
      throw Exception(error.toString());
    });

    return CubeSessionManager.instance.activeSession!.user;
  } else {
    final session = await createSession(user);
     CubeChatConnection.instance.login(user).catchError((error) {
      throw Exception(error.toString());
    });
    context.read<MyCubeSession>().setSession(session);

    return session.user;
  }
}
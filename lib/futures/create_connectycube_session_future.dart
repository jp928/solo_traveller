import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:flutter/cupertino.dart';
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
    user = await signUp(user);
  } else {
    user = await signIn(user);
  }

  log(user.toString());
  myCubeUser.setUser(user);
  user.password = myCubeUser.email;

  final session = await createSession(user);
  context.read<MyCubeSession>().setSession(session);

  return session.user;
}
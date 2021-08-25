import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/src/provider.dart';
import 'package:solo_traveller/providers/my_cube_session.dart';
import 'package:solo_traveller/providers/my_cube_user.dart';

Future<CubeUser?> createConnectyCubeSession(BuildContext context) async {
  CubeSettings.instance.isDebugEnabled = true;
  MyCubeUser myCubeUser = context.read<MyCubeUser>();
  await createSession();

  CubeUser user = CubeUser(
      // login: myCubeUser.email,
      email: myCubeUser.email,
      password: myCubeUser.email,
      fullName: myCubeUser.name
  );

  await signUp(user);

  log(user.toString());
  myCubeUser.setUser(user);

  final session = await createSession(user);
  context.read<MyCubeSession>().setSession(session);

  return session.user;
}
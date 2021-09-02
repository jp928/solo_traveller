import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/src/provider.dart';
import 'package:solo_traveller/providers/my_cube_session.dart';
import 'package:solo_traveller/providers/my_cube_user.dart';

Future<CubeUser?> createConnectyCubeSessionWithFacebook(BuildContext context, String accessToken) async {
  CubeSettings.instance.isDebugEnabled = true;
  MyCubeUser myCubeUser = context.read<MyCubeUser>();
  await createSession();

  CubeUser user = await signInUsingSocialProvider(CubeProvider.FACEBOOK, accessToken);

  log(user.toString());
  myCubeUser.setUser(user);

  final session = await createSession(user);
  context.read<MyCubeSession>().setSession(session);

  return session.user;
}
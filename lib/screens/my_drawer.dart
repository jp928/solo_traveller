import 'package:connectycube_sdk/connectycube_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/src/provider.dart';
import 'package:solo_traveller/providers/my_cube_session.dart';
import 'package:solo_traveller/providers/my_cube_user.dart';
import 'package:solo_traveller/screens/get_start_screen.dart';
import 'package:solo_traveller/screens/my_profile_screen.dart';
import 'package:solo_traveller/widgets/avatar.dart';

import 'my_chats_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    await secureStorage.deleteAll();

    MyCubeUser cubeUser = context.read<MyCubeUser>();
    cubeUser.setEmail('');
    cubeUser.setName('');
    cubeUser.setProfileImage('');
    cubeUser.setUser(null);

    await signOut();
    await deleteSession();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => GetStartScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watch<MyCubeUser>();

    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    // child: ClipOval(
                    //   child: Icon(Icons.camera),
                    //   // child: Image.asset(
                    //   //   // "imgs/avatar.png",
                    //   //   width: 80,
                    //   // ),
                    // ),

                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50)),
                      width: 64,
                      height: 64,
                      child: Avatar(image: user.profileImage)
                    )
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        user.user?.fullName ?? '',
                        style: TextStyle(fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(padding: EdgeInsets.only(top: 8)),
                      Text(
                        user.user?.email ?? '',
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  )
                ],
              ),
            ),
            Divider(
              height: 64,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('My profile'),
                    onTap: (){
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new MyProfileScreen()
                          )
                      );

                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.chat),
                    title: const Text('Chat'),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new MyChatsScreen())
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () async {
                      await _logout(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
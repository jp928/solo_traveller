import 'package:connectycube_sdk/connectycube_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/src/provider.dart';
import 'package:solo_traveller/providers/my_cube_user.dart';
import 'package:solo_traveller/screens/get_start_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  void _logout(BuildContext context) async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    await secureStorage.deleteAll();

    MyCubeUser cubeUser = context.read<MyCubeUser>();
    cubeUser.setEmail('');
    cubeUser.setName('');
    cubeUser.setProfileImage('');
    cubeUser.setUser(null);

    await signOut();

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
    print(user.user);
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
                      child: user.profileImage == null ? Icon(
                        Icons.camera_alt_outlined,
                        size: 32,
                        color: Colors.grey[600],
                      ) :
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                          child: Image.network(
                            user.profileImage!,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover
                          ),
                        ),
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
                      _logout(context);

                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: (){
                      _logout(context);

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
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:solo_traveller/providers/my_cube_user.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = context.watch<MyCubeUser>();
    log(user.email ?? '');
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
                      child: Icon(
                        Icons.camera_alt_outlined,
                        size: 32,
                        color: Colors.grey[600],
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
                    leading: const Icon(Icons.add),
                    title: const Text('Add account'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Manage accounts'),
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
import 'dart:developer';

import 'package:connectycube_sdk/connectycube_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:solo_traveller/futures/get_user_profile_future.dart';
import 'package:solo_traveller/models/person.dart';
import 'package:solo_traveller/models/profile.dart';
import 'package:solo_traveller/providers/my_cube_user.dart';
import 'package:solo_traveller/widgets/photo_hero.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chat_dialog_screen.dart';

class PeopleProfileScreen extends StatefulWidget {
  final int userId;
  PeopleProfileScreen({
    required this.userId,
  });

  @override
  _PeopleProfileScreenState createState() => _PeopleProfileScreenState();
}

class _PeopleProfileScreenState extends State<PeopleProfileScreen> {
  Profile? _profile;

  Future<void> _retrieveProfile(String userId) async {
    var profile = await getUserProfile(id: userId);

    setState(() {
      _profile = profile;
    });
  }

  String calculateAge(String? birthDateStr) {
    if (birthDateStr == null) {
      return '';
    }

    DateTime birthDate = DateTime.parse(birthDateStr);
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age.toString();
  }

  @override
  void initState() {
    super.initState();
    _retrieveProfile(widget.userId.toString());
  }

  @override
  Widget build(BuildContext context) {
    final person = ModalRoute.of(context)!.settings.arguments as Person;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF4F4F4),
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(74, 90, 247, 1), //change your color here
        ),
        title: Text(
          '${person.firstName}\'s profile',
          style: TextStyle(color: Colors.black54),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_profile?.chatAccountId == null) {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Failed'),
                  content: Text('Can\'t chat with this user.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                )
            );
          } else {
            MyCubeUser myCubeUser = context.read<MyCubeUser>();

            CubeDialog newDialog = CubeDialog(CubeDialogType.PRIVATE, occupantsIds: [
              int.parse(_profile?.chatAccountId ?? '0')
            ]);
            createDialog(newDialog).then((createdDialog) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDialogScreen(myCubeUser.user!, createdDialog),
                ),
              );
            });
          }

          // Add your onPressed code here!
        },
        // label: const Text('Approve'),
        child: const Icon(Icons.chat),
        backgroundColor: Color(0xff718CFB),
      ),
      body: Container(
        // Set background to blue to emphasize that it's a new route.
        // color: Colors.lightBlueAccent,
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PhotoHero(
                    photo: person.profileImage,
                    id: person.id.toString(),
                    width: 64.0,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${person.firstName} ${person.lastName}',
                          style: TextStyle(fontSize: 24)),
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                      ),
                      Text(
                        '${_profile?.gender ?? ''}, ${calculateAge(_profile?.dateOfBirth)}',
                      )
                    ],
                  )
                ],
              ),
            ),
            Divider(
              height: 0,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'About',
                    style: TextStyle(fontSize: 10),
                  ),
                  Text(_profile?.about ?? '',
                      style: GoogleFonts.getFont('Source Sans Pro',
                          color: Color(0xff4A4A4A), fontSize: 16))
                ],
              ),
            ),
            Divider(
              height: 0,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Stats',
                    style: TextStyle(fontSize: 10),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text((_profile?.momentCount ?? 0).toString(),
                                style: TextStyle(
                                    color: Color(0xff718CFB), fontSize: 16)),
                            Text('MOMENTS',
                                style: GoogleFonts.getFont('Source Sans Pro',
                                    color: Color(0xff4A4A4A)))
                          ],
                        ),
                      ),
                      Container(
                          height: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text((_profile?.followerCount ?? 0).toString(),
                                  style: TextStyle(
                                      color: Color(0xff718CFB), fontSize: 16)),
                              Text('FOLLOWERS',
                                  style: GoogleFonts.getFont('Source Sans Pro',
                                      color: Color(0xff4A4A4A)))
                            ],
                          )),
                      Container(
                          height: 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text((_profile?.followingCount ?? 0).toString(),
                                  style: TextStyle(
                                      color: Color(0xff718CFB), fontSize: 16)),
                              Text('FOLLOWING',
                                  style: GoogleFonts.getFont('Source Sans Pro',
                                      color: Color(0xff4A4A4A)))
                            ],
                          )
                      ),
                    ],
                  )
                ],
              ),
            ),
            Divider(
              height: 0,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Mutual interests',
                    style: TextStyle(fontSize: 10),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12),
                  ),
                Wrap(
                    spacing: 8.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: (_profile?.interests ?? []).map((interest) {
                      return Container(
                          height: 40,
                          width: 108,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(0xff718CFB),
                                radius: 16,
                              ),
                              Text(interest!,
                                  style: TextStyle(
                                      color: Color(0xff2E2F41), fontSize: 12)),
                            ],
                          )
                      );
                    }).toList()
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

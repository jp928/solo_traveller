import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solo_traveller/models/person.dart';
import 'package:solo_traveller/widgets/photo_hero.dart';

class PeopleProfileScreen extends StatelessWidget {
  const PeopleProfileScreen({Key? key}) : super(key: key);
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
      ),
      body: Container(
        // Set background to blue to emphasize that it's a new route.
        color: Colors.lightBlueAccent,
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.topLeft,
        child: PhotoHero(
          photo: person.profileImage,
          id: person.id.toString(),
          width: 100.0,
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

import 'package:connectycube_sdk/connectycube_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AavatarText extends StatelessWidget {
  const AavatarText({
    Key? key,
    this.condition,
    this.text,
    this.image,
  }) : super(key: key);

  final bool? condition;
  final String? text;
  final String? image;

  @override
  Widget build(BuildContext context) {
    if (condition == true)
      return CircleAvatar(
        backgroundImage: NetworkImage(image!),
        radius: 30,
      );
    else
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Text(
          isEmpty(text) ? '?' : text!,
          style: TextStyle(fontSize: 30),
        ),
      );
  }
}

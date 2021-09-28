import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key? key,
    this.image,
    size = 64
  }) : super(key: key);

  final String? image;
  final double size = 64;

  @override
  Widget build(BuildContext context) {
    log(image ?? '');
    if (image == null)
      return Icon(
        Icons.person,
        size: size / 2,
        color: Colors.grey[600],
      );
    else
      return CircleAvatar(
        backgroundImage: NetworkImage(image!),
        radius: size / 2,
      );
      // return ClipRRect(
      //   borderRadius: BorderRadius.circular(size/2),
      //   child: Image.network(
      //       image!,
      //       width: size,
      //       height: size,
      //       fit: BoxFit.cover
      //   ),
      // );
  }
}

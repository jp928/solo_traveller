import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoHero extends StatelessWidget {
  const PhotoHero({
    Key? key,
    this.photo,
    this.onTap,
    required this.id,
    required this.width,
  }) : super(key: key);

  final String? photo;
  final VoidCallback? onTap;
  final double width;
  final String id;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: id,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: this.photo == null
                ? Icon(
                    Icons.camera_alt_outlined,
                    size: width / 2,
                    color: Colors.grey[600],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(width / 2),
                    child: Image.network(photo!,
                        height: width, width: width, fit: BoxFit.cover),
                  ),
          ),
        ),
      ),
    );
  }
}

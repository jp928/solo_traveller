import 'dart:math';

import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart' hide Element;
import 'dart:io';

class ImageText extends SpecialText {
  ImageText(TextStyle textStyle,
      {this.attachedImg,
      SpecialTextGestureTapCallback? onTap,
      required this.start})
      : super(
          ImageText.flag,
          '/>',
          textStyle,
          onTap: onTap,
        );
  static const String flag = '<img:solo-traveller';
  final int start;
  final File? attachedImg;

  @override
  InlineSpan finishText() {
    final String text = toString();
    if (this.attachedImg != null) {
      return ImageSpan(
        FileImage(attachedImg!),
        actualText: text,
        imageWidth: 100,
        imageHeight: 100,
        start: start,
        fit: BoxFit.fill,
        margin: const EdgeInsets.only(left: 2.0, top: 2.0, right: 0)
      );
    }

    return TextSpan(text: text, style: textStyle);
  }
}

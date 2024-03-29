import 'dart:developer';

import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'image_text.dart';
import 'dart:io';

class MySpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  MySpecialTextSpanBuilder(this.attachedImage);

  final File? attachedImage;

  @override
  TextSpan build(String data,
      {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap}) {
    if (kIsWeb) {
      return TextSpan(text: data, style: textStyle);
    }

    return super.build(data, textStyle: textStyle, onTap: onTap);
  }

  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle,
      SpecialTextGestureTapCallback? onTap,
      required int index}) {
    if (flag.isEmpty) {
      return null;
    }

    if (isStart(flag, ImageText.flag)) {
      return ImageText(textStyle ?? TextStyle(fontSize: 12), attachedImg: attachedImage, start: index - (ImageText.flag.length - 1));
    }

    return null;
  }
}

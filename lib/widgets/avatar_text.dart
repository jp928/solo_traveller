import 'package:connectycube_sdk/connectycube_core.dart';
import 'package:flutter/cupertino.dart';

class AavatarText extends StatelessWidget {
  const AavatarText({
    Key? key,
    this.condition,
    this.text,
  }) : super(key: key);

  final bool? condition;
  final String? text;

  @override
  Widget build(BuildContext context) {
    if (condition == true)
      return SizedBox.shrink();
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

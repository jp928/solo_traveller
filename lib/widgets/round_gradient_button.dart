import 'package:flutter/material.dart';

class RoundedGradientButton extends StatelessWidget {
  final String buttonText;
  final double width;
  final Function onPressed;
  final bool transparent;

  RoundedGradientButton({
    required this.buttonText,
    required this.width,
    required this.onPressed,
    this.transparent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          // boxShadow: [
          //   BoxShadow(
          //       color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
          // ],
          gradient: this.transparent ? null : LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 1.0],
            colors: [
              Color.fromRGBO(137, 130, 252, 1),
              Color.fromRGBO(79, 152, 248, 1)
            ],
          ),
          color: Color(0xffF4F4F4),
          borderRadius: BorderRadius.circular(28),
        ),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
                side: this.transparent ?
                BorderSide(
                  color: Color.fromRGBO(113, 140, 250, 1),
                  width: 2
                ) : BorderSide.none
              ),
            ),
            minimumSize: MaterialStateProperty.all(Size(width, 56)),
            backgroundColor:
            MaterialStateProperty.all(Colors.transparent),
            shadowColor:
            MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: () {
            onPressed();
          },
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 18,
                color: this.transparent ? Color.fromRGBO(113, 140, 250, 1) : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
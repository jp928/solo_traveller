import 'package:flutter/material.dart';

class RoundedGradientButton extends StatelessWidget {
  final String buttonText;
  final double width;
  final Function onPressed;

  RoundedGradientButton({
    required this.buttonText,
    required this.width,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 1.0],
            colors: [
              Color.fromRGBO(137, 130, 252, 1),
              Color.fromRGBO(79, 152, 248, 1)
            ],
          ),
          color: Colors.deepPurple.shade300,
          borderRadius: BorderRadius.circular(28),
        ),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
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
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
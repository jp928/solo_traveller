import 'package:flutter/material.dart';

class InterestButton extends StatefulWidget {
  final List<int> interestIds;
  final double size;
  final Function onTap;
  final String text;
  final int index;

  const InterestButton({ Key? key, required this.interestIds, required this.size, required this.onTap, required this.text, required this.index})
      : super(key: key);

  @override
  _InterestButtonState createState() => _InterestButtonState();
}

class _InterestButtonState extends State<InterestButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(minWidth: 120, maxWidth: widget.size),
        height: 120,
        child: Center(
          child: Material(
              shape: CircleBorder(),
              color: widget.interestIds.contains(widget.index) ? Colors.blueAccent : Colors.white,
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                child: new Container(
                  width: widget.size,
                  height: widget.size,
                  child: Center(
                    child: Text(
                      widget.text,
                      style: TextStyle(
                          color: widget.interestIds.contains(widget.index)
                              ? Colors.white
                              : Colors.black54,
                          fontSize: 16),
                    ),
                  ),
                ),
                onTap: () {
                  widget.onTap();
                },
              )),
        ));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YearsPicker extends StatefulWidget {
  final Function(String) onChange;

  const YearsPicker({Key? key, required this.onChange}) : super(key: key);
  @override
  _YearsPickerWidgetState createState() => _YearsPickerWidgetState();
}

class _YearsPickerWidgetState extends State<YearsPicker> {
  Widget yearPicker() {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: 0),
      magnification: 1.1,
      // backgroundColor: beachRed[50],
      onSelectedItemChanged: (x) {
        setState(() {});
        // widget.onChange('$currentTimeInHour Hr $currentTimeInMin mins');
      },
      children: List.generate(
          100,
          (index) {
            return Center(
              child: Text(
                  (DateTime.now().year - 16 - index).toString()
              ),
            );
          }
      ),

      // style: TextStyle(color: Color(0xffF4F4F4)),
      itemExtent: 40,
    );
  }

  String currentTimeInHour = '';
  String currentTimeInMin = '';
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: Color(0xffF4F4F4)),
      //style: TextStyle(color: '#ffffff'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  'Select a year',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                )
            ),
            Container(
              //color: beachRed[50],
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Container(
                  //color: beachRed[50],
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: yearPicker()),
                        // Expanded(child: durationPicker(inMinutes: true)),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
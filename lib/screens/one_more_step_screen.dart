import 'package:flutter/material.dart';
import 'package:solo_traveller/widgets/round_gradient_button.dart';

class OneMoreStepScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF4F4F4),
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(74, 90, 247, 1), //change your color here
        ),
      ),
      backgroundColor: Color(0xffF4F4F4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: 720,
            // width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    // mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        constraints: BoxConstraints(minWidth: 120, maxWidth: MediaQuery.of(context).size.width * 0.5 - 48),
                        height: 120,
                        child: Center(
                          child: Material(
                            // elevation: 4.0,
                            shape: CircleBorder(),
                            clipBehavior: Clip.hardEdge,
                            color: Colors.blueAccent,
                            child: InkWell(
                              onTap: () {},
                            )
                          ),
                        )
                      ),
                      Container(
                        constraints: BoxConstraints(minWidth: 120, maxWidth: MediaQuery.of(context).size.width * 0.5 - 48),
                        height: 120,
                        child: Center(
                          child: Material(
                            // elevation: 4.0,
                            shape: CircleBorder(),
                            clipBehavior: Clip.hardEdge,
                            color: Colors.blueAccent,
                            child: InkWell(
                              onTap: () {},
                            )
                          ),
                        )
                      ),
                    ],
                  )
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        constraints: BoxConstraints(minWidth: 120, maxWidth: MediaQuery.of(context).size.width * 0.5 - 48),
                        height: 120,
                        child: Material(
                          // elevation: 4.0,
                          shape: CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          color: Colors.blueAccent,
                          child: InkWell(
                            onTap: () {},
                          )
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(minWidth: 120, maxWidth: MediaQuery.of(context).size.width * 0.5 - 48),
                        height: 120,
                        child: Material(
                          // elevation: 4.0,
                          shape: CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          color: Colors.blueAccent,
                          child: InkWell(
                            onTap: () {},
                          )
                        ),
                      ),
                    ],
                  )
                ),

                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      // mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          constraints: BoxConstraints(minWidth: 120, maxWidth: MediaQuery.of(context).size.width * 0.5 - 48),
                          height: 120,
                          child: Material(
                            // elevation: 4.0,
                            shape: CircleBorder(),
                            clipBehavior: Clip.hardEdge,
                            color: Colors.blueAccent,
                            child: InkWell(
                              onTap: () {},
                            )
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(minWidth: 120, maxWidth: MediaQuery.of(context).size.width * 0.5 - 48),
                          height: 120,
                          child: Material(
                            shape: CircleBorder(),
                            clipBehavior: Clip.hardEdge,
                            color: Colors.blueAccent,
                            child: InkWell(
                              onTap: () {},
                            )
                          ),
                        ),
                      ],
                    )
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    // mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        constraints: BoxConstraints(minWidth: 120, maxWidth: MediaQuery.of(context).size.width * 0.5 - 48),
                        height: 120,
                        child: Material(
                          // elevation: 4.0,
                            shape: CircleBorder(),
                            clipBehavior: Clip.hardEdge,
                            color: Colors.blueAccent,
                            child: InkWell(
                              onTap: () {},
                            )
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(minWidth: 120, maxWidth: MediaQuery.of(context).size.width * 0.5 - 48),
                        height: 120,
                        child: Material(
                          // elevation: 4.0,
                            shape: CircleBorder(),
                            clipBehavior: Clip.hardEdge,
                            color: Colors.blueAccent,
                            child: InkWell(
                              onTap: () {},
                            )
                        ),
                      ),
                    ],
                  )
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
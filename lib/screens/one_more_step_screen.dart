import 'package:flutter/material.dart';
import 'package:solo_traveller/widgets/interest_button.dart';
import 'package:solo_traveller/widgets/round_gradient_button.dart';

import 'moment_screen.dart';

class OneMoreStepScreen extends StatefulWidget {
  @override
  _OneMoreStepState createState() => _OneMoreStepState();
}

class _OneMoreStepState extends State<OneMoreStepScreen> {

  List<int> interestIds = [];

  List<String> interests = [
    'Exploring',
    'Sports',
    'Socialising',
    'Events',
    'Culture',
    'Foodie',
    'Shows',
    'Markets',
    'Festivals',
    'Workshops'
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemSize = screenWidth / 2 - 48;

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
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Expanded(
                child: GridView.count(
                  childAspectRatio: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  children:
                    interests.map((interest) {
                      var index = interests.indexOf(interest);
                      return InterestButton(
                          interestIds: interestIds,
                          text: interest,
                          index: index,
                          size: itemSize,
                          onTap: () {
                            setState(() {
                              interestIds.add(index);
                            });
                          }
                        );
                    }).toList()
                )
              ),

              // Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RoundedGradientButton(
                        transparent: true,
                        buttonText: 'Skip',
                        width: screenWidth * 0.4 - 48,
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new MomentScreen())
                          );
                        }),
                    RoundedGradientButton(
                      buttonText: 'Go !',
                      width: screenWidth * 0.6 - 48,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new MomentScreen())
                          );
                      },
                    ),
                  ],
                )
              )
            ],
          )
        ),
      ),
    );
  }
}

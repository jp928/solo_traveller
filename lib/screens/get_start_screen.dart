import 'package:flutter/material.dart';
import 'package:solo_traveller/widgets/round_gradient_button.dart';

class GetStartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: true,
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
            // height: 500,
            height: 600,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset('assets/images/icon.png'),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Text(
                      'Get started',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w400),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'Sign up for new account, enter your email and get started.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w400),
                    )),
                Expanded(
                    child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: new BorderSide(color: Color.fromRGBO(218, 218, 236, 1))
                            ),

                            focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Color.fromRGBO(79, 152, 248, 1))
                            ),
                            hintText: 'Email'
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: new BorderSide(color: Color.fromRGBO(218, 218, 236, 1))
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Color.fromRGBO(79, 152, 248, 1))
                            ),
                            hintText: 'Password',
                          ),
                          // scrollPadding: EdgeInsets.only(top: 100),
                        ),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: new BorderSide(color: Color.fromRGBO(218, 218, 236, 1))
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Color.fromRGBO(79, 152, 248, 1))
                            ),
                            hintText: 'Confirm password'),
                        ),

                        RoundedGradientButton(
                            buttonText: 'Register',
                            width: 300,
                            onPressed: () {

                        })
                      ],
                    ),
                ))
              ],
            ),
          )),
        ));
  }
}

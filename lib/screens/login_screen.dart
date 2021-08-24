import 'package:flutter/material.dart';
import 'package:solo_traveller/widgets/round_gradient_button.dart';

class LoginScreen extends StatelessWidget {
  final _loginForm = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
      body: SafeArea(
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
                child: Container(
                  // height: 500,
                  height: 800,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset('assets/images/icon.png'),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                          child: Text(
                            'Log in',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w400),
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Type in your email and password',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          )),
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Form(
                                key: _loginForm,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    TextFormField(
                                      controller: _emailController,
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          return 'Please enter you email.';
                                        }

                                        if (RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                            .hasMatch(text) ==
                                            false) {
                                          return 'Please enter a valid email.';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Color.fromRGBO(
                                                      218, 218, 236, 1))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Color.fromRGBO(
                                                      79, 152, 248, 1))),
                                          hintText: 'Email'),
                                      autocorrect: false,
                                    ),
                                    TextFormField(
                                      controller: _passwordController,
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          return 'Please enter a password.';
                                        }

                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Color.fromRGBO(
                                                    218, 218, 236, 1))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Color.fromRGBO(
                                                    79, 152, 248, 1))),
                                        hintText: 'Password',
                                      ),
                                      autocorrect: false,
                                      obscureText: true,
                                    ),
                                    RoundedGradientButton(
                                      buttonText: 'Log in',
                                      width: 300,
                                      onPressed: () {

                                      },
                                    ),
                                    Text('Can\'t login? Reset you password'),
                                    RoundedGradientButton(
                                      transparent: true,
                                      buttonText: 'Login with Facebook',
                                      width: 300,
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                new LoginScreen()));
                                      },
                                    ),
                                  ],
                                ),
                              )))
                    ],
                  ),
                ))),
      ),
    );
  }
}
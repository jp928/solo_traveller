import 'package:flutter/material.dart';
import 'package:solo_traveller/futures/register_future.dart';
import 'package:solo_traveller/widgets/round_gradient_button.dart';
import 'package:solo_traveller/screens/create_profile_screen.dart';

import 'login_screen.dart';

class GetStartScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _registerForm = GlobalKey<FormState>();

  void _register(context) async {
    final isValid = _registerForm.currentState!.validate();
    if (!isValid) {
      return;
    }

    bool result = false;
    try {
      result = await register(_emailController.text, _passwordController.text);
    } on Exception catch (e) {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Failed'),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ));
    }

    // If success
    if (result) {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new CreateProfileScreen()));
    }
  }

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
                          'Get started',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w400),
                        )),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Sign up for new account, enter your email and get started.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        )),
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Form(
                              key: _registerForm,
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
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    validator: (text) {
                                      if (text == null || text.isEmpty)
                                        return 'Please enter a password.';
                                      if (text !=
                                          _confirmPasswordController.text)
                                        return 'Confirm password has to match.';

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
                                        hintText: 'Confirm password'),
                                    autocorrect: false,
                                    obscureText: true,
                                  ),
                                  RoundedGradientButton(
                                    buttonText: 'Register',
                                    width: 300,
                                    onPressed: () => _register(context),
                                  ),
                                  Text('Already have an account?'),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0)),
                                        backgroundColor: Colors.transparent,
                                        textStyle: TextStyle(fontSize: 18)),
                                    // color: Colors.transparent,
                                    // shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.circular(18.0)),
                                    child: Text('Log In'),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  new LoginScreen()));
                                    },
                                  ),
                                  Text('Prefer to log in with Facebook?'),
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
        ));
  }
}

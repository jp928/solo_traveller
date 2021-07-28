import 'package:flutter/material.dart';
import 'package:solo_traveller/futures/register_future.dart';
import 'package:solo_traveller/widgets/round_gradient_button.dart';

class GetStartScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _registerForm = GlobalKey<FormState>();

  void _register(context) async {
    final isValid = _registerForm.currentState!.validate();
    if (!isValid) {
      return;
    }

    bool result = await register(_emailController.text, _passwordController.text);

    if (result) {
      Navigator.pop(context);
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
          child: SingleChildScrollView(
              child: Container(
            // height: 500,
            height: 720,
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
                    child: Form(
                      key: _registerForm,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          TextFormField(
                            controller: _emailController,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Please enter you email.';
                              }

                              if (RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(text) == false) {
                                return 'Please enter a valid email.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: new BorderSide(color: Color.fromRGBO(218, 218, 236, 1))
                                ),

                                focusedBorder: OutlineInputBorder(
                                    borderSide: new BorderSide(color: Color.fromRGBO(79, 152, 248, 1))
                                ),
                                hintText: 'Email'
                            ),
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
                                  borderSide: new BorderSide(color: Color.fromRGBO(218, 218, 236, 1))
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: new BorderSide(color: Color.fromRGBO(79, 152, 248, 1))
                              ),
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
                              if (text != _confirmPasswordController.text)
                                return 'Confirm password has to match.';

                              return null;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: new BorderSide(color: Color.fromRGBO(218, 218, 236, 1))
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: new BorderSide(color: Color.fromRGBO(79, 152, 248, 1))
                                ),
                                hintText: 'Confirm password'
                            ),
                            autocorrect: false,
                            obscureText: true,
                          ),

                          RoundedGradientButton(
                            buttonText: 'Register',
                            width: 300,
                            onPressed: () => _register(context),
                          ),
                        ],
                      ),
                    )
                ))
              ],
            ),
          )),
        ));
  }
}

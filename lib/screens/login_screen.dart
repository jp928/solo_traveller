import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:solo_traveller/futures/auth_future.dart';
import 'package:solo_traveller/futures/create_connecty_cube_session_with_facebook_future.dart';
import 'package:solo_traveller/futures/create_connectycube_session_future.dart';
import 'package:solo_traveller/futures/external_auth_future.dart';
import 'package:solo_traveller/futures/facebook_login_future.dart';
import 'package:solo_traveller/providers/my_cube_user.dart';
import 'package:solo_traveller/widgets/round_gradient_button.dart';

import 'moment_screen.dart';

class LoginScreen extends StatelessWidget {
  final _loginForm = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _loginWithFacebook(BuildContext context) async {
    Map<String, dynamic>? facebookUserData = await facebookLogin();

    bool result = false;
    if (facebookUserData != null) {
      String email = facebookUserData['email'];
      MyCubeUser cubeUser = context.read<MyCubeUser>();
      cubeUser.setEmail(email);
      cubeUser.setName(facebookUserData['name']);
      cubeUser.setProfileImage(facebookUserData['picture']['data']['url']);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        }
      );

      try {
        result = await externalAuth(email, facebookUserData['id']);
        await createConnectyCubeSessionWithFacebook(context, facebookUserData['accessToken']);
      } on Exception catch (e) {
        // Dismiss loading
        Navigator.pop(context);
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
          )
        );
      }

      // Dismiss loading
      Navigator.pop(context);

      if (result) {
        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                new MomentScreen()
            )
        );
      }
    }
  }

  void _login(BuildContext context) async {
    final isValid = _loginForm.currentState!.validate();
    if (!isValid) {
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator(),);
        }
    );

    bool result = false;
    try {
      var email = _emailController.text;
      MyCubeUser user = context.read<MyCubeUser>();
      user.setEmail(email);

      await createConnectyCubeSession(context, withSignUp: false);
      result = await auth(email, _passwordController.text);

    } on Exception catch (e) {
      Navigator.pop(context);
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
        )
      );
    }

    Navigator.pop(context);

    // If success
    if (result) {
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) =>
              new MomentScreen()
          )
      );
    }
  }

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
                                      keyboardType: TextInputType.emailAddress,
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
                                      onPressed: () => _login(context),
                                    ),
                                    Text('Can\'t login? Reset you password'),
                                    RoundedGradientButton(
                                      transparent: true,
                                      buttonText: 'Login with Facebook',
                                      width: 300,
                                      onPressed: () => _loginWithFacebook(context)
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
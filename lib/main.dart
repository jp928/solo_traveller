import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solo_traveller/providers/my_cube_session.dart';
import 'package:solo_traveller/providers/my_cube_user.dart';
import 'package:solo_traveller/screens/get_start_screen.dart';
import 'package:solo_traveller/screens/login_screen.dart';
import 'package:solo_traveller/widgets/round_gradient_button.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:connectivity/connectivity.dart';

void main() {
  // Init ConnectyCube
  init('802', 'xfa-UKcGfX3q3q9', 'Ev3jDG52EKBKPDv');
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MyCubeSession>(create: (_) => MyCubeSession()),
        ChangeNotifierProvider<MyCubeUser>(create: (_) => MyCubeUser()),
      ],
      child: App(),
    ),
  );
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> with WidgetsBindingObserver {
  late StreamSubscription<ConnectivityResult> connectivityStateSubscription;
  late AppLifecycleState appState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoloTraveller',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // backgroundColor: Color(0xffEFEFEF)
        // backgroundColor: Colors.red
        textSelectionTheme: TextSelectionThemeData(
            cursorColor:  Color.fromRGBO(79, 152, 248, 1)
        ),
      ),

      supportedLocales: [
        Locale('en'),
      ],
      localizationsDelegates: [
        CountryLocalizations.delegate,
      ],
      home: MyHomePage(title: 'Flutter Demo Home Page!'),
    );
  }

  @override
  void initState() {
    super.initState();

    // Firebase.initializeApp();

    init('802', 'xfa-UKcGfX3q3q9', 'Ev3jDG52EKBKPDv',
        onSessionRestore: () async {
          return createSession(context.read<MyCubeUser>().user);
        });

    connectivityStateSubscription =
        Connectivity().onConnectivityChanged.listen((connectivityType) {
          if (AppLifecycleState.resumed != appState) return;

          if (connectivityType != ConnectivityResult.none) {
            log("chatConnectionState = ${CubeChatConnection.instance.chatConnectionState}");
            bool isChatDisconnected =
                CubeChatConnection.instance.chatConnectionState ==
                    CubeChatConnectionState.Closed ||
                    CubeChatConnection.instance.chatConnectionState ==
                        CubeChatConnectionState.ForceClosed;

            if (isChatDisconnected &&
                CubeChatConnection.instance.currentUser != null) {
              CubeChatConnection.instance.relogin();
            }
          }
        });

    appState = WidgetsBinding.instance!.lifecycleState!;
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    connectivityStateSubscription.cancel();

    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appState = state;

    if (AppLifecycleState.paused == state) {
      if (CubeChatConnection.instance.isAuthenticated()) {
        CubeChatConnection.instance.logout();
      }
    } else if (AppLifecycleState.resumed == state) {
      CubeUser? user = context.read<MyCubeUser>().user;

      if (user != null && !CubeChatConnection.instance.isAuthenticated()) {
        CubeChatConnection.instance.login(user);
      }
    }
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;
  //
  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Color(0xffF4F4F4),
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 36),
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset('assets/images/walkthrough.png'),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  'Find and connect with people near you when you travel',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
                )
              ),
              Expanded(
                child:  Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RoundedGradientButton(
                      buttonText: 'Join',
                      width: 120,
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(builder: (context) => new GetStartScreen())
                        );
                      },
                    ),
                    RoundedGradientButton(
                      transparent: true,
                      buttonText: 'Login',
                      width: 120,
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(builder: (context) => new LoginScreen())
                        );
                      },
                    )
                  ],
                )
              )
            ],
          ),
        )
      ),
    );
  }
}

import 'package:connectycube_sdk/connectycube_calls.dart';
import 'package:connectycube_sdk/connectycube_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:solo_traveller/providers/my_cube_user.dart';

import 'chat_dialog_screen.dart';

class MyChatsScreen extends StatefulWidget {
  @override
  _MyChatsScreenState createState() => _MyChatsScreenState();
}

class _MyChatsScreenState extends State<MyChatsScreen> {
  CubeUser? currentUser;
  var dialogList = <CubeDialog>[];
  var loading = false;

  @override
  initState() {
    currentUser = context.read<MyCubeUser>().user;
    super.initState();
    _retrieveDialogs();
  }

  Future<void> _retrieveDialogs() async {
    setState(() {
      loading = true;
    });

    var dialogs;
    try {
      dialogs = await getDialogs();
    } on Exception catch (e) {
      showDialog(
        context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Failed'),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ));
    }

    if (loading && dialogs != null) {
      setState(() {
        loading = false;
        dialogList.clear();
        // dialogList = dialogs;
        dialogList.addAll(dialogs.items);
        // dialogList = dialogs.cast<CubeDialog>();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(false);
        },
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: Color(0xffF4F4F4),
              shadowColor: Colors.transparent,
              iconTheme: IconThemeData(
                color: Color.fromRGBO(74, 90, 247, 1), //change your color here
              ),
            ),
            backgroundColor: Color(0xffF4F4F4),
            body: SafeArea(
                top: false,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      children: [
                        Container(
                          child: Visibility(
                            maintainSize: false,
                            maintainAnimation: false,
                            maintainState: false,
                            visible: loading,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        Expanded(
                          child: RefreshIndicator(
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                CubeDialog _dialog = dialogList[index];

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatDialogScreen(currentUser!, _dialog),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      children: [
                                        Text(_dialog.name ?? ''),
                                      ],
                                    ),
                                  )
                                );
                              },
                              separatorBuilder: (context, index) => Divider(
                                height: 0.5,
                                thickness: 0.5,
                                indent: 0,
                                endIndent: 0,
                              ),
                              itemCount: dialogList.length,
                            ),
                            onRefresh: () async {
                              await _retrieveDialogs();
                            },
                          )
                        )
                      ],
                    ),

                ))));
  }
}

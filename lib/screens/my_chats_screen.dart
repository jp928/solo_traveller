import 'package:connectycube_sdk/connectycube_calls.dart';
import 'package:connectycube_sdk/connectycube_chat.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:solo_traveller/providers/my_cube_user.dart';
import 'package:solo_traveller/widgets/avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'chat_dialog_screen.dart';

class MyChatsScreen extends StatefulWidget {
  @override
  _MyChatsScreenState createState() => _MyChatsScreenState();
}

class _MyChatsScreenState extends State<MyChatsScreen> {
  CubeUser? currentUser;
  var dialogList = <Map<String, dynamic>>[];
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

    MyCubeUser user = context.read<MyCubeUser>();
    int? myCubeUserId = user.user?.id;


    var futureList = dialogs.items.map<Future<Map<String, dynamic>>>((item) async {
      CubeUser? participant = await _getParticipant(item, myCubeUserId);
      String short = timeago.format(item.updatedAt, locale: 'en_short');
      String? lastUpdate =  item.updatedAt == null
        ?
        null
        :
      (short == 'now' ) ? short : '$short ago';

      return {
        'dialog': item,
        'avatar': getPrivateUrlForUid(participant?.avatar),
        'participantName': participant?.fullName,
        'lastMessage': item.lastMessage,
        'lastUpdate': lastUpdate
      };
    }).toList();

    List<Map<String, dynamic>> _dialogList = await Future.wait(futureList);
    if (loading && dialogs != null) {
      setState(() {
        loading = false;
        dialogList.clear();
        dialogList.addAll(_dialogList);
      });
    }
  }

  Future<CubeUser?> _getParticipant(CubeDialog dialog, int? myCubeUserId) async {
    List<int> participants = dialog.occupantsIds!;
    participants.remove(myCubeUserId);
    return getUserById(participants.first);
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
                                var item = dialogList[index];
                                CubeDialog _dialog = item['dialog'];
                                // log(_dialog.photo);
                                log(_dialog.toString());


                                return GestureDetector(
                                  onTap: () {
                                    log('-------------------------------------');
                                    log(currentUser!.id!.toString());
                                    print(_dialog.occupantsIds);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatDialogScreen(currentUser!, _dialog),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: ListTile(
                                      leading: Avatar(image: item['avatar']),
                                      title: Text(item['participantName'] ?? ''),
                                      subtitle: Text(item['lastMessage'] ?? '', style: TextStyle(color: Color(0xff4A4A4A), fontSize: 10),),
                                      trailing: Text(item['lastUpdate'] ?? '')
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

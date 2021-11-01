import 'package:flutter/material.dart';
import 'package:solo_traveller/widgets/moment_list.dart';
import 'package:solo_traveller/widgets/people_near_me_list.dart';
import 'my_drawer.dart';

class MomentScreen extends StatefulWidget {
  @override
  _MomentScreenState createState() => _MomentScreenState();
}

class _MomentScreenState extends State<MomentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List tabs = ['#ALL MOMENTS', '#ALL PEOPLE'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);

    // Dismiss keyboard
    _tabController.addListener(() {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
                backgroundColor: Color(0xffF4F4F4),
                shadowColor: Colors.transparent,
                iconTheme: IconThemeData(
                  color:
                      Color.fromRGBO(74, 90, 247, 1), //change your color here
                ),
                leading: Builder(builder: (context) {
                  return IconButton(
                    icon: Icon(Icons.dehaze_sharp, color: Colors.black54),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                }),
                bottom: TabBar(
                  controller: _tabController,
                  tabs: tabs.map((e) => Tab(text: e)).toList(),
                  labelColor: Colors.black54,
                )),
            drawer: new MyDrawer(),
            backgroundColor: Color(0xffF4F4F4),
            body: TabBarView(
              controller: _tabController,
              children: tabs.map((e) {
                if (e == tabs[0]) {
                  return MomentList();
                }

                return PeopleNearMeList();
              }).toList(),
            )));
  }
}

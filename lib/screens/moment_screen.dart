import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:solo_traveller/futures/register_future.dart';
import 'package:solo_traveller/providers/my_cube_user.dart';
import 'package:solo_traveller/widgets/round_gradient_button.dart';
import 'package:solo_traveller/screens/create_profile_screen.dart';

import 'login_screen.dart';
import 'my_drawer.dart';

class MomentScreen extends StatefulWidget {
  @override
  _MomentScreenState createState() => _MomentScreenState();
}

class _MomentScreenState extends State<MomentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController; //需要定义一个Controller
  List tabs = ['#ALL MOMENTS', '#ALL PEOPLE'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
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

        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.dehaze_sharp, color: Colors.black54), //自定义图标
            onPressed: () {
              // 打开抽屉菜单
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs.map((e) => Tab(text: e)).toList(),
          labelColor: Colors.black54,
        )
      ),
      drawer: new MyDrawer(),
      backgroundColor: Color(0xffF4F4F4),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((e) {
          return Container(
            alignment: Alignment.center,
            child: Text(e, textScaleFactor: 5),
          );
        }).toList(),
      )
    );
  }
}

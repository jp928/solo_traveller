import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:solo_traveller/futures/get_posts_future.dart';
import 'package:solo_traveller/models/post.dart';
import 'package:solo_traveller/widgets/post_item.dart';

import 'my_drawer.dart';

class MomentScreen extends StatefulWidget {
  @override
  _MomentScreenState createState() => _MomentScreenState();
}

class _MomentScreenState extends State<MomentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List tabs = ['#ALL MOMENTS', '#ALL PEOPLE'];

  var _posts = <Post>[];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);

    log("here");

    setState(() {
      loading = true;
    });
    // Retrieve first
    _retrievePosts(1);
  }

  void _retrievePosts(int pageNum) async {
    var _newPosts = await getPosts(pageNum: pageNum);
    setState(() {
      log(_newPosts[1].toString());
      _posts.insertAll(_posts.length, _newPosts);

      if (pageNum == 1 && loading) {
        loading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          return Stack(
            children: <Widget>[
              SafeArea(
                top: false,
                child: Container(
                  alignment: Alignment.center,
                  child: Column(children: <Widget>[
                    Expanded(
                      child: _posts.length == 0 ?
                      Center(
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 32)),
                            loading ?
                            new CircularProgressIndicator()
                                :
                            IconButton(
                              icon: const Icon(Icons.refresh_outlined),
                              tooltip: 'Refresh',
                              onPressed: () {
                                _retrievePosts(1);
                              },
                            )
                          ],
                        ),
                      ) :
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: _posts.length,
                        itemBuilder: (context, index) {

                          if (index == _posts.length - 1) {
                            int pageNum = (_posts.length / 20).ceil() + 1;
                            _retrievePosts(pageNum);
                          }

                          return PostItem(post: _posts[index]);
                        },
                        separatorBuilder: (context, index) => Divider(height: .0),
                      ),
                    ),
                  ]),
                )
              ),

              Align(
                alignment: Alignment.bottomLeft,
                child: SafeArea(
                  top: false,
                  child: Container(
                    padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
                    height: 60,
                    width: double.infinity,
                    color: Color(0xffF4F4F4),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(Icons.add, color: Colors.white, size: 20, ),
                          ),
                        ),
                        SizedBox(width: 15,),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "Write message...",
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        SizedBox(width: 15,),
                        FloatingActionButton(
                          onPressed: (){},
                          child: Icon(Icons.send,color: Colors.white,size: 18,),
                          backgroundColor: Colors.blue,
                          elevation: 0,
                        ),
                      ],

                    ),
                  ),
                )
              ),
            ],
          );
        }).toList(),
      )
    );
  }
}

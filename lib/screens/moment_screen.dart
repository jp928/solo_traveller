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
          return Container(
            alignment: Alignment.center,
            child: Column(children: <Widget>[
              // ListTile(title:Text('Moment')),
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
                )
                :
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    //如果到了表尾
                    if (index == _posts.length - 1) {
                      int pageNum = (_posts.length / 20).ceil() + 1;
                      _retrievePosts(pageNum);
                      // if (_posts.length - 1 < 20) {
                      //   //获取数据
                      //   _retrieveData();
                      //   //加载时显示loading
                      //   return Container(
                      //     padding: const EdgeInsets.all(16.0),
                      //     alignment: Alignment.center,
                      //     child: SizedBox(
                      //         width: 24.0,
                      //         height: 24.0,
                      //         child: CircularProgressIndicator(strokeWidth: 2.0)
                      //     ),
                      //   );
                      // } else {
                      //   //已经加载了100条数据，不再获取数据。
                      //   return Container(
                      //       alignment: Alignment.center,
                      //       padding: EdgeInsets.all(16.0),
                      //       child: Text("没有更多了", style: TextStyle(color: Colors.grey),)
                      //   );
                      // }
                    }
                    //显示单词列表项
                    return PostItem(post: _posts[index]);
                  },
                  separatorBuilder: (context, index) => Divider(height: .0),
                ),
              )
                ,
            ]),
          );
        }).toList(),
      )
    );
  }
}

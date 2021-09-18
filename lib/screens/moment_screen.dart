import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solo_traveller/futures/get_posts_future.dart';
import 'package:solo_traveller/futures/upload_moment_image_future.dart';
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
  final TextEditingController _postTextController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  var _posts = <Post>[];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);

    setState(() {
      loading = true;
    });
    // Retrieve first
    _retrievePosts(1, isRefresh: true);
  }

  Future<void> _retrievePosts(int pageNum, { bool isRefresh = false }) async {
    var _newPosts = await getPosts(pageNum: pageNum);
    setState(() {
      if (isRefresh) {
        _posts = _newPosts;
      } else {
        _posts.insertAll(_posts.length, _newPosts);
      }

      if (pageNum == 1 && loading) {
        loading = false;
      }
    });
  }

  void _createPost() async {
    bool _createPostSuccess = false;
    if (_image != null) {
      var body = _postTextController.text;
      try {
        _createPostSuccess = await uploadMomentImage(File(_image!.path), body);
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
          )
        );
      }

      if (_createPostSuccess) {
        _retrievePosts(1, isRefresh: true);
      }
    }
  }

  _imgFromCamera() async {
    XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      // imageQuality: 50,
      maxHeight: 200,
      maxWidth: 200,
    );

    setState(() {
      _image = image!;
    });
  }

  _imgFromGallery() async {
    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      // imageQuality: 50,
      maxHeight: 200,
      maxWidth: 200,
    );

    setState(() {
      _image = image!;
    });
  }

  void _showImagePicker (context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
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
                                _retrievePosts(1, isRefresh: true);
                              },
                            )
                          ],
                        ),
                      ) :

                      RefreshIndicator(
                        child: ListView.separated(
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
                          physics: const AlwaysScrollableScrollPhysics(),
                        ),

                        onRefresh:  () async {
                          await _retrievePosts(1, isRefresh: true);
                        },

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
                    padding: EdgeInsets.only(left: 10,bottom: 10,top: 10,right: 10),
                    height: 60,
                    width: double.infinity,
                    color: Color(0xffF4F4F4),
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 8,),
                        Expanded(
                          child: TextField(
                            controller: _postTextController,
                            maxLines: 15,
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Type a message',
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(width: 8,),
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.lightBlue,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.photo_library_outlined),
                            color: Colors.grey,
                            onPressed: () {
                              _showImagePicker(context);
                            },
                          ),
                        ),
                        SizedBox(width: 8,),
                        FloatingActionButton(
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.zero,
                            side: BorderSide(
                              color: Colors.grey,
                              width: 1
                            )
                          ),
                          backgroundColor: Colors.transparent,
                          onPressed: () {
                            _createPost();
                          },
                          child: Text(
                            'Send',
                            style: TextStyle(color: Colors.grey),
                          ),
                          // child: TextButton(
                          //   child: Text('Send'),
                          //   style: TextButton.styleFrom(
                          //     primary: Colors.grey,
                          //     // backgroundColor: Colors.teal,
                          //     onSurface: Colors.grey,
                          //   ),
                          //
                          // ),
                          // backgroundColor: Colors.blue,
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

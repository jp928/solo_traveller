import 'dart:io';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:solo_traveller/futures/create_post_future.dart';
import 'package:solo_traveller/futures/get_posts_future.dart';
import 'package:solo_traveller/futures/upload_moment_image_future.dart';
import 'package:solo_traveller/models/post.dart';
import 'package:solo_traveller/widgets/image_text.dart';
import 'package:solo_traveller/widgets/post_item.dart';

import 'my_special_text_span_builder.dart';

class MomentList extends StatefulWidget {
  @override
  _MomentListState createState() => _MomentListState();
}

class _MomentListState extends State<MomentList> {
  final TextEditingController _postTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  var _posts = <Post>[];
  bool loading = false;
  bool loadingMore = false;

  double _offset = 0;
  final String inserted = "${ImageText.flag}/>";

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading &&
          !loadingMore) {
        setState(() {
          loadingMore = true;
        });

        int pageNum = (_posts.length / 20).ceil() + 1;
        _retrievePosts(pageNum);
      }
    });

    // Retrieve first
    _retrievePosts(1, isRefresh: true);
  }

  void _insertImageInTextField() {
    String text = _postTextController.text;
    if (text.contains(this.inserted)) {
      text = text.replaceRange(0, this.inserted.length, '');
    }
    
    final newText = "${this.inserted}$text";
    _postTextController.value = TextEditingValue(
      text: newText
    );
  }

  Future<void> _retrievePosts(int pageNum, {bool isRefresh = false}) async {
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

      if (loadingMore == true) {
        loadingMore = false;
      }
    });
  }

  void _createPost() async {
    bool _createPostSuccess = false;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        });

    String body = _postTextController.text;
    if (body.contains(this.inserted)) {
      body = body.replaceRange(0, this.inserted.length, '');
    }

    try {
      if (_image != null) {
        _createPostSuccess = await uploadMomentImage(File(_image!.path), body);
      } else {
        _createPostSuccess = await createPost(body, null, null, null, null);
      }
    } on Exception catch (e) {
      await showDialog<String>(
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
              ));
    } finally {
      // Dismiss loading
      Navigator.pop(context);
    }

    if (_createPostSuccess) {
      _retrievePosts(1, isRefresh: true);
    }
  }

  _imgFromCamera() async {
    XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 512,
      maxHeight: 512,
    );

    setState(() {
      _image = image!;
      _insertImageInTextField();
    });
  }

  _imgFromGallery() async {
    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
    );

    setState(() {
      _image = image!;
      _insertImageInTextField();
    });
    
    Navigator.of(context).pop();
  }

  void _showImagePicker(context) {
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
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SafeArea(
            top: false,
            child: Container(
              alignment: Alignment.center,
              child: Column(children: <Widget>[
                Expanded(
                  child: _posts.length == 0
                      ? Center(
                          child: Column(
                            children: [
                              Padding(padding: EdgeInsets.only(top: 32)),
                              loading
                                  ? new CircularProgressIndicator()
                                  : IconButton(
                                      icon: const Icon(Icons.refresh_outlined),
                                      tooltip: 'Refresh',
                                      onPressed: () {
                                        _retrievePosts(1, isRefresh: true);
                                      },
                                    )
                            ],
                          ),
                        )
                      : new NotificationListener(
                          child: RefreshIndicator(
                            child: ListView.separated(
                              key: PageStorageKey('post'),
                              physics: ClampingScrollPhysics(),
                              controller: _scrollController,
                              shrinkWrap: true,
                              itemCount: _posts.length,
                              itemBuilder: (context, index) {
                                if (_offset > 0 && loadingMore == true) {
                                  _scrollController.jumpTo(_offset);
                                }
                                return PostItem(post: _posts[index]);
                              },
                              separatorBuilder: (context, index) =>
                                  Divider(height: .0),
                            ),
                            onRefresh: () async {
                              await _retrievePosts(1, isRefresh: true);
                            },
                          ),
                          onNotification: (t) {
                            if (t is ScrollEndNotification) {
                              _offset = _scrollController.position.pixels;
                              print(_scrollController.position.pixels);
                            }

                            return true;
                          },
                        ),
                ),
              ]),
            )),
        Align(
            alignment: Alignment.bottomLeft,
            child: SafeArea(
              top: false,
              child: ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: 60,
                    maxHeight: 120,
                  ),
                  child: Container(
                    padding:
                    EdgeInsets.only(left: 10, right: 10),
                    width: double.infinity,
                    color: Color(0xffF4F4F4),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child:
                          // TextField(
                          //   controller: _postTextController,
                          //   maxLines: 15,
                          //   style: TextStyle(
                          //     fontSize: 14.0,
                          //   ),
                          //   decoration: InputDecoration(
                          //     hintText: 'Type a message',
                          //     hintStyle: TextStyle(color: Colors.black54),
                          //     border: InputBorder.none,
                          //   ),
                          // ),
                          ExtendedTextField(
                            expands: true,
                            specialTextSpanBuilder: MySpecialTextSpanBuilder(_image == null ? null : File(_image!.path)),
                            controller: _postTextController,
                            // selectionControls: _myExtendedMaterialTextSelectionControls,
                            maxLines: null,
                            decoration: InputDecoration(
                              // border: OutlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(74, 90, 247, 1), width: 1)),
                              border: InputBorder.none,
                            ),

                            // focusNode: _focusNode,
                            // decoration: InputDecoration(
                            //     suffixIcon: GestureDetector(
                            //       onTap: () {
                            //         setState(() {
                            //           sessions.insert(0, _textEditingController.text);
                            //           _textEditingController.value =
                            //               _textEditingController.value.copyWith(
                            //                   text: '',
                            //                   selection:
                            //                       const TextSelection.collapsed(offset: 0),
                            //                   composing: TextRange.empty);
                            //         });
                            //       },
                            //       child: const Icon(Icons.send),
                            //     ),
                            //     contentPadding: const EdgeInsets.all(12.0)
                            //   ),
                            //textDirection: TextDirection.rtl,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
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
                        SizedBox(
                          width: 8,
                        ),
                        FloatingActionButton(
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.zero,
                              side: BorderSide(color: Colors.grey, width: 1)),
                          backgroundColor: Colors.transparent,
                          onPressed: () {
                            _createPost();
                          },
                          child: Text(
                            'Send',
                            style: TextStyle(color: Colors.grey),
                          ),
                          elevation: 0,
                        ),
                      ],
                    ),
                ),
              ),
            )),
      ],
    );
  }
}

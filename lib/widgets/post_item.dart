import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:solo_traveller/models/post.dart';

class PostItem extends StatelessWidget {
  final Post post;

  PostItem({ required this.post });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0, top: 10),
      child: ListTile(
        onTap: () {
          FocusScope.of(context).unfocus();
          // print(news.web_link);
          // Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailsPage(news)));
        },
        title: Container(
          margin: EdgeInsets.only(left: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              post.profileImage == null ?
                Icon(
                  Icons.camera_alt_outlined,
                  size: 40,
                  color: Colors.grey[800],
                )
                :
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    post.profileImage!
                  )
                ),
              Padding(padding: EdgeInsets.only(left: 10)),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        post.fullName,
                        style: TextStyle(fontSize: 12.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(post.created),
                        style: TextStyle(fontSize: 8, color: Colors.grey)
                      )
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    // padding: const EdgeInsets.only(bottom: 20.0),
                    child: new Text(
                      post.body ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        subtitle: post.imageUrl == null ? null : Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Image(
            fit: BoxFit.fitWidth,
            width: MediaQuery.of(context).size.width - 64,
            image: NetworkImage(
                post.imageUrl!
            ),
          ),
        ),
      ),
    );
  }
}
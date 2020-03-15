import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/pages/post_screen.dart';
import 'package:fluttershare/pages/profile.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  getActivityFeed() async {
    QuerySnapshot snapshot = await activityFeedRef
        .document(currentUser.id)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .getDocuments();
    List<ActivityFeedItem> feedItems = [];
    snapshot.documents.forEach((doc) {
     feedItems.add(ActivityFeedItem.fromdocument(doc));
    });

    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: header(context, titleText: 'Activity Feed'),
      body: Container(
        child: FutureBuilder(
          future: getActivityFeed(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return circularProgress();
            }
            return ListView(
              children: snapshot.data,
            );
          },
        ),
      ),
    );
  }
}

Widget mediaPreview;
String activityItemText;

class ActivityFeedItem extends StatelessWidget {
  final String userId;
  final String username;
  final String type;
  final String userProfileImg;
  final String mediaUrl;
  final String postId;
  final String commentData;
  final Timestamp timestamp;

  ActivityFeedItem(
      {this.userId,
      this.username,
      this.type,
      this.userProfileImg,
      this.mediaUrl,
      this.postId,
      this.commentData,
      this.timestamp});

  factory ActivityFeedItem.fromdocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
      userId: doc['userId'],
      username: doc['username'],
      type: doc['type'],
      userProfileImg: doc['userProfileImg'],
      mediaUrl: doc['mediaUrl'],
      postId: doc['postId'],
      commentData: doc['commentData'],
      timestamp: doc['timestamp'],
    );
  }


  showPost(context){

    Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen(postId: postId,userId: userId,)));


  }



  configureMediaPreview(context) {




    if (type == 'like' || type == 'comment') {
      mediaPreview = GestureDetector(
        onTap: () {},
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(mediaUrl),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = Text('');
    }
    if (type == 'like') {
      activityItemText = 'Is Liked your Post';
    } else if (type == 'follow') {
      activityItemText = 'is Follow You';
    } else if (type == 'comment') {
      activityItemText = 'replied : $commentData';
    } else {
      activityItemText = "Error: Unknown Type '$type";
    }
  }



  @override
  Widget build(BuildContext context) {

configureMediaPreview(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white,
        child: ListTile(
          title: GestureDetector(
            onTap: ()=>showProfile(context, profileId: userId),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: username,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '$activityItemText',
                  ),
                ],
              ),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userProfileImg),
          ),
          subtitle: Text(
            timeago.format(
              timestamp.toDate(),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}


showProfile(BuildContext context, {String profileId}){
  Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile(profileId: profileId,)));
}
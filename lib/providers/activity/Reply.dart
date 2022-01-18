import 'dart:math';

import 'package:flutter/material.dart';

// provider
import 'package:today_dinner/providers/home.dart';
import 'package:today_dinner/providers/data/Feed.dart';
import 'package:today_dinner/providers/data/Freetalk.dart';
import 'package:today_dinner/providers/data/Recipe.dart';

// firebase database => firestore
import 'package:cloud_firestore/cloud_firestore.dart';
// firebase storage
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// provider listener 이용
import 'package:flutter/foundation.dart';
// firebase auth
import 'package:firebase_auth/firebase_auth.dart';
import 'package:today_dinner/screens/Home/index.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class Reply with ChangeNotifier {
  int selected_index = 0;

  // feed랑 freetalk에 사용
  void select_index(index) {
    selected_index = index;
  }

  String reply = "";

  // 댓글 작성 입력
  void setReply(value) {
    reply = value;
  }

  int Error = 0; // Error state => 1일 때 Error 발생
  String AlertTitle = ""; // Alert 제목
  String AlertContent = ""; // Alert 내용

  // 글쓰기 완료
  void replyComplete(doc_id, user, auth, context, top_index) async {
    // init
    Error = 0;
    AlertTitle = "";
    AlertContent = "";

    // 예외처리
    if (reply == "") {
      Error = 1;
      AlertTitle = "댓글 작성 에러";
      AlertContent = "댓글을 작성해주세요.";
      return;
    }

    // init
    var rand = new Random().nextInt(100000000);

    var parameter = {
      'content': reply,
      'createdAt': FieldValue.serverTimestamp(),
      'nickname': user['nickname'],
      'profileimage': user['profileimage'],
      'user': user['email'],
    };

    //데이터베이스 저장
    // Feed
    if (top_index == 1) {
      context.Feed().create_data(Parameter: parameter);
    }

    // Freetalk
    if (top_index == 2) {
      context.Freetalk().create_data(Parameter: parameter);
    }

    // Recipe
    if (top_index == 3) {
      context.Recipe().create_data(Parameter: parameter);
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("댓글쓰기 완료"),
            content: new Text("댓글 쓰기가 완료되었습니다."),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text("닫기"),
              ),
            ],
          );
        });
  }
}

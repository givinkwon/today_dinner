import 'package:flutter/material.dart';
// firebase database => firestore
import 'package:cloud_firestore/cloud_firestore.dart';
// firebase storage
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// provider listener 이용
import 'package:flutter/foundation.dart';

import 'package:today_dinner/screens/Home/index.dart';
import 'package:today_dinner/screens/Login/index.dart';

// firebase auth
import 'package:firebase_auth/firebase_auth.dart';

//
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class FindPassword with ChangeNotifier {
  String Email = "";

  // 이메일 입력
  void setEmail(value) {
    Email = value;
  }

  // 비밀번호 리셋 이메일 발송
  Future<void> resetPassword(context) async {
    await _firebaseAuth.sendPasswordResetEmail(email: Email);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("비밀번호 찾기"),
            content: new Text("비밀번호 재설정 이메일을 보냈습니다."),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginIndexPage()),
                  );
                },
                child: new Text("닫기"),
              ),
            ],
          );
        });
  }
}

import 'package:flutter/material.dart';

// provider listener 이용
import 'package:flutter/foundation.dart';

// firebase auth
import 'package:firebase_auth/firebase_auth.dart';
import 'package:today_dinner/repo/User.dart';

import 'package:today_dinner/screens/Login/login.dart';
import 'package:today_dinner/screens/Video/index.dart';

class LoginViewModel with ChangeNotifier {
  late var _UserRepo = UserRepo();
  var Data = [];

  // 생성자
  LoginViewModel() {
    _UserRepo = UserRepo();
  }

  // data 호출
  Future<void> load_data({String? email = ""}) async {
    Data = [];
    await _UserRepo.get_data(Email: email);
    Data = _UserRepo.Data;

    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // data 호출
  Future<void> create_data(email) async {
    Data = [];
    await _UserRepo.get_data(Email: email);
    Data = _UserRepo.Data;

    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  String Email = "";

  // 이메일 입력
  void setEmail(value) {
    Email = value;
  }

  String Password = "";

  // 비밀번호 입력
  void setPassword(value) {
    Password = value;
  }

  int Error = 0; // Error state => 1일 때 Error 발생
  String AlertTitle = ""; // Alert 제목
  String AlertContent = ""; // Alert 내용
  int EmailCheckState = 0; // email check가 완료되면 1

  int isUser = 0; // 0이면 user가 없는 것, 1이면 user가 있는 것

  // 로그인
  Future<dynamic> login(context) async {
    // init
    isUser = 0;
    Error = 0;
    AlertTitle = "";
    AlertContent = "";

    // 예외처리
    if (Email == "") {
      Error = 1;
      AlertTitle = "로그인 에러";
      AlertContent = "이메일을 입력해주세요.";
      return;
    }
    if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(Email.toString())) {
      Error = 1;
      AlertTitle = "로그인 에러";
      AlertContent = "이메일 형식을 확인해주세요.";
      return;
    }
    if (Password == "") {
      Error = 1;
      AlertTitle = "로그인 에러";
      AlertContent = "비밀번호를 입력해주세요.";
      return;
    }

    // 로그인하기
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: Email,
            password: Password,
          )
          .then((_) => {
                // 페이지 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VideoScreen()),
                )
              });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("로그인 에러"),
                content: new Text("없는 계정입니다."),
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
      } else if (e.code == 'wrong-password') {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("로그인 에러"),
                content: new Text("비밀번호가 틀립니다."),
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
  }

  // 비밀번호 리셋 이메일 발송
  Future<void> resetPassword(context) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: Email);

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
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: new Text("닫기"),
              ),
            ],
          );
        });
  }

  // 준비중입니다.
  Future<void> Alert(context, title,
      {String content1 = "", String content2 = "", String close = "확인"}) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scaffold(
            body: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                width: MediaQuery.of(context).size.width * 0.911,
                height: 190,
                child: Column(children: [
                  // title
                  Container(
                    margin: EdgeInsets.only(top: 32, bottom: 16),
                    child: Text(title,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),

                  // content
                  Container(
                    margin: EdgeInsets.only(bottom: 6),
                    child: Text(
                      content1,
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(129, 128, 128, 1)),
                    ),
                  ),

                  // content
                  Container(
                    child: Text(
                      content2,
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(129, 128, 128, 1)),
                    ),
                  ),

                  // button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 28),
                      child: Text(
                        close,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          );
        });
  }
}

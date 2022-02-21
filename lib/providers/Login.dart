import 'package:flutter/material.dart';

// provider listener 이용
import 'package:flutter/foundation.dart';

// firebase auth
import 'package:firebase_auth/firebase_auth.dart';
import 'package:today_dinner/repo/User.dart';

import 'package:today_dinner/screens/Login/login.dart';
import 'package:today_dinner/screens/Recipe/index.dart';
import 'package:today_dinner/screens/Video/index.dart';

class LoginViewModel with ChangeNotifier {
  late var _UserRepo = UserRepo();
  var Data = [];

  // 생성자
  LoginViewModel() {
    _UserRepo = UserRepo();
  }

  // data 호출
  Future<void> load_data({String? phone = "", String? email = ""}) async {
    Data = [];
    await _UserRepo.get_data(Email: email, Phone: phone);
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

  String Phone = "";

  // 아이디 찾기 => 전화번호 입력
  void setPhone(value) {
    Phone = value;
  }

  int Error = 0; // Error state => 1일 때 Error 발생
  String AlertTitle = ""; // Alert 제목
  String AlertContent = ""; // Alert 내용

  // 로그인
  Future<dynamic> login(context) async {
    // init
    Error = 0;

    // 예외처리
    if (Email == "") {
      Error = 1;
      AlertTitle = "로그인 에러";
      AlertContent = "이메일을 입력해주세요.";
    } else if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(Email.toString())) {
      Error = 1;
      AlertTitle = "로그인 에러";
      AlertContent = "이메일 형식을 확인해주세요.";
    } else if (Password == "") {
      Error = 1;
      AlertTitle = "로그인 에러";
      AlertContent = "비밀번호를 입력해주세요.";
    }

    // error가 있으면
    if (Error == 1) {
      Alert(context, AlertTitle, content1: AlertContent);
    } else {
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
                    MaterialPageRoute(builder: (context) => RecipeScreen()),
                  )
                });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          AlertTitle = "로그인 에러";
          AlertContent = "없는 계정입니다.";
          Alert(context, AlertTitle, content1: AlertContent);
        } else if (e.code == 'wrong-password') {
          AlertTitle = "로그인 에러";
          AlertContent = "비밀번호가 틀렸습니다.";
          Alert(context, AlertTitle, content1: AlertContent);
        }
      }
    }
  }

  // 아이디 찾기
  Future<dynamic> FindId(context) async {
    // 기 회원가입이 있는 경우 에러 발생
    await load_data(phone: Phone);

    if (Phone == "") {
      AlertTitle = "아이디 찾기";
      AlertContent = "휴대폰을 입력해주세요.";
      Alert(context, AlertTitle, content1: AlertContent);
    }

    // 예외처리
    else if (Data.length > 0) {
      print(Data);
      AlertTitle = "아이디 찾기";
      AlertContent = "회원님의 아이디는 ${_UserRepo.Data[0]['email']}입니다.";
      Alert(context, AlertTitle, content1: AlertContent);
    } else {
      AlertTitle = "아이디 찾기";
      AlertContent = "해당 번호로 가입한 아이디가 없습니다.";
      Alert(context, AlertTitle, content1: AlertContent);
    }

    // 이전으로 돌아가기
    Navigator.pop(context);
  }

  // 비밀번호 리셋 이메일 발송
  Future<void> resetPassword(context) async {
    // 기 회원가입이 있는 경우 에러 발생
    await load_data(phone: Phone);

    // 예외 처리
    if (Phone == "") {
      AlertTitle = "비밀번호 찾기";
      AlertContent = "휴대폰을 입력해주세요.";
      Alert(context, AlertTitle, content1: AlertContent);
    } else if (Email == "") {
      AlertTitle = "비밀번호 찾기";
      AlertContent = "이메일을 입력해주세요.";
      Alert(context, AlertTitle, content1: AlertContent);
    }

    // data가 있을 때
    else if (Data.length > 0) {
      // 이메일과 비밀번호가 다른 경우 에러 처리
      if (Data[0]['email'] != Email) {
        AlertTitle = "비밀번호 찾기";
        AlertContent = "가입 이메일과 전화번호가 다릅니다.";
        Alert(context, AlertTitle, content1: AlertContent);
      } else {
        // 비밀번호 리셋 이메일 보내기
        await FirebaseAuth.instance.sendPasswordResetEmail(email: Email);

        // 알람 띄우기
        AlertTitle = "비밀번호 찾기";
        AlertContent = "비밀번호 재설정 이메일을 보냈습니다.";
        Alert(context, AlertTitle, content1: AlertContent);
      }
    }
  }

  // Alert
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

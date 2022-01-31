import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/src/provider.dart';
import 'package:today_dinner/main.dart';
import 'package:today_dinner/providers/Login.dart';
import 'package:today_dinner/screens/Login/login.dart';
import 'package:today_dinner/screens/Signup/index.dart';
import 'package:today_dinner/screens/Video/index.dart';

// 로그인 기본 class
class FindPasswordScreen extends StatelessWidget {
  // "다음" 버튼 클릭했을 때
  _clicknext(BuildContext context) async {
    // Todo :  유효성 검증 pop up

    // Screen 이동
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(0, 0, 0, 1), //색변경
        ),
        title: Text(
          "비밀번호 찾기",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Color.fromRGBO(40, 40, 40, 1)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // signup title
        Container(
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.width * 0.044,
              top: MediaQuery.of(context).size.height * 0.033,
              left: MediaQuery.of(context).size.width * 0.044),
          child: Text(
            '''가입 시에 입력했던 정보를
입력해주세요.''',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),

        // findpassword email
        Container(
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.044, bottom: 4),
          child: Text(
            "이메일",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),

        // email textbox
        Container(
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.044,
              right: MediaQuery.of(context).size.width * 0.044,
              bottom: 16),
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color.fromRGBO(221, 227, 233, 1))),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '이메일을 입력해주세요.',
              contentPadding: EdgeInsets.all(12.0),
            ),
            onChanged: (text) {
              context.read<LoginViewModel>().setEmail(text);
            },
          ),
        ),
        // findpassword phone
        Container(
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.044, bottom: 4),
          child: Text(
            "휴대폰 번호",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),

        // phone textbox
        Container(
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.044,
              right: MediaQuery.of(context).size.width * 0.044,
              bottom: 16),
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color.fromRGBO(221, 227, 233, 1))),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '-제외한 숫자 11자리',
              contentPadding: EdgeInsets.all(12.0),
            ),
            onChanged: (text) {
              context.read<LoginViewModel>().setPhone(text);
            },
          ),
        ),

        // next button
        Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.width * 0.13,
            left: MediaQuery.of(context).size.width * 0.044,
          ),
          width: MediaQuery.of(context).size.width * 0.911,
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 127, 34, 1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color.fromRGBO(221, 227, 233, 1))),
          child: TextButton(
            onPressed: () =>
                context.read<LoginViewModel>().resetPassword(context),
            child: Text(
              "확인",
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
          ),
        ),
      ]),
    );
  }
}

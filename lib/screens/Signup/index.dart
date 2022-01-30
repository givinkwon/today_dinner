import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:today_dinner/providers/Signup.dart';

// web link
import 'package:url_launcher/url_launcher.dart';

// final GoogleSignIn googleSignIn = GoogleSignIn();

// 회원가입 기본정보 입력
class SignupFirstScreen extends StatelessWidget {
  // "다음" 버튼 클릭했을 때
  _clicknext(BuildContext context) async {
    // Todo :  유효성 검증 pop up

    // Screen 이동
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupSecondScreen()),
    );
  }

  // 중복확인 클릭했을 때
  _emailCheckButtonPressed(BuildContext context) async {
    context.read<SignupViewModel>().EmailCheck(context, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(0, 0, 0, 1), //색변경
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // signup title
        Container(
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.width * 0.054,
              top: MediaQuery.of(context).size.height * 0.033,
              left: MediaQuery.of(context).size.width * 0.044),
          child: Text(
            '''회원정보를
입력해주세요''',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),

        // signup email
        Container(
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.044, bottom: 4),
          child: Text(
            "이메일",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),

        // signup textbox
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
              // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
              // context.read<SignupViewModel>().setEmail(text);
            },
          ),
        ),

        // signup password
        Container(
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.044, bottom: 4),
          child: Text(
            "비밀번호",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),

        // signup email
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
              hintText: '영문, 숫자 8자 이상',
              contentPadding: EdgeInsets.all(12.0),
            ),
            onChanged: (text) {
              // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
              // context.read<SignupViewModel>().setEmail(text);
            },
          ),
        ),
        // signup textbox
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
              hintText: '비밀번호를 한 번 더 입력해주세요.',
              contentPadding: EdgeInsets.all(12.0),
            ),
            onChanged: (text) {
              // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
              // context.read<SignupViewModel>().setEmail(text);
            },
          ),
        ),

        // signup nickname
        Container(
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.044, bottom: 4),
          child: Text(
            "닉네임",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),

        // nickname textbox
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
              hintText: '닉네임을 입력해주세요.',
              contentPadding: EdgeInsets.all(12.0),
            ),
            onChanged: (text) {
              // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
              // context.read<SignupViewModel>().setEmail(text);
            },
          ),
        ),

        // signup phone
        Container(
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.044, bottom: 4),
          child: Text(
            "휴대폰 번호",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),

        // phone textbox
        Row(children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.587,
            margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.044,
                right: MediaQuery.of(context).size.width * 0.024,
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
                // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
                // context.read<SignupViewModel>().setEmail(text);
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.303,
            padding: EdgeInsets.only(top: 13, bottom: 13, left: 42, right: 42),
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color.fromRGBO(255, 127, 34, 1))),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "인증",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 127, 34, 1)),
              ),
            ),
          ),
        ]),

        // signup cretification
        Container(
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.044, bottom: 4),
          child: Text(
            "인증번호 6자리",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),

        // celtification textbox
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
              hintText: '인증번호 6자리를 입력해주세요.',
              contentPadding: EdgeInsets.all(12.0),
            ),
            onChanged: (text) {
              // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
              // context.read<SignupViewModel>().setEmail(text);
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
              color: Color.fromRGBO(255, 227, 206, 1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color.fromRGBO(221, 227, 233, 1))),
          child: TextButton(
            onPressed: () => _clicknext(context),
            child: Text(
              "다음",
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
          ),
        ),
      ]),
    );
  }
}

// 회원가입 기본정보 입력
class SignupSecondScreen extends StatelessWidget {
  // "완료" 버튼 클릭했을 때
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
            '''환영합니다!
서비스 이용약관에
동의해주세요.''',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),

        // signup all agree
        Container(
          width: MediaQuery.of(context).size.width * 0.911,
          height: 48,
          padding: EdgeInsets.only(top: 12, bottom: 12, left: 12),
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.044, bottom: 4),
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(width: 2, color: Color.fromRGBO(255, 127, 34, 1))),
          child: Row(
            children: [
              Container(
                child: Image.asset(
                  'assets/signup/ic_check_active.png',
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 12),
                child: Text(
                  "모두 동의합니다.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),

        // 필수 동의
        Container(
          width: MediaQuery.of(context).size.width * 0.911,
          height: 48,
          padding: EdgeInsets.only(top: 14, bottom: 14, left: 14),
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.044, bottom: 0),
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
          child: Row(
            children: [
              Container(
                child: Image.asset(
                  'assets/signup/ic_check_active.png',
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 12),
                child: Text(
                  "(필수) 만 14세 이상입니다.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),

        // 서비스 이용약관 동의
        Container(
          width: MediaQuery.of(context).size.width * 0.911,
          height: 48,
          padding: EdgeInsets.only(top: 14, bottom: 14, left: 14),
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.044, bottom: 0),
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
          child: Row(
            children: [
              Container(
                child: Image.asset(
                  'assets/signup/ic_check_active.png',
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 12),
                child: Text(
                  "(필수) 개인정보 수집 이용에 동의합니다.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),

        // 마케팅 및 수신 동의

        // 서비스 이용약관 동의
        Container(
          width: MediaQuery.of(context).size.width * 0.911,
          height: 48,
          padding: EdgeInsets.only(top: 14, bottom: 14, left: 14),
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.044, bottom: 0),
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
          child: Row(
            children: [
              Container(
                child: Image.asset(
                  'assets/signup/ic_check_active.png',
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 12),
                child: Text(
                  "(선택) 요리 추천 등 혜택/정보 수신에 동의합니다.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),

        // complete button
        Container(
          margin: EdgeInsets.only(
            top: 42,
            left: MediaQuery.of(context).size.width * 0.044,
          ),
          width: MediaQuery.of(context).size.width * 0.911,
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 227, 206, 1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color.fromRGBO(221, 227, 233, 1))),
          child: TextButton(
            onPressed: () => _clicknext(context),
            child: Text(
              "완료",
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
          ),
        ),
      ]),
    );
  }
}

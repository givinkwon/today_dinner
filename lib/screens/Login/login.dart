import 'package:flutter/material.dart';
import 'package:today_dinner/screens/Login/findid.dart';
import 'package:today_dinner/screens/Login/findpassword.dart';
import 'package:today_dinner/screens/Signup/index.dart';

// 로그인
class LoginScreen extends StatelessWidget {
  // "완료" 버튼 클릭했을 때
  _clicknext(BuildContext context) async {
    // Todo :  유효성 검증 pop up

    // Screen 이동
  }

  // 아이디 찾기로 이동하는 함수
  _FindIdButtonPressed(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FindIdScreen()),
    );
  }

  // 비밀번호 찾기로 이동하는 함수
  _FindPasswordButtonPressed(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FindPasswordScreen()),
    );
  }

  // 회원가입으로 이동하는 함수
  _signupButtonPressed(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupFirstScreen()),
    );
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
            "로그인",
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
              hintText: '비밀번호를 입력해주세요.',
              contentPadding: EdgeInsets.all(12.0),
            ),
            onChanged: (text) {
              // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
              // context.read<SignupViewModel>().setEmail(text);
            },
          ),
        ),

        // login button
        Container(
          margin: EdgeInsets.only(
            top: 24,
            left: MediaQuery.of(context).size.width * 0.044,
            bottom: 32,
          ),
          width: MediaQuery.of(context).size.width * 0.911,
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 127, 34, 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton(
            onPressed: () => _clicknext(context),
            child: Text(
              "로그인",
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
          ),
        ),

        // 아이디 찾기 | 비밀번호 찾기 | 회원가입
        Row(children: [
          // 아이디 찾기
          GestureDetector(
            onTap: () {
              _FindIdButtonPressed(context);
            },
            child: Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.158, bottom: 25),
              padding: EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 8),
              child: Text(
                "아이디 찾기",
                style: TextStyle(
                    fontSize: 14, color: Color.fromRGBO(192, 196, 205, 1)),
              ),
            ),
          ),
          Container(
            height: 16,
            margin: EdgeInsets.only(bottom: 25),
            decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(
                width: 1.0,
                color: Color.fromRGBO(95, 104, 113, 1),
              )),
            ),
          ),
          // 비밀번호 찾기
          GestureDetector(
            onTap: () {
              _FindPasswordButtonPressed(context);
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 25),
              padding: EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 8),
              child: Text(
                "비밀번호 찾기",
                style: TextStyle(
                    fontSize: 14, color: Color.fromRGBO(192, 196, 205, 1)),
              ),
            ),
          ),
          Container(
            height: 16,
            margin: EdgeInsets.only(bottom: 25),
            decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(
                width: 1.0,
                color: Color.fromRGBO(95, 104, 113, 1),
              )),
            ),
          ),
          // 회원가입
          GestureDetector(
            onTap: () {
              _signupButtonPressed(context);
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 25),
              padding: EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 8),
              child: Text(
                "회원가입",
                style: TextStyle(
                    fontSize: 14, color: Color.fromRGBO(192, 196, 205, 1)),
              ),
            ),
          ),
        ]),

        // Facebook 로그인
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.height * 0.061,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.022,
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(66, 133, 244, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                // kakao login logo
                Container(
                  margin: EdgeInsets.only(
                    left: 14,
                    right: 0,
                    top: 14,
                    bottom: 15,
                  ),
                  child: Image.asset('assets/login/ic_facebook.png'),
                ),

                // kakao login text
                Container(
                  width: MediaQuery.of(context).size.width * 0.526,
                  margin: EdgeInsets.only(
                    left: 18,
                    right: 0,
                    top: 13,
                    bottom: 13,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "페이스북으로 시작하기",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Google login
        Center(
          child: GestureDetector(
            onTap: () {
              // _signInWithGoogle();
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * 0.061,
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.022,
              ),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color.fromRGBO(210, 210, 210, 1))),
              child: Row(
                children: [
                  // kakao login logo
                  Container(
                    margin: EdgeInsets.only(
                      left: 14,
                      right: 0,
                      top: 14,
                      bottom: 15,
                    ),
                    child: Image.asset('assets/login/ic_google.png'),
                  ),

                  // kakao login text
                  Container(
                    width: MediaQuery.of(context).size.width * 0.526,
                    margin: EdgeInsets.only(
                      left: 18,
                      right: 0,
                      top: 13,
                      bottom: 13,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "구글로 시작하기",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // login
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.545,
            child: Row(
              children: [
                // kakao login
                Container(
                  padding: EdgeInsets.all(12),
                  width: 44,
                  height: 44,
                  margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.0889),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(249, 224, 1, 1),
                    borderRadius: BorderRadius.circular(44),
                  ),
                  child: Image.asset(
                    'assets/login/ic_kakao.png',
                  ),
                ),

                // naver login
                Container(
                  padding: EdgeInsets.all(12),
                  width: 44,
                  height: 44,
                  margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.0889),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(3, 199, 90, 1),
                    borderRadius: BorderRadius.circular(44),
                  ),
                  child: Image.asset(
                    'assets/login/ic_naver.png',
                  ),
                ),

                // email login
                GestureDetector(
                  onTap: () {
                    _signupButtonPressed(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.circular(44),
                      border:
                          Border.all(color: Color.fromRGBO(210, 210, 210, 1)),
                    ),
                    child: Image.asset(
                      'assets/login/ic_mail.png',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

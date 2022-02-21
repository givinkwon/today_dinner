import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/src/provider.dart';
import 'package:today_dinner/providers/Login.dart';
import 'package:today_dinner/providers/Signup.dart';
import 'package:today_dinner/screens/Login/findid.dart';
import 'package:today_dinner/screens/Login/findpassword.dart';
import 'package:today_dinner/screens/Recipe/index.dart';
import 'package:today_dinner/screens/Signup/index.dart';
import 'package:today_dinner/screens/Video/index.dart';
import 'package:today_dinner/main.dart';

// 로그인
class LoginScreen extends StatelessWidget {
  // 페이스북 로그인
  Future<dynamic> _signInWithFacebook(BuildContext context) async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        await FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    try {
      final awitAsult = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      final user = awitAsult.user;

      // 페이스북은 이메일이나 전화번호가 안잡히는 경우가 있는데 이런 경우에는 아이디 가입 비허용
      if (user?.email == null) {
        return context.read<LoginViewModel>().Alert(context, "가입 에러",
            content1: "계정에 이메일이 등록되어 있지 않습니다.", content2: "이메일 가입을 이용해주세요.");
      }

      // 새로 회원가입했으면 데이터베이스 만들기

      // 1. 데이터 호출
      await context.read<LoginViewModel>().load_data(email: user?.email);

      // 2. 데이터가 없다면 회원가입창으로 이동
      if (context.read<LoginViewModel>().Data.length == 0) {
        _signupButtonPressed(context);
        // 이메일 설정
        context.read<SignupViewModel>().Email = user?.email;
        // 가입 유저 설정 => Password DB 동기화
        context.read<SignupViewModel>().SignupUser = user;
      }

      // 3. 데이터가 있다면 본 페이지로 이동
      if (context.read<LoginViewModel>().Data.length > 0) {
        // 비밀번호 DB 동기화
        auth.currentUser?.updatePassword(
            context.read<LoginViewModel>().Data[0]['password']);
        // 페이지 이동
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RecipeScreen()));
      }
    } catch (e) {
      context
          .read<LoginViewModel>()
          .Alert(context, "가입 에러", content1: "이미 해당 아이디로 가입한 아이디가 있습니다.");
    }
  }

  // 구글 로그인
  Future<dynamic> _signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final OAuthCredential credential = await GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final awitAsult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final user = awitAsult.user;

    // 새로 회원가입했으면 데이터베이스 만들기
    // 1. 데이터 호출
    await context.read<LoginViewModel>().load_data(email: user?.email);

    // 2. 데이터가 없다면 회원가입창으로 이동
    if (context.read<LoginViewModel>().Data.length == 0) {
      // 이메일 설정
      context.read<SignupViewModel>().Email = user?.email;
      // 가입 유저 설정 => Password DB 동기화
      context.read<SignupViewModel>().SignupUser = user;
      // 페이지 이동
      _signupButtonPressed(context);
    } else {
      // 비밀번호 DB 동기화
      auth.currentUser
          ?.updatePassword(context.read<LoginViewModel>().Data[0]['password']);
      // 데이터가 있다면 본 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RecipeScreen()),
      );
    }
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
      resizeToAvoidBottomInset: false, // 공사장 해결
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
              context.read<LoginViewModel>().setEmail(text);
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
              context.read<LoginViewModel>().setPassword(text);
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
            onPressed: () => context.read<LoginViewModel>().login(context),
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
          child: GestureDetector(
            onTap: () {
              _signInWithFacebook(context);
            },
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
                      top: MediaQuery.of(context).size.height * 0.017,
                      bottom: MediaQuery.of(context).size.height * 0.017,
                    ),
                    child: Image.asset('assets/login/ic_facebook.png'),
                  ),

                  // kakao login text
                  Container(
                    width: MediaQuery.of(context).size.width * 0.526,
                    margin: EdgeInsets.only(
                      left: 18,
                      right: 0,
                      top: MediaQuery.of(context).size.height * 0.017,
                      bottom: MediaQuery.of(context).size.height * 0.017,
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
        ),

        // Google login
        Center(
          child: GestureDetector(
            onTap: () {
              _signInWithGoogle(context);
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
                  // google login logo
                  Container(
                    margin: EdgeInsets.only(
                      left: 14,
                      right: 0,
                      top: MediaQuery.of(context).size.height * 0.017,
                      bottom: MediaQuery.of(context).size.height * 0.017,
                    ),
                    child: Image.asset('assets/login/ic_google.png'),
                  ),

                  // google login text
                  Container(
                    width: MediaQuery.of(context).size.width * 0.526,
                    margin: EdgeInsets.only(
                      left: 18,
                      right: 0,
                      top: MediaQuery.of(context).size.height * 0.017,
                      bottom: MediaQuery.of(context).size.height * 0.017,
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

        // // login
        // Center(
        //   child: Container(
        //     width: MediaQuery.of(context).size.width * 0.545,
        //     child: Row(
        //       children: [
        //         // // kakao login
        //         // GestureDetector(
        //         //   onTap: () {
        //         //     context.read<LoginViewModel>().Alert(context, "준비중입니다.",
        //         //         content1: "빠른 시일 내로 준비하도록 할게요.");
        //         //   },
        //         //   child: Container(
        //         //     padding: EdgeInsets.all(12),
        //         //     width: 44,
        //         //     height: 44,
        //         //     margin: EdgeInsets.only(
        //         //         right: MediaQuery.of(context).size.width * 0.0889),
        //         //     decoration: BoxDecoration(
        //         //       color: Color.fromRGBO(249, 224, 1, 1),
        //         //       borderRadius: BorderRadius.circular(44),
        //         //     ),
        //         //     child: Image.asset(
        //         //       'assets/login/ic_kakao.png',
        //         //     ),
        //         //   ),
        //         // ),

        //         // // naver login
        //         // GestureDetector(
        //         //   onTap: () {
        //         //     context.read<LoginViewModel>().Alert(context, "준비중입니다.",
        //         //         content1: "빠른 시일 내로 준비하도록 할게요.");
        //         //   },
        //         //   child: Container(
        //         //     padding: EdgeInsets.all(12),
        //         //     width: 44,
        //         //     height: 44,
        //         //     margin: EdgeInsets.only(
        //         //         right: MediaQuery.of(context).size.width * 0.0889),
        //         //     decoration: BoxDecoration(
        //         //       color: Color.fromRGBO(3, 199, 90, 1),
        //         //       borderRadius: BorderRadius.circular(44),
        //         //     ),
        //         //     child: Image.asset(
        //         //       'assets/login/ic_naver.png',
        //         //     ),
        //         //   ),
        //         // ),

        //         // email login
        //         GestureDetector(
        //           onTap: () {
        //             _signupButtonPressed(context);
        //           },
        //           child: Container(
        //             padding: EdgeInsets.all(12),
        //             width: 44,
        //             height: 44,
        //             decoration: BoxDecoration(
        //               color: Color.fromRGBO(255, 255, 255, 1),
        //               borderRadius: BorderRadius.circular(44),
        //               border:
        //                   Border.all(color: Color.fromRGBO(210, 210, 210, 1)),
        //             ),
        //             child: Image.asset(
        //               'assets/login/ic_mail.png',
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ]),
    );
  }
}

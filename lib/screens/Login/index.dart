import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/src/provider.dart';
import 'package:today_dinner/main.dart';
import 'package:today_dinner/providers/Login.dart';
import 'package:today_dinner/providers/Signup.dart';
import 'package:today_dinner/screens/Login/login.dart';
import 'package:today_dinner/screens/Signup/index.dart';
import 'package:today_dinner/screens/Video/index.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// 로그인 기본 class
class LoginIndexScreen extends StatelessWidget {
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
        _nologinButtonPressed(context);
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

    try {
      final awitAsult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = awitAsult.user;

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
      } else {
        auth.currentUser?.updatePassword(
            context.read<LoginViewModel>().Data[0]['password']);
        // 데이터가 있다면 본 페이지로 이동
        _nologinButtonPressed(context);
      }
    } catch (e) {
      context
          .read<LoginViewModel>()
          .Alert(context, "가입 에러", content1: "이미 해당 이메일로 가입한 아이디가 있습니다.");
    }
  }

  // 로그인 창으로 이동하는 함수
  _EmailLoginButtonPressed(BuildContext context) async {
    // 페이지 이동
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  // 홈페이지로 이동하는 함수
  _nologinButtonPressed(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => VideoScreen()),
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
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(251, 246, 240, 1),
        toolbarHeight: 0,
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Column(
        children: [
          // title
          Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.11),
            child: Text(
              "맛간요리",
              style: TextStyle(
                  color: Color.fromRGBO(255, 127, 34, 1),
                  fontWeight: FontWeight.w900,
                  fontSize: 70),
            ),
          ),
          // logo
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.389,
            child: Image.asset('assets/login/ic_character.png'),
          ),

          // Facebook 로그인
          Container(
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
                GestureDetector(
                  onTap: () {
                    _signInWithFacebook(context);
                  },
                  child: Container(
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
                ),
              ],
            ),
          ),

          // Google login
          GestureDetector(
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

          // login
          Container(
            width: MediaQuery.of(context).size.width * 0.545,
            child: Row(
              children: [
                // kakao login
                GestureDetector(
                  onTap: () {
                    context.read<LoginViewModel>().Alert(context, "준비중입니다.",
                        content1: "빠른 시일 내로 준비하도록 할게요.");
                  },
                  child: Container(
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
                ),
                // naver login
                GestureDetector(
                  onTap: () {
                    context.read<LoginViewModel>().Alert(context, "준비중입니다.",
                        content1: "빠른 시일 내로 준비하도록 할게요.");
                  },
                  child: Container(
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
                ),

                // email login
                GestureDetector(
                  onTap: () {
                    _EmailLoginButtonPressed(context);
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

          // no login
          GestureDetector(
            onTap: () {
              _nologinButtonPressed(context);
            },
            child: Container(
              margin: EdgeInsets.only(
                left: 0,
                right: 0,
                top: 36,
              ),
              child: Text(
                "일단 둘러볼래요",
                style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(192, 196, 205, 1),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

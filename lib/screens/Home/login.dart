import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:provider/provider.dart';
import 'package:today_dinner/providers/home.dart';
import '../Login/index.dart';
import 'package:today_dinner/screens/Signup/index.dart';
import './index.dart';
import 'package:today_dinner/screens/Login/index.dart';

// 로그인 기본 class
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

// 전체 class
class _LoginPageState extends State<LoginPage> {
  // 로그인 창으로 이동하는 함수
  Future<void> _loginButtonPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginIndexPage()),
    );
  }

  // 홈페이지로 이동하는 함수
  Future<void> _nologinButtonPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  // 회원가입으로 이동하는 함수
  Future<void> _signupButtonPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (BuildContext context) => Home(),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 300),
              child: Image(
                image: AssetImage('assets/main.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  text: "오늘의 저녁\n\n\n\n\n\n",
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  text: "우리가족 식사고민끝! 요리 필수 앱\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _loginButtonPressed,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.orange[700],
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.all(15),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      child: Text(
                        "로그인하고 살펴보기",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    TextButton(
                      onPressed: _nologinButtonPressed,
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                      ),
                      child: Text(
                        "로그인 없이 살펴보기",
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: _signupButtonPressed,
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                      ),
                      child: Text(
                        "가입하기",
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

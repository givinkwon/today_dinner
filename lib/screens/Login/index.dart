import 'package:flutter/material.dart';
import 'package:today_dinner/screens/Login/login.dart';
import 'package:today_dinner/screens/Signup/index.dart';
import 'package:today_dinner/screens/Video/index.dart';

// 로그인 기본 class
class LoginIndexScreen extends StatelessWidget {
  // 로그인 창으로 이동하는 함수
  _loginButtonPressed(BuildContext context) async {
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
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(251, 246, 240, 1),
        toolbarHeight: 0,
      ),
      backgroundColor: Color.fromRGBO(251, 246, 240, 1),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage('assets/main2.jpg'),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => _loginButtonPressed(context),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color.fromRGBO(201, 92, 57, 1),
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
                      onPressed: () => _nologinButtonPressed(context),
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                      ),
                      child: Text(
                        "로그인 없이 살펴보기",
                        style: TextStyle(
                            fontSize: 17, color: Color.fromRGBO(89, 89, 89, 1)),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _signupButtonPressed(context),
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                      ),
                      child: Text(
                        "가입하기",
                        style: TextStyle(
                            fontSize: 15, color: Color.fromRGBO(89, 89, 89, 1)),
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

import 'package:flutter/material.dart';
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

// appbar 지우기
class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(246, 246, 246, 1),
      height: 0,
    );
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
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
  void initState() {
    super.initState();

    if (mounted) {
      setState(() {});
    }
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
      body: ChangeNotifierProvider(
        create: (BuildContext context) => Home(),
        child: Container(
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
                        onPressed: _loginButtonPressed,
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
                        onPressed: _nologinButtonPressed,
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                        ),
                        child: Text(
                          "로그인 없이 살펴보기",
                          style: TextStyle(
                              fontSize: 17,
                              color: Color.fromRGBO(89, 89, 89, 1)),
                        ),
                      ),
                      TextButton(
                        onPressed: _signupButtonPressed,
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                        ),
                        child: Text(
                          "가입하기",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromRGBO(89, 89, 89, 1)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

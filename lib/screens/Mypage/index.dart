import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// provider listener 이용
import 'package:flutter/foundation.dart';
import 'package:today_dinner/providers/profile.dart';
import 'package:today_dinner/providers/recipe.dart';
import 'package:today_dinner/providers/reply.dart';
import 'package:today_dinner/screens/Home/index.dart';
import 'package:today_dinner/screens/Home/login.dart';
import 'package:today_dinner/screens/Product/index.dart';
import 'package:today_dinner/screens/Scrap/index.dart';
import 'package:today_dinner/screens/Recipe/index.dart';
import 'package:today_dinner/screens/Shopping/index.dart';
import 'package:today_dinner/screens/Signup/index.dart';
import 'package:today_dinner/screens/Login/index.dart';
import 'package:today_dinner/screens/Write/index.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:today_dinner/screens/Reply/index.dart';
import 'package:today_dinner/screens/Mypage/index.dart';
import 'package:today_dinner/screens/Mypage/Mywrite.dart';
import 'package:today_dinner/screens/Mypage/Account/index.dart';
import 'package:today_dinner/screens/Login/index.dart';
// provider => watch는 값이 변화할 때 리렌더링, read는 값이 변화해도 렌더링 x
// => watch는 값을 보여주는 UI에 read는 변경이 필요없는 함수에 주로 사용
import 'package:today_dinner/providers/home.dart';
import 'package:today_dinner/providers/write.dart';

// firestorage.List feed_image = firestorage.ref('20210917_164240.jpg');
// var url = firestorage.ref('20210917_164240.jpg').getDownloadURL();

// firebase auth
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

FirebaseAuth auth = FirebaseAuth.instance;

// 로그인 기본 class
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();

  dispose() {}
}

class _MyPageState extends State<MyPage> {
  @override
  void initState() {
    // 로그인 상태인지 확인
    // print(auth.currentUser);
    if (auth.currentUser != null) {
      // print(auth.currentUser!.email);
    }

    context.read<Profile>().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromRGBO(40, 40, 40, 1), //색변경
        ),
        backgroundColor: Colors.white,
        title: Text(
          "마이페이지",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(40, 40, 40, 1)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 800,
          child: ListView(
            children: <Widget>[
              if (auth.currentUser != null)
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MywritePage(),
                      ),
                    );
                  },
                  //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능

                  leading: Icon(Icons.my_library_books_sharp),
                  title: Text('내가 쓴 글'),
                ),
              if (auth.currentUser != null)
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScrapPage(),
                      ),
                    );
                  },
                  leading: Icon(Icons.bookmark),
                  title: Text('스크랩한 글'),
                ),
              if (auth.currentUser != null)
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountPage(),
                      ),
                    );
                  },
                  leading: Icon(Icons.people),
                  title: Text('계정 설정'),
                ),
              if (auth.currentUser != null)
                ListTile(
                  onTap: () {
                    auth.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  leading: Icon(Icons.exit_to_app),
                  title: Text('로그아웃'),
                ),
              if (auth.currentUser == null)
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginIndexPage(),
                      ),
                    );
                  },
                  leading: Icon(Icons.login),
                  title: Text('로그인'),
                ),
              if (auth.currentUser == null)
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupPage(),
                      ),
                    );
                  },
                  leading: Icon(Icons.people),
                  title: Text('회원가입'),
                ),
              ListTile(
                onTap: () {
                  launch('https://forms.gle/EQuQTbkH64W93JHF7');
                },
                leading: Icon(Icons.dvr),
                title: Text('피드백 남기기'),
              ),
              if (context.watch<Profile>().Marketing == true &&
                  auth.currentUser != null)
                ListTile(
                  onTap: () {
                    context.read<Profile>().changeMarketing(
                        context,
                        auth.currentUser?.email,
                        context.read<Profile>().Marketing);
                  },
                  leading: Icon(Icons.search),
                  title: Text('혜택/정보 수신 동의 해제'),
                ),
              if (context.watch<Profile>().Marketing == false &&
                  auth.currentUser != null)
                ListTile(
                  onTap: () {
                    context.read<Profile>().changeMarketing(
                        context,
                        auth.currentUser?.email,
                        context.read<Profile>().Marketing);
                  },
                  leading: Icon(Icons.search),
                  title: Text('혜택/정보 수신 동의'),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color.fromRGBO(201, 92, 57, 1),
          type: BottomNavigationBarType.fixed,
          onTap: (index) => {
                // 홈
                if (index == 0)
                  {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    ),
                  },

                // 글쓰기
                if (auth.currentUser != null && index == 1)
                  {
                    context.read<Write>().init(), // 글 쓸 때 이미지 초기화
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WritePage()),
                    ),
                  },

                // 미가입 시
                if (auth.currentUser == null && index == 1)
                  {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text("로그인"),
                            content: new Text("로그인이 필요합니다."),
                            actions: <Widget>[
                              new FlatButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginIndexPage()),
                                  );
                                },
                                child: new Text("로그인 페이지로 이동"),
                              ),
                            ],
                          );
                        }),
                  },

                // 스크랩
                if (auth.currentUser != null && index == 2)
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScrapPage()),
                    ),
                  },

                //미가입 시
                if (auth.currentUser == null && index == 2)
                  {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text("로그인"),
                            content: new Text("로그인이 필요합니다."),
                            actions: <Widget>[
                              new FlatButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginIndexPage()),
                                  );
                                },
                                child: new Text("로그인 페이지로 이동"),
                              ),
                            ],
                          );
                        }),
                  },
                // 마이페이지
                if (index == 3)
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyPage()),
                    ),
                  },
              },
          currentIndex: 0,
          items: [
            new BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('홈'),
            ),
            if (auth.currentUser != null)
              new BottomNavigationBarItem(
                icon: Icon(Icons.add),
                title: Text('글쓰기'),
              ),
            if (auth.currentUser != null)
              new BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                title: Text('스크랩'),
              ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('마이페이지'),
            )
          ]),
    );
  }
}

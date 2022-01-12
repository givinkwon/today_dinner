import 'package:flutter/material.dart';
import 'package:today_dinner/screens/Home/index.dart';
import 'package:today_dinner/screens/Recipe/index.dart';
import 'package:today_dinner/screens/Scrap/index.dart';
import 'package:today_dinner/screens/Write/index.dart';
import 'package:today_dinner/screens/Mypage/index.dart';
import 'package:today_dinner/screens/Home/login.dart';
// provider => watch는 값이 변화할 때 리렌더링, read는 값이 변화해도 렌더링 x
// => watch는 값을 보여주는 UI에 read는 변경이 필요없는 함수에 주로 사용
import 'package:today_dinner/providers/home.dart';
import 'package:today_dinner/providers/write.dart';
import 'package:today_dinner/providers/recipe.dart';

// firestorage.List feed_image = firestorage.ref('20210917_164240.jpg');
// var url = firestorage.ref('20210917_164240.jpg').getDownloadURL();

// firebase auth
import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';
// provider listener 이용
import 'package:flutter/foundation.dart';

FirebaseAuth auth = FirebaseAuth.instance;

// appbar 지우기
class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}

class ShoppingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 그리드 뷰 이미지
    List<String> images = [
      "assets/main.jpg",
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromRGBO(40, 40, 40, 1), //색변경
        ),
        backgroundColor: Colors.white,
        title: Text(
          "스크랩",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(40, 40, 40, 1)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 10.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  // 네비게이션바 메뉴 1
                  Expanded(
                    flex: 1,
                    child: Align(
                      child: Container(
                        color: Colors.white,
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              text: "모두 보기",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 네비게이션바 메뉴 2

                  Expanded(
                    flex: 1,
                    child: Align(
                      child: Container(
                        color: Colors.white,
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              text: "밀키트 | 간편식",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // 상세 하단 경게선
              Container(child: Divider(color: Colors.grey, thickness: 2.0)),
              // 본문 내용
              Container(
                height: 500,
                child: GridView.builder(
                  padding: EdgeInsets.all(5.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 12.0,
                  ),
                  itemCount: 16,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, int index) {
                    return Container(
                      color: Colors.grey[300],
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: Text("GridView $index"),
                      ),
                    );
                  },
                ),
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
                    Navigator.pushReplacement(
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ScrapPage()),
                    ),
                  },

                // 미가입 시
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
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
                    Navigator.pushReplacement(
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
            new BottomNavigationBarItem(
              icon: Icon(Icons.add),
              title: Text('글쓰기'),
            ),
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

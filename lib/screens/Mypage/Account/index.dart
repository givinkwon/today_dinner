import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// provider listener 이용
import 'package:flutter/foundation.dart';
import 'package:today_dinner/providers/recipe.dart';
import 'package:today_dinner/providers/reply.dart';
import 'package:today_dinner/screens/Home/index.dart';
import 'package:today_dinner/screens/Product/index.dart';
import 'package:today_dinner/screens/Scrap/index.dart';
import 'package:today_dinner/screens/Recipe/index.dart';
import 'package:today_dinner/screens/Shopping/index.dart';
import 'package:today_dinner/screens/Write/index.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:today_dinner/screens/Reply/index.dart';
import 'package:today_dinner/screens/Mypage/index.dart';
import 'package:today_dinner/screens/Mypage/Mywrite.dart';
import 'package:today_dinner/screens/Home/Login.dart';
import 'package:today_dinner/screens/Login/index.dart';

// provider => watch는 값이 변화할 때 리렌더링, read는 값이 변화해도 렌더링 x
// => watch는 값을 보여주는 UI에 read는 변경이 필요없는 함수에 주로 사용
import 'package:today_dinner/providers/home.dart';
import 'package:today_dinner/providers/write.dart';
import 'package:today_dinner/providers/profile.dart';

// firestorage.List feed_image = firestorage.ref('20210917_164240.jpg');
// var url = firestorage.ref('20210917_164240.jpg').getDownloadURL();

// firebase auth
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;

// 로그인 기본 class
class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // 로그인 상태인지 확인
    // print(auth.currentUser);
    if (auth.currentUser != null) {
      // print(auth.currentUser!.email);
    }
  }

// 비밀번호 재설정
  @override
  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  @override
  Widget build(BuildContext context) {
    print(context.read<Home>().User);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromRGBO(40, 40, 40, 1), //색변경
        ),
        backgroundColor: Colors.white,
        title: Text(
          "계정 설정",
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
              Stack(children: [
                Image(
                  image: AssetImage('assets/profile.jpg'),
                  fit: BoxFit.cover,
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(
                      "프로필 사진 추가",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                // 이미지가 없는 경우 + 프로필 수정 하지 않은 경우
                if (context.read<Home>().User[0]['profileimage'].length == 0 &&
                    context.read<Profile>().ImageUrl.length == 0)
                  GestureDetector(
                    onTap: () {
                      context.read<Profile>().getGalleryImage().then((_) {
                        // 이미지 선택 후 업로드
                        context.read<Profile>().changeProfileImage(
                            context, auth.currentUser?.email);
                        setState(() {});
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.add,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                // 이미지가 있는 경우 + 프로필 수정 하지 않은 경우
                if (context.read<Home>().User[0]['profileimage'].length > 0 &&
                    context.read<Profile>().ImageUrl.length == 0)
                  GestureDetector(
                    onTap: () {
                      context.read<Profile>().getGalleryImage().then((_) {
                        // 이미지 선택 후 업로드
                        context.read<Profile>().changeProfileImage(
                            context, auth.currentUser?.email);
                        setState(() {});
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                              context.read<Home>().User[0]['profileimage']),
                          child: Icon(
                            Icons.add,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                // 프로플 수정한 경우
                if (context.read<Profile>().ImageUrl.length > 0)
                  GestureDetector(
                    onTap: () {
                      context.read<Profile>().getGalleryImage().then((_) {
                        // 이미지 선택 후 업로드
                        context.read<Profile>().changeProfileImage(
                            context, auth.currentUser?.email);
                        setState(() {});
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              NetworkImage(context.read<Profile>().ImageUrl[0]),
                          child: Icon(
                            Icons.add,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
              ]),
              ListTile(
                //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능

                leading: Icon(Icons.email),
                title: Text('이메일'),
                trailing: Text(
                  "${context.read<Home>().User[0]['email']}",
                  style: TextStyle(color: Colors.blue[400]),
                ),
              ),
              ListTile(
                onTap: () {
                  context.read<Profile>().changeNicknameWidget(context);
                },
                //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능

                leading: Icon(Icons.people),
                title: Text('닉네임'),
                trailing: Text(
                  "변경하기",
                  style: TextStyle(color: Colors.blue[400]),
                ),
              ),
              ListTile(
                onTap: () {
                  resetPassword(context.read<Home>().User[0]['email']);
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text("비밀번호 재설정"),
                          content: new Text("비밀번호 재설정 메일이 이메일로 발송되었습니다."),
                          actions: <Widget>[
                            new FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: new Text("닫기"),
                            ),
                          ],
                        );
                      });
                },
                leading: Icon(Icons.lock),
                title: Text('비밀번호'),
                trailing: Text(
                  "변경하기",
                  style: TextStyle(color: Colors.blue[400]),
                ),
              ),
              ListTile(
                onTap: () {
                  context.read<Profile>().changePhoneWidget(context);
                },
                leading: Icon(Icons.phone),
                title: Text('휴대폰'),
                trailing: Text(
                  "변경하기",
                  style: TextStyle(color: Colors.blue[400]),
                ),
              ),
              ListTile(
                onTap: () {
                  context.read<Profile>().withdrawalAccountWidget(context);
                },
                leading: Icon(Icons.person_off),
                title: Text('회원 탈퇴'),
              )
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
                                  Navigator.push(
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

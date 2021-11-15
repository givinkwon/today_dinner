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

// provider => watch는 값이 변화할 때 리렌더링, read는 값이 변화해도 렌더링 x
// => watch는 값을 보여주는 UI에 read는 변경이 필요없는 함수에 주로 사용
import 'package:today_dinner/providers/home.dart';
import 'package:today_dinner/providers/write.dart';

// firestorage.List feed_image = firestorage.ref('20210917_164240.jpg');
// var url = firestorage.ref('20210917_164240.jpg').getDownloadURL();

// firebase auth
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;

// 로그인 기본 class
class ReplyPage extends StatefulWidget {
  @override
  _ReplyPageState createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // 로그인 상태인지 확인

    if (auth.currentUser != null) {
      // print(auth.currentUser!.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, title: Text("댓글")),
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // 아이디
                if (context.watch<Home>().top_index != 3)
                  Container(
                    height: 100,
                    child: Row(children: [
                      Container(
                        width: 10,
                      ),
                      // Feed 선택 + profileimage가 있을 때
                      if (context.watch<Home>().top_index == 1 &&
                          context
                                  .watch<Home>()
                                  .Feed[context.watch<Reply>().selected_index]
                                      ['profileimage']
                                  .length >
                              0 &&
                          context.watch<Home>().Feed[context
                                  .watch<Reply>()
                                  .selected_index]['profileimage'][0] !=
                              "")
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(context
                                  .watch<Home>()
                                  .Feed[context.watch<Reply>().selected_index]
                              ['profileimage'][0]),
                        ), // profileimage가 없을 때
                      if (context.watch<Home>().top_index == 1 &&
                          context
                                  .watch<Home>()
                                  .Feed[context.watch<Reply>().selected_index]
                                      ['profileimage']
                                  .length >
                              0 &&
                          context.watch<Home>().Feed[context
                                  .watch<Reply>()
                                  .selected_index]['profileimage'][0] ==
                              "")
                        CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.purple,
                            child: Icon(Icons.people)),

                      // Freetalk 선택 + profileimage가 있을 때
                      if (context.watch<Home>().top_index == 2 &&
                          context
                                  .watch<Home>()
                                  .Freetalk[context
                                      .watch<Reply>()
                                      .selected_index]['profileimage']
                                  .length >
                              0 &&
                          context.watch<Home>().Freetalk[context
                                  .watch<Reply>()
                                  .selected_index]['profileimage'][0] !=
                              "")
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                              context.watch<Home>().Freetalk[context
                                  .watch<Reply>()
                                  .selected_index]['profileimage'][0]),
                        ), // profileimage가 없을 때
                      if (context.watch<Home>().top_index == 2 &&
                          context
                                  .watch<Home>()
                                  .Freetalk[context
                                      .watch<Reply>()
                                      .selected_index]['profileimage']
                                  .length >
                              0 &&
                          context.watch<Home>().Freetalk[context
                                  .watch<Reply>()
                                  .selected_index]['profileimage'][0] ==
                              "")
                        CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.purple,
                            child: Icon(Icons.people)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            context.watch<Home>().top_index == 1
                                ? (context.watch<Home>().Feed[context
                                    .watch<Reply>()
                                    .selected_index]['nickname'])
                                : (context.watch<Home>().Freetalk[context
                                    .watch<Reply>()
                                    .selected_index]['nickname']),
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      // 본문 내용
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            context.watch<Home>().top_index == 1
                                ? (context.watch<Home>().Feed[context
                                    .watch<Reply>()
                                    .selected_index]['content'])
                                : (context.watch<Home>().top_index == 2
                                    ? context.watch<Home>().Freetalk[context
                                        .watch<Reply>()
                                        .selected_index]['content']
                                    : context.watch<Home>().Recipe[context
                                        .watch<Reply>()
                                        .selected_index]['content']),
                            style: TextStyle(fontSize: 14, color: Colors.black),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ]),
                  ),

                // Start : Feed 댓글
                if (context.watch<Home>().top_index == 1 &&
                    context
                                .watch<Home>()
                                .Feed[context.watch<Reply>().selected_index]
                            ['reply'] !=
                        null &&
                    context
                            .watch<Home>()
                            .Feed[context.watch<Reply>().selected_index]
                                ['reply']
                            .length !=
                        0)
                  for (var reply in context
                      .watch<Home>()
                      .Feed[context.watch<Reply>().selected_index]['reply']
                      .reversed
                      .toList())
                    Container(
                      height: 100,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(children: [
                          Container(
                            width: 10,
                          ),
                          // 프로필 이미지가 없는 경우
                          if (reply['profileimage'] == "")
                            CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.purple,
                                child: Icon(Icons.people)),
                          // 프로필 이미지가 있는 경우
                          if (reply['profileimage'] != "")
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage(reply['profileimage']),
                            ),
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text('${reply['nickname']} ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text('${reply['content']}'),
                          ),
                        ]),
                      ),
                    ),

                // End : Feed 댓글

                // Start : Freetalk 댓글 2개 미리보기 => 2개 이하인 경우에는 전부 / 2개 이상인 경우에는 2개만
                if (context.watch<Home>().top_index == 2 &&
                    context
                                .watch<Home>()
                                .Freetalk[context.watch<Reply>().selected_index]
                            ['reply'] !=
                        null &&
                    context
                            .watch<Home>()
                            .Freetalk[context.watch<Reply>().selected_index]
                                ['reply']
                            .length !=
                        0)
                  for (var reply in context
                      .watch<Home>()
                      .Freetalk[context.watch<Reply>().selected_index]['reply']
                      .reversed
                      .toList())
                    Container(
                      height: 100,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(children: [
                          Container(
                            width: 10,
                          ),
                          // 프로필 이미지가 없는 경우
                          if (reply['profileimage'] == "")
                            CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.purple,
                                child: Icon(Icons.people)),
                          // 프로필 이미지가 있는 경우
                          if (reply['profileimage'] != "")
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage(reply['profileimage']),
                            ),
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text('${reply['nickname']} ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text('${reply['content']}'),
                          ),
                        ]),
                      ),
                    ),
              ],
            ),
          ),
        ),
        Row(children: [
          Expanded(flex: 1, child: Container()),
          Expanded(
              flex: 8,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '댓글을 입력해주세요.',
                ),
                onChanged: (text) {
                  // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
                  context.read<Reply>().setReply(text);
                },
              )),
          Expanded(flex: 1, child: Container()),
          Expanded(
            flex: 3,
            child: TextButton(
              onPressed: () {
                context.read<Reply>().replyComplete(
                    context
                        .read<Home>()
                        .Feed[context.read<Reply>().selected_index]['id'],
                    context.read<Home>().User[0],
                    auth,
                    context);
              },
              style: TextButton.styleFrom(
                  primary: Colors.purple,
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.purple, width: 2)),
              child: Text(
                "입력하기",
                style: TextStyle(fontSize: 12, color: Colors.purple),
              ),
            ),
          ),
          Expanded(flex: 1, child: Container()),
        ]),
        Container(
          height: 20,
        ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (index) => {
                // 홈
                if (index == 0)
                  {
                    Navigator.push(
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

                // 스크랩
                if (index == 2)
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScrapPage()),
                    ),
                  },

                // 마이페이지
                if (auth.currentUser != null && index == 3)
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

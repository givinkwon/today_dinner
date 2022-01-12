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
import 'package:today_dinner/screens/Home/login.dart';
import 'package:today_dinner/screens/Login/index.dart';

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
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromRGBO(40, 40, 40, 1), //색변경
        ),
        backgroundColor: Colors.white,
        title: Text(
          "댓글",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(40, 40, 40, 1)),
        ),
        centerTitle: true,
      ),
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                // 아이디
                if (context.watch<Home>().top_index != 3)
                  Row(children: [
                    Container(
                      width: 15,
                    ),
                    // Feed 선택 + profileimage가 있을 때
                    if (context.watch<Home>().top_index == 1 &&
                        context
                                .watch<Home>()
                                .Feed[context.watch<Reply>().selected_index]
                                    ['profileimage']
                                .length >
                            0 &&
                        context
                                    .watch<Home>()
                                    .Feed[context.watch<Reply>().selected_index]
                                ['profileimage'][0] !=
                            "")
                      CircleAvatar(
                        radius: 15,
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
                        context
                                    .watch<Home>()
                                    .Feed[context.watch<Reply>().selected_index]
                                ['profileimage'][0] ==
                            "")
                      CircleAvatar(
                          radius: 15,
                          backgroundColor: Color.fromRGBO(220, 220, 220, 1),
                          foregroundColor: Colors.white,
                          child: Icon(Icons.person)),

                    // Freetalk 선택 + profileimage가 있을 때
                    if (context.watch<Home>().top_index == 2 &&
                        context
                                .watch<Home>()
                                .Freetalk[context.watch<Reply>().selected_index]
                                    ['profileimage']
                                .length >
                            0 &&
                        context.watch<Home>().Freetalk[context
                                .watch<Reply>()
                                .selected_index]['profileimage'][0] !=
                            "")
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(context
                                .watch<Home>()
                                .Freetalk[context.watch<Reply>().selected_index]
                            ['profileimage'][0]),
                      ), // profileimage가 없을 때
                    if (context.watch<Home>().top_index == 2 &&
                        context
                                .watch<Home>()
                                .Freetalk[context.watch<Reply>().selected_index]
                                    ['profileimage']
                                .length >
                            0 &&
                        context.watch<Home>().Freetalk[context
                                .watch<Reply>()
                                .selected_index]['profileimage'][0] ==
                            "")
                      CircleAvatar(
                          radius: 15,
                          backgroundColor: Color.fromRGBO(220, 220, 220, 1),
                          foregroundColor: Colors.white,
                          child: Icon(Icons.person)),

                    Container(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 50,
                          bottom: 5),
                      child: Text(
                        context.watch<Home>().top_index == 1
                            ? (context
                                    .watch<Home>()
                                    .Feed[context.watch<Reply>().selected_index]
                                ['nickname'])
                            : (context.watch<Home>().Freetalk[context
                                .watch<Reply>()
                                .selected_index]['nickname']),
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(40, 40, 40, 1),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),

                // 본문 내용
                Container(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 7),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    context.watch<Home>().top_index == 1
                        ? (context
                                .watch<Home>()
                                .Feed[context.watch<Reply>().selected_index]
                            ['content'])
                        : (context.watch<Home>().top_index == 2
                            ? context.watch<Home>().Freetalk[context
                                .watch<Reply>()
                                .selected_index]['content']
                            : context.watch<Home>().Recipe[context
                                .watch<Reply>()
                                .selected_index]['content']),
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(40, 40, 40, 1),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                // 댓글 시간
                Container(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 7),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "${DateTime.parse(context.watch<Home>().Feed[context.watch<Reply>().selected_index]['createdAt'].toDate().toString()).month}월 ${DateTime.parse(context.watch<Home>().Feed[context.watch<Reply>().selected_index]['createdAt'].toDate().toString()).day}일",
                    style: TextStyle(
                      fontSize: 10,
                      color: Color.fromRGBO(40, 40, 40, 1),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                // // 상세 하단 경계선
                Container(
                    margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Divider(color: Colors.grey[300], thickness: 1.0)),

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
                      margin: EdgeInsets.only(top: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(children: [
                          Row(children: [
                            Container(
                              width: 15,
                            ),
                            // 프로필 이미지가 없는 경우
                            if (reply['profileimage'] == "")
                              CircleAvatar(
                                  radius: 15,
                                  backgroundColor:
                                      Color.fromRGBO(220, 220, 220, 1),
                                  foregroundColor: Colors.white,
                                  child: Icon(
                                    Icons.person,
                                  )),
                            // 프로필 이미지가 있는 경우
                            if (reply['profileimage'] != "")
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    NetworkImage(reply['profileimage']),
                              ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 50,
                                  bottom: 5),
                              child: Text('${reply['nickname']} ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(40, 40, 40, 1),
                                  )),
                            ),
                          ]),
                          Container(
                            padding: EdgeInsets.only(
                                left:
                                    MediaQuery.of(context).size.width / 7 - 2),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              '${reply['content']}',
                              style: TextStyle(
                                  color: Color.fromRGBO(40, 40, 40, 1)),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left:
                                    MediaQuery.of(context).size.width / 7 - 2),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "${DateTime.parse(context.watch<Home>().Feed[context.watch<Reply>().selected_index]['createdAt'].toDate().toString()).month}월 ${DateTime.parse(context.watch<Home>().Feed[context.watch<Reply>().selected_index]['createdAt'].toDate().toString()).day}일",
                              style: TextStyle(
                                fontSize: 10,
                                color: Color.fromRGBO(40, 40, 40, 1),
                              ),
                              textAlign: TextAlign.left,
                            ),
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
                      margin: EdgeInsets.only(top: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(children: [
                          Row(children: [
                            Container(
                              width: 15,
                            ),
                            // 프로필 이미지가 없는 경우
                            if (reply['profileimage'] == "")
                              CircleAvatar(
                                  radius: 15,
                                  backgroundColor:
                                      Color.fromRGBO(220, 220, 220, 1),
                                  foregroundColor: Colors.white,
                                  child: Icon(
                                    Icons.person,
                                  )),
                            // 프로필 이미지가 있는 경우
                            if (reply['profileimage'] != "")
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    NetworkImage(reply['profileimage']),
                              ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 50,
                                  bottom: 5),
                              child: Text('${reply['nickname']} ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(40, 40, 40, 1),
                                  )),
                            ),
                          ]),
                          Container(
                            padding: EdgeInsets.only(
                                left:
                                    MediaQuery.of(context).size.width / 7 - 2),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              '${reply['content']}',
                              style: TextStyle(
                                color: Color.fromRGBO(40, 40, 40, 1),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left:
                                    MediaQuery.of(context).size.width / 7 - 2),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "${DateTime.parse(context.watch<Home>().Freetalk[context.watch<Reply>().selected_index]['createdAt'].toDate().toString()).month}월 ${DateTime.parse(context.watch<Home>().Freetalk[context.watch<Reply>().selected_index]['createdAt'].toDate().toString()).day}일",
                              style: TextStyle(
                                fontSize: 10,
                                color: Color.fromRGBO(40, 40, 40, 1),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ]),
                      ),
                    ),

                // Start : Recipe 댓글 2개 미리보기 => 2개 이하인 경우에는 전부 / 2개 이상인 경우에는 2개만
                if (context.watch<Home>().top_index == 3 &&
                    context
                                .watch<Home>()
                                .Recipe[context.watch<Reply>().selected_index]
                            ['reply'] !=
                        null &&
                    context
                            .watch<Home>()
                            .Recipe[context.watch<Reply>().selected_index]
                                ['reply']
                            .length !=
                        0)
                  for (var reply in context
                      .watch<Home>()
                      .Recipe[context.watch<Reply>().selected_index]['reply']
                      .reversed
                      .toList())
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(children: [
                          Row(children: [
                            Container(
                              width: 15,
                            ),
                            // 프로필 이미지가 없는 경우
                            if (reply['profileimage'] == "")
                              CircleAvatar(
                                  radius: 15,
                                  backgroundColor:
                                      Color.fromRGBO(220, 220, 220, 1),
                                  foregroundColor: Colors.white,
                                  child: Icon(
                                    Icons.person,
                                  )),
                            // 프로필 이미지가 있는 경우
                            if (reply['profileimage'] != "")
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    NetworkImage(reply['profileimage']),
                              ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 50,
                                  bottom: 5),
                              child: Text('${reply['nickname']} ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(40, 40, 40, 1),
                                  )),
                            ),
                          ]),
                          Container(
                            padding: EdgeInsets.only(
                                left:
                                    MediaQuery.of(context).size.width / 7 - 2),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              '${reply['content']}',
                              style: TextStyle(
                                color: Color.fromRGBO(40, 40, 40, 1),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left:
                                    MediaQuery.of(context).size.width / 7 - 2),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "${DateTime.parse(context.watch<Home>().Recipe[context.watch<Reply>().selected_index]['createdAt'].toDate().toString()).month}월 ${DateTime.parse(context.watch<Home>().Recipe[context.watch<Reply>().selected_index]['createdAt'].toDate().toString()).day}일",
                              style: TextStyle(
                                fontSize: 10,
                                color: Color.fromRGBO(40, 40, 40, 1),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ]),
                      ),
                    ),
              ],
            ),
          ),
        ),
        // // 상세 하단 경계선
        Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            child: Divider(color: Colors.grey[300], thickness: 1.0)),
        if (auth.currentUser != null) // 로그인한 경우만 댓글
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            width: MediaQuery.of(context).size.width - 30,
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '댓글을 입력해주세요.',
                contentPadding: EdgeInsets.only(
                  top: 20,
                  left: 15,
                ),
                suffixIcon: TextButton(
                  onPressed: () {
                    context.read<Home>().top_index == 1
                        ? (context.read<Reply>().replyComplete(
                            context
                                    .read<Home>()
                                    .Feed[context.read<Reply>().selected_index]
                                ['id'],
                            context.read<Home>().User[0],
                            auth,
                            context,
                            context.read<Home>().top_index))
                        : (context.read<Home>().top_index == 2
                            ? (context.read<Reply>().replyComplete(
                                context.read<Home>().Freetalk[
                                    context.read<Reply>().selected_index]['id'],
                                context.read<Home>().User[0],
                                auth,
                                context,
                                context.read<Home>().top_index))
                            : (context.read<Reply>().replyComplete(
                                context.read<Home>().Recipe[
                                    context.read<Reply>().selected_index]['id'],
                                context.read<Home>().User[0],
                                auth,
                                context,
                                context.read<Home>().top_index)));
                  },
                  child: Text('등록',
                      style: TextStyle(color: Color.fromRGBO(201, 92, 57, 1))),
                ),
              ),
              style: TextStyle(fontSize: 13),
              onChanged: (text) {
                // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
                context.read<Reply>().setReply(text);
              },
            ),
          ),
        Container(
          height: 20,
        ),
      ]),
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

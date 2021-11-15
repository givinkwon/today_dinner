import 'dart:convert';

// flexible grid with image that fetch from server
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// provider listener 이용
import 'package:flutter/foundation.dart';
import 'package:today_dinner/providers/recipe.dart';
import 'package:today_dinner/providers/reply.dart';
import './login.dart';
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

// Feed 기본 Class => 피드 / 자유 게시판 / 식사
class Feed extends StatefulWidget {
  final int index;
  Feed(this.index);
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  // 좋아요 함수
  void Like_Click(like_check, index) async {
    var id = "";
    // 좋아요 되어 있지 않은 경우
    if (like_check == false) {
      // Feed
      if (context.read<Home>().top_index == 1) {
        id = context.read<Home>().Feed[index]['id'];
      }
      if (context.read<Home>().top_index == 2) {
        id = context.read<Home>().Freetalk[index]['id'];
      }
      context
          .read<Home>()
          .add_like(auth, auth.currentUser?.email, id)
          .then((_) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("좋아요 완료"),
                content: new Text("해당 글에 좋아요 했습니다."),
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
      });
    }
    // 이미 좋아요 되어 있는 경우
    if (like_check == true) {
      // Feed
      if (context.read<Home>().top_index == 1) {
        id = context.read<Home>().Feed[index]['id'];
      }
      if (context.read<Home>().top_index == 2) {
        id = context.read<Home>().Freetalk[index]['id'];
      }
      context
          .read<Home>()
          .remove_like(auth, auth.currentUser?.email, id)
          .then((_) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("좋아요 취소 완료"),
                content: new Text("해당 글에 좋아요 취소했습니다."),
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
      });
    }
  }

  // 피드 이미지 저장하는 함수
  Future<void> Bookmark_Click(bookmark_check, index) async {
    var id = "";
    // 좋아요 되어 있지 않은 경우
    if (bookmark_check == false) {
      // Feed
      if (context.read<Home>().top_index == 1) {
        id = context.read<Home>().Feed[index]['id'];
      }
      if (context.read<Home>().top_index == 2) {
        id = context.read<Home>().Freetalk[index]['id'];
      }
      if (context.read<Home>().top_index == 3) {
        id = context.read<Home>().Recipe[index]['id'];
      }
      context
          .read<Home>()
          .add_bookmark(auth, auth.currentUser?.email, id)
          .then((_) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("스크랩 완료"),
                content: new Text("해당 글을 스크랩 했습니다."),
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
      });
    }
    // 이미 좋아요 되어 있는 경우
    if (bookmark_check == true) {
      // Feed
      if (context.read<Home>().top_index == 1) {
        id = context.read<Home>().Feed[index]['id'];
      }
      if (context.read<Home>().top_index == 2) {
        id = context.read<Home>().Freetalk[index]['id'];
      }
      if (context.read<Home>().top_index == 3) {
        id = context.read<Home>().Recipe[index]['id'];
      }

      context
          .read<Home>()
          .remove_bookmark(auth, auth.currentUser?.email, id)
          .then((_) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("스크랩 취소 완료"),
                content: new Text("해당 글을 스크랩 취소했습니다."),
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
      });
    }
  }

  // 선택된 필터가 있으면 필터에 부합하는 데이터만 노출
  void checkfilter(int index) async {
    // true 값으로 init
    context.watch<Home>().check = true;
    if (context.watch<Home>().Selected_list.length > 0) {
      // 필터가 있으면 false로 바꾸기
      context.watch<Home>().check = false;

      // Feed의 경우
      if (context.watch<Home>().top_index == 1) {
        for (var data in context.watch<Home>().Feed[index]['filter']) {
          for (var selected in context.watch<Home>().Selected_list) {
            print(data);
            print(selected);
            if (data.indexOf(selected) == 0) {
              // 피드에 포함된 필터가 선택되어 있는 경우에는 다시 true로 return
              context.watch<Home>().check = true;
            }
          }
        }
      }
      // Freetalk의 경우
      if (context.watch<Home>().top_index == 2) {
        for (var data in context.watch<Home>().Freetalk[index]['filter']) {
          for (var selected in context.watch<Home>().Selected_list) {
            print(data);
            print(selected);
            if (data.indexOf(selected) == 0) {
              // 피드에 포함된 필터가 선택되어 있는 경우에는 다시 true로 return
              context.watch<Home>().check = true;
            }
          }
        }
      }
      // Recipe의 경우
      if (context.watch<Home>().top_index == 3) {
        for (var data in context.watch<Home>().Recipe[index]['filter']) {
          for (var selected in context.watch<Home>().Selected_list) {
            print(data);
            print(selected);
            if (data.indexOf(selected) == 0) {
              // 피드에 포함된 필터가 선택되어 있는 경우에는 다시 true로 return
              context.watch<Home>().check = true;
            }
          }
        }
      }
    }
  }

  // 검색어가 있으면 검색어에 부합하는 데이터만 노출
  void checksearch(int index) async {
    // true 값으로 init
    context.watch<Home>().checksearch = true;
    if (context.watch<Home>().Searchtext.length > 0) {
      // 검색어가 있으면 false로 바꾸기
      context.watch<Home>().check = false;
      print(context.watch<Home>().Feed[index]);
      // Feed의 경우
      if (context.watch<Home>().top_index == 1) {
        if (context
            .watch<Home>()
            .Feed[index]['nickname']
            .contains(context.watch<Home>().Searchtext)) {
          context.watch<Home>().check = true;
        }
        if (context.watch<Home>().Feed[index]['filter'] != null &&
            context
                .watch<Home>()
                .Feed[index]['filter']
                .contains(context.watch<Home>().Searchtext)) {
          context.watch<Home>().check = true;
        }
        if (context
            .watch<Home>()
            .Feed[index]['content']
            .contains(context.watch<Home>().Searchtext)) {
          context.watch<Home>().check = true;
        }
      }

      // Freetalk의 경우
      if (context.watch<Home>().top_index == 2) {
        if (context
            .watch<Home>()
            .Freetalk[index]['nickname']
            .contains(context.watch<Home>().Searchtext)) {
          context.watch<Home>().check = true;
        }
        if (context.watch<Home>().Freetalk[index]['filter'] != null &&
            context
                .watch<Home>()
                .Freetalk[index]['filter']
                .contains(context.watch<Home>().Searchtext)) {
          context.watch<Home>().check = true;
        }
        if (context
            .watch<Home>()
            .Freetalk[index]['content']
            .contains(context.watch<Home>().Searchtext)) {
          context.watch<Home>().check = true;
        }
      }

      // Recipe의 경우
      if (context.watch<Home>().top_index == 3) {
        if (context
            .watch<Home>()
            .Recipe[index]['nickname']
            .contains(context.watch<Home>().Searchtext)) {
          context.watch<Home>().check = true;
        }
        if (context.watch<Home>().Recipe[index]['filter'] != null &&
            context
                .watch<Home>()
                .Recipe[index]['filter']
                .contains(context.watch<Home>().Searchtext)) {
          context.watch<Home>().check = true;
        }
        if (context
            .watch<Home>()
            .Recipe[index]['title']
            .contains(context.watch<Home>().Searchtext)) {
          context.watch<Home>().check = true;
        }
      }
    }
  }

  //init
  bool like_check = false;
  bool bookmark_check = false;
  @override
  Widget build(BuildContext context) {
    // print(_Feed[widget.index]);
    print(context.watch<Home>().User);

    // 데이터 로딩이 완료된 후에 렌더링
    if (context.watch<Home>().Feed_image_loading == true &&
        context.watch<Home>().Feed_profileimage_loading == true &&
        context.watch<Home>().Freetalk_image_loading == true &&
        context.watch<Home>().Freetalk_profileimage_loading == true &&
        context.watch<Home>().Recipe_content_loading == true &&
        context.watch<Home>().Recipe_profileimage_loading == true) {
      // 필터 체크하는 함수
      checkfilter(widget.index);
      // 검색어 체크하는 함수
      checksearch(widget.index);
      if (context.watch<Home>().check) {
        if (context.watch<Home>().checksearch) {
          if (context.watch<Home>().top_index == 1) {
            if (context.watch<Home>().Feed[widget.index]['like'] != null) {
              for (var like_id in context.watch<Home>().Feed[widget.index]
                  ['like']) {
                if (like_id['value'] == auth.currentUser?.email) {
                  like_check = true;
                }
              }
            }
            if (context.watch<Home>().Feed[widget.index]['bookmark'] != null) {
              print(context.watch<Home>().Feed[widget.index]['bookmark']);
              for (var bookmark_id in context.watch<Home>().Feed[widget.index]
                  ['bookmark']) {
                if (bookmark_id['value'] == auth.currentUser?.email) {
                  bookmark_check = true;
                }
              }
            }
          }

          if (context.watch<Home>().top_index == 2) {
            if (context.watch<Home>().Freetalk[widget.index]['like'] != null) {
              for (var like_id in context.watch<Home>().Freetalk[widget.index]
                  ['like']) {
                if (like_id['value'] == auth.currentUser?.email) {
                  like_check = true;
                }
              }
            }
            if (context.watch<Home>().Freetalk[widget.index]['bookmark'] !=
                null) {
              print(context.watch<Home>().Freetalk[widget.index]['bookmark']);
              for (var bookmark_id
                  in context.watch<Home>().Freetalk[widget.index]['bookmark']) {
                if (bookmark_id['value'] == auth.currentUser?.email) {
                  bookmark_check = true;
                }
              }
            }
          }
          if (context.watch<Home>().top_index == 3) {
            if (context.watch<Home>().Recipe[widget.index]['like'] != null) {
              for (var like_id in context.watch<Home>().Recipe[widget.index]
                  ['like']) {
                if (like_id['value'] == auth.currentUser?.email) {
                  like_check = true;
                }
              }
            }
            if (context.watch<Home>().Recipe[widget.index]['bookmark'] !=
                null) {
              print(context.watch<Home>().Recipe[widget.index]['bookmark']);
              for (var bookmark_id in context.watch<Home>().Recipe[widget.index]
                  ['bookmark']) {
                if (bookmark_id['value'] == auth.currentUser?.email) {
                  bookmark_check = true;
                }
              }
            }
          }

          return Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 20,
                ),
                Row(children: [
                  SizedBox(
                    width: 20,
                  ),
                  // profileimage가 있을 때
                  if (context
                              .watch<Home>()
                              .Feed[widget.index]['profileimage']
                              .length >
                          0 &&
                      context.watch<Home>().Feed[widget.index]['profileimage']
                              [0] !=
                          "")
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(context
                          .watch<Home>()
                          .Feed[widget.index]['profileimage'][0]),
                    ), // profileimage가 없을 때
                  if (context
                              .watch<Home>()
                              .Feed[widget.index]['profileimage']
                              .length >
                          0 &&
                      context.watch<Home>().Feed[widget.index]['profileimage']
                              [0] ==
                          "")
                    CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.purple,
                        child: Icon(Icons.people)),
                  if (context.watch<Home>().top_index != 3)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          context.watch<Home>().top_index == 1
                              ? (context.watch<Home>().Feed[widget.index]
                                  ['nickname'])
                              : (context.watch<Home>().Freetalk[widget.index]
                                  ['nickname']),
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ),
                ]),
                Container(
                  height: 20,
                ),

                // feed image
                if (context.watch<Home>().top_index == 1)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var image in context
                            .watch<Home>()
                            .Feed[widget.index]['image'])
                          Container(
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(
                                image['value'],
                                fit: BoxFit.fitWidth,
                              )),
                      ],
                    ),
                  ),

                // freetalk image
                if (context.watch<Home>().top_index == 2)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var image in context
                            .watch<Home>()
                            .Freetalk[widget.index]['image'])
                          Container(
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(
                                image['value'],
                                fit: BoxFit.fitWidth,
                              )),
                      ],
                    ),
                  ),

                // recip image
                if (context.watch<Home>().top_index == 3)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            // 데이터 전달하기
                            context.read<Recipe>().select_data(
                                context.read<Home>().Recipe[widget.index]);
                            // 페이지 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RecipePage()),
                            );
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(
                                context.watch<Home>().Recipe[widget.index]
                                    ['mainimage'],
                                fit: BoxFit.fitWidth,
                              )),
                        ),
                      ],
                    ),
                  ),

                // 제목
                if (context.watch<Home>().top_index == 3)
                  Text(
                    context.watch<Home>().Recipe[widget.index]['title'],
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                // 레시피 작성자
                if (context.watch<Home>().top_index == 3)
                  Text(
                    context.watch<Home>().Recipe[widget.index]['user'],
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),

                // 피드 아이콘 => 좋아요 / 댓글 / 북마크
                if (context.watch<Home>().top_index != 3)
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: like_check == true
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border),
                        onPressed: () {
                          Like_Click(like_check, widget.index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.question_answer_outlined),
                        onPressed: () {
                          // index 설정
                          context.read<Reply>().select_index(widget.index);
                          // 페이지 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReplyPage()),
                          );
                        },
                      ),
                      IconButton(
                        icon: bookmark_check == true
                            ? Icon(Icons.bookmark_add)
                            : Icon(Icons.bookmark_add_outlined),
                        onPressed: () {
                          Bookmark_Click(bookmark_check, widget.index);
                        },
                      ),
                    ],
                  ),
                // 좋아요 개수
                if (context.watch<Home>().top_index != 3 &&
                    context.watch<Home>().Feed[widget.index]['like'] != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        context.watch<Home>().top_index == 1
                            ? ("좋아요" +
                                context
                                    .watch<Home>()
                                    .Feed[widget.index]['like']
                                    .length
                                    .toString() +
                                "개")
                            : (context.watch<Home>().top_index == 2
                                ? ("좋아요" +
                                    context
                                        .watch<Home>()
                                        .Freetalk[widget.index]['like']
                                        .length
                                        .toString() +
                                    "개")
                                : ("좋아요" +
                                    context
                                        .watch<Home>()
                                        .Recipe[widget.index]['like']
                                        .length
                                        .toString() +
                                    "개")),
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                // 아이디
                if (context.watch<Home>().top_index != 3)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        context.watch<Home>().top_index == 1
                            ? (context.watch<Home>().Feed[widget.index]
                                ['nickname'])
                            : (context.watch<Home>().Freetalk[widget.index]
                                ['nickname']),
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ),
                // 본문 내용
                if (context.read<Home>().top_index != 3)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        context.watch<Home>().top_index == 1
                            ? (context.watch<Home>().Feed[widget.index]
                                ['content'])
                            : context.watch<Home>().Freetalk[widget.index]
                                ['content'],
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                // Feed 댓글 2개 이상일 때
                if (context.watch<Home>().top_index == 1 &&
                    context.watch<Home>().Feed[widget.index]['reply'] != null &&
                    context.watch<Home>().Feed[widget.index]['reply'].length >
                        2)
                  GestureDetector(
                    onTap: () async {
                      // index 설정
                      context.read<Reply>().select_index(widget.index);
                      // 페이지 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReplyPage()),
                      );
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                            '댓글 ${context.watch<Home>().Feed[widget.index]['reply'].length}개 모두 보기'),
                      ),
                    ),
                  ),

                // Start : Feed 댓글 2개 미리보기 => 2개 이하인 경우에는 전부 / 2개 이상인 경우에는 2개만
                if (context.watch<Home>().top_index == 1 &&
                    context.watch<Home>().Feed[widget.index]['reply'] != null &&
                    context.watch<Home>().Feed[widget.index]['reply'].length !=
                        0 &&
                    context.watch<Home>().Feed[widget.index]['reply'].length <
                        3)
                  for (var reply in context.watch<Home>().Feed[widget.index]
                      ['reply'])
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(children: [
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
                if (context.watch<Home>().top_index == 1 &&
                    context.watch<Home>().Feed[widget.index]['reply'] != null &&
                    context.watch<Home>().Feed[widget.index]['reply'].length !=
                        0 &&
                    context.watch<Home>().Feed[widget.index]['reply'].length >
                        2)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(children: [
                      Row(children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                              '${context.watch<Home>().Feed[widget.index]['reply'][0]['nickname']} ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                              '${context.watch<Home>().Feed[widget.index]['reply'][0]['content']}'),
                        ),
                      ]),
                      Row(children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                              '${context.watch<Home>().Feed[widget.index]['reply'][1]['nickname']} ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                              '${context.watch<Home>().Feed[widget.index]['reply'][1]['content']}'),
                        ),
                      ]),
                    ]),
                  ),

                // End : Feed 댓글 2개 미리보기 => 2개 이하인 경우에는 전부 / 2개 이상인 경우에는 2개만

                // Freetalk 댓글
                if (context.watch<Home>().top_index == 2 &&
                    context.watch<Home>().Freetalk[widget.index]['reply'] !=
                        null &&
                    context
                            .watch<Home>()
                            .Freetalk[widget.index]['reply']
                            .length >
                        2)
                  GestureDetector(
                    onTap: () async {
                      // 페이지 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReplyPage()),
                      );
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                            '댓글 ${context.watch<Home>().Freetalk[widget.index]['reply'].length}개 모두 보기'),
                      ),
                    ),
                  ),

                // Start : Freetalk 댓글 2개 미리보기 => 2개 이하인 경우에는 전부 / 2개 이상인 경우에는 2개만
                if (context.watch<Home>().top_index == 2 &&
                    context.watch<Home>().Freetalk[widget.index]['reply'] !=
                        null &&
                    context
                            .watch<Home>()
                            .Freetalk[widget.index]['reply']
                            .length !=
                        0 &&
                    context
                            .watch<Home>()
                            .Freetalk[widget.index]['reply']
                            .length <
                        3)
                  for (var reply in context.watch<Home>().Freetalk[widget.index]
                      ['reply'])
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(children: [
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
                if (context.watch<Home>().top_index == 2 &&
                    context.watch<Home>().Freetalk[widget.index]['reply'] !=
                        null &&
                    context
                            .watch<Home>()
                            .Freetalk[widget.index]['reply']
                            .length !=
                        0 &&
                    context
                            .watch<Home>()
                            .Freetalk[widget.index]['reply']
                            .length >
                        2)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(children: [
                      Row(children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                              '${context.watch<Home>().Freetalk[widget.index]['reply'][0]['nickname']} ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                              '${context.watch<Home>().Freetalk[widget.index]['reply'][0]['content']}'),
                        ),
                      ]),
                      Row(children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                              '${context.watch<Home>().Freetalk[widget.index]['reply'][1]['nickname']} ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                              '${context.watch<Home>().Freetalk[widget.index]['reply'][1]['content']}'),
                        ),
                      ]),
                    ]),
                  ),

                // End : Freetalk 댓글 2개 미리보기 => 2개 이하인 경우에는 전부 / 2개 이상인 경우에는 2개만
              ],
            ),
          );
        } else {
          return Container(
            width: 0,
            height: 0,
          );
        }
      } else {
        return Container(
          width: 0,
          height: 0,
        );
      }
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }
}

// SelectedFilter 기본 class => 선택된 필터 종류 보여주는 박스
class SelectedFilter extends StatefulWidget {
  @override
  _SelectedFilterState createState() => _SelectedFilterState();
}

class _SelectedFilterState extends State<SelectedFilter> {
  @override
  Widget build(BuildContext context) {
    if (context.watch<Home>().Selected_list.length > 0) {
      return Container(
        height: 70.0,
        child: GridView.builder(
          padding: EdgeInsets.all(5.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 3.0,
            mainAxisSpacing: 20.0,
            childAspectRatio: 0.38,
          ),
          itemCount: context.watch<Home>().Selected_list.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, int index) {
            return Row(children: <Widget>[
              Text(
                context.watch<Home>().Selected_list[index],
                style: TextStyle(fontSize: 14, color: Colors.purple),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  context
                      .read<Home>()
                      .remove_list(context.read<Home>().Selected_list[index]);
                },
              ),
            ]);
          },
        ),
      );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }
}

// Filter 기본 class
class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  // bottomSheet 함수 => 1차 메뉴
  void _showbottom(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: new Text('식사'),
                onTap: () async {
                  _showbottomMeal(context);
                },
              ),
              ListTile(
                title: new Text('종류'),
                onTap: () {
                  _showbottomCategory(context);
                },
              ),
              ListTile(
                title: new Text('식재료'),
                onTap: () {
                  _showbottomFood(context);
                },
              ),
            ],
          );
        });
  }

  // bottomSheet 함수 => 2차 메뉴 : 식사
  void _showbottomMeal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (var data in context.watch<Home>().Meal)
                ListTile(
                  title: new Text(data['value']),
                  onTap: () {
                    context.read<Home>().add_list(data['value']);
                    // 2단계 종료
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
            ],
          );
        });
  }

  // bottomSheet 함수 => 2차 메뉴 : 종류
  void _showbottomCategory(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (var data in context.watch<Home>().Type)
                    ListTile(
                      title: new Text(data['value']),
                      onTap: () {
                        context.read<Home>().add_list(data['value']);
                        // 2단계 종료
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
            ],
          );
        });
  }

  // bottomSheet 함수 => 2차 메뉴 : 식재료
  void _showbottomFood(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 0;
                  i < context.watch<Home>().Ingredients_id.length;
                  i++)
                ListTile(
                  title: new Text(context.watch<Home>().Ingredients_id[i]),
                  onTap: () {
                    _showbottomFoodSecondary(i);
                  },
                ),
            ],
          );
        });
  }

  // bottomSheet 함수 => 3차 메뉴 : 식재료
  void _showbottomFoodSecondary(int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView(children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (var key in context.watch<Home>().Ingredients[index].keys)
                  ListTile(
                    title: new Text(key),
                    onTap: () {
                      context.read<Home>().add_list(key);
                      // 3단계 종료
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Icon(
              Icons.filter_alt,
              color: Colors.purple,
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                _showbottom(context);
              },
              child: Row(
                children: <Widget>[
                  Text(
                    '식사',
                    style: TextStyle(fontSize: 18, color: Colors.purple),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.purple),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                _showbottom(context);
              },
              child: Row(
                children: <Widget>[
                  Text(
                    '종류',
                    style: TextStyle(fontSize: 18, color: Colors.purple),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.purple),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                _showbottom(context);
              },
              child: Row(
                children: <Widget>[
                  Text(
                    '식재료',
                    style: TextStyle(fontSize: 18, color: Colors.purple),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.purple),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// TopBar 기본 class
class TopBar extends StatefulWidget {
  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                context.read<Home>().select_top(1);
                setState(() {});
              },
              child: Column(
                children: <Widget>[
                  Text(
                    '식사',
                    style: TextStyle(
                        fontSize: 18,
                        color: context.watch<Home>().top_index == 1
                            ? Colors.purple
                            : Colors.grey),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border(
                          bottom: BorderSide(
                              width: context.watch<Home>().top_index == 1
                                  ? 3.0
                                  : 2.0,
                              color: context.watch<Home>().top_index == 1
                                  ? Colors.purple
                                  : Colors.grey)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                context.read<Home>().select_top(2);
                setState(() {});
              },
              child: Column(
                children: <Widget>[
                  Text(
                    '자유 수다방',
                    style: TextStyle(
                        fontSize: 18,
                        color: context.watch<Home>().top_index ==
                                2 // 수정 시 재빌드하기 위해서는 watch를 사용
                            ? Colors.purple
                            : Colors.grey),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border(
                          bottom: BorderSide(
                              width: context.watch<Home>().top_index == 2
                                  ? 3.0
                                  : 2.0,
                              color: context.watch<Home>().top_index == 2
                                  ? Colors.purple
                                  : Colors.grey)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                context.read<Home>().select_top(3);
                setState(() {});
              },
              child: Column(
                children: <Widget>[
                  Text(
                    '레시피',
                    style: TextStyle(
                        fontSize: 18,
                        color: context.watch<Home>().top_index == 3
                            ? Colors.purple
                            : Colors.grey),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border(
                          bottom: BorderSide(
                              width: context.watch<Home>().top_index == 3
                                  ? 3.0
                                  : 2.0,
                              color: context.watch<Home>().top_index == 3
                                  ? Colors.purple
                                  : Colors.grey)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// appbar 지우기
class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}

// 로그인 기본 class
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // 로그인 상태인지 확인
    print(auth.currentUser);
    if (auth.currentUser != null) {
      print(auth.currentUser!.email);
    }

    context.read<Home>().get_data(auth.currentUser?.email);
    // listener를 추가하여 비동기 변경이 발생했을 때 수정할 수 있도록 changeNotifier를 듣고 있음
    if (mounted) {
      Provider.of<Home>(context, listen: false).addListener(() => setState(() {
            print("리렌더링");
          }));
    }
  }

  // bookmark icon 클릭했을 때
  Future<void> _onBookmarkButtonPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScrapPage()),
    );
  }

  // shopping icon 클릭했을 때
  Future<void> _onShoppingButtonPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShoppingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 그리드 뷰 이미지
    List<String> images = [
      "assets/main.jpg",
    ];

    return Scaffold(
      appBar: EmptyAppBar(),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.black38.withAlpha(10),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "레시피를 검색해보세요.",
                                hintStyle: TextStyle(
                                  color: Colors.black.withAlpha(120),
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (text) {
                                // // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
                                context.read<Home>().setSearchText(text);
                              },
                            ),
                          ),
                          GestureDetector(
                              onTap: () async {
                                setState(() {});
                              },
                              child: Icon(
                                Icons.search,
                                color: Colors.black.withAlpha(120),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // 메인 상단 메뉴
          TopBar(),
          // 필터
          Filter(),
          // 필터 선택 tagbox
          SelectedFilter(),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: context.read<Home>().top_index == 1
                    ? (context.read<Home>().Feed.length)
                    : (context.read<Home>().top_index == 2
                        ? context.read<Home>().Freetalk.length
                        : context.read<Home>().Recipe.length),
                itemBuilder: (BuildContext context, int index) {
                  return Feed(index);
                }),
          ),
        ],
      ),
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

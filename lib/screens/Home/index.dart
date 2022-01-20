// import 'dart:async';
// import 'dart:convert';

// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/widgets.dart';
// import 'package:provider/provider.dart';
// // provider listener 이용
// import 'package:flutter/foundation.dart';
// import 'package:today_dinner/providers/profile.dart';
// import 'package:today_dinner/providers/recipe.dart';
// import 'package:today_dinner/providers/reply.dart';
// import './login.dart';
// import 'package:today_dinner/screens/Scrap/index.dart';
// import 'package:today_dinner/screens/Recipe/index.dart';
// import 'package:today_dinner/screens/Shopping/index.dart';
// import 'package:today_dinner/screens/Write/index.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:today_dinner/screens/Reply/index.dart';
// import 'package:today_dinner/screens/Mypage/index.dart';
// import 'package:today_dinner/screens/Login/index.dart';

// // provider => watch는 값이 변화할 때 리렌더링, read는 값이 변화해도 렌더링 x
// // => watch는 값을 보여주는 UI에 read는 변경이 필요없는 함수에 주로 사용
// import 'package:today_dinner/providers/home.dart';
// import 'package:today_dinner/providers/write.dart';

// // firestorage.List feed_image = firestorage.ref('20210917_164240.jpg');
// // var url = firestorage.ref('20210917_164240.jpg').getDownloadURL();

// // firebase auth
// import 'package:firebase_auth/firebase_auth.dart';

// // youtube
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// FirebaseAuth auth = FirebaseAuth.instance;

// FirebaseAnalytics analytics = FirebaseAnalytics.instance;

// // youtube video
// class Player extends StatefulWidget {
//   @override
//   _PlayerState createState() => _PlayerState();
// }

// class _PlayerState extends State<Player> {
//   late YoutubePlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = YoutubePlayerController(
//       initialVideoId: 'iLnmTe5Q2Qw',
//       flags: const YoutubePlayerFlags(
//         mute: true,
//         autoPlay: true,
//         disableDragSeek: true,
//         loop: false,
//         isLive: false,
//         forceHD: false,
//         enableCaption: true,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 300,
//       child: Column(children: [
//         YoutubePlayer(
//           key: ObjectKey(_controller),
//           controller: _controller,
//           actionsPadding: const EdgeInsets.only(left: 16.0),
//           bottomActions: [
//             CurrentPosition(),
//             const SizedBox(width: 10.0),
//             ProgressBar(isExpanded: true),
//             const SizedBox(width: 10.0),
//             RemainingDuration(),
//             //FullScreenButton(),
//           ],
//         ),
//         TextButton(
//           onPressed: () {
//             _controller.seekTo(Duration(seconds: 50));
//           },
//           style: TextButton.styleFrom(
//               primary: Color.fromRGBO(201, 92, 57, 1),
//               backgroundColor: Colors.white,
//               side:
//                   BorderSide(color: Color.fromRGBO(201, 92, 57, 1), width: 2)),
//           child: Text(
//             "이동하기",
//             style:
//                 TextStyle(fontSize: 12, color: Color.fromRGBO(201, 92, 57, 1)),
//           ),
//         ),
//       ]),
//     );
//   }
// }

// // Feed 기본 Class => 피드 / 자유 게시판 / 식사
// class Feed extends StatefulWidget {
//   final int index;
//   Feed(this.index);

//   @override
//   _FeedState createState() => _FeedState();
// }

// class _FeedState extends State<Feed> {
//   // bottomSheet 함수 => 글 클릭 시
//   void _showbottomContent(BuildContext context, String userdata) {
//     showModalBottomSheet(
//         context: context,
//         builder: (context) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               ListTile(
//                 title: new Text('이 사용자 신고하기'),
//                 onTap: () async {
//                   _showbottomPolicePerson(context);
//                 },
//               ),
//               ListTile(
//                 title: new Text('이 게시글 신고하기'),
//                 onTap: () async {
//                   _showbottomPoliceWrite(context);
//                 },
//               ),
//               if (userdata != '')
//                 ListTile(
//                   title: new Text('이 사용자의 글 보지 않기'),
//                   onTap: () async {
//                     // 미가입 시
//                     if (auth.currentUser == null) {
//                       showDialog(
//                           context: context,
//                           barrierDismissible: false,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: new Text("로그인"),
//                               content: new Text("로그인이 필요합니다."),
//                               actions: <Widget>[
//                                 new FlatButton(
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => LoginPage()),
//                                     );
//                                   },
//                                   child: new Text("로그인 페이지로 이동"),
//                                 ),
//                               ],
//                             );
//                           });
//                     } else {
//                       context.read<Profile>().AddBlacklist(
//                           context, auth.currentUser!.email, userdata);
//                     }
//                   },
//                 ),
//             ],
//           );
//         });
//   }

// // bottomSheet 함수 => 사용자 신고하기 클릭 시
//   void _showbottomPolicePerson(BuildContext context) {
//     showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (context) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               ListTile(
//                 title: new Text("비매너 사용자에요"),
//                 onTap: () async {
//                   await showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: new Text("신고되었습니다."),
//                           content: new Text("담당자가 확인 후 조치하도록 하겠습니다."),
//                           actions: <Widget>[
//                             new FlatButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: new Text("닫기"),
//                             ),
//                           ],
//                         );
//                       });
//                   // 2단계 종료
//                   Navigator.pop(context);
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: new Text("욕설을 해요"),
//                 onTap: () async {
//                   await showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: new Text("신고되었습니다."),
//                           content: new Text("담당자가 확인 후 조치하도록 하겠습니다."),
//                           actions: <Widget>[
//                             new FlatButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: new Text("닫기"),
//                             ),
//                           ],
//                         );
//                       });
//                   // 2단계 종료
//                   Navigator.pop(context);
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: new Text("성희롱을 해요"),
//                 onTap: () async {
//                   await showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: new Text("신고되었습니다."),
//                           content: new Text("담당자가 확인 후 조치하도록 하겠습니다."),
//                           actions: <Widget>[
//                             new FlatButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: new Text("닫기"),
//                             ),
//                           ],
//                         );
//                       });
//                   // 2단계 종료
//                   Navigator.pop(context);
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: new Text("사기 사용자에요"),
//                 onTap: () {
//                   showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: new Text("신고되었습니다."),
//                           content: new Text("담당자가 확인 후 조치하도록 하겠습니다."),
//                           actions: <Widget>[
//                             new FlatButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: new Text("닫기"),
//                             ),
//                           ],
//                         );
//                       });
//                   // 2단계 종료
//                   Navigator.pop(context);
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: new Text("기타"),
//                 onTap: () {
//                   showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: new Text("신고되었습니다."),
//                           content: new Text("담당자가 확인 후 조치하도록 하겠습니다."),
//                           actions: <Widget>[
//                             new FlatButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: new Text("닫기"),
//                             ),
//                           ],
//                         );
//                       });
//                   // 2단계 종료
//                   Navigator.pop(context);
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           );
//         });
//   }

// // bottomSheet 함수 => 사용자 신고하기 클릭 시
//   void _showbottomPoliceWrite(BuildContext context) {
//     showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (context) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               ListTile(
//                 title: new Text("부적절한 글이에요."),
//                 onTap: () async {
//                   await showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: new Text("신고되었습니다."),
//                           content: new Text("담당자가 확인 후 조치하도록 하겠습니다."),
//                           actions: <Widget>[
//                             new FlatButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: new Text("닫기"),
//                             ),
//                           ],
//                         );
//                       });
//                   // 2단계 종료
//                   Navigator.pop(context);
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: new Text("부당하게 비방하거나 모욕하는 글이에요."),
//                 onTap: () async {
//                   await showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: new Text("신고되었습니다."),
//                           content: new Text("담당자가 확인 후 조치하도록 하겠습니다."),
//                           actions: <Widget>[
//                             new FlatButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: new Text("닫기"),
//                             ),
//                           ],
//                         );
//                       });
//                   // 2단계 종료
//                   Navigator.pop(context);
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: new Text("중복/도배 글이에요"),
//                 onTap: () async {
//                   await showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: new Text("신고되었습니다."),
//                           content: new Text("담당자가 확인 후 조치하도록 하겠습니다."),
//                           actions: <Widget>[
//                             new FlatButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: new Text("닫기"),
//                             ),
//                           ],
//                         );
//                       });
//                   // 2단계 종료
//                   Navigator.pop(context);
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: new Text("기타"),
//                 onTap: () {
//                   showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: new Text("신고되었습니다."),
//                           content: new Text("담당자가 확인 후 조치하도록 하겠습니다."),
//                           actions: <Widget>[
//                             new FlatButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: new Text("닫기"),
//                             ),
//                           ],
//                         );
//                       });
//                   // 2단계 종료
//                   Navigator.pop(context);
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           );
//         });
//   }

//   // 좋아요 함수
//   void Like_Click(like_check, index) async {
//     var id = "";
//     // 좋아요 되어 있지 않은 경우
//     if (like_check == false) {
//       // Feed
//       if (context.watch<Home>().top_index == 1) {
//         id = context.watch<Home>().Feed[index]['id'];
//       }
//       if (context.watch<Home>().top_index == 2) {
//         id = context.watch<Home>().Freetalk[index]['id'];
//       }
//       context
//           .read<Home>()
//           .add_like(auth, auth.currentUser?.email, id)
//           .then((_) {
//         // showDialog(
//         //     context: context,
//         //     barrierDismissible: false,
//         //     builder: (BuildContext context) {
//         //       return AlertDialog(
//         //         title: new Text("좋아요 완료"),
//         //         content: new Text("해당 글에 좋아요 했습니다."),
//         //         actions: <Widget>[
//         //           new FlatButton(
//         //             onPressed: () {
//         //               Navigator.pop(context);
//         //             },
//         //             child: new Text("닫기"),
//         //           ),
//         //         ],
//         //       );
//         //     });
//       });
//     }
//     // 이미 좋아요 되어 있는 경우
//     if (like_check == true) {
//       // Feed
//       if (context.watch<Home>().top_index == 1) {
//         id = context.watch<Home>().Feed[index]['id'];
//       }
//       if (context.watch<Home>().top_index == 2) {
//         id = context.watch<Home>().Freetalk[index]['id'];
//       }
//       context
//           .read<Home>()
//           .remove_like(auth, auth.currentUser?.email, id)
//           .then((_) {
//         // showDialog(
//         //     context: context,
//         //     barrierDismissible: false,
//         //     builder: (BuildContext context) {
//         //       return AlertDialog(
//         //         title: new Text("좋아요 취소 완료"),
//         //         content: new Text("해당 글에 좋아요 취소했습니다."),
//         //         actions: <Widget>[
//         //           new FlatButton(
//         //             onPressed: () {
//         //               Navigator.pop(context);
//         //             },
//         //             child: new Text("닫기"),
//         //           ),
//         //         ],
//         //       );
//         //     });
//       });
//     }
//   }

//   // 피드 이미지 저장하는 함수
//   Future<void> Bookmark_Click(bookmark_check, index) async {
//     var id = "";
//     // 좋아요 되어 있지 않은 경우
//     if (bookmark_check == false) {
//       // Feed
//       if (context.read<Home>().top_index == 1) {
//         id = context.read<Home>().Feed[index]['id'];
//       }
//       if (context.read<Home>().top_index == 2) {
//         id = context.read<Home>().Freetalk[index]['id'];
//       }
//       if (context.read<Home>().top_index == 3) {
//         id = context.read<Home>().Recipe[index]['id'];
//       }
//       context
//           .read<Home>()
//           .add_bookmark(auth, auth.currentUser?.email, id)
//           .then((_) {
//         showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: new Text("스크랩 완료"),
//                 content: new Text("해당 글을 스크랩 했습니다."),
//                 actions: <Widget>[
//                   new FlatButton(
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => HomePage()),
//                       );
//                     },
//                     child: new Text("닫기"),
//                   ),
//                 ],
//               );
//             });
//       });
//     }
//     // 이미 좋아요 되어 있는 경우
//     if (bookmark_check == true) {
//       // Feed
//       if (context.watch<Home>().top_index == 1) {
//         id = context.watch<Home>().Feed[index]['id'];
//       }
//       if (context.watch<Home>().top_index == 2) {
//         id = context.watch<Home>().Freetalk[index]['id'];
//       }
//       if (context.watch<Home>().top_index == 3) {
//         id = context.watch<Home>().Recipe[index]['id'];
//       }

//       context
//           .read<Home>()
//           .remove_bookmark(auth, auth.currentUser?.email, id)
//           .then((_) {
//         showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: new Text("스크랩 취소 완료"),
//                 content: new Text("해당 글을 스크랩 취소했습니다."),
//                 actions: <Widget>[
//                   new FlatButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: new Text("닫기"),
//                   ),
//                 ],
//               );
//             });
//       });
//     }
//   }

//   // 블랙리스트가 걸려있는 경우 해당 아이디 글 노출 x
//   void checkblacklist(int index) async {
//     // true 값으로 init
//     context.watch<Home>().checkblacklist = true;

//     // Feed의 경우
//     if (context.watch<Home>().top_index == 1 &&
//         context.watch<Home>().User.length > 0) {
//       for (var selected in context.watch<Home>().User[0]?['blacklist']) {
//         print(context.watch<Home>().Feed[index]['user']);
//         print(selected);
//         if (context.watch<Home>().Feed[index]['user'] == selected['value']) {
//           // 블랙리스트가 쓴 글인 경우 선택되어 있는 경우에는 다시 false로 return
//           context.watch<Home>().checkblacklist = false;
//         }
//       }
//     }

//     // Freetalk의 경우
//     if (context.watch<Home>().top_index == 2 &&
//         context.watch<Home>().User.length > 0) {
//       for (var selected in context.watch<Home>().User[0]?['blacklist']) {
//         // print(data);
//         // print(selected);
//         if (context.watch<Home>().Feed[index]['user'] == selected['value']) {
//           // 블랙리스트가 쓴 글인 경우 선택되어 있는 경우에는 다시 false로 return
//           context.watch<Home>().checkblacklist = false;
//         }
//       }
//     }
//   }

//   // // 선택된 필터가 있으면 필터에 부합하는 데이터만 노출 => and 조건
//   // void checkfilter(int index) async {
//   //   // true 값으로 init
//   //   context.watch<Home>().check = true;
//   //   if (context.watch<Home>().Selected_list.length > 0) {
//   //     // 필터가 있으면 false로 바꾸기 & count 0으로 초기화
//   //     context.watch<Home>().check = false;
//   //     context.watch<Home>().filter_count = 0;

//   //     // Feed의 경우
//   //     if (context.watch<Home>().top_index == 1) {
//   //       for (var data in context.watch<Home>().Feed[index]['filter']) {
//   //         for (var selected in context.watch<Home>().Selected_list) {
//   //           // print(data);
//   //           // print(selected);
//   //           if (data.indexOf(selected) == 0) {
//   //             // 피드에 포함된 필터가 선택되어 있는 경우에는 다시 true로 return
//   //             context.watch<Home>().filter_count += 1;
//   //           }
//   //         }
//   //       }

//   //       if (context.watch<Home>().filter_count ==
//   //           context.watch<Home>().Selected_list.length) {
//   //         context.watch<Home>().check =
//   //             true; // filter_count와 선택된 필터 리스트 길이가 같음 => and 조건 부합
//   //       }
//   //     }
//   //     // Freetalk의 경우
//   //     if (context.watch<Home>().top_index == 2) {
//   //       for (var data in context.watch<Home>().Freetalk[index]['filter']) {
//   //         for (var selected in context.watch<Home>().Selected_list) {
//   //           // print(data);
//   //           // print(selected);
//   //           if (data.indexOf(selected) == 0) {
//   //             // 피드에 포함된 필터가 선택되어 있는 경우에는 다시 true로 return
//   //             context.watch<Home>().filter_count += 1;
//   //           }
//   //         }
//   //       }
//   //       if (context.watch<Home>().filter_count ==
//   //           context.watch<Home>().Selected_list.length) {
//   //         context.watch<Home>().check =
//   //             true; // filter_count와 선택된 필터 리스트 길이가 같음 => and 조건 부합
//   //       }
//   //     }
//   //     // Recipe의 경우
//   //     if (context.watch<Home>().top_index == 3) {
//   //       for (var data in context.watch<Home>().Recipe[index]['filter']) {
//   //         for (var selected in context.watch<Home>().Selected_list) {
//   //           // print(data);
//   //           // print(selected);
//   //           if (data.indexOf(selected) == 0) {
//   //             // 피드에 포함된 필터가 선택되어 있는 경우에는 다시 true로 return
//   //             context.watch<Home>().filter_count += 1;
//   //           }
//   //         }
//   //       }
//   //       if (context.watch<Home>().filter_count ==
//   //           context.watch<Home>().Selected_list.length) {
//   //         context.watch<Home>().check =
//   //             true; // filter_count와 선택된 필터 리스트 길이가 같음 => and 조건 부합
//   //       }
//   //     }
//   //   }
//   // }

//   // 검색어가 있으면 검색어에 부합하는 데이터만 노출
//   void checksearch(int index) async {
//     // true 값으로 init
//     context.watch<Home>().checksearch = true;
//     if (context.watch<Home>().Searchtext.length > 0) {
//       // 검색어가 있으면 false로 바꾸기
//       context.watch<Home>().check = false;
//       // print(context.watch<Home>().Feed);
//       // Feed의 경우
//       if (context.watch<Home>().top_index == 1) {
//         if (context
//             .watch<Home>()
//             .Feed[index]['nickname']
//             .contains(context.watch<Home>().Searchtext)) {
//           context.watch<Home>().check = true;
//         }
//         if (context.watch<Home>().Feed[index]['filter'] != null &&
//             context
//                 .watch<Home>()
//                 .Feed[index]['filter']
//                 .contains(context.watch<Home>().Searchtext)) {
//           context.watch<Home>().check = true;
//         }
//         if (context
//             .watch<Home>()
//             .Feed[index]['content']
//             .contains(context.watch<Home>().Searchtext)) {
//           context.watch<Home>().check = true;
//         }
//       }

//       // Freetalk의 경우
//       if (context.watch<Home>().top_index == 2) {
//         if (context
//             .watch<Home>()
//             .Freetalk[index]['nickname']
//             .contains(context.watch<Home>().Searchtext)) {
//           context.watch<Home>().check = true;
//         }
//         if (context.watch<Home>().Freetalk[index]['filter'] != null &&
//             context
//                 .watch<Home>()
//                 .Freetalk[index]['filter']
//                 .contains(context.watch<Home>().Searchtext)) {
//           context.watch<Home>().check = true;
//         }
//         if (context
//             .watch<Home>()
//             .Freetalk[index]['content']
//             .contains(context.watch<Home>().Searchtext)) {
//           context.watch<Home>().check = true;
//         }
//       }

//       // Recipe의 경우
//       if (context.watch<Home>().top_index == 3) {
//         if (context
//             .watch<Home>()
//             .Recipe[index]['nickname']
//             .contains(context.watch<Home>().Searchtext)) {
//           context.watch<Home>().check = true;
//         }
//         if (context.watch<Home>().Recipe[index]['filter'] != null &&
//             context
//                 .watch<Home>()
//                 .Recipe[index]['filter']
//                 .contains(context.watch<Home>().Searchtext)) {
//           context.watch<Home>().check = true;
//         }
//         if (context
//             .watch<Home>()
//             .Recipe[index]['title']
//             .contains(context.watch<Home>().Searchtext)) {
//           context.watch<Home>().check = true;
//         }
//       }
//     }
//   }

//   //init
//   bool like_check = false;
//   bool bookmark_check = false;
//   @override
//   Widget build(BuildContext context) {
//     // 블랙리스트 체크하는 함수
//     checkblacklist(widget.index);
//     // // 필터 체크하는 함수
//     // checkfilter(widget.index);
//     // 검색어 체크하는 함수
//     checksearch(widget.index);
//     if (context.watch<Home>().checkblacklist) {
//       // if (context.watch<Home>().check) {
//       if (context.watch<Home>().checksearch) {
//         if (context.watch<Home>().top_index == 1) {
//           if (context.watch<Home>().Feed[widget.index]['like'] != null) {
//             for (var like_id in context.watch<Home>().Feed[widget.index]
//                 ['like']) {
//               if (like_id['value'] == auth.currentUser?.email) {
//                 like_check = true;
//               }
//             }
//           }
//           if (context.watch<Home>().Feed[widget.index]['bookmark'] != null) {
//             print(context.watch<Home>().Feed[widget.index]['bookmark']);
//             for (var bookmark_id in context.watch<Home>().Feed[widget.index]
//                 ['bookmark']) {
//               if (bookmark_id['value'] == auth.currentUser?.email) {
//                 bookmark_check = true;
//               }
//             }
//           }
//         }

//         if (context.watch<Home>().top_index == 2) {
//           if (context.watch<Home>().Freetalk[widget.index]['like'] != null) {
//             for (var like_id in context.watch<Home>().Freetalk[widget.index]
//                 ['like']) {
//               if (like_id['value'] == auth.currentUser?.email) {
//                 like_check = true;
//               }
//             }
//           }
//           if (context.watch<Home>().Freetalk[widget.index]['bookmark'] !=
//               null) {
//             print(context.watch<Home>().Freetalk[widget.index]['bookmark']);
//             for (var bookmark_id in context.watch<Home>().Freetalk[widget.index]
//                 ['bookmark']) {
//               if (bookmark_id['value'] == auth.currentUser?.email) {
//                 bookmark_check = true;
//               }
//             }
//           }
//         }
//         if (context.watch<Home>().top_index == 3) {
//           if (context.watch<Home>().Recipe[widget.index]['like'] != null) {
//             for (var like_id in context.watch<Home>().Recipe[widget.index]
//                 ['like']) {
//               if (like_id['value'] == auth.currentUser?.email) {
//                 like_check = true;
//               }
//             }
//           }
//           if (context.watch<Home>().Recipe[widget.index]['bookmark'] != null) {
//             print(context.watch<Home>().Recipe[widget.index]['bookmark']);
//             for (var bookmark_id in context.watch<Home>().Recipe[widget.index]
//                 ['bookmark']) {
//               if (bookmark_id['value'] == auth.currentUser?.email) {
//                 bookmark_check = true;
//               }
//             }
//           }
//         }

//         return Container(
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Container(
//                 height: 20,
//               ),
//               Row(children: [
//                 SizedBox(
//                   width: 10,
//                 ),
//                 // profileimage가 있을 때 : Feed
//                 if (context.watch<Home>().top_index == 1 &&
//                     context
//                             .watch<Home>()
//                             .Feed[widget.index]['profileimage']
//                             .length >
//                         0 &&
//                     context.watch<Home>().Feed[widget.index]['profileimage']
//                             [0] !=
//                         "")
//                   CircleAvatar(
//                     radius: 15,
//                     backgroundColor: Colors.white,
//                     backgroundImage: NetworkImage(context
//                         .watch<Home>()
//                         .Feed[widget.index]['profileimage'][0]),
//                   ), // profileimage가 없을 때
//                 if (context.watch<Home>().top_index == 1 &&
//                     context
//                             .watch<Home>()
//                             .Feed[widget.index]['profileimage']
//                             .length >
//                         0 &&
//                     context.watch<Home>().Feed[widget.index]['profileimage']
//                             [0] ==
//                         "")
//                   CircleAvatar(
//                       radius: 15,
//                       backgroundColor: Colors.white,
//                       foregroundColor: Color.fromRGBO(201, 92, 57, 1),
//                       child: Icon(Icons.people)),
//                 // profileimage가 있을 때 : Freetalk
//                 if (context.watch<Home>().top_index == 2 &&
//                     context
//                             .watch<Home>()
//                             .Freetalk[widget.index]['profileimage']
//                             .length >
//                         0 &&
//                     context.watch<Home>().Freetalk[widget.index]['profileimage']
//                             [0] !=
//                         "")
//                   CircleAvatar(
//                     radius: 15,
//                     backgroundColor: Colors.white,
//                     backgroundImage: NetworkImage(context
//                         .watch<Home>()
//                         .Freetalk[widget.index]['profileimage'][0]),
//                   ), // profileimage가 없을 때
//                 if (context.watch<Home>().top_index == 2 &&
//                     context
//                             .watch<Home>()
//                             .Freetalk[widget.index]['profileimage']
//                             .length >
//                         0 &&
//                     context.watch<Home>().Freetalk[widget.index]['profileimage']
//                             [0] ==
//                         "")
//                   CircleAvatar(
//                       radius: 15,
//                       backgroundColor: Colors.white,
//                       foregroundColor: Color.fromRGBO(201, 92, 57, 1),
//                       child: Icon(Icons.people)),

//                 if (context.watch<Home>().top_index != 3)
//                   Container(
//                     padding: EdgeInsets.only(left: 10),
//                     child: Text(
//                       context.watch<Home>().top_index == 1
//                           ? (context.watch<Home>().Feed[widget.index]
//                               ['nickname'])
//                           : (context.watch<Home>().Freetalk[widget.index]
//                               ['nickname']),
//                       style: TextStyle(
//                           fontSize: 14, color: Color.fromRGBO(40, 40, 40, 1)),
//                     ),
//                   ),
//               ]),
//               Container(
//                 height: 20,
//               ),

//               // feed image
//               if (context.watch<Home>().top_index == 1 &&
//                   context.watch<Home>().Feed[widget.index]['image'] != null)
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: [
//                       for (var image in context.watch<Home>().Feed[widget.index]
//                           ['image'])
//                         Container(
//                           width: MediaQuery.of(context).size.width,
//                           child: FadeInImage(
//                             image: NetworkImage(
//                               image['value'],
//                             ),
//                             placeholder: AssetImage('assets/loading.gif'),
//                             imageErrorBuilder:
//                                 (context, exception, stackTrace) {
//                               print(exception);
//                               return Image.asset('assets/loading.gif');
//                             },
//                             fit: BoxFit.fitWidth,
//                           ),
//                         )
//                     ],
//                   ),
//                 ),

//               // freetalk image
//               if (context.watch<Home>().top_index == 2 &&
//                   context.watch<Home>().Freetalk[widget.index]['image'] != null)
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: [
//                       for (var image in context
//                           .watch<Home>()
//                           .Freetalk[widget.index]['image'])
//                         Container(
//                           width: MediaQuery.of(context).size.width,
//                           child: FadeInImage(
//                             image: NetworkImage(
//                               image['value'],
//                             ),
//                             placeholder: AssetImage('assets/loading.gif'),
//                             imageErrorBuilder: (_, __, ___) {
//                               return Image.asset('assets/loading.gif');
//                             },
//                             fit: BoxFit.fitWidth,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),

//               // recipe image
//               if (context.watch<Home>().top_index == 3)
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Stack(
//                     children: [
//                       GestureDetector(
//                         onTap: () async {
//                           // gtag
//                           await analytics.logEvent(
//                               name: 'click_recipe_detail',
//                               parameters: {
//                                 'recipe_name': context
//                                     .read<Home>()
//                                     .Recipe[widget.index]['id']
//                               });

//                           // 데이터 전달하기
//                           context.read<Recipe>().select_data(
//                               context.read<Home>().Recipe[widget.index]);

//                           //index 설정
//                           context.read<Reply>().select_index(widget.index);

//                           // 페이지 이동
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => RecipePage()),
//                           );
//                         },
//                         child: Container(
//                           height: 180,
//                           margin: EdgeInsets.only(left: 15, right: 15),
//                           width: MediaQuery.of(context).size.width - 30,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: FadeInImage(
//                               imageErrorBuilder:
//                                   (context, exception, stackTrace) {
//                                 return Container(
//                                   width: 100.0,
//                                   height: 100.0,
//                                   child: Image.asset('assets/loading.gif'),
//                                 );
//                               },
//                               image: NetworkImage(
//                                 context
//                                             .watch<Home>()
//                                             .Recipe[widget.index]['videourl']
//                                             .split("=")
//                                             .length ==
//                                         2
//                                     ? "https://img.youtube.com/vi/${context.watch<Home>().Recipe[widget.index]['videourl'].split("=")[1]}/0.jpg"
//                                     : "https://img.youtube.com/vi/tg7w12Eyzbk/0.jpg",
//                               ),
//                               placeholder: AssetImage("assets/loading.gif"),
//                               fit: BoxFit.fitWidth,
//                             ),
//                           ),
//                         ),
//                       ),
//                       if (auth.currentUser != null)
//                         Positioned(
//                           top: MediaQuery.of(context).size.height * 0.18,
//                           left: MediaQuery.of(context).size.width - 80,
//                           right: 0,
//                           child: IconButton(
//                             icon: bookmark_check == true
//                                 ? Icon(Icons.bookmark,
//                                     color: Colors.white, size: 32)
//                                 : Icon(Icons.bookmark_outline,
//                                     color: Colors.white, size: 32),
//                             onPressed: () {
//                               Bookmark_Click(bookmark_check, widget.index);
//                             },
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),

//               // 제목
//               if (context.watch<Home>().top_index == 3)
//                 Container(
//                   padding: EdgeInsets.only(top: 20, left: 20, right: 20),
//                   child: Text(
//                     context.watch<Home>().Recipe[widget.index]['title'],
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         fontSize: 14,
//                         color: Color.fromRGBO(40, 40, 40, 1),
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),

//               // 피드 아이콘 => 좋아요 / 댓글 / 북마크
//               if (context.watch<Home>().top_index != 3)
//                 Row(
//                   children: <Widget>[
//                     IconButton(
//                       icon: like_check == true
//                           ? Icon(Icons.favorite)
//                           : Icon(Icons.favorite_border),
//                       onPressed: () {
//                         // 미가입 시
//                         if (auth.currentUser == null) {
//                           showDialog(
//                               context: context,
//                               barrierDismissible: false,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   title: new Text("로그인"),
//                                   content: new Text("로그인이 필요합니다."),
//                                   actions: <Widget>[
//                                     new FlatButton(
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   LoginPage()),
//                                         );
//                                       },
//                                       child: new Text("로그인 페이지로 이동"),
//                                     ),
//                                   ],
//                                 );
//                               });
//                         } else {
//                           Like_Click(like_check, widget.index);
//                         }
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.question_answer_outlined),
//                       onPressed: () {
//                         // 미가입 시
//                         if (auth.currentUser == null) {
//                           showDialog(
//                               context: context,
//                               barrierDismissible: false,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   title: new Text("로그인"),
//                                   content: new Text("로그인이 필요합니다."),
//                                   actions: <Widget>[
//                                     new FlatButton(
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   LoginPage()),
//                                         );
//                                       },
//                                       child: new Text("로그인 페이지로 이동"),
//                                     ),
//                                   ],
//                                 );
//                               });
//                         } else {
//                           // index 설정
//                           context.read<Reply>().select_index(widget.index);
//                           // 페이지 이동
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => ReplyPage()),
//                           );
//                         }
//                       },
//                     ),
//                     IconButton(
//                       icon: bookmark_check == true
//                           ? Icon(Icons.bookmark_add)
//                           : Icon(Icons.bookmark_add_outlined),
//                       onPressed: () {
//                         // 미가입 시
//                         if (auth.currentUser == null) {
//                           showDialog(
//                               context: context,
//                               barrierDismissible: false,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   title: new Text("로그인"),
//                                   content: new Text("로그인이 필요합니다."),
//                                   actions: <Widget>[
//                                     new FlatButton(
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   LoginPage()),
//                                         );
//                                       },
//                                       child: new Text("로그인 페이지로 이동"),
//                                     ),
//                                   ],
//                                 );
//                               });
//                         } else {
//                           Bookmark_Click(bookmark_check, widget.index);
//                         }
//                       },
//                     ),
//                   ],
//                 ),

//               // 좋아요 개수 => 없는 경우(Feed)
//               if (context.watch<Home>().top_index == 1 &&
//                   context.watch<Home>().Feed[widget.index]['like'] == null)
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Container(
//                     padding: EdgeInsets.only(left: 10),
//                     child: Text(
//                       "좋아요 0개",
//                       style: TextStyle(
//                           fontSize: 14,
//                           color: Color.fromRGBO(40, 40, 40, 1),
//                           fontWeight: FontWeight.bold),
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                 ),
//               // 좋아요 개수 => 없는 경우(Feed)
//               if (context.watch<Home>().top_index == 2 &&
//                   context.watch<Home>().Freetalk[widget.index]['like'] == null)
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Container(
//                     padding: EdgeInsets.only(left: 10),
//                     child: Text(
//                       "좋아요 0개",
//                       style: TextStyle(
//                           fontSize: 14,
//                           color: Color.fromRGBO(40, 40, 40, 1),
//                           fontWeight: FontWeight.bold),
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                 ),
//               // 좋아요 개수
//               if (context.watch<Home>().top_index != 3 &&
//                   context.watch<Home>().Feed[widget.index]['like'] != null)
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Container(
//                     padding: EdgeInsets.only(left: 10),
//                     child: Text(
//                       context.watch<Home>().top_index == 1
//                           ? ("좋아요" +
//                               context
//                                   .watch<Home>()
//                                   .Feed[widget.index]['like']
//                                   .length
//                                   .toString() +
//                               "개")
//                           : (context.watch<Home>().top_index == 2
//                               ? ("좋아요" +
//                                   context
//                                       .watch<Home>()
//                                       .Freetalk[widget.index]['like']
//                                       .length
//                                       .toString() +
//                                   "개")
//                               : ("좋아요" +
//                                   context
//                                       .watch<Home>()
//                                       .Recipe[widget.index]['like']
//                                       .length
//                                       .toString() +
//                                   "개")),
//                       style: TextStyle(
//                           fontSize: 14,
//                           color: Color.fromRGBO(40, 40, 40, 1),
//                           fontWeight: FontWeight.bold),
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                 ),
//               // 아이디
//               if (context.watch<Home>().top_index != 3)
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       alignment: Alignment.centerLeft,
//                       margin: EdgeInsets.only(left: 10),
//                       child: Text(
//                           context.watch<Home>().top_index == 1
//                               ? (context.watch<Home>().Feed[widget.index]
//                                   ['nickname'])
//                               : (context.watch<Home>().Freetalk[widget.index]
//                                   ['nickname']),
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                           )),
//                     ),
//                     Expanded(
//                       child: ListTile(
//                         dense: true,
//                         leading: Container(
//                           padding: EdgeInsets.only(right: 10),
//                           child: Text(
//                               context.watch<Home>().top_index == 1
//                                   ? (context.watch<Home>().Feed[widget.index]
//                                       ['content'])
//                                   : context.watch<Home>().Freetalk[widget.index]
//                                       ['content'],
//                               style: TextStyle(
//                                   fontSize: 13.0,
//                                   fontWeight: FontWeight.normal),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis),
//                         ),
//                         onTap: () async {},
//                         trailing: Container(
//                           alignment: Alignment.centerRight,
//                           width: 20,
//                           child: IconButton(
//                             icon: Icon(
//                               Icons.more_vert,
//                               color: Colors.grey,
//                               size: 20,
//                             ),
//                             onPressed: () {
//                               // Feed인 경우
//                               if (context.read<Home>().top_index == 1) {
//                                 _showbottomContent(
//                                     context,
//                                     context.read<Home>().Feed[widget.index]
//                                         ['user']);
//                               }
//                               // Freetalk인 경우
//                               if (context.read<Home>().top_index == 2) {
//                                 _showbottomContent(
//                                     context,
//                                     context.read<Home>().Freetalk[widget.index]
//                                         ['user']);
//                               }
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//               // Feed 댓글 2개 이상일 때
//               if (context.watch<Home>().top_index == 1 &&
//                   context.watch<Home>().Feed[widget.index]['reply'] != null &&
//                   context.watch<Home>().Feed[widget.index]['reply'].length > 2)
//                 GestureDetector(
//                   onTap: () async {
//                     // index 설정
//                     context.read<Reply>().select_index(widget.index);
//                     // 페이지 이동
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ReplyPage()),
//                     );
//                   },
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Container(
//                       padding: EdgeInsets.only(left: 10),
//                       child: Text(
//                           '댓글 ${context.watch<Home>().Feed[widget.index]['reply'].length}개 모두 보기',
//                           style: TextStyle(color: Colors.grey[500])),
//                     ),
//                   ),
//                 ),

//               // Start : Feed 댓글 2개 미리보기 => 2개 이하인 경우에는 전부 / 2개 이상인 경우에는 댓글 미리보기
//               if (context.watch<Home>().top_index == 1 &&
//                   context.watch<Home>().Feed[widget.index]['reply'] != null &&
//                   context.watch<Home>().Feed[widget.index]['reply'].length !=
//                       0 &&
//                   context.watch<Home>().Feed[widget.index]['reply'].length < 3)
//                 for (var reply in context.watch<Home>().Feed[widget.index]
//                     ['reply'])
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         alignment: Alignment.centerLeft,
//                         margin: EdgeInsets.only(left: 10),
//                         child: Text(reply['nickname'],
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             )),
//                       ),
//                       Expanded(
//                         child: ListTile(
//                           dense: true,
//                           visualDensity: VisualDensity(vertical: -4),
//                           leading: Container(
//                             padding: EdgeInsets.only(right: 30),
//                             child: Text(reply['content'],
//                                 style: TextStyle(
//                                     fontSize: 13.0,
//                                     fontWeight: FontWeight.normal),
//                                 overflow: TextOverflow.ellipsis),
//                           ),
//                           onTap: () async {},
//                           trailing: Container(
//                             alignment: Alignment.centerRight,
//                             width: 20,
//                             child: IconButton(
//                               icon: Icon(
//                                 Icons.more_vert,
//                                 color: Colors.grey,
//                                 size: 20,
//                               ),
//                               onPressed: () {
//                                 _showbottomContent(context, '');
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//               // End : Feed 댓글 2개 미리보기 => 2개 이하인 경우에는 전부 / 2개 이상인 경우에는 2개만

//               // Freetalk 댓글
//               if (context.watch<Home>().top_index == 2 &&
//                   context.watch<Home>().Freetalk[widget.index]['reply'] !=
//                       null &&
//                   context.watch<Home>().Freetalk[widget.index]['reply'].length >
//                       2)
//                 GestureDetector(
//                   onTap: () async {
//                     // 페이지 이동
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ReplyPage()),
//                     );
//                   },
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Container(
//                       padding: EdgeInsets.only(left: 10),
//                       child: Text(
//                           '댓글 ${context.watch<Home>().Freetalk[widget.index]['reply'].length}개 모두 보기'),
//                     ),
//                   ),
//                 ),

//               // Start : Freetalk 댓글 2개 미리보기 => 2개 이하인 경우에는 전부 / 2개 이상인 경우에는 미리보기
//               if (context.watch<Home>().top_index == 2 &&
//                   context.watch<Home>().Freetalk[widget.index]['reply'] !=
//                       null &&
//                   context
//                           .watch<Home>()
//                           .Freetalk[widget.index]['reply']
//                           .length !=
//                       0 &&
//                   context.watch<Home>().Freetalk[widget.index]['reply'].length <
//                       3)
//                 for (var reply in context.watch<Home>().Freetalk[widget.index]
//                     ['reply'])
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         alignment: Alignment.centerLeft,
//                         margin: EdgeInsets.only(left: 10),
//                         child: Text(reply['nickname'],
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             )),
//                       ),
//                       Expanded(
//                         child: ListTile(
//                           dense: true,
//                           visualDensity: VisualDensity(vertical: -4),
//                           leading: Container(
//                             padding: EdgeInsets.only(right: 30),
//                             child: Text(reply['content'],
//                                 style: TextStyle(
//                                     fontSize: 13.0,
//                                     fontWeight: FontWeight.normal),
//                                 overflow: TextOverflow.ellipsis),
//                           ),
//                           onTap: () async {},
//                           trailing: Container(
//                             alignment: Alignment.centerRight,
//                             width: 20,
//                             child: IconButton(
//                               icon: Icon(
//                                 Icons.more_vert,
//                                 color: Colors.grey,
//                                 size: 20,
//                               ),
//                               onPressed: () {
//                                 _showbottomContent(context, '');
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//               // End : Freetalk 댓글 2개 미리보기 => 2개 이하인 경우에는 전부 / 2개 이상인 경우에는 2개만
//             ],
//           ),
//         );
//       } else {
//         return Container(
//           width: 0,
//           height: 0,
//         );
//       }
//     } else {
//       return Container(
//         width: 0,
//         height: 0,
//       );
//     }
//   }
//   // else {
//   //   return Container(
//   //     width: 0,
//   //     height: 0,
//   //   );
//   // }
//   // }
// }

// // SelectedFilter 기본 class => 선택된 필터 종류 보여주는 박스
// class SelectedFilter extends StatefulWidget {
//   @override
//   _SelectedFilterState createState() => _SelectedFilterState();
// }

// class _SelectedFilterState extends State<SelectedFilter> {
//   @override
//   Widget build(BuildContext context) {
//     if (context.watch<Home>().Selected_list.length > 0) {
//       return Container(
//         width: MediaQuery.of(context).size.width,
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Container(
//             margin: EdgeInsets.only(left: 15, bottom: 20),
//             height: 30,
//             child: Row(mainAxisSize: MainAxisSize.max, children: [
//               for (var text in context.watch<Home>().Selected_list)
//                 Container(
//                   decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(40.0)),
//                   padding: EdgeInsets.only(left: 15),
//                   margin: EdgeInsets.only(right: 15),
//                   child: Row(children: [
//                     Text(
//                       text,
//                       style: TextStyle(
//                           fontSize: 14, color: Color.fromRGBO(201, 92, 57, 1)),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.close, size: 12),
//                       onPressed: () {
//                         context.read<Home>().remove_list(text);
//                       },
//                     ),
//                   ]),
//                 ),
//             ]),
//           ),
//         ),
//       );
//     } else {
//       return Container(
//         height: 0,
//       );
//     }
//   }
// }

// // Filter 기본 class
// class Filter extends StatefulWidget {
//   @override
//   _FilterState createState() => _FilterState();
// }

// class _FilterState extends State<Filter> {
//   // bottomSheet 함수 => 1차 메뉴
//   void _showbottom(BuildContext context) {
//     showModalBottomSheet(
//         context: context,
//         builder: (context) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               ListTile(
//                 title: new Text('조리법'),
//                 onTap: () async {
//                   await analytics.logEvent(name: 'click_filter_cook');
//                   _showbottomCook(context);
//                 },
//               ),
//               ListTile(
//                 title: new Text('영유아식'),
//                 onTap: () async {
//                   await analytics.logEvent(name: 'click_filter_babyfood');
//                   _showbottomBaby(context);
//                 },
//               ),
//               if (context.watch<Home>().top_index != 3)
//                 ListTile(
//                   title: new Text('식사'),
//                   onTap: () async {
//                     await analytics.logEvent(name: 'click_filter_meal');
//                     _showbottomMeal(context);
//                   },
//                 ),
//               ListTile(
//                 title: new Text('종류'),
//                 onTap: () async {
//                   await analytics.logEvent(name: 'click_filter_type');
//                   _showbottomCategory(context);
//                 },
//               ),
//               ListTile(
//                 title: new Text('식재료'),
//                 onTap: () async {
//                   await analytics.logEvent(name: 'click_filter_ingredients');
//                   _showbottomFood(context);
//                 },
//               ),
//             ],
//           );
//         });
//   }

//   // bottomSheet 함수 => 2차 메뉴 : 조리법
//   void _showbottomCook(BuildContext context) {
//     showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (context) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               for (var data in context.watch<Home>().Cook)
//                 ListTile(
//                   title: new Text(data['value']),
//                   onTap: () {
//                     context.read<Home>().add_list(data['value']);
//                     // 2단계 종료
//                     Navigator.pop(context);
//                   },
//                 ),
//             ],
//           );
//         });
//   }

//   // bottomSheet 함수 => 2차 메뉴 : 영유아식
//   void _showbottomBaby(BuildContext context) {
//     showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (context) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               for (var data in context.watch<Home>().Baby)
//                 ListTile(
//                   title: new Text(data['value']),
//                   onTap: () {
//                     context.read<Home>().add_list(data['value']);
//                     // 2단계 종료
//                     Navigator.pop(context);
//                   },
//                 ),
//             ],
//           );
//         });
//   }

//   // bottomSheet 함수 => 2차 메뉴 : 식사
//   void _showbottomMeal(BuildContext context) {
//     showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (context) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               for (var data in context.watch<Home>().Meal)
//                 ListTile(
//                   title: new Text(data['value']),
//                   onTap: () {
//                     context.read<Home>().add_list(data['value']);
//                     // 2단계 종료
//                     Navigator.pop(context);
//                   },
//                 ),
//             ],
//           );
//         });
//   }

//   // bottomSheet 함수 => 2차 메뉴 : 종류
//   void _showbottomCategory(BuildContext context) {
//     showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (context) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   for (var data in context.watch<Home>().Type)
//                     ListTile(
//                       title: new Text(data['value']),
//                       onTap: () {
//                         context.read<Home>().add_list(data['value']);
//                         // 2단계 종료
//                         Navigator.pop(context);
//                       },
//                     ),
//                 ],
//               ),
//             ],
//           );
//         });
//   }

//   // bottomSheet 함수 => 2차 메뉴 : 식재료
//   void _showbottomFood(BuildContext context) {
//     showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (context) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               for (int i = 0;
//                   i < context.watch<Home>().Ingredients_id.length;
//                   i++)
//                 ListTile(
//                   title: new Text(context.watch<Home>().Ingredients_id[i]),
//                   onTap: () {
//                     _showbottomFoodSecondary(i);
//                   },
//                 ),
//             ],
//           );
//         });
//   }

//   // bottomSheet 함수 => 3차 메뉴 : 식재료
//   void _showbottomFoodSecondary(int index) {
//     showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (context) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               for (var key in context.watch<Home>().Ingredients[index].keys)
//                 ListTile(
//                   title: new Text(key),
//                   onTap: () {
//                     context.read<Home>().add_list(key);
//                     // 3단계 종료
//                     Navigator.pop(context);
//                     Navigator.pop(context);
//                   },
//                 ),
//             ],
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: <Widget>[
//             Container(
//               width: 60,
//               child: Icon(
//                 Icons.filter_alt,
//                 color: Color.fromRGBO(201, 92, 57, 1),
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.only(right: 30),
//               child: GestureDetector(
//                 onTap: () async {
//                   _showbottomCook(context);
//                 },
//                 child: Row(
//                   children: <Widget>[
//                     Text(
//                       '조리법',
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Color.fromRGBO(201, 92, 57, 1),
//                       ),
//                     ),
//                     Icon(
//                       Icons.arrow_drop_down,
//                       color: Color.fromRGBO(201, 92, 57, 1),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.only(right: 30),
//               child: GestureDetector(
//                 onTap: () async {
//                   _showbottomBaby(context);
//                 },
//                 child: Row(
//                   children: <Widget>[
//                     Text(
//                       '영유아식',
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Color.fromRGBO(201, 92, 57, 1),
//                       ),
//                     ),
//                     Icon(
//                       Icons.arrow_drop_down,
//                       color: Color.fromRGBO(201, 92, 57, 1),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             if (context.watch<Home>().top_index != 3)
//               Container(
//                 margin: EdgeInsets.only(right: 30),
//                 child: GestureDetector(
//                   onTap: () async {
//                     _showbottomMeal(context);
//                   },
//                   child: Row(
//                     children: <Widget>[
//                       Text(
//                         '식사',
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: Color.fromRGBO(201, 92, 57, 1),
//                         ),
//                       ),
//                       Icon(
//                         Icons.arrow_drop_down,
//                         color: Color.fromRGBO(201, 92, 57, 1),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             Container(
//               margin: EdgeInsets.only(right: 30),
//               child: GestureDetector(
//                 onTap: () async {
//                   _showbottomCategory(context);
//                 },
//                 child: Row(
//                   children: <Widget>[
//                     Text(
//                       '종류',
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Color.fromRGBO(201, 92, 57, 1),
//                       ),
//                     ),
//                     Icon(
//                       Icons.arrow_drop_down,
//                       color: Color.fromRGBO(201, 92, 57, 1),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.only(right: 30),
//               child: GestureDetector(
//                 onTap: () async {
//                   _showbottomFood(context);
//                 },
//                 child: Row(
//                   children: <Widget>[
//                     Text(
//                       '식재료',
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Color.fromRGBO(201, 92, 57, 1),
//                       ),
//                     ),
//                     Icon(
//                       Icons.arrow_drop_down,
//                       color: Color.fromRGBO(201, 92, 57, 1),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // TopBar 기본 class
// class TopBar extends StatefulWidget {
//   @override
//   _TopBarState createState() => _TopBarState();
// }

// class _TopBarState extends State<TopBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             flex: 1,
//             child: GestureDetector(
//               onTap: () async {
//                 // gtag
//                 await analytics.logEvent(name: 'click_feed');

//                 context.read<Home>().select_top(1);
//                 setState(() {});
//               },
//               child: Column(
//                 children: <Widget>[
//                   Text(
//                     '식사',
//                     style: TextStyle(
//                         fontSize: 18,
//                         color: context.watch<Home>().top_index == 1
//                             ? Color.fromRGBO(201, 92, 57, 1)
//                             : Color.fromRGBO(40, 40, 40, 1)),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Color.fromRGBO(40, 40, 40, 1),
//                       border: Border(
//                           bottom: BorderSide(
//                               width: context.watch<Home>().top_index == 1
//                                   ? 3.0
//                                   : 0.0,
//                               color: context.watch<Home>().top_index == 1
//                                   ? Color.fromRGBO(201, 92, 57, 1)
//                                   : Colors.white)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: GestureDetector(
//               onTap: () async {
//                 // gtag
//                 await analytics.logEvent(name: 'click_freetalk');

//                 context.read<Home>().select_top(2);
//                 setState(() {});
//               },
//               child: Column(
//                 children: <Widget>[
//                   Text(
//                     '자유 수다방',
//                     style: TextStyle(
//                         fontSize: 18,
//                         color: context.watch<Home>().top_index ==
//                                 2 // 수정 시 재빌드하기 위해서는 watch를 사용
//                             ? Color.fromRGBO(201, 92, 57, 1)
//                             : Color.fromRGBO(40, 40, 40, 1)),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Color.fromRGBO(40, 40, 40, 1),
//                       border: Border(
//                           bottom: BorderSide(
//                               width: context.watch<Home>().top_index == 2
//                                   ? 3.0
//                                   : 0.0,
//                               color: context.watch<Home>().top_index == 2
//                                   ? Color.fromRGBO(201, 92, 57, 1)
//                                   : Colors.white)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: GestureDetector(
//               onTap: () async {
//                 // gtag
//                 await analytics.logEvent(name: 'click_recipe');

//                 context.read<Home>().select_top(3);
//                 setState(() {});
//               },
//               child: Column(
//                 children: <Widget>[
//                   Text(
//                     '레시피',
//                     style: TextStyle(
//                         fontSize: 18,
//                         color: context.watch<Home>().top_index == 3
//                             ? Color.fromRGBO(201, 92, 57, 1)
//                             : Color.fromRGBO(40, 40, 40, 1)),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       border: Border(
//                           bottom: BorderSide(
//                               width: context.watch<Home>().top_index == 3
//                                   ? 3.0
//                                   : 0.0,
//                               color: context.watch<Home>().top_index == 3
//                                   ? Color.fromRGBO(201, 92, 57, 1)
//                                   : Colors.white)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // appbar 지우기
// class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }

//   @override
//   Size get preferredSize => Size(0.0, 0.0);
// }

// // 로그인 기본 class
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final Home myProvider;
//   var loading = false;
//   var search_text = "";
//   // 현재 pixel 확인
//   ScrollController _scrollController = new ScrollController();

//   // void _scrollToTop() {
//   //   _scrollController.animateTo(0,
//   //       duration: Duration(seconds: 3), curve: Curves.linear);
//   // }

//   @override
//   void initState() {
//     // 로그인 상태인지 확인
//     print(auth.currentUser);
//     if (auth.currentUser != null) {
//       print(auth.currentUser!.email);
//     }

//     // 데이터 가져오기
//     context.read<Home>().get_data();

//     // 스플래쉬 화면
//     Timer(Duration(milliseconds: 2000), () {
//       loading = true;
//       setState(() {});
//     });

//     // 데이터 가져오기
//     _scrollController.addListener(() {
//       print(_scrollController.position.maxScrollExtent);
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         context.read<Home>().get_data_append();
//       }
//     });

//     super.initState();
//   }

//   // bookmark icon 클릭했을 때
//   Future<void> _onBookmarkButtonPressed() async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => ScrapPage()),
//     );
//   }

//   // shopping icon 클릭했을 때
//   Future<void> _onShoppingButtonPressed() async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => ShoppingPage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // 그리드 뷰 이미지
//     List<String> images = [
//       "assets/main.jpg",
//     ];
//     if (loading == false) {
//       return Scaffold(
//         appBar: AppBar(
//           bottomOpacity: 0.0,
//           elevation: 0.0,
//           backgroundColor: Color.fromRGBO(251, 246, 240, 1),
//           toolbarHeight: 0,
//         ),
//         backgroundColor: Color.fromRGBO(251, 246, 240, 1),
//         body: Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             child: Image.asset('assets/splash.jpg')),
//       );
//     } else {
//       return Scaffold(
//         appBar: AppBar(
//           bottomOpacity: 0.0,
//           elevation: 0.0,
//           backgroundColor: Colors.white,
//           toolbarHeight: 0,
//         ),
//         body: Column(
//           children: <Widget>[
//             Row(
//               children: <Widget>[
//                 Expanded(
//                   child: Column(
//                     children: <Widget>[
//                       Container(
//                         height: 40,
//                         margin: EdgeInsets.only(top: 10, left: 15, right: 15),
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 0, horizontal: 20),
//                         decoration: BoxDecoration(
//                           color: Color.fromRGBO(40, 40, 40, 1).withAlpha(10),
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(10),
//                           ),
//                         ),
//                         child: Row(
//                           children: <Widget>[
//                             Expanded(
//                               child: TextField(
//                                 decoration: InputDecoration(
//                                   hintText: "레시피를 검색해보세요.",
//                                   hintStyle: TextStyle(
//                                     color: Color.fromRGBO(40, 40, 40, 1)
//                                         .withAlpha(120),
//                                   ),
//                                   border: InputBorder.none,
//                                 ),
//                                 onChanged: (text) {
//                                   // // // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
//                                   search_text = text;
//                                 },
//                               ),
//                             ),
//                             GestureDetector(
//                                 onTap: () async {
//                                   context
//                                       .read<Home>()
//                                       .setSearchText(search_text);
//                                   context.read<Home>().Search();
//                                   // 스크롤 상단으로
//                                   _scrollController.animateTo(0,
//                                       duration: Duration(seconds: 3),
//                                       curve: Curves.linear);
//                                 },
//                                 child: Icon(
//                                   Icons.search,
//                                   color: Color.fromRGBO(40, 40, 40, 1)
//                                       .withAlpha(120),
//                                 )),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             // 메인 상단 메뉴
//             TopBar(),
//             // 필터
//             Filter(),
//             // 필터 선택 tagbox
//             SelectedFilter(),
//             Expanded(
//               child: ListView.builder(
//                   controller: _scrollController,
//                   scrollDirection: Axis.vertical,
//                   itemCount: context.watch<Home>().top_index == 1
//                       ? (context.watch<Home>().Feed.length)
//                       : (context.watch<Home>().top_index == 2
//                           ? context.watch<Home>().Freetalk.length
//                           : context.watch<Home>().Recipe.length),
//                   itemBuilder: (BuildContext context, int index) {
//                     return Feed(index);
//                   }),
//             ),
//           ],
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//             selectedItemColor: Color.fromRGBO(201, 92, 57, 1),
//             type: BottomNavigationBarType.fixed,
//             onTap: (index) => {
//                   print(index),
//                   // 글쓰기
//                   if (auth.currentUser != null && index == 1)
//                     {
//                       context.read<Write>().init(), // 글 쓸 때 이미지 초기화
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => WritePage()),
//                       ),
//                     },

//                   // 미가입 시
//                   if (auth.currentUser == null && index == 1)
//                     {
//                       showDialog(
//                           context: context,
//                           barrierDismissible: false,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: new Text("로그인"),
//                               content: new Text("로그인이 필요합니다."),
//                               actions: <Widget>[
//                                 new FlatButton(
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               LoginIndexPage()),
//                                     );
//                                   },
//                                   child: new Text("로그인 페이지로 이동"),
//                                 ),
//                               ],
//                             );
//                           }),
//                     },

//                   // 스크랩
//                   if (auth.currentUser != null && index == 2)
//                     {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => ScrapPage()),
//                       ),
//                     },

//                   //미가입 시
//                   if (auth.currentUser == null && index == 2)
//                     {
//                       showDialog(
//                           context: context,
//                           barrierDismissible: false,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: new Text("로그인"),
//                               content: new Text("로그인이 필요합니다."),
//                               actions: <Widget>[
//                                 new FlatButton(
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               LoginIndexPage()),
//                                     );
//                                   },
//                                   child: new Text("로그인 페이지로 이동"),
//                                 ),
//                               ],
//                             );
//                           }),
//                     },
//                   // 마이페이지
//                   if (index == 3)
//                     {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => MyPage()),
//                       ),
//                     },
//                 },
//             currentIndex: 0,
//             items: [
//               new BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 title: Text('홈'),
//               ),
//               new BottomNavigationBarItem(
//                 icon: Icon(Icons.add),
//                 title: Text('글쓰기'),
//               ),
//               new BottomNavigationBarItem(
//                 icon: Icon(Icons.bookmark),
//                 title: Text('스크랩'),
//               ),
//               new BottomNavigationBarItem(
//                 icon: Icon(Icons.person),
//                 title: Text('마이페이지'),
//               )
//             ]),
//       );
//     }
//   }
// }

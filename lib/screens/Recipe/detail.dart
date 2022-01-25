// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:today_dinner/screens/Product/index.dart';
// import 'package:today_dinner/screens/Reply/index.dart';
// import 'package:today_dinner/screens/Home/index.dart';
// import 'package:today_dinner/screens/Product/index.dart';
// import 'package:today_dinner/screens/Scrap/index.dart';
// import 'package:today_dinner/screens/Recipe/index.dart';
// import 'package:today_dinner/screens/Shopping/index.dart';
// import 'package:today_dinner/screens/Write/index.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:today_dinner/screens/Reply/index.dart';
// import 'package:today_dinner/screens/Mypage/index.dart';
// import 'package:today_dinner/screens/Mypage/Mywrite.dart';
// import 'package:today_dinner/screens/Home/login.dart';
// import 'package:today_dinner/screens/Login/index.dart';
// // provider => watch는 값이 변화할 때 리렌더링, read는 값이 변화해도 렌더링 x
// // => watch는 값을 보여주는 UI에 read는 변경이 필요없는 함수에 주로 사용
// import 'package:today_dinner/providers/home.dart';
// import 'package:today_dinner/providers/write.dart';
// import 'package:today_dinner/providers/recipe.dart';
// import 'package:today_dinner/providers/reply.dart';

// // firestorage.List feed_image = firestorage.ref('20210917_164230.jpg');
// // var url = firestorage.ref('20210917_164230.jpg').getDownloadURL();

// // firebase auth
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:provider/provider.dart';
// // provider listener 이용
// import 'package:flutter/foundation.dart';

// // youtube
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// FirebaseAuth auth = FirebaseAuth.instance;

// FirebaseAnalytics analytics = FirebaseAnalytics.instance;

// // appbar 지우기
// class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }

//   @override
//   Size get preferredSize => Size(0.0, 0.0);
// }

// // youtube video
// class Player extends StatefulWidget {
//   var data;

//   Player(this.data);

//   @override
//   _PlayerState createState() => _PlayerState();
// }

// class _PlayerState extends State<Player> {
//   late YoutubePlayerController _controller;
//   var videoId;
//   @override
//   void initState() {
//     super.initState();
//     videoId = YoutubePlayer.convertUrlToId("${widget.data['videourl']}");
//     _controller = YoutubePlayerController(
//       initialVideoId: videoId ?? "zkKqPiSYMAc",
//       flags: const YoutubePlayerFlags(
//         mute: false,
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
//     print(widget.data['tag']);
//     Orientation currentOrientation = MediaQuery.of(context).orientation;
//     return Align(
//       alignment: Alignment.center,
//       child: Container(
//         height: currentOrientation == Orientation.portrait
//             ? 340
//             : MediaQuery.of(context).size.width,
//         width: currentOrientation == Orientation.portrait
//             ? MediaQuery.of(context).size.width
//             : MediaQuery.of(context).size.width - 100,
//         child: Column(children: [
//           YoutubePlayer(
//             key: ObjectKey(_controller),
//             controller: _controller,
//             actionsPadding: const EdgeInsets.only(left: 16.0),
//             bottomActions: [
//               CurrentPosition(),
//               const SizedBox(width: 10.0),
//               ProgressBar(isExpanded: true),
//               const SizedBox(width: 10.0),
//               RemainingDuration(),
//               PlaybackSpeedButton(),
//               FullScreenButton(),
//             ],
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   for (var tag in widget.data?['tag'])
//                     Container(
//                         margin: EdgeInsets.only(left: 10, top: 5),
//                         child: TextButton(
//                           onPressed: () async {
//                             // gtag
//                             await analytics
//                                 .logEvent(name: 'click_timelink', parameters: {
//                               'recipe_name': widget.data['id'],
//                               'recipe_tag_name': tag['name'],
//                             });

//                             // 동영상 초 이동
//                             _controller
//                                 .seekTo(Duration(seconds: tag['seconds']));
//                           },
//                           style: TextButton.styleFrom(
//                               primary: Color.fromRGBO(201, 92, 57, 1),
//                               backgroundColor: Colors.white,
//                               side: BorderSide(
//                                   color: Color.fromRGBO(201, 92, 57, 1),
//                                   width: 2)),
//                           child: Text(
//                             tag['name'],
//                             style: TextStyle(
//                                 fontSize: 12,
//                                 color: Color.fromRGBO(201, 92, 57, 1)),
//                           ),
//                         )),
//                 ],
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }

// // 로그인 기본 class
// class RecipePage extends StatefulWidget {
//   @override
//   _RecipePageState createState() => _RecipePageState();
// }

// class _RecipePageState extends State<RecipePage> {
//   @override
//   void initState() {
//     // 로그인 상태인지 확인
//     // print(auth.currentUser);
//     if (auth.currentUser != null) {
//       // print(auth.currentUser!.uid);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // 그리드 뷰 이미지
//     List<String> images = [
//       "assets/main.jpg",
//     ];
//     Orientation currentOrientation = MediaQuery.of(context).orientation;
//     if (currentOrientation == Orientation.portrait) {
//       return Scaffold(
//         appBar: AppBar(
//           iconTheme: IconThemeData(
//             color: Color.fromRGBO(40, 40, 40, 1), //색변경
//           ),
//           backgroundColor: Colors.white,
//           title: Text(
//             context.watch<Recipe>().Selected_data['title'],
//             style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Color.fromRGBO(40, 40, 40, 1)),
//           ),
//           centerTitle: true,
//         ),
//         body: SingleChildScrollView(
//           child: Container(
//             child: Column(
//               children: <Widget>[
//                 Player(context.watch<Recipe>().Selected_data),

//                 // 제품 태그
//                 ListTile(
//                   //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
//                   title: Text('음식정보',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border(
//                       top: BorderSide(
//                           width: 1, color: Color.fromRGBO(40, 40, 40, 1)),
//                     ),
//                   ),
//                   margin: EdgeInsets.only(left: 15, right: 15),
//                   child: Column(children: [
//                     Container(
//                       height: 30,
//                       decoration: BoxDecoration(
//                         border: Border(
//                           bottom:
//                               BorderSide(width: 1, color: Colors.grey.shade300),
//                         ),
//                       ),
//                       child: ListTile(
//                         dense: true,
//                         visualDensity: VisualDensity(vertical: -4),
//                         //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
//                         title: Text('난이도',
//                             style: TextStyle(
//                               fontSize: 10.0,
//                               fontWeight: FontWeight.bold,
//                             )),
//                         trailing: Text(
//                           context.watch<Recipe>().Selected_data['difficulty'],
//                           style: TextStyle(
//                             fontSize: 10.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: 30,
//                       decoration: BoxDecoration(
//                         border: Border(
//                           bottom:
//                               BorderSide(width: 1, color: Colors.grey.shade300),
//                         ),
//                       ),
//                       child: ListTile(
//                         dense: true,
//                         visualDensity: VisualDensity(vertical: -4),
//                         //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
//                         title: Text('소요시간',
//                             style: TextStyle(
//                               fontSize: 10.0,
//                               fontWeight: FontWeight.bold,
//                             )),
//                         trailing: Text(
//                           context.watch<Recipe>().Selected_data['spendtime'],
//                           style: TextStyle(
//                             fontSize: 10.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: 30,
//                       decoration: BoxDecoration(
//                         border: Border(
//                           bottom:
//                               BorderSide(width: 1, color: Colors.grey.shade300),
//                         ),
//                       ),
//                       child: ListTile(
//                         dense: true,
//                         visualDensity: VisualDensity(vertical: -4),
//                         //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
//                         title: Text('인분',
//                             style: TextStyle(
//                               fontSize: 10.0,
//                               fontWeight: FontWeight.bold,
//                             )),
//                         trailing: Text(
//                           context.watch<Recipe>().Selected_data['serving'],
//                           style: TextStyle(
//                             fontSize: 10.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ]),
//                 ),

//                 // 제품 태그
//                 ListTile(
//                   //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
//                   title: Text('기본 재료',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border(
//                       top: BorderSide(
//                           width: 1, color: Color.fromRGBO(40, 40, 40, 1)),
//                     ),
//                   ),
//                   margin: EdgeInsets.only(left: 15, right: 15),
//                   child: Column(children: [
//                     // 내용
//                     for (var primary_data
//                         in context.watch<Recipe>().Selected_data['primary'])
//                       Container(
//                         height: 30,
//                         constraints: BoxConstraints(maxHeight: 150),
//                         decoration: BoxDecoration(
//                           border: Border(
//                             bottom: BorderSide(
//                                 width: 1, color: Colors.grey.shade300),
//                           ),
//                         ),
//                         child: ListTile(
//                             dense: true,
//                             visualDensity: VisualDensity(vertical: -4),
//                             minLeadingWidth: 200,
//                             leading: Text(primary_data['title'],
//                                 style: TextStyle(
//                                   fontSize: 10.0,
//                                   fontWeight: FontWeight.bold,
//                                 )),
//                             onTap: () async {},
//                             trailing: Container(
//                               width: MediaQuery.of(context).size.width - 200,
//                               child: Align(
//                                 alignment: Alignment.centerRight,
//                                 child: Text(primary_data['content'],
//                                     maxLines: 5,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                       fontSize: 10.0,
//                                       fontWeight: FontWeight.bold,
//                                     )),
//                               ),
//                             )),
//                       ),
//                   ]),
//                 ),

//                 if (context.watch<Recipe>().Selected_data['secondary'].length >
//                     0)
//                   ListTile(
//                     //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
//                     title: Text('양념/소스 재료',
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                   ),
//                 if (context.watch<Recipe>().Selected_data['secondary'].length >
//                     0)
//                   Container(
//                     decoration: BoxDecoration(
//                       border: Border(
//                         top: BorderSide(
//                             width: 1, color: Color.fromRGBO(40, 40, 40, 1)),
//                       ),
//                     ),
//                     margin: EdgeInsets.only(left: 15, right: 15),
//                     child: Column(children: [
//                       // 내용
//                       for (var primary_data
//                           in context.watch<Recipe>().Selected_data['secondary'])
//                         Container(
//                           constraints:
//                               BoxConstraints(minHeight: 30, maxHeight: 150),
//                           decoration: BoxDecoration(
//                             border: Border(
//                               bottom: BorderSide(
//                                   width: 1, color: Colors.grey.shade300),
//                             ),
//                           ),
//                           child: ListTile(
//                               dense: true,
//                               visualDensity: VisualDensity(vertical: -4),
//                               minLeadingWidth: 200,
//                               leading: Text(primary_data['title'],
//                                   style: TextStyle(
//                                     fontSize: 10.0,
//                                     fontWeight: FontWeight.bold,
//                                   )),
//                               onTap: () async {},
//                               trailing: Container(
//                                 width: MediaQuery.of(context).size.width - 200,
//                                 child: Align(
//                                   alignment: Alignment.centerRight,
//                                   child: Text(primary_data['content'],
//                                       maxLines: 5,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                         fontSize: 10.0,
//                                         fontWeight: FontWeight.bold,
//                                       )),
//                                 ),
//                               )),
//                         ),
//                     ]),
//                   ),

//                 // // 상세 하단 경계선
//                 if (context.watch<Recipe>().Selected_data['reply'].length != 0)
//                   Container(
//                       margin: EdgeInsets.only(left: 15, right: 15),
//                       padding: EdgeInsets.only(top: 20, bottom: 20),
//                       child: Divider(color: Colors.grey[300], thickness: 1.0)),

//                 // 댓글 2개 이상일 때
//                 if (context.watch<Recipe>().Selected_data['reply'] != null &&
//                     context.watch<Recipe>().Selected_data['reply'].length > 2)
//                   GestureDetector(
//                     onTap: () async {
//                       //페이지 이동
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => ReplyPage()),
//                       );
//                     },
//                     child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Container(
//                         margin: EdgeInsets.only(left: 15, right: 15),
//                         child: Text(
//                             '댓글 ${context.watch<Recipe>().Selected_data['reply'].length}개 모두 보기'),
//                       ),
//                     ),
//                   ),

//                 // Start : 댓글 2개 미리보기 => 2개 이하인 경우에는 전부 / 2개 이상인 경우에는 2개만
//                 if (context.watch<Recipe>().Selected_data['reply'] != null &&
//                     context.watch<Recipe>().Selected_data['reply'].length !=
//                         0 &&
//                     context.watch<Recipe>().Selected_data['reply'].length < 3)
//                   for (var reply
//                       in context.watch<Recipe>().Selected_data['reply'])
//                     Column(children: [
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Row(children: [
//                           Container(
//                             padding: EdgeInsets.only(left: 10),
//                             child: Text('${reply['nickname']} ',
//                                 style: TextStyle(fontWeight: FontWeight.bold)),
//                           ),
//                           Container(
//                             padding: EdgeInsets.only(left: 10),
//                             child: Text('${reply['content']}'),
//                           ),
//                         ]),
//                       ),
//                     ]),
//                 if (context.watch<Recipe>().Selected_data['reply'] != null &&
//                     context.watch<Recipe>().Selected_data['reply'].length !=
//                         0 &&
//                     context.watch<Recipe>().Selected_data['reply'].length > 2)
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Column(children: [
//                       Row(children: [
//                         Container(
//                           padding: EdgeInsets.only(left: 10),
//                           child: Text(
//                               '${context.watch<Recipe>().Selected_data['reply'][0]['nickname']} ',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                         ),
//                         Container(
//                           padding: EdgeInsets.only(left: 10),
//                           child: Text(
//                               '${context.watch<Recipe>().Selected_data['reply'][0]['content']}'),
//                         ),
//                       ]),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(children: [
//                         Container(
//                           padding: EdgeInsets.only(left: 10),
//                           child: Text(
//                               '${context.watch<Recipe>().Selected_data['reply'][1]['nickname']} ',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                         ),
//                         Container(
//                           padding: EdgeInsets.only(left: 10),
//                           child: Text(
//                               '${context.watch<Recipe>().Selected_data['reply'][1]['content']}'),
//                         ),
//                       ]),
//                     ]),
//                   ),

//                 SizedBox(
//                   height: 30,
//                 ),

//                 // 댓글 입력
//                 Container(
//                   margin: EdgeInsets.only(left: 15, right: 15),
//                   child: Row(children: [
//                     Expanded(
//                         flex: 8,
//                         child: Container(
//                             height: 40,
//                             child: TextField(
//                               decoration: InputDecoration(
//                                 hintText: '댓글을 입력해주세요.',
//                               ),
//                               onChanged: (text) {
//                                 // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
//                                 context.read<Reply>().setReply(text);
//                               },
//                             ))),
//                     Expanded(flex: 1, child: Container()),
//                     Expanded(
//                       flex: 3,
//                       child: TextButton(
//                         onPressed: () {
//                           context.read<Reply>().replyComplete(
//                               context.read<Recipe>().Selected_data['id'],
//                               context.read<Home>().User[0],
//                               auth,
//                               context,
//                               context.read<Home>().top_index);
//                         },
//                         style: TextButton.styleFrom(
//                             primary: Color.fromRGBO(201, 92, 57, 1),
//                             backgroundColor: Colors.white,
//                             side: BorderSide(
//                                 color: Color.fromRGBO(201, 92, 57, 1),
//                                 width: 2)),
//                         child: Text(
//                           "입력하기",
//                           style: TextStyle(
//                               fontSize: 12,
//                               color: Color.fromRGBO(201, 92, 57, 1)),
//                         ),
//                       ),
//                     ),
//                   ]),
//                 ),
//                 Container(
//                   height: 20,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//             selectedItemColor: Color.fromRGBO(201, 92, 57, 1),
//             type: BottomNavigationBarType.fixed,
//             onTap: (index) => {
//                   // 홈
//                   if (index == 0)
//                     {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => HomePage()),
//                       ),
//                     },

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
//     } else {
//       return Scaffold(
//         appBar: null,
//         body: SingleChildScrollView(
//           child: Container(
//             child: Column(children: <Widget>[
//               Container(
//                 child: Column(children: <Widget>[
//                   Player(context.watch<Recipe>().Selected_data),
//                 ]),
//               ),
//             ]),
//           ),
//         ),
//       );
//     }
//   }
// }

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// // provider listener 이용
// import 'package:flutter/foundation.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:today_dinner/screens/Scrap/index.dart';
// import 'package:today_dinner/screens/Recipe/index.dart';
// import 'package:today_dinner/screens/Shopping/index.dart';
// import 'package:today_dinner/screens/Write/index.dart';
// import 'package:today_dinner/screens/Home/index.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:today_dinner/screens/Mypage/index.dart';
// import 'package:today_dinner/screens/Home/login.dart';
// import 'package:today_dinner/screens/Login/index.dart';
// // provider => watch는 값이 변화할 때 리렌더링, read는 값이 변화해도 렌더링 x
// // => watch는 값을 보여주는 UI에 read는 변경이 필요없는 함수에 주로 사용
// import 'package:today_dinner/providers/home.dart';
// import 'package:today_dinner/providers/write.dart';

// // firestorage.List feed_image = firestorage.ref('20210917_164240.jpg');
// // var url = firestorage.ref('20210917_164240.jpg').getDownloadURL();

// // firebase auth
// import 'package:firebase_auth/firebase_auth.dart';

// // 갤러리에서 이미지 가져오기
// import 'package:image_picker/image_picker.dart';

// // firebase 데이터 저장
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:get/get.dart'; // url 가져오기
// import 'dart:io';

// FirebaseAuth auth = FirebaseAuth.instance;

// FileStorage _fileStoarge = Get.put(FileStorage());

// class FileStorage extends GetxController {
//   late FirebaseStorage storage; //= FirebaseStorage.instance; //storage instance
//   late Reference storageRef; //= storage.ref().child(''); //storage

//   FileStorage() {
//     storage = FirebaseStorage.instance;
//   }

//   Future<String> uploadFile(String filePath, String uploadPath) async {
//     File file = File(filePath);

//     try {
//       storageRef = storage.ref(uploadPath);
//       await storageRef.putFile(file);
//       String downloadURL = await storageRef.getDownloadURL();
//       return downloadURL;
//     } on FirebaseException catch (e) {
//       // e.g, e.code == 'canceled'
//       return '-1';
//     }
//   }
// }

// // SelectedFilter 기본 class => 선택된 필터 종류 보여주는 박스
// class SelectedFilter extends StatefulWidget {
//   @override
//   _SelectedFilterState createState() => _SelectedFilterState();
// }

// class _SelectedFilterState extends State<SelectedFilter> {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Container(
//         height: 30,
//         margin: EdgeInsets.only(bottom: 20),
//         child: Row(children: [
//           for (var text in context.watch<Write>().Selected_list)
//             Container(
//               decoration: BoxDecoration(
//                   color: Colors.grey.shade200,
//                   borderRadius: BorderRadius.circular(40.0)),
//               padding: EdgeInsets.only(left: 15),
//               margin: EdgeInsets.only(right: 15),
//               child: Row(children: [
//                 Text(
//                   text,
//                   style: TextStyle(
//                       fontSize: 14, color: Color.fromRGBO(201, 92, 57, 1)),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.close, size: 12),
//                   onPressed: () {
//                     context.read<Write>().remove_list(text);
//                   },
//                 ),
//               ]),
//             ),
//         ]),
//       ),
//     );
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
//                   _showbottomCook(context);
//                 },
//               ),
//               ListTile(
//                 title: new Text('영유아식'),
//                 onTap: () async {
//                   _showbottomBaby(context);
//                 },
//               ),
//               if (context.watch<Home>().top_index != 3)
//                 ListTile(
//                   title: new Text('식사'),
//                   onTap: () async {
//                     _showbottomMeal(context);
//                   },
//                 ),
//               ListTile(
//                 title: new Text('종류'),
//                 onTap: () {
//                   _showbottomCategory(context);
//                 },
//               ),
//               ListTile(
//                 title: new Text('식재료'),
//                 onTap: () {
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
//                     context.read<Write>().add_list(data['value']);
//                     // 2단계 종료
//                     Navigator.pop(context);
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
//                     context.read<Write>().add_list(data['value']);
//                     // 2단계 종료
//                     Navigator.pop(context);
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
//                     context.read<Write>().add_list(data['value']);
//                     // 2단계 종료
//                     Navigator.pop(context);
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
//                         context.read<Write>().add_list(data['value']);
//                         // 2단계 종료
//                         Navigator.pop(context);
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
//                     context.read<Write>().add_list(key);
//                     // 3단계 종료
//                     Navigator.pop(context);
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
//       padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             flex: 1,
//             child: GestureDetector(
//               onTap: () async {
//                 _showbottom(context);
//               },
//               child: Icon(
//                 Icons.filter_alt,
//                 size: 32,
//                 color: Color.fromRGBO(201, 92, 57, 1),
//               ),
//             ),
//           ),
//         ],
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
//                 context.read<Write>().select_top(1);
//                 setState(() {});
//               },
//               child: Column(
//                 children: <Widget>[
//                   Text(
//                     '식사',
//                     style: TextStyle(
//                         fontSize: 18,
//                         color: context.watch<Write>().top_index == 1
//                             ? Color.fromRGBO(201, 92, 57, 1)
//                             : Color.fromRGBO(40, 40, 40, 1)),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       border: Border(
//                           bottom: BorderSide(
//                               width: context.watch<Write>().top_index == 1
//                                   ? 3.0
//                                   : 0.0,
//                               color: context.watch<Write>().top_index == 1
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
//                 context.read<Write>().select_top(2);
//                 setState(() {});
//               },
//               child: Column(
//                 children: <Widget>[
//                   Text(
//                     '자유 수다방',
//                     style: TextStyle(
//                         fontSize: 18,
//                         color: context.watch<Write>().top_index ==
//                                 2 // 수정 시 재빌드하기 위해서는 watch를 사용
//                             ? Color.fromRGBO(201, 92, 57, 1)
//                             : Color.fromRGBO(40, 40, 40, 1)),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       border: Border(
//                           bottom: BorderSide(
//                               width: context.watch<Write>().top_index == 2
//                                   ? 3.0
//                                   : 0.0,
//                               color: context.watch<Write>().top_index == 2
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
// class WritePage extends StatefulWidget {
//   @override
//   _WritePageState createState() => _WritePageState();
// }

// class _WritePageState extends State<WritePage> {
//   @override
//   void initState() {
//     super.initState();
//     // 로그인 상태인지 확인
//     print(auth.currentUser);
//     if (auth.currentUser != null) {
//       print(auth.currentUser!.uid);
//     }

//     // listener를 추가하여 비동기 변경이 발생했을 때 수정할 수 있도록 changeNotifier를 듣고 있음
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

//   // "글쓰기" 클릭했을 때
//   Future<dynamic> _writeButtonPressed() async {
//     context.read<Write>().writeComplete(context, context.read<Home>().User);
//     // alert 창 띄우기
//     if (context.read<Write>().AlertTitle != "") {
//       showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: new Text(context.read<Write>().AlertTitle),
//               content: new Text(context.read<Write>().AlertContent),
//               actions: <Widget>[
//                 new FlatButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: new Text("닫기"),
//                 ),
//               ],
//             );
//           });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // 그리드 뷰 이미지
//     List<String> images = [
//       "assets/main.jpg",
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: Color.fromRGBO(40, 40, 40, 1), //색변경
//         ),
//         backgroundColor: Colors.white,
//         title: Text(
//           "글쓰기",
//           style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Color.fromRGBO(40, 40, 40, 1)),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.only(left: 15, right: 15),
//           child: Column(
//             children: <Widget>[
//               // 메인 상단 메뉴
//               TopBar(),
//               // 본문 내용
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(children: [
//                   for (var image in context.watch<Write>().ImageUrl)
//                     Container(
//                       width: MediaQuery.of(context).size.width * 0.9,
//                       padding: EdgeInsets.only(
//                         right: 20,
//                       ),
//                       height: 300,
//                       child: FadeInImage(
//                         image: NetworkImage(
//                           image,
//                         ),
//                         placeholder: AssetImage('assets/loading.gif'),
//                         imageErrorBuilder: (context, exception, stackTrace) {
//                           print(exception);
//                           return Image.asset('assets/loading.gif');
//                         },
//                         fit: BoxFit.fitWidth,
//                       ),
//                     ),
//                   GestureDetector(
//                     onTap: () {
//                       context.read<Write>().getGalleryImage().then((_) {
//                         setState(() {});
//                       });
//                     },
//                     child: Container(
//                       width: MediaQuery.of(context).size.width * 0.9,
//                       height: 300,
//                       color: Colors.grey[300],
//                       padding: EdgeInsets.all(10.0),
//                       child: Center(
//                         child: Icon(Icons.add, size: 50, color: Colors.grey),
//                       ),
//                     ),
//                   ),
//                 ]),
//               ),

//               // 필터 선택 tagbox
//               Container(
//                 margin: EdgeInsets.only(bottom: 20),
//                 child: TextField(
//                   maxLines: 3,
//                   decoration: InputDecoration(
//                     hintText: context.read<Write>().top_index == 1
//                         ? '사진에 대해 설명해주세요.'
//                         : '내용을 작성해주세요.',
//                   ),
//                   onChanged: (text) {
//                     // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
//                     context.read<Write>().setContent(text);
//                   },
//                 ),
//               ),

//               Filter(),
//               Container(
//                 child: Text(
//                   '필터를 선택해주세요.',
//                 ),
//               ),
//               SizedBox(height: 20),
//               // 필터 선택 tagbox
//               SelectedFilter(),
//               Container(
//                 width: 300,
//                 child: TextButton(
//                   onPressed: _writeButtonPressed,
//                   style: TextButton.styleFrom(
//                       primary: Color.fromRGBO(201, 92, 57, 1),
//                       backgroundColor: Color.fromRGBO(201, 92, 57, 1),
//                       side: BorderSide(
//                           color: Color.fromRGBO(201, 92, 57, 1), width: 2)),
//                   child: Text(
//                     "글쓰기",
//                     style: TextStyle(fontSize: 17, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//           selectedItemColor: Color.fromRGBO(201, 92, 57, 1),
//           type: BottomNavigationBarType.fixed,
//           onTap: (index) => {
//                 // 홈
//                 if (index == 0)
//                   {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (context) => HomePage()),
//                     ),
//                   },

//                 // 글쓰기
//                 if (auth.currentUser != null && index == 1)
//                   {
//                     context.read<Write>().init(), // 글 쓸 때 이미지 초기화
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => WritePage()),
//                     ),
//                   },

//                 // 미가입 시
//                 if (auth.currentUser == null && index == 1)
//                   {
//                     showDialog(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: new Text("로그인"),
//                             content: new Text("로그인이 필요합니다."),
//                             actions: <Widget>[
//                               new FlatButton(
//                                 onPressed: () {
//                                   Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => LoginIndexPage()),
//                                   );
//                                 },
//                                 child: new Text("로그인 페이지로 이동"),
//                               ),
//                             ],
//                           );
//                         }),
//                   },

//                 // 스크랩
//                 if (auth.currentUser != null && index == 2)
//                   {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ScrapPage()),
//                     ),
//                   },

//                 //미가입 시
//                 if (auth.currentUser == null && index == 2)
//                   {
//                     showDialog(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: new Text("로그인"),
//                             content: new Text("로그인이 필요합니다."),
//                             actions: <Widget>[
//                               new FlatButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => LoginIndexPage()),
//                                   );
//                                 },
//                                 child: new Text("로그인 페이지로 이동"),
//                               ),
//                             ],
//                           );
//                         }),
//                   },
//                 // 마이페이지
//                 if (index == 3)
//                   {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => MyPage()),
//                     ),
//                   },
//               },
//           currentIndex: 0,
//           items: [
//             new BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               title: Text('홈'),
//             ),
//             new BottomNavigationBarItem(
//               icon: Icon(Icons.add),
//               title: Text('글쓰기'),
//             ),
//             new BottomNavigationBarItem(
//               icon: Icon(Icons.bookmark),
//               title: Text('스크랩'),
//             ),
//             new BottomNavigationBarItem(
//               icon: Icon(Icons.person),
//               title: Text('마이페이지'),
//             )
//           ]),
//     );
//   }
// }

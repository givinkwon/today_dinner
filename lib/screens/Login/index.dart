// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// // screen
// import 'package:today_dinner/screens/Login/findpassword.dart';
// // provider listener 이용
// // provider => watch는 값이 변화할 때 리렌더링, read는 값이 변화해도 렌더링 x
// // => watch는 값을 보여주는 UI에 read는 변경이 필요없는 함수에 주로 사용
// import 'package:today_dinner/providers/login.dart';
// // provider listener 이용
// import 'package:flutter/foundation.dart';

// // 로그인 기본 class
// class LoginIndexPage extends StatefulWidget {
//   @override
//   _LoginIndexPageState createState() => _LoginIndexPageState();
// }

// class _LoginIndexPageState extends State<LoginIndexPage> {
//   // 로그인 클릭했을 때
//   Future<void> _loginButtonPressed() async {
//     context.read<Login>().login(context);

//     // alert 창 띄우기
//     if (context.read<Login>().AlertTitle != "") {
//       showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: new Text(context.read<Login>().AlertTitle),
//               content: new Text(context.read<Login>().AlertContent),
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
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: Color.fromRGBO(40, 40, 40, 1), //색변경
//         ),
//         backgroundColor: Colors.white,
//         title: Text(
//           "로그인",
//           style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Color.fromRGBO(40, 40, 40, 1)),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Container(
//               height: 200,
//             ),
//             Row(
//               children: <Widget>[
//                 SizedBox(
//                   width: 30,
//                 ),
//                 Expanded(
//                   child: Container(
//                       height: 40,
//                       child: TextField(
//                         decoration: InputDecoration(
//                           hintText: '이메일을 입력해주세요.',
//                         ),
//                         onChanged: (text) {
//                           // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
//                           context.read<Login>().setEmail(text);
//                         },
//                       )),
//                 ),
//                 SizedBox(
//                   width: 30,
//                 ),
//               ],
//             ),
//             Container(
//               height: 30,
//             ),
//             Row(
//               children: <Widget>[
//                 SizedBox(
//                   width: 30,
//                 ),
//                 Expanded(
//                   child: Container(
//                       height: 40,
//                       child: TextField(
//                         obscureText: true,
//                         enableSuggestions: false,
//                         autocorrect: false,
//                         decoration: InputDecoration(
//                           hintText: '비밀번호를 입력해주세요.',
//                         ),
//                         onChanged: (text) {
//                           // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
//                           context.read<Login>().setPassword(text);
//                         },
//                       )),
//                 ),
//                 SizedBox(
//                   width: 30,
//                 ),
//               ],
//             ),
//             Container(
//               height: 30,
//             ),
//             Row(
//               children: <Widget>[
//                 SizedBox(
//                   width: 30,
//                 ),
//                 Expanded(
//                   child: TextButton(
//                     onPressed: _loginButtonPressed,
//                     style: TextButton.styleFrom(
//                         primary: Color.fromRGBO(201, 92, 57, 1),
//                         backgroundColor: Color.fromRGBO(201, 92, 57, 1),
//                         side: BorderSide(
//                             color: Color.fromRGBO(201, 92, 57, 1), width: 2)),
//                     child: Text(
//                       "로그인하기",
//                       style: TextStyle(fontSize: 17, color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 30,
//                 ),
//               ],
//             ),
//             Row(
//               children: <Widget>[
//                 SizedBox(
//                   width: 30,
//                 ),
//                 Expanded(
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => FindPasswordPage()));
//                     },
//                     style: TextButton.styleFrom(
//                         primary: Color.fromRGBO(201, 92, 57, 1),
//                         backgroundColor: Colors.grey,
//                         side: BorderSide(color: Colors.grey, width: 2)),
//                     child: Text(
//                       "비밀번호 찾기",
//                       style: TextStyle(fontSize: 17, color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 30,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

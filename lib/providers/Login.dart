// import 'package:flutter/material.dart';

// // firebase database => firestore
// import 'package:cloud_firestore/cloud_firestore.dart';
// // firebase storage
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// // provider listener 이용
// import 'package:flutter/foundation.dart';

// // provider import
// import 'package:today_dinner/repo/Feed.dart';
// import 'package:today_dinner/repo/Freetalk.dart';
// import 'package:today_dinner/repo/Recipe.dart';
// import 'package:today_dinner/repo/User.dart';

// // firebase auth
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:today_dinner/screens/Home/index.dart';

// FirebaseFirestore firestore = FirebaseFirestore.instance;
// firebase_storage.FirebaseStorage storage =
//     firebase_storage.FirebaseStorage.instance;

// class LoginViewmodel with ChangeNotifier {
//   // 생성자
//   LoginViewModel() {}

//   String Email = "";

//   // 이메일 입력
//   void setEmail(value) {
//     Email = value;
//   }

//   String Password = "";

//   // 비밀번호 입력
//   void setPassword(value) {
//     Password = value;
//   }

//   int Error = 0; // Error state => 1일 때 Error 발생
//   String AlertTitle = ""; // Alert 제목
//   String AlertContent = ""; // Alert 내용
//   int EmailCheckState = 0; // email check가 완료되면 1

//   int isUser = 0; // 0이면 user가 없는 것, 1이면 user가 있는 것

//   // 로그인
//   Future<dynamic> login(context) async {
//     // init
//     isUser = 0;
//     Error = 0;
//     AlertTitle = "";
//     AlertContent = "";

//     // 예외처리
//     if (Email == "") {
//       Error = 1;
//       AlertTitle = "로그인 에러";
//       AlertContent = "이메일을 입력해주세요.";
//       return;
//     }
//     if (!RegExp(
//             r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
//         .hasMatch(Email.toString())) {
//       Error = 1;
//       AlertTitle = "로그인 에러";
//       AlertContent = "이메일 형식을 확인해주세요.";
//       return;
//     }
//     if (Password == "") {
//       Error = 1;
//       AlertTitle = "로그인 에러";
//       AlertContent = "비밀번호를 입력해주세요.";
//       return;
//     }

//     // 로그인하기
//     try {
//       await FirebaseAuth.instance
//           .signInWithEmailAndPassword(
//             email: Email,
//             password: Password,
//           )
//           .then((_) => {
//                 // 페이지 이동
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomePage()),
//                 )
//               });
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: new Text("로그인 에러"),
//                 content: new Text("없는 계정입니다."),
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
//       } else if (e.code == 'wrong-password') {
//         showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: new Text("로그인 에러"),
//                 content: new Text("비밀번호가 틀립니다."),
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
//       }
//     }
//   }
// }

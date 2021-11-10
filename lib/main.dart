import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// // 카카오 로그인
// import 'package:kakao_flutter_sdk/all.dart';

import 'screens/Home/login.dart';

import 'package:provider/provider.dart';
// provider
import 'package:today_dinner/providers/home.dart';
import 'package:today_dinner/providers/signup.dart';
import 'package:today_dinner/providers/login.dart';
import 'package:today_dinner/providers/write.dart';
import 'package:today_dinner/providers/recipe.dart';
import 'package:today_dinner/providers/reply.dart';
import 'package:today_dinner/providers/mypage.dart';
import 'package:today_dinner/providers/profile.dart';

// firebase database => firestore
import 'package:cloud_firestore/cloud_firestore.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // KakaoContext.clientId = "457c2efc04af1b1dd6b18bcb2ab525bb";
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => Home()),
      ChangeNotifierProvider(create: (_) => Signup()),
      ChangeNotifierProvider(create: (_) => Login()),
      ChangeNotifierProvider(create: (_) => Write()),
      ChangeNotifierProvider(create: (_) => Recipe()),
      ChangeNotifierProvider(create: (_) => Reply()),
      ChangeNotifierProvider(create: (_) => Mypage()),
      ChangeNotifierProvider(create: (_) => Profile()),
    ], child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    // UI 용 : https://muhly.tistory.com/67
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      // 배경을 흰색으로 => 안드로이드에서만 작동
      statusBarColor: Colors.white,
      // 검정색 배경으로 => ios에서 작동
      statusBarBrightness: Brightness.light,
    ));
    return MaterialApp(
      // debug 띠 없애기
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

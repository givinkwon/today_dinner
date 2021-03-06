import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:today_dinner/providers/Login.dart';
import 'package:today_dinner/providers/Mypage.dart';
// provider

import 'package:today_dinner/providers/Recipe.dart';
import 'package:today_dinner/providers/Scrap.dart';
import 'package:today_dinner/providers/Signup.dart';
import 'package:today_dinner/providers/Video.dart';
import 'package:today_dinner/screens/Login/index.dart';
// // 카카오 로그인
// import 'package:kakao_flutter_sdk/all.dart';

import 'package:provider/provider.dart';

// firebase database => firestore
import 'package:cloud_firestore/cloud_firestore.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

// push alarm
import 'package:firebase_messaging/firebase_messaging.dart';

// GA & GTAG
import 'package:firebase_analytics/firebase_analytics.dart';

// auth
import 'package:firebase_auth/firebase_auth.dart';
import 'package:today_dinner/screens/Recipe/index.dart';
import 'package:today_dinner/screens/Video/index.dart';

FirebaseAuth auth = FirebaseAuth.instance;

FirebaseAnalytics analytics = FirebaseAnalytics.instance;

FirebaseMessaging messaging = FirebaseMessaging.instance;

// 백그라운드 메세지
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  // facebook login
  // initialiaze the facebook javascript SDK
  FacebookAuth.instance.webInitialize(
    appId: "314172300596289",
    cookie: true,
    xfbml: true,
    version: "v12.0",
  );
  // gtag
  // analytics.logEvent(name: 'add_folder');

  // KakaoContext.clientId = "457c2efc04af1b1dd6b18bcb2ab525bb";
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // push alarm 권한 요청
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  // 반환된 토큰을 사용하여 사용자 지정 서버에서 사용자에게 메시지를 보냅니다.
  String? token = await messaging.getToken(
    vapidKey:
        "BKGWcPsrVOksieVQ4lNG2jngvBsrRQtQsrb8sKAt3k6GfncP9zDrZcTcGdInv1nEbXK15t3phhawJg19Xoj84vg",
  );

  // 포그라운드에서 메세지 받았을 때
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  // 백그라운드에서 메세지 받았을 때
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => VideoViewModel()),
      ChangeNotifierProvider(create: (context) => RecipeViewModel()),
      ChangeNotifierProvider(create: (context) => ScrapViewModel()),
      ChangeNotifierProvider(create: (context) => SignupViewModel()),
      ChangeNotifierProvider(create: (context) => LoginViewModel()),
      ChangeNotifierProvider(create: (context) => MypageViewModel()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // UI 용 : https://muhly.tistory.com/67
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      // 배경을 흰색으로 => 안드로이드에서만 작동
      statusBarColor: Colors.white,
      // 검정색 배경으로 => ios에서 작동
      statusBarBrightness: Brightness.light,
    ));
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: Colors.transparent,
      ),

      // debug 띠 없애기
      debugShowCheckedModeBanner: false,
      home: auth.currentUser != null ? RecipeScreen() : LoginIndexScreen(),
    );
  }
}

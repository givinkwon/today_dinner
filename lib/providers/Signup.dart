import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:today_dinner/repo/User.dart';
import 'package:today_dinner/screens/Recipe/index.dart';

// firebase storage
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

FirebaseFirestore firestore = FirebaseFirestore.instance;
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class SignupViewModel with ChangeNotifier {
  late var _UserRepo = UserRepo();

  // 생성자
  SignupViewModel() {
    _UserRepo = UserRepo();
  }

  String Email = "";

  // 이메일 입력
  void setEmail(value) {
    Email = value;
  }

  String Password = "";
  String Password_check = "";

  // 비밀번호 입력
  void setPassword(value) {
    Password = value;
  }

  // 비밀번호확인 입력
  void setPasswordCheck(value) {
    Password_check = value;
  }

  String Nickname = "";

  // 비밀번호 입력
  void setNickname(value) {
    Nickname = value;
  }

  String Name = "";

  // 이름 입력
  void setName(value) {
    Name = value;
  }

  String Phone = "";

  // 휴대폰 입력
  void setPhone(value) {
    Phone = value;
  }

  bool Marketing = true;

  void setMarketing(value) {
    Marketing = value;
    notifyListeners();
  }

  int Error = 0; // Error state => 1일 때 Error 발생
  String AlertTitle = ""; // Alert 제목
  String AlertContent = ""; // Alert 내용
  int EmailCheckState = 0; // email check가 완료되면 1

  // 이메일 중복 확인 => 비동기 문제로 state 가 1인 경우에는 회원가입까지, 0인 경우에는 중복확인만
  Future<dynamic> EmailCheck(context, state) async {
    // init
    Error = 0;
    AlertTitle = "";
    AlertContent = "";
    EmailCheckState = 0;
    // 기 회원가입이 있는 경우 에러 발생
    await _UserRepo.get_data(Email: Email);
    if (_UserRepo.Data.length > 0) {
      Error = 1;
      AlertTitle = "회원가입 에러";
      AlertContent = "기존에 가입된 이메일입니다.";
    }

    // 에러가 없는 경우 유효성 체크
    if (Error == 0) {
      if (Email == "" ||
          !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
              .hasMatch(Email.toString())) {
        AlertTitle = "이메일 중복 확인";
        AlertContent = "이메일 형식을 확인해주세요";
      } else if (state == 0) {
        AlertTitle = "이메일 중복 확인";
        AlertContent = "이메일로 사용이 가능합니다.";
      }
      if (state == 1) {
        // Authencication 저장
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: Email,
          password: Password,
        );

        // 데이터베이스 저장
        await _UserRepo.create_data(Email, Parameter: {
          'createdAt': FieldValue.serverTimestamp(),
          'email': Email,
          'nickname': Nickname,
          'password': Password,
          'phone': Phone,
          'name': Name,
          'profileimage': '',
          'marketing': Marketing,
        });

        // 회원가입 완료 표시
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("회원가입 완료"),
                content: new Text("회원가입이 완료되었습니다."),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RecipeScreen()),
                      );
                    },
                    child: new Text("메인페이지로 이동"),
                  ),
                ],
              );
            });
      }
    }
    // alert 창 띄우기
    if (AlertTitle != "") {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(AlertTitle),
              content: new Text(AlertContent),
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
    }
    return;
  }

  // 회원가입완료
  Future<dynamic> signupComplete(context) async {
    // init
    Error = 0;
    AlertTitle = "";
    AlertContent = "";

    // 예외처리
    if (Email == "") {
      Error = 1;
      AlertTitle = "회원가입 에러";
      AlertContent = "이메일을 입력해주세요.";
      return;
    }
    if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(Email.toString())) {
      Error = 1;
      AlertTitle = "회원가입 에러";
      AlertContent = "이메일 형식을 확인해주세요.";
      return;
    }
    if (Password == "") {
      Error = 1;
      AlertTitle = "회원가입 에러";
      AlertContent = "비밀번호를 입력해주세요.";
      return;
    }
    if (Password.length < 6) {
      Error = 1;
      AlertTitle = "회원가입 에러";
      AlertContent = "비밀번호는 최소 6글자 이상이어야 합니다.";
      return;
    }
    if (Password != Password_check) {
      Error = 1;
      AlertTitle = "회원가입 에러";
      AlertContent = "입력한 비밀번호가 다릅니다.";
      return;
    }
    if (Nickname == "") {
      Error = 1;
      AlertTitle = "회원가입 에러";
      AlertContent = "사용할 닉네임을 입력해주세요.";
      return;
    }
    if (Name == "") {
      Error = 1;
      AlertTitle = "회원가입 에러";
      AlertContent = "이름을 입력해주세요.";
      return;
    }
    if (Phone == "") {
      Error = 1;
      AlertTitle = "회원가입 에러";
      AlertContent = "휴대폰을 입력해주세요.";
      return;
    }

    await EmailCheck(context, 1);
  }

  // 휴대폰 인증
  bool phone_authentication_request = false; // 휴대폰 인증 요청

  // 인증번호 발송하기
  Future<dynamic> PhoneRequest(context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // 안드로이드는 자동 인증
    await auth.verifyPhoneNumber(
      phoneNumber: '+82' + Phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        print(1);
        await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      codeSent: (String verificationId, int? forceResendingToken) {},
      verificationFailed: (FirebaseAuthException error) {},
    );

    notifyListeners();
  }
}

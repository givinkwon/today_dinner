import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/src/provider.dart';
import 'package:today_dinner/providers/Login.dart';
import 'package:today_dinner/repo/User.dart';
import 'package:today_dinner/screens/Recipe/index.dart';

// firebase storage
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:today_dinner/screens/Signup/index.dart';
import 'package:today_dinner/screens/Video/index.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class SignupViewModel with ChangeNotifier {
  late var _UserRepo = UserRepo();

  // 생성자
  SignupViewModel() {
    _UserRepo = UserRepo();
  }

  String? Email = "";

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

  // 닉네임 입력
  void setNickname(value) {
    Nickname = value;
  }

  String Phone = "";

  // 휴대폰 입력
  void setPhone(value) {
    Phone = value;
  }

  var SMSCode = "";
  // 인증번호 입력
  void setSMSCode(value) {
    SMSCode = value;
  }

  // 마케팅 수신 동의
  bool Marketing = true;

  void setMarketing() {
    Marketing = !Marketing;
    notifyListeners();
  }

  int Error = 0; // Error state => 1일 때 Error 발생
  String AlertTitle = ""; // Alert 제목
  String AlertContent = ""; // Alert 내용

  // 회원가입 첫번째 페이지 "다음" 눌렀을 때
  Future<dynamic> signupNext(context) async {
    // init
    Error = 0;

    // 기 회원가입이 있는 경우 에러 발생
    await _UserRepo.get_data(Email: Email);

    // 예외처리
    if (Email == "") {
      Error = 1;
      AlertTitle = "회원가입 에러";
      AlertContent = "이메일을 입력해주세요.";
    } else if (_UserRepo.Data.length > 0) {
      Error = 1;
      AlertTitle = "회원가입 에러";
      AlertContent = "기존에 가입된 이메일입니다.";
    } else if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(Email.toString())) {
      Error = 1;
      AlertTitle = "회원가입 에러";
      AlertContent = "이메일 형식을 확인해주세요.";
    } else if (Password == "") {
      Error = 1;
      AlertTitle = "회원가입 에러";
      AlertContent = "비밀번호를 입력해주세요.";
    } else if (Password.length < 8) {
      Error = 1;
      AlertTitle = "회원가입 에러";
      AlertContent = "비밀번호는 최소 8글자 이상이어야 합니다.";
    } else if (Password != Password_check) {
      Error = 1;
      AlertTitle = "회원가입 에러";
      AlertContent = "입력한 비밀번호가 다릅니다.";
    } else if (Nickname == "") {
      Error = 1;
      AlertTitle = "회원가입 에러";
      AlertContent = "사용할 닉네임을 입력해주세요.";
    } else if (Phone == "") {
      Error = 1;
      AlertTitle = "회원가입 에러";
      AlertContent = "휴대폰을 입력해주세요.";
    } else if (phone_authentication_request == false) {
      Error = 1;
      AlertTitle = "회원가입 에러";
      AlertContent = "휴대폰 인증을 완료해주세요.";
    } else {
      // 기 회원가입이 있는 경우 에러 발생 => 전화번호 중복 체크
      await _UserRepo.get_data(Phone: Phone);

      if (_UserRepo.Data.length > 0 && _UserRepo.Data[0]['phone'] == Phone) {
        Error = 1;
        AlertTitle = "회원가입 에러";
        AlertContent = "기 가입된 휴대폰입니다.";
      }
    }
    // 에러가 있는 경우 알람 띄우기
    if (Error == 1) {
      Alert(context, AlertTitle, content1: AlertContent);
    } else {
      // 에러가 없는 경우 다음으로 보내기
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignupSecondScreen()),
      );
    }
  }

  // 회원가입완료
  var SignupUser = auth.currentUser;

  Future<dynamic> signupComplete(BuildContext context) async {
    // Authencication 저장
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: Email!,
        password: Password,
      );
    } catch (e) {}

    // 계정 DB 동기화
    SignupUser?.updatePassword(Password);

    // 데이터베이스 저장
    await _UserRepo.create_data(Email!, Parameter: {
      'createdAt': FieldValue.serverTimestamp(),
      'email': Email,
      'nickname': Nickname,
      'password': Password,
      'phone': Phone,
      'profileimage': '',
      'marketing': Marketing,
    });

    // 페이지 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VideoScreen(),
      ),
    );
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
        print("인증이 성공했습니다.");
        phone_authentication_request = true;
      },

      // 시간 초과
      codeAutoRetrievalTimeout: (String verificationId) {},

      // 코드 보냈을 때
      codeSent: (String verificationId, int? forceResendingToken) async {
        Alert(context, "인증 번호 입력",
            texthint: "인증번호를 입력해주세요.",
            verificationId: verificationId,
            forceResendingToken: forceResendingToken);
      },

      // 실패했을 때
      verificationFailed: (FirebaseAuthException error) {
        Alert(context, "인증 실패", content1: "올바른 전화번호를 입력해주세요.");
      },
    );

    notifyListeners();
  }

  Future<void> Alert(context, title,
      {String texthint = "",
      String content1 = "",
      String content2 = "",
      String close = "확인",
      String verificationId = "",
      int? forceResendingToken = 0}) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scaffold(
            resizeToAvoidBottomInset: false, // 공사장 해결
            body: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                width: MediaQuery.of(context).size.width * 0.911,
                height: 190,
                child: Column(children: [
                  // title
                  Container(
                    margin: EdgeInsets.only(top: 32, bottom: 16),
                    child: Text(title,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                  if (texthint != "")
                    Container(
                      width: 150,
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '인증번호를 입력하세요',
                        ),
                        onChanged: (text) {
                          setSMSCode(text);
                        },
                      ),
                    ),

                  // content
                  if (texthint == "")
                    Container(
                      margin: EdgeInsets.only(bottom: 6),
                      child: Text(
                        content1,
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(129, 128, 128, 1)),
                      ),
                    ),

                  // content
                  if (texthint == "")
                    Container(
                      child: Text(
                        content2,
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(129, 128, 128, 1)),
                      ),
                    ),

                  // 인증번호 입력 시
                  if (texthint != "")
                    GestureDetector(
                      onTap: () async {
                        // 휴대폰 인증
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId,
                                smsCode: SMSCode);

                        try {
                          await auth.signInWithCredential(credential);
                          // sucess
                          print("인증이 성공했습니다.");
                          phone_authentication_request = true;
                          Navigator.pop(context);

                          // 성공 알람
                          Alert(context, "인증 성공", content1: "인증에 성공했습니다.");
                        } catch (e) {
                          // fail
                          Alert(context, "인증 실패",
                              content1: "올바른 인증번호를 입력해주세요.");
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 28),
                        child: Text(
                          close,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  // 그외
                  if (texthint == "")
                    // button
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 28),
                        child: Text(
                          close,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ]),
              ),
            ),
          );
        });
  }
}

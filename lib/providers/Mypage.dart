import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/src/provider.dart';
import 'package:today_dinner/repo/User.dart';
import 'package:today_dinner/screens/Login/login.dart';
import 'package:today_dinner/screens/Recipe/index.dart';

class MypageViewModel with ChangeNotifier {
  late var _UserRepo = UserRepo();
  var Data = [];
  List<String> ImageUrl = []; // 업로드된 이미지의 url

  // 생성자
  MypageViewModel() {
    _UserRepo = UserRepo();
    load_data();
  }

  void load_data() async {
    if (auth.currentUser?.email != null) {
      await _UserRepo.get_data(Email: auth.currentUser!.email!);
      Data = _UserRepo.Data;
      notifyListeners();
    }
  }

  void changeProfileImage(context, Email) async {
    //데이터베이스 저장
    await _UserRepo.update_data(Email,
        Parameter: {'profileimage': ImageUrl[0]});

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("프로필 수정 완료"),
            content: new Text("프로필 사진이 수정되었습니다."),
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

    load_data();
  }

  var Marketing = true;
  // 마케팅 수신 동의 업데이트
  // 글쓰기 완료
  void changeMarketing(context, Email, value) async {
    if (value == true) {
      Marketing = false;
    } else {
      Marketing = true;
    }
    //데이터베이스 저장
    await _UserRepo.update_data(Email, Parameter: {
      'marketing': Marketing,
    });

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("혜택/정보 수신 동의 변경 완료"),
            content: new Text("변경되었습니다."),
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

    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // 갤러리에서 이미지 가져오기
  Future<dynamic> getGalleryImage() async {
    // init
    String downloadURL = "";
    ImageUrl = [];

    // 갤러리 호출
    ImagePicker imagePicker = ImagePicker();
    var pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    // 이미지 선택 시 => pickedFile 객체가 생김
    if (pickedFile != null) {
      var storageRef = storage.ref(pickedFile.path);
      File file = File(pickedFile.path);
      await storageRef.putFile(file); // firestore에 파일업로드
      String downloadURL = await storageRef.getDownloadURL();
      ImageUrl.add(downloadURL); // url 리스트 더하기
      return ImageUrl;
    } else {
      return;
    }
  }

  // 닉네임 변경하기
  Future<dynamic> changeNickname(context) async {
    // 데이터베이스 저장
    firestore.collection("User").doc(auth.currentUser?.email).update({
      'nickname': accounttext,
    });

    // 데이터 다시 불러오기
    load_data();
  }

  // 비밀번호 변경하기
  Future<dynamic> changePassword(context) async {
    try {
      auth.currentUser?.updatePassword(accounttext); // 비밀번호 DB 동기화
      // // 데이터베이스 저장
      firestore.collection("User").doc(auth.currentUser?.email).update({
        'password': accounttext,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        Alert(context, "변경 에러", content1: "변경을 위해 재로그인해주세요.");
      }
    }

    // 데이터 다시 불러오기
    load_data();
  }

  // 휴대폰 변경하기
  Future<dynamic> changePhone(context) async {
    // 데이터베이스 저장
    firestore.collection("User").doc(auth.currentUser?.email).update({
      'phone': accounttext,
    });

    // 데이터 다시 불러오기
    load_data();
  }

  // 회원 탈퇴
  Future<dynamic> withdrawalAccount(context) async {
    var deleteEmail = auth.currentUser?.email;
    try {
      await auth.currentUser?.delete();
      // 데이터베이스 저장
      firestore.collection("User").doc(deleteEmail).update({
        'deactivate': true,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        Alert(context, "탈퇴 오류", content1: "재로그인 후 탈퇴해주세요.");
      }
    }

    // 데이터 다시 불러오기
    load_data();
  }

  // 계정 정보 수정 텍스트
  var accounttext = "";
  SetAccountText(value) {
    accounttext = value;
  }

  // 계정 정보 수정
  Future<dynamic> EditAccount(context, purpose) async {
    // 닉네임 수정
    if (purpose == "nickname") {
      Alert(context, "닉네임 수정",
          purpose: "nickname", content1: "현재 닉네임 : ${Data[0]['nickname']}");
    }

    // 비밀번호 수정
    if (purpose == "password") {
      Alert(context, "비밀번호 변경", purpose: "password");
    }

    // 휴대폰 수정
    if (purpose == "phone") {
      Alert(context, "휴대폰 변경",
          purpose: "phone", content1: "현재 휴대폰 : ${Data[0]['phone']}");
    }

    // 회원탈퇴
    if (purpose == "deactivate") {
      Alert(context, "회원 탈퇴",
          purpose: "deactivate", content1: "탈퇴하시려면 '탈퇴합니다.'를 적어주세요.");
    }
  }

  Future<void> Alert(
    context,
    title, {
    String purpose = "",
    String content1 = "",
    String content2 = "",
  }) async {
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

                  // content1
                  Container(
                    margin: EdgeInsets.only(bottom: 6),
                    child: Text(
                      content1,
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(129, 128, 128, 1)),
                    ),
                  ),

                  // textfield
                  if (purpose != "")
                    Container(
                      width: 150,
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "변경 내용을 입력하세요",
                        ),
                        onChanged: (text) {
                          SetAccountText(text);
                        },
                      ),
                    ),

                  if (purpose == "")
                    Container(
                      child: Text(""),
                    ),

                  // button
                  GestureDetector(
                    onTap: () async {
                      if (purpose == "deactivate" && accounttext != "탈퇴합니다.") {
                        Alert(context, "탈퇴 오류", content1: "정확히 작성해주세요.");
                      } else if (accounttext == "") {
                        Alert(context, "수정 오류", content1: "변경 내용을 작성해주세요.");
                      } else {
                        // alert 끄기
                        Navigator.pop(context);

                        if (purpose == "deactivate" &&
                            accounttext == "탈퇴합니다.") {
                          Alert(context, "회원 탈퇴", content1: "회원 탈퇴되었습니다.");

                          auth.signOut();
                          // 메인 페이지로 이동
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        }

                        // nickname 수정
                        else if (purpose == "nickname") {
                          Alert(context, "수정 완료", content1: "변경되었습니다.");
                          changeNickname(context);
                        }

                        // 비밀번호 수정
                        else if (purpose == "password") {
                          await changePassword(context); // 비밀번호 변경

                          Alert(context, "수정 완료", content1: "변경되었습니다.");
                        }

                        // 휴대폰 수정
                        else if (purpose == "phone") {
                          Alert(context, "수정 완료", content1: "변경되었습니다.");
                          changePhone(context);
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 14),
                      child: Text(
                        "확인",
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

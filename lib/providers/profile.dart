import 'dart:math';

import 'package:flutter/material.dart';
// firebase database => firestore
import 'package:cloud_firestore/cloud_firestore.dart';
// firebase storage
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// provider listener 이용
import 'package:flutter/foundation.dart';

// Screen
import 'package:today_dinner/screens/Home/index.dart';
import 'package:today_dinner/screens/Home/login.dart';

// firebase auth
import 'package:firebase_auth/firebase_auth.dart';

// 갤러리에서 이미지 가져오기
import 'package:image_picker/image_picker.dart';

// firebase 데이터 저장
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

// provider
import 'package:provider/provider.dart';
import 'package:today_dinner/providers/home.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class Profile with ChangeNotifier {
  List<String> ImageUrl = []; // 업로드된 이미지의 url

  // 초기화
  void init() {
    ImageUrl = [];
  }

  // 글쓰기 완료
  void changeProfileImage(context, email) {
    //데이터베이스 저장
    firestore.collection("User").doc(email).update({
      'profileimage': ImageUrl[0],
    }).then((_) => {
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
              }),
        });
  }

  int Error = 0; // Error state => 1일 때 Error 발생
  String AlertTitle = ""; // Alert 제목
  String AlertContent = ""; // Alert 내용
  int EmailCheckState = 0; // email check가 완료되면 1

  String Phone = "";

  // 휴대폰 입력
  void setPhone(value) {
    Phone = value;
  }

  // 닉네임 변경하는 위젯
  Future<dynamic> changePhoneWidget(context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('휴대폰 변경하기'),
            content: Container(
              height: 200,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      child: Phone.length == ""
                          ? Text(
                              "현재 휴대폰 : ${context.read<Home>().User[0]['phone']}",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            )
                          : Text(
                              "현재 휴대폰 : ${Phone}",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            )),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    child: Text(
                      "변경할 휴대폰",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '휴대폰을 입력해주세요.',
                    ),
                    onChanged: (text) {
                      // // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
                      context.read<Profile>().setPhone(text);
                    },
                  )),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('변경하기'),
                onPressed: () {
                  changePhone(context);
                },
              ),
              FlatButton(
                child: Text('취소하기'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  // 휴대폰 변경하기
  Future<dynamic> changePhone(context) async {
    // init
    Error = 0;
    AlertTitle = "";
    AlertContent = "";

    if (Phone == "") {
      Error = 1;
      AlertTitle = "휴대폰 변경 에러";
      AlertContent = "휴대폰을 입력해주세요.";
    }

    // alert 창 띄우기
    if (AlertTitle != "") {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(context.read<Profile>().AlertTitle),
              content: new Text(context.read<Profile>().AlertContent),
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

    if (AlertTitle == "") {
      // 데이터베이스 저장
      firestore.collection("User").doc(auth.currentUser?.email).update({
        'phone': Phone,
      }).then((_) => {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: new Text("휴대폰 변경 완료"),
                    content: new Text("휴대폰 변경이 완료되었습니다."),
                    actions: <Widget>[
                      new FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: new Text("닫기"),
                      ),
                    ],
                  );
                }),
          });
    }
  }

  String Nickname = "";

  // 닉네임 입력
  void setNickname(value) {
    Nickname = value;
  }

  // 닉네임 변경하는 위젯
  Future<dynamic> changeNicknameWidget(context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('닉네임 변경하기'),
            content: Container(
              height: 200,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    child: Nickname.length == ""
                        ? Text(
                            "현재 닉네임 : ${context.read<Home>().User[0]['nickname']}",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )
                        : Text(
                            "현재 닉네임 : ${Nickname}",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    child: Text(
                      "변경할 닉네임",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '닉네임을 입력해주세요.',
                    ),
                    onChanged: (text) {
                      // // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
                      context.read<Profile>().setNickname(text);
                    },
                  )),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('변경하기'),
                onPressed: () {
                  changeNickname(context);
                },
              ),
              FlatButton(
                child: Text('취소하기'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  // 닉네임 변경하기
  Future<dynamic> changeNickname(context) async {
    // init
    Error = 0;
    AlertTitle = "";
    AlertContent = "";

    if (Nickname == "") {
      Error = 1;
      AlertTitle = "닉네임 변경 에러";
      AlertContent = "닉네임을 입력해주세요.";
    }

    // alert 창 띄우기
    if (AlertTitle != "") {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(context.read<Profile>().AlertTitle),
              content: new Text(context.read<Profile>().AlertContent),
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

    if (AlertTitle == "") {
      // 데이터베이스 저장
      firestore.collection("User").doc(auth.currentUser?.email).update({
        'nickname': Nickname,
      }).then((_) => {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: new Text("닉네임 변경 완료"),
                    content: new Text("닉네임 변경이 완료되었습니다."),
                    actions: <Widget>[
                      new FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: new Text("닫기"),
                      ),
                    ],
                  );
                }),
          });
    }
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

  String Remove = "";

  // 비밀번호 입력
  void setRemove(value) {
    Remove = value;
  }

  //회원 탈퇴
  Future<dynamic> withdrawalAccountWidget(context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('회원 탈퇴하기'),
            content: Container(
              height: 200,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    child: Text(
                      "정말 회원탈퇴하시겠어요? 탈퇴 시 계정 복구가 어렵습니다.",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    child: Text(
                      "[탈퇴하겠습니다]라고 작성해주세요.",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '탈퇴하겠습니다',
                    ),
                    onChanged: (text) {
                      // // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
                      context.read<Profile>().setRemove(text);
                    },
                  )),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('탈퇴하기'),
                onPressed: () {
                  withdrawalAccount(context);
                },
              ),
              FlatButton(
                child: Text('취소하기'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  // 회원 탈퇴
  Future<dynamic> withdrawalAccount(context) async {
    // init
    Error = 0;
    AlertTitle = "";
    AlertContent = "";

    if (Remove != "탈퇴하겠습니다") {
      Error = 1;
      AlertTitle = "계정 삭제 에러";
      AlertContent = "[탈퇴하겠습니다]를 입력해주세요.";
    }

    // alert 창 띄우기
    if (AlertTitle != "") {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(context.read<Profile>().AlertTitle),
              content: new Text(context.read<Profile>().AlertContent),
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

    if (AlertTitle == "") {
      try {
        var deleteEmail = auth.currentUser?.email;
        await auth.currentUser?.delete().then((_) => {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: new Text("계정 탈퇴 완료"),
                      content: new Text("계정 탈퇴가 완료되었습니다."),
                      actions: <Widget>[
                        new FlatButton(
                          onPressed: () {
                            // 페이지 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          child: new Text("닫기"),
                        ),
                      ],
                    );
                  }),
              // 데이터베이스 저장
              firestore.collection("User").doc(deleteEmail).update({
                'deactivate': true,
              }),
            });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text("계정 탈퇴 실패"),
                  content: new Text(
                      "세션이 만료되어 계정 탈퇴가 제대로 되지 않았습니다. 재로그인 후 탈퇴처리 해주세요."),
                  actions: <Widget>[
                    new FlatButton(
                      onPressed: () {
                        // 페이지 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: new Text("닫기"),
                    ),
                  ],
                );
              });
        }
      }
    }
  }
}

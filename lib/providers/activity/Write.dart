import 'dart:math';

import 'package:flutter/material.dart';
// firebase database => firestore
import 'package:cloud_firestore/cloud_firestore.dart';
// firebase storage
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// provider listener 이용
import 'package:flutter/foundation.dart';

import 'package:today_dinner/screens/Home/index.dart';
import 'package:today_dinner/screens/Mypage/Mywrite.dart';

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
FirebaseAuth auth = FirebaseAuth.instance;

class Write with ChangeNotifier {
  List<String> ImageUrl = []; // 업로드된 이미지의 url
  String Content = ""; // 업로드 내용
  int top_index = 1; // 상단 메뉴 1 : 식사 , 2 : 자유 수다방

  // 초기화
  void init() {
    ImageUrl = [];
    Content = "";
    Selected_list = [];
  }

  // 메인페이지 상단 메뉴 선택 시
  void select_top(value) {
    top_index = value;
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // 글 업로드 내용
  void setContent(val) {
    Content = val;
  }

  List<String> Selected_list = []; // 필터 선택 박스

  // 필터 태그 선택 시
  void add_list(value) {
    Selected_list.add(value);
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // 필터 태그 삭제 시
  void remove_list(value) {
    Selected_list.remove(value);
    notifyListeners();
  }

  int Error = 0; // Error state => 1일 때 Error 발생
  String AlertTitle = ""; // Alert 제목
  String AlertContent = ""; // Alert 내용

  // 글쓰기 완료
  void writeComplete(context, user_data) {
    // init
    Error = 0;
    AlertTitle = "";
    AlertContent = "";

    // 예외처리
    if (Content == "") {
      Error = 1;
      AlertTitle = "글쓰기 에러";
      AlertContent = "내용을 입력해주세요.";
      return;
    }
    if (top_index == 1 && ImageUrl.length == 0) {
      Error = 1;
      AlertTitle = "글쓰기 에러";
      AlertContent = "사진을 입력해주세요.";
      return;
    }

    var rand = new Random().nextInt(100000000);

    // 피드인 경우
    if (top_index == 1) {
      //데이터베이스 저장
      firestore.collection("Feed").doc("$rand").set({
        'id': "${rand}",
        'createdAt': FieldValue.serverTimestamp(),
        'content': Content,
        'user': auth.currentUser?.email,
        'nickname': user_data[0]['nickname'],
      }).then((_) => {
            for (var Url in ImageUrl)
              {
                print(Url),
                firestore
                    .collection("Feed")
                    .doc("$rand")
                    .collection("image")
                    .doc()
                    .set({
                  'value': Url,
                }),
              },
            for (var filter in Selected_list)
              {
                print(filter),
                firestore
                    .collection("Feed")
                    .doc("$rand")
                    .collection("filter")
                    .doc(filter)
                    .set({
                  'value': filter,
                }),
              },
          });
    }
    // 자유게시판인 경우
    if (top_index == 2) {
      //데이터베이스 저장
      firestore.collection("Freetalk").doc("$rand").set({
        'id': "${rand}",
        'createdAt': FieldValue.serverTimestamp(),
        'content': Content,
        'user': auth.currentUser?.email,
        'nickname': user_data[0]['nickname'],
      }).then((_) => {
            for (var Url in ImageUrl)
              {
                print(Url),
                firestore
                    .collection("Freetalk")
                    .doc("$rand")
                    .collection("image")
                    .doc()
                    .set({
                  'value': Url,
                }),
              },
            for (var filter in Selected_list)
              {
                print(filter),
                firestore
                    .collection("Freetalk")
                    .doc("$rand")
                    .collection("filter")
                    .doc(filter)
                    .set({
                  'value': filter,
                }),
              },
          });
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("글쓰기 완료"),
            content: new Text("글쓰기가 완료되었습니다."),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MywritePage()),
                  );
                },
                child: new Text("메인페이지로 이동"),
              ),
            ],
          );
        });
  }

  // 갤러리에서 이미지 가져오기
  Future<dynamic> getGalleryImage() async {
    // init
    String downloadURL = "";

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
}

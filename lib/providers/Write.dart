// import 'package:flutter/material.dart';

// // provider listener 이용
// import 'package:flutter/foundation.dart';

// // 갤러리에서 이미지 가져오기
// import 'package:image_picker/image_picker.dart';

// import 'dart:io';

// // provider
// import 'package:today_dinner/providers/repo/Feed.dart';
// import 'package:today_dinner/providers/repo/Freetalk.dart';
// import 'package:today_dinner/providers/repo/Recipe.dart';

// class WriteViewmodel with ChangeNotifier {
//   // 생성자
//   WriteViewModel() {}

//   List<String> ImageUrl = []; // 업로드된 이미지의 url
//   String Content = ""; // 업로드 내용
//   int top_index = 1; // 상단 메뉴 1 : 식사 , 2 : 자유 수다방

//   // 초기화
//   void init() {
//     ImageUrl = [];
//     Content = "";
//     Selected_list = [];
//   }

//   // 메인페이지 상단 메뉴 선택 시
//   void select_top(value) {
//     top_index = value;
//     // 구독 widget에게 변화 알려서 re-build
//     notifyListeners();
//   }

//   // 글 업로드 내용
//   void setContent(val) {
//     Content = val;
//   }

//   List<String> Selected_list = []; // 필터 선택 박스

//   // 필터 태그 선택 시
//   void add_list(value) {
//     Selected_list.add(value);
//     // 구독 widget에게 변화 알려서 re-build
//     notifyListeners();
//   }

//   // 필터 태그 삭제 시
//   void remove_list(value) {
//     Selected_list.remove(value);
//     notifyListeners();
//   }

//   int Error = 0; // Error state => 1일 때 Error 발생
//   String AlertTitle = ""; // Alert 제목
//   String AlertContent = ""; // Alert 내용

//   // 글쓰기 완료
//   void writeComplete(context, user_data) {
//     // init
//     Error = 0;
//     AlertTitle = "";
//     AlertContent = "";
//     Map<String, dynamic> parameter = {};

//     // 예외처리
//     if (Content == "") {
//       Error = 1;
//       AlertTitle = "글쓰기 에러";
//       AlertContent = "내용을 입력해주세요.";
//       return;
//     }
//     if (top_index == 1 && ImageUrl.length == 0) {
//       Error = 1;
//       AlertTitle = "글쓰기 에러";
//       AlertContent = "사진을 입력해주세요.";
//       return;
//     }

//     // 피드인 경우
//     if (top_index == 1) {
//       Feed().create_data(Parameter: parameter);
//     }
//     // 자유게시판인 경우
//     if (top_index == 2) {
//       Freetalk().create_data(Parameter: parameter);
//     }

//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: new Text("글쓰기 완료"),
//             content: new Text("글쓰기가 완료되었습니다."),
//             actions: <Widget>[
//               new FlatButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: new Text("메인페이지로 이동"),
//               ),
//             ],
//           );
//         });
//   }

//   // 갤러리에서 이미지 가져오기
//   Future<dynamic> getGalleryImage() async {
//     // init
//     String downloadURL = "";

//     // 갤러리 호출
//     ImagePicker imagePicker = ImagePicker();
//     var pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

//     // 이미지 선택 시 => pickedFile 객체가 생김
//     if (pickedFile != null) {
//       var storageRef = storage.ref(pickedFile.path);
//       File file = File(pickedFile.path);
//       await storageRef.putFile(file); // firestore에 파일업로드
//       String downloadURL = await storageRef.getDownloadURL();
//       ImageUrl.add(downloadURL); // url 리스트 더하기
//       return ImageUrl;
//     } else {
//       return;
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:today_dinner/main.dart';

// import 'package:today_dinner/utils/BottomNavigationBar.dart';

// // 로그인 기본 class
// class AccountPage extends StatelessWidget {
// // 비밀번호 재설정
//   @override
//   Future<void> resetPassword(String email) async {
//     await auth.sendPasswordResetEmail(email: email);
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
//           "계정 설정",
//           style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Color.fromRGBO(40, 40, 40, 1)),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           height: 800,
//           child: ListView(
//             children: <Widget>[
//               Stack(children: [
//                 Image(
//                   image: AssetImage('assets/profile.jpg'),
//                   fit: BoxFit.cover,
//                 ),

//                 Padding(
//                   padding: EdgeInsets.only(top: 10),
//                   child: Center(
//                     child: Text(
//                       "프로필 사진 추가",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 // // 이미지가 없는 경우 + 프로필 수정 하지 않은 경우
//                 // if (context.read<Home>().User[0]['profileimage'].length == 0 &&
//                 //     context.read<Profile>().ImageUrl.length == 0)
//                 //   GestureDetector(
//                 //     onTap: () {
//                 //       context.read<Profile>().getGalleryImage().then((_) {
//                 //         // 이미지 선택 후 업로드
//                 //         context.read<Profile>().changeProfileImage(
//                 //             context, auth.currentUser?.email);
//                 //         setState(() {});
//                 //       });
//                 //     },
//                 //     child: Padding(
//                 //       padding: EdgeInsets.only(top: 40),
//                 //       child: Center(
//                 //         child: CircleAvatar(
//                 //           radius: 80,
//                 //           backgroundColor: Colors.white,
//                 //           child: Icon(
//                 //             Icons.add,
//                 //             color: Colors.grey,
//                 //             size: 40,
//                 //           ),
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ),
//                 // // 이미지가 있는 경우 + 프로필 수정 하지 않은 경우
//                 // if (context.read<Home>().User[0]['profileimage'].length > 0 &&
//                 //     context.read<Profile>().ImageUrl.length == 0)
//                 //   GestureDetector(
//                 //     onTap: () {
//                 //       context.read<Profile>().getGalleryImage().then((_) {
//                 //         // 이미지 선택 후 업로드
//                 //         context.read<Profile>().changeProfileImage(
//                 //             context, auth.currentUser?.email);
//                 //         setState(() {});
//                 //       });
//                 //     },
//                 //     child: Padding(
//                 //       padding: EdgeInsets.only(top: 40),
//                 //       child: Center(
//                 //         child: CircleAvatar(
//                 //           radius: 80,
//                 //           backgroundColor: Colors.white,
//                 //           backgroundImage: NetworkImage(
//                 //               context.read<Home>().User[0]['profileimage']),
//                 //           child: Icon(
//                 //             Icons.add,
//                 //             color: Colors.grey,
//                 //             size: 40,
//                 //           ),
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ),
//                 // // 프로플 수정한 경우
//                 // if (context.read<Profile>().ImageUrl.length > 0)
//                 //   GestureDetector(
//                 //     onTap: () {
//                 //       context.read<Profile>().getGalleryImage().then((_) {
//                 //         // 이미지 선택 후 업로드
//                 //         context.read<Profile>().changeProfileImage(
//                 //             context, auth.currentUser?.email);
//                 //         setState(() {});
//                 //       });
//                 //     },
//                 //     child: Padding(
//                 //       padding: EdgeInsets.only(top: 40),
//                 //       child: Center(
//                 //         child: CircleAvatar(
//                 //           radius: 80,
//                 //           backgroundColor: Colors.white,
//                 //           backgroundImage:
//                 //               NetworkImage(context.read<Profile>().ImageUrl[0]),
//                 //           child: Icon(
//                 //             Icons.add,
//                 //             color: Colors.grey,
//                 //             size: 40,
//                 //           ),
//                 //         ),
//                 //       ),
//                 //     ),
//                 //   ),
//               ]),
//               ListTile(
//                 //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능

//                 leading: Icon(Icons.email),
//                 title: Text('이메일'),
//                 trailing: Text(
//                   "${context.read<Home>().User[0]['email']}",
//                   style: TextStyle(color: Colors.blue[400]),
//                 ),
//               ),
//               ListTile(
//                 onTap: () {
//                   context.read<Profile>().changeNicknameWidget(context);
//                 },
//                 //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능

//                 leading: Icon(Icons.people),
//                 title: Text('닉네임'),
//                 trailing: Text(
//                   "변경하기",
//                   style: TextStyle(color: Colors.blue[400]),
//                 ),
//               ),
//               ListTile(
//                 onTap: () {
//                   resetPassword(context.read<Home>().User[0]['email']);
//                   showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: new Text("비밀번호 재설정"),
//                           content: new Text("비밀번호 재설정 메일이 이메일로 발송되었습니다."),
//                           actions: <Widget>[
//                             new FlatButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: new Text("닫기"),
//                             ),
//                           ],
//                         );
//                       });
//                 },
//                 leading: Icon(Icons.lock),
//                 title: Text('비밀번호'),
//                 trailing: Text(
//                   "변경하기",
//                   style: TextStyle(color: Colors.blue[400]),
//                 ),
//               ),
//               ListTile(
//                 onTap: () {
//                   context.read<Profile>().changePhoneWidget(context);
//                 },
//                 leading: Icon(Icons.phone),
//                 title: Text('휴대폰'),
//                 trailing: Text(
//                   "변경하기",
//                   style: TextStyle(color: Colors.blue[400]),
//                 ),
//               ),
//               ListTile(
//                 onTap: () {
//                   context.read<Profile>().withdrawalAccountWidget(context);
//                 },
//                 leading: Icon(Icons.person_off),
//                 title: Text('회원 탈퇴'),
//               )
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: bottomNavigation(context),
//     );
//   }
// }

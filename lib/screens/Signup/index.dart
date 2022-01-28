import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:today_dinner/providers/Signup.dart';

// web link
import 'package:url_launcher/url_launcher.dart';

// final GoogleSignIn googleSignIn = GoogleSignIn();

// 로그인 기본 class
class SignupScreen extends StatelessWidget {
  // "회원가입하기" 클릭했을 때
  _signupButtonPressed(BuildContext context) async {
    context.read<SignupViewModel>().signupComplete(context);

    // alert 창 띄우기
    if (context.read<SignupViewModel>().AlertTitle != "") {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(context.read<SignupViewModel>().AlertTitle),
              content: new Text(context.read<SignupViewModel>().AlertContent),
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
  }

  // 중복확인 클릭했을 때
  _emailCheckButtonPressed(BuildContext context) async {
    context.read<SignupViewModel>().EmailCheck(context, 0);
  }

  // shopping icon 클릭했을 때
  _checkButtonPressed() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromRGBO(40, 40, 40, 1), //색변경
        ),
        backgroundColor: Colors.white,
        title: Text(
          "회원가입",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(40, 40, 40, 1)),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color.fromRGBO(251, 246, 240, 1),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 40,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),
                Expanded(
                    child: Container(
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '이메일을 입력해주세요.',
                    ),
                    onChanged: (text) {
                      // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
                      context.read<SignupViewModel>().setEmail(text);
                    },
                  ),
                )),
                SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 90,
                  child: TextButton(
                    onPressed: () => _emailCheckButtonPressed(context),
                    style: TextButton.styleFrom(
                        primary: Color.fromRGBO(201, 92, 57, 1),
                        backgroundColor: Colors.white,
                        side: BorderSide(
                            color: Color.fromRGBO(201, 92, 57, 1), width: 2)),
                    child: Text(
                      "중복확인",
                      style: TextStyle(
                          fontSize: 12, color: Color.fromRGBO(201, 92, 57, 1)),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 40,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),
                Expanded(
                    child: Container(
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '닉네임을 입력해주세요.',
                    ),
                    onChanged: (text) {
                      // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
                      context.read<SignupViewModel>().setNickname(text);
                    },
                  ),
                )),
                SizedBox(
                  width: 30,
                ),
                // SizedBox(
                //   width: 90,
                // ),
              ],
            ),
            Container(
              height: 40,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),

                Expanded(
                    child: Container(
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '비밀번호를 입력해주세요.',
                    ),
                    onChanged: (text) {
                      // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
                      context.read<SignupViewModel>().setPassword(text);
                    },
                  ),
                )),
                SizedBox(
                  width: 30,
                ),
                // SizedBox(
                //   width: 90,
                // ),
              ],
            ),
            Container(
              height: 40,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),

                Expanded(
                    child: Container(
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '비밀번호를 재입력해주세요.',
                    ),
                    onChanged: (text) {
                      // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
                      context.read<SignupViewModel>().setPasswordCheck(text);
                    },
                  ),
                )),
                SizedBox(
                  width: 30,
                ),
                // SizedBox(
                //   width: 90,
                // ),
              ],
            ),
            Container(
              height: 40,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),

                Expanded(
                    child: Container(
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '이름을 입력해주세요.',
                    ),
                    onChanged: (text) {
                      // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
                      context.read<SignupViewModel>().setName(text);
                    },
                  ),
                )),
                SizedBox(
                  width: 30,
                ),
                // SizedBox(
                //   width: 90,
                // ),
              ],
            ),
            Container(
              height: 40,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),
                Expanded(
                    child: Container(
                  height: 40,
                  child: Row(mainAxisSize: MainAxisSize.max, children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.54,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: '전화번호를 입력해주세요.',
                        ),
                        onChanged: (text) {
                          // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.

                          context.read<SignupViewModel>().setPhone(text);
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context
                                .read<SignupViewModel>()
                                .phone_authentication_request = true;
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: new Text("전화번호 인증"),
                                    content: new Text("준비중입니다."),
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
                            // 인증번호 발송
                            // context.read<Signup>().PhoneRequest(context);
                          },
                          style: TextButton.styleFrom(
                              primary: Color.fromRGBO(201, 92, 57, 1),
                              backgroundColor: context
                                      .read<SignupViewModel>()
                                      .phone_authentication_request
                                  ? Colors.grey
                                  : Color.fromRGBO(201, 92, 57, 1),
                              side: context
                                      .read<SignupViewModel>()
                                      .phone_authentication_request
                                  ? BorderSide(color: Colors.grey, width: 2)
                                  : BorderSide(
                                      color: Color.fromRGBO(201, 92, 57, 1),
                                      width: 2)),
                          child: Text(
                            "인증요청",
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ]),
                )),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
            // Container(
            //   height: 40,
            // ),
            // if (context.watch<Signup>().phone_authentication_request == true)
            //   Row(
            //     children: <Widget>[
            //       SizedBox(
            //         width: 30,
            //       ),
            //       Expanded(
            //           child: Container(
            //         height: 40,
            //         child: Row(mainAxisSize: MainAxisSize.max, children: [
            //           Container(
            //             width: MediaQuery.of(context).size.width * 0.54,
            //             child: TextField(
            //               decoration: InputDecoration(
            //                 hintText: '인증번호를 입력해주세요.',
            //               ),
            //               onChanged: (text) {
            //                 // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
            //                 context.read<Signup>().setPhone(text);
            //               },
            //             ),
            //           ),
            //           Container(
            //             width: MediaQuery.of(context).size.width * 0.3,
            //             child: Align(
            //               alignment: Alignment.centerRight,
            //               child: TextButton(
            //                 onPressed: () {

            //                 },
            //                 style: TextButton.styleFrom(
            //                     primary: Color.fromRGBO(201, 92, 57, 1),
            //                     backgroundColor: Color.fromRGBO(201, 92, 57, 1),
            //                     side: BorderSide(
            //                         color: Color.fromRGBO(201, 92, 57, 1),
            //                         width: 2)),
            //                 child: Text(
            //                   "인증완료",
            //                   style:
            //                       TextStyle(fontSize: 17, color: Colors.white),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ]),
            //       )),
            //       SizedBox(
            //         width: 30,
            //       ),
            //     ],
            //   ),

            Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Checkbox(
                    value: true,
                    activeColor: Color.fromRGBO(201, 92, 57, 1),
                    onChanged: (_) => {}),
                GestureDetector(
                  onTap: () {
                    launch(
                        'https://www.notion.so/c69c4fbf01d04188871580fd3f1c1859');
                  },
                  child: Text("개인정보처리방침",
                      style: TextStyle(
                          fontSize: 12, color: Color.fromRGBO(201, 92, 57, 1))),
                ),
                Text(" 및 ", style: TextStyle(fontSize: 12)),
                GestureDetector(
                  onTap: () {
                    launch(
                        'https://www.notion.so/fd2aa6cb08344a7ca91582e07bbef709');
                  },
                  child: Text("서비스 이용약관",
                      style: TextStyle(
                          fontSize: 12, color: Color.fromRGBO(201, 92, 57, 1))),
                ),
                Text("동의", style: TextStyle(fontSize: 12)),
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Checkbox(
                    value: context.watch<SignupViewModel>().Marketing,
                    activeColor: Color.fromRGBO(201, 92, 57, 1),
                    onChanged: (value) =>
                        {context.read<SignupViewModel>().setMarketing(value)}),
                Text("맞춤형 요리 추천, 할인 등 혜택/정보 수신 동의(PUSH 알람)",
                    style: TextStyle(fontSize: 12)),
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),

                Expanded(
                  child: TextButton(
                    onPressed: () => _signupButtonPressed(context),
                    style: TextButton.styleFrom(
                        primary: Color.fromRGBO(201, 92, 57, 1),
                        backgroundColor: Color.fromRGBO(201, 92, 57, 1),
                        side: BorderSide(
                            color: Color.fromRGBO(201, 92, 57, 1), width: 2)),
                    child: Text(
                      "가입하기",
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                // SizedBox(
                //   width: 90,
                //   // child: TextButton(
                //   //   onPressed: _checkButtonPressed,
                //   //   style: TextButton.styleFrom(
                //   //       primary: Color.fromRGBO(201, 92, 57, 1),
                //   //       backgroundColor: Colors.white,
                //   //       side: BorderSide(color: Color.fromRGBO(201, 92, 57, 1), width: 2)),
                //   //   child: Text(
                //   //     "인증번호받기",
                //   //     style: TextStyle(fontSize: 12, color: Color.fromRGBO(201, 92, 57, 1)),
                //   //   ),
                //   // ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

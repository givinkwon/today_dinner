import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// provider listener 이용
// provider => watch는 값이 변화할 때 리렌더링, read는 값이 변화해도 렌더링 x
// => watch는 값을 보여주는 UI에 read는 변경이 필요없는 함수에 주로 사용
import 'package:today_dinner/providers/signup.dart';
import 'package:today_dinner/providers/home.dart';
// provider listener 이용
import 'package:flutter/foundation.dart';

// appbar 지우기
class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}

// 로그인 기본 class
class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  void initState() {
    // super.initState();
    // listener를 추가하여 비동기 변경이 발생했을 때 수정할 수 있도록 changeNotifier를 듣고 있음
    Provider.of<Signup>(context, listen: false).addListener(() => setState(() {
          print(2);
        }));
  }

  // "회원가입하기" 클릭했을 때
  Future<dynamic> _signupButtonPressed() async {
    context.read<Signup>().signupComplete(context);

    // alert 창 띄우기
    if (context.read<Signup>().AlertTitle != "") {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(context.read<Signup>().AlertTitle),
              content: new Text(context.read<Signup>().AlertContent),
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
  Future<void> _emailCheckButtonPressed() async {
    context.read<Signup>().EmailCheck(context, 0);
  }

  // shopping icon 클릭했을 때
  Future<void> _checkButtonPressed() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EmptyAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 20,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    "이메일",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '이메일을 입력해주세요.',
                  ),
                  onChanged: (text) {
                    // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
                    context.read<Signup>().setEmail(text);
                  },
                )),
                SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 90,
                  child: TextButton(
                    onPressed: _emailCheckButtonPressed,
                    style: TextButton.styleFrom(
                        primary: Colors.purple,
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.purple, width: 2)),
                    child: Text(
                      "중복확인",
                      style: TextStyle(fontSize: 12, color: Colors.purple),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
            Container(
              height: 20,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    "닉네임",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '사용할 닉네임을 입력해주세요.',
                  ),
                  onChanged: (text) {
                    // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
                    context.read<Signup>().setNickname(text);
                  },
                )),
                SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 90,
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
            Container(
              height: 20,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    "비밀번호",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '비밀번호를 입력해주세요.',
                  ),
                  onChanged: (text) {
                    // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
                    context.read<Signup>().setPassword(text);
                  },
                )),
                SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 90,
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
            Container(
              height: 20,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    "비밀번호확인",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '비밀번호를 재입력해주세요.',
                  ),
                  onChanged: (text) {
                    // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
                    context.read<Signup>().setPasswordCheck(text);
                  },
                )),
                SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 90,
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
            Container(
              height: 20,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    "이름",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '이름을 입력해주세요.',
                  ),
                  onChanged: (text) {
                    // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
                    context.read<Signup>().setName(text);
                  },
                )),
                SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 90,
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
            Container(
              height: 20,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    "휴대폰",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '숫자만 입력해주세요.',
                  ),
                  onChanged: (text) {
                    // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
                    context.read<Signup>().setPhone(text);
                  },
                )),
                SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 90,
                  // child: TextButton(
                  //   onPressed: _checkButtonPressed,
                  //   style: TextButton.styleFrom(
                  //       primary: Colors.purple,
                  //       backgroundColor: Colors.white,
                  //       side: BorderSide(color: Colors.purple, width: 2)),
                  //   child: Text(
                  //     "인증번호받기",
                  //     style: TextStyle(fontSize: 12, color: Colors.purple),
                  //   ),
                  // ),
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
            Container(
              height: 90,
            ),
            Container(
              width: 300,
              child: TextButton(
                onPressed: _signupButtonPressed,
                style: TextButton.styleFrom(
                    primary: Colors.purple,
                    backgroundColor: Colors.purple,
                    side: BorderSide(color: Colors.purple, width: 2)),
                child: Text(
                  "가입하기",
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

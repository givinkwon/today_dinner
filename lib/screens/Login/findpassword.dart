import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:today_dinner/providers/Login.dart';

// 로그인 기본 class
class FindPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromRGBO(40, 40, 40, 1), //색변경
        ),
        backgroundColor: Colors.white,
        title: Text(
          "로그인",
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
              height: 200,
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
                          context.read<LoginViewModel>().setEmail(text);
                        },
                      )),
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
            Container(
              height: 30,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      context.read<LoginViewModel>().resetPassword(context);
                    },
                    style: TextButton.styleFrom(
                        primary: Color.fromRGBO(201, 92, 57, 1),
                        backgroundColor: Color.fromRGBO(201, 92, 57, 1),
                        side: BorderSide(
                            color: Color.fromRGBO(201, 92, 57, 1), width: 2)),
                    child: Text(
                      "비밀번호 찾기",
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

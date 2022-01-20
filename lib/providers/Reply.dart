import 'package:flutter/material.dart';

// provider
import 'package:today_dinner/repo/Feed.dart';
import 'package:today_dinner/repo/Freetalk.dart';
import 'package:today_dinner/repo/Recipe.dart';

// provider listener 이용
import 'package:flutter/foundation.dart';

class ReplyViewmodel with ChangeNotifier {
  // 생성자
  ReplyViewModel() {}

  int selected_index = 0;

  // feed랑 freetalk에 사용
  void select_index(index) {
    selected_index = index;
  }

  String reply = "";

  // 댓글 작성 입력
  void setReply(value) {
    reply = value;
  }

  int Error = 0; // Error state => 1일 때 Error 발생
  String AlertTitle = ""; // Alert 제목
  String AlertContent = ""; // Alert 내용

  // 글쓰기 완료
  void replyComplete(DocId, user, auth, context, top_index) async {
    // init
    Error = 0;
    AlertTitle = "";
    AlertContent = "";

    // 예외처리
    if (reply == "") {
      Error = 1;
      AlertTitle = "댓글 작성 에러";
      AlertContent = "댓글을 작성해주세요.";
      return;
    }

    //데이터베이스 저장
    // Feed
    if (top_index == 1) {
      // Feed().update_data(DocId, 'reply', reply);
    }

    // Freetalk
    if (top_index == 2) {
      // Freetalk().update_data(DocId, 'reply', reply);
    }

    // Recipe
    if (top_index == 3) {
      // Recipe().update_data(DocId, 'reply', reply);
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("댓글쓰기 완료"),
            content: new Text("댓글 쓰기가 완료되었습니다."),
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

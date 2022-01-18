import 'package:flutter/material.dart';

// provider listener 이용
import 'package:flutter/foundation.dart';

// provider import
import 'package:today_dinner/providers/data/Feed.dart';
import 'package:today_dinner/providers/data/Freetalk.dart';
import 'package:today_dinner/providers/data/Recipe.dart';
import 'package:today_dinner/providers/data/User.dart';

class Mypage with ChangeNotifier {
  List<String> filter_list = []; // 선택된 필터 List

  int top_index = 3; // 메인페이지 상단 메뉴 1 : 피드, 2: 레시피, 3: 자유게시판

  String Searchtext = ""; // 검색어 저장
}

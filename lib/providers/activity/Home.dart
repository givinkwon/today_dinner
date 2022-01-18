import 'package:flutter/material.dart';

// provider listener 이용
import 'package:flutter/foundation.dart';

// provider import
import 'package:today_dinner/providers/data/Feed.dart';
import 'package:today_dinner/providers/data/Freetalk.dart';
import 'package:today_dinner/providers/data/Recipe.dart';
import 'package:today_dinner/providers/data/User.dart';

class Home with ChangeNotifier {
  List<String> filter_list = []; // 선택된 필터 List

  int top_index = 3; // 메인페이지 상단 메뉴 1 : 피드, 2: 레시피, 3: 자유게시판

  String Searchtext = ""; // 검색어 저장

  // 필터 태그 선택 시
  void add_filter(value) {
    filter_list.add(value);
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // 필터 태그 삭제 시
  void remove_list(value) {
    filter_list.remove(value);
    notifyListeners();
  }

  // 메인페이지 상단 메뉴 선택 시
  void select_top(value) {
    top_index = value;

    // 필터 초기화
    filter_list = [];

    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // 검색어 저장
  void setSearchText(value) {
    Searchtext = value;
  }
}

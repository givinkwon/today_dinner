import 'package:flutter/material.dart';

// provider listener 이용
import 'package:flutter/foundation.dart';

// provider import
import 'package:today_dinner/providers/repo/Feed.dart';
import 'package:today_dinner/providers/repo/Freetalk.dart';
import 'package:today_dinner/providers/repo/Recipe.dart';
import 'package:today_dinner/providers/repo/User.dart';
import 'package:today_dinner/providers/repo/Home.dart';

class HomeViewmodel with ChangeNotifier {
  late final RecipeRepo _RecipeRepo; // video Reopsitory

  // 생성자
  HomeViewModel() {}

  List<String> filter_list = []; // 선택된 필터 List

  int top_index = 3; // 메인페이지 상단 메뉴 1 : 피드, 2: 레시피, 3: 자유게시판

  String Searchtext = ""; // 검색어 저장

  // 필터 태그 선택 시
  void add_filter(value) {
    filter_list.add(value);

    if (top_index == 1) {
      // 데이터 호출
      // Feed().get_data(Filter: filter_list);
    }
    if (top_index == 2) {
      // 데이터 호출
      // Freetalk().get_data(Filter: filter_list);
    }
    if (top_index == 3) {
      // 데이터 호출
      _RecipeRepo.get_data(Filter: filter_list);
    }
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

  // 좋아요 & 북마크 추가
  void add_like(GoalField, DocId, UserEmail) {
    // Feed
    if (top_index == 1) {
      // Feed().update_data(DocId, GoalField, UserEmail);
    }

    // Freetalk
    if (top_index == 2) {
      // Freetalk().update_data(DocId, GoalField, UserEmail);
    }

    // Recipe
    if (top_index == 3) {
      _RecipeRepo.update_data(DocId, GoalField, UserEmail);
    }
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // 좋아요 제거
  void remove_like(GoalField, DocId, UserEmail) {
    // Feed
    if (top_index == 1) {
      // Feed().delete_data(DocId, 'field', Field: GoalField, Value: UserEmail);
    }

    // Freetalk
    if (top_index == 2) {
      // Freetalk()
      // .delete_data(DocId, 'field', Field: GoalField, Value: UserEmail);
    }

    // Recipe
    if (top_index == 3) {
      _RecipeRepo.delete_data(DocId, 'field',
          Field: GoalField, Value: UserEmail);
    }
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // 검색어 저장
  void setSearchText(value) {
    Searchtext = value;
  }
}
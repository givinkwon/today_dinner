import 'package:flutter/material.dart';
// firebase database => firestore
import 'package:cloud_firestore/cloud_firestore.dart';
// firebase storage
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// provider listener 이용
import 'package:flutter/foundation.dart';
import 'package:today_dinner/repo/Recipe.dart';

import 'dart:collection';

FirebaseFirestore firestore = FirebaseFirestore.instance;
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class RecipeViewModel with ChangeNotifier {
  late var _RecipeRepo = RecipeRepo();
  var Data = [];
  bool data_loading = false; // data patch 중에 로딩

  // 생성자
  RecipeViewModel() {
    _RecipeRepo = RecipeRepo();
    load_data();
  }

  // data 호출
  Future<void> load_data() async {
    // 검색어 초기화
    search_text = "";
    Data = await _RecipeRepo.get_data();
    data_loading = true;

    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // 스크롤 하단에 도착해서 추가 데이터 호출
  Future<void> add_data({Search: ""}) async {
    Data =
        await _RecipeRepo.get_data(Add: true, Search: Search, Filter: Filter);
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // 검색어 저장
  var search_text = "";

  void setSearchText(data) {
    search_text = data;

    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // 검색하기
  void Search() async {
    await _RecipeRepo.get_data(Search: search_text);
    Data = _RecipeRepo.Data;
    data_loading = true;

    //스크롤 상단으로
    ScrollTop();

    notifyListeners();
  }

  // 레시피 디테일 보기
  var recipe_data = {};

  void SelectRecipe(data) async {
    // tag sort
    var unsorted = data['tag'];

    final sorted = new SplayTreeMap<String, String>.from(
        unsorted,
        (key1, key2) =>
            int.parse(unsorted[key1]).compareTo(int.parse(unsorted[key2])));
    data['tag'] = sorted;

    recipe_data = data;
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // 북마크 클릭 시
  void ClickBookmark(data, index) {
    // 북마크가 있으면
    if (data['bookmark'] != null &&
        data['bookmark'].contains(auth.currentUser?.email)) {
      _RecipeRepo.delete_data(data['title'], "field",
          Field: 'bookmark', Value: auth.currentUser?.email);
      // data 업데이트
      Data[index]['bookmark'].remove(auth.currentUser?.email);
    } else {
      // 북마크가 없으면
      _RecipeRepo.update_data(
          data['title'], 'bookmark', auth.currentUser?.email);

      if (Data[index]['bookmark'] == null) {
        Data[index]['bookmark'] = [];
        Data[index]['bookmark'].add(auth.currentUser?.email);
      } else {
        Data[index]['bookmark'].add(auth.currentUser?.email);
      }
    }
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // 레시피 클릭 시
  Future<void> SearchRecipe(data) async {
    search_text = data;
    notifyListeners();
  }

  // 스크롤 전달
  var RecipeController;
  SetController(var controller) {
    RecipeController = controller;
  }

  ScrollTop() {
    RecipeController.animateTo(0.0,
        duration: Duration(seconds: 1), curve: Curves.linear);
  }

  // 필터 클릭 시
  String Filter = "전체";

  Future<void> SelectFilter(data) async {
    Filter = data;
    search_text = ""; // 초기화
    Data = await _RecipeRepo.get_data(Filter: Filter);
    ScrollTop();
    notifyListeners();
  }
}

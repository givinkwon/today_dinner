import 'package:flutter/material.dart';
// firebase database => firestore
import 'package:cloud_firestore/cloud_firestore.dart';
// firebase storage
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// provider listener 이용
import 'package:flutter/foundation.dart';
import 'package:today_dinner/repo/Recipe.dart';

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
    await _RecipeRepo.get_data();
    Data = _RecipeRepo.Data;
    data_loading = true;
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // 스크롤 하단에 도착해서 추가 데이터 호출
  Future<void> add_data() async {
    await _RecipeRepo.get_data(Add: true);
    Data = _RecipeRepo.Data;
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
    print(search_text);
    await _RecipeRepo.get_data(Search: search_text);

    Data = _RecipeRepo.Data;
    notifyListeners();
  }

  // 레시피 디테일 보기
  var recipe_data = {};

  void SelectRecipe(data) {
    recipe_data = data;
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  void ClickBookmark(data) {
    recipe_data = data;

    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }
}

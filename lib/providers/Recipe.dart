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

class RecipeViewmodel with ChangeNotifier {
  late var _RecipeRepo = RecipeRepo();
  var Data = [];
  // 생성자
  RecipeViewModel() {
    print(1);
    _RecipeRepo = RecipeRepo();
    load_data();
  }

  // data 호출
  Future<void> load_data() async {
    await _RecipeRepo.get_data();
    var Data = _RecipeRepo.Data;
  }

  dynamic Selected_data = []; // 선택된 데이터

  // 메인페이지 상단 메뉴 선택 시 데이터 호출
  void select_data(data) {
    Selected_data = data;
    print(Selected_data);
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }
}

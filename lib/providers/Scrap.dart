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

class ScrapViewModel with ChangeNotifier {
  late var _RecipeRepo = RecipeRepo();
  var Data = [];
  bool data_loading = false; // data patch 중에 로딩

  // 생성자
  ScrapViewModel() {
    _RecipeRepo = RecipeRepo();
  }

  // data 호출
  Future<void> load_data() async {
    await _RecipeRepo.get_data(
        Activity: "Scrap", Email: auth.currentUser?.email);
    Data = _RecipeRepo.Data;
    data_loading = true;
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // 스크롤 하단에 도착해서 추가 데이터 호출
  Future<void> add_data() async {
    await _RecipeRepo.get_data(
      Add: true,
      Activity: "Scrap",
      Email: auth.currentUser?.email,
    );
    Data = _RecipeRepo.Data;
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // 레시피 디테일 보기
  var recipe_data = {};

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
}

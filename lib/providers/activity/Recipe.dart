import 'package:flutter/material.dart';
// firebase database => firestore
import 'package:cloud_firestore/cloud_firestore.dart';
// firebase storage
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// provider listener 이용
import 'package:flutter/foundation.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class Recipe with ChangeNotifier {
  dynamic Selected_data = []; // 선택된 데이터

  // 메인페이지 상단 메뉴 선택 시 데이터 호출
  void select_data(data) {
    Selected_data = data;
    print(Selected_data);
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }
}

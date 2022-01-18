import 'dart:math';

import 'package:flutter/material.dart';

// firebase database => firestore
import 'package:cloud_firestore/cloud_firestore.dart';
// firebase storage
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// provider listener 이용
import 'package:flutter/foundation.dart';

// firebase
FirebaseFirestore firestore = FirebaseFirestore.instance;
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class Type with ChangeNotifier {
  List<dynamic> Data = []; // Type 데이터 호출
  dynamic Data_last_doc; // pagnation을 위해 호출 시 마지막 Doc 정보 저장

  // 초기 데이터 호출
  void get_data() async {
    // init
    Data = [];

    await firestore
        .collection("Type")
        .orderBy("createdAt", descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      // 데이터 있는 지 체크
      if (querySnapshot.docs.length > 0) {
        // 마지막 doc 체크
        Data_last_doc = querySnapshot.docs.last;

        for (var TypeDoc in querySnapshot.docs) {
          Data.add(TypeDoc.data());
        }
      }
    });

    notifyListeners();
  }
}

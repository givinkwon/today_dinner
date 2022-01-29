import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
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
// auth
FirebaseAuth auth = FirebaseAuth.instance;

class VideoRepo {
  List<dynamic> Data = []; // Video 데이터 호출
  dynamic Data_last_doc; // pagnation을 위해 호출 시 마지막 Doc 정보 저장
  dynamic Firebase_Query =
      firestore.collection("Video"); // 호출할 Query를 저장하고 마지막에 호출

  // 데이터 호출
  Future<void> get_data({int Limit = 10, bool Add = false}) async {
    // init
    var Pre_Data = Data;
    Data = [];

    Firebase_Query = firestore
        .collection("Video")
        .orderBy("createdAt", descending: true)
        .limit(Limit);

    // 초기 호출이 아닌 경우
    if (Add == true) {
      Data = Pre_Data;
      Firebase_Query = Firebase_Query.startAfterDocument(Data_last_doc);
    }

    await Firebase_Query.get().then((QuerySnapshot querySnapshot) async {
      // 데이터 있는 지 체크
      if (querySnapshot.docs.length > 0) {
        // 마지막 doc 체크
        Data_last_doc = querySnapshot.docs.last;

        for (var VideoDoc in querySnapshot.docs) {
          Data.add(VideoDoc.data());
        }
      }
    });
  }
}

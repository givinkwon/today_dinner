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

class UserRepo with ChangeNotifier {
  List<dynamic> Data = []; // User 데이터 호출
  dynamic Data_last_doc; // pagnation을 위해 호출 시 마지막 Doc 정보 저장

  // 초기 데이터 호출 : 필터 / 개수 / 검색
  void get_data({String Email = "", int Limit = 10}) async {
    // init
    Data = [];

    // Email 현재 USER를 넣어 currentuser data 가져오기
    if (Email != null) {
      await firestore
          .collection("User")
          .where('email', isEqualTo: Email)
          .orderBy("createdAt", descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        // 데이터 있는 지 체크
        if (querySnapshot.docs.length > 0) {
          // 마지막 doc 체크
          Data_last_doc = querySnapshot.docs.last;

          for (var UserDoc in querySnapshot.docs) {
            Data.add(UserDoc.data());
          }
        }
      });
    }

    //초기 호출
    else {
      await firestore
          .collection("User")
          .orderBy("createdAt", descending: true)
          .limit(Limit)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        // 데이터 있는 지 체크
        if (querySnapshot.docs.length > 0) {
          // 마지막 doc 체크
          Data_last_doc = querySnapshot.docs.last;

          for (var UserDoc in querySnapshot.docs) {
            Data.add(UserDoc.data());
          }
        }
      });
    }

    notifyListeners();
  }

  // 추가 유저 데이터 호출
  void get_data_append({int Limit = 10}) async {
    //일반 추가 호출
    await firestore
        .collection("User")
        .orderBy("createdAt", descending: true)
        .startAfterDocument(Data_last_doc)
        .limit(Limit)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      // 데이터 있는 지 체크
      if (querySnapshot.docs.length > 0) {
        // 마지막 doc 체크
        Data_last_doc = querySnapshot.docs.last;

        for (var UserDoc in querySnapshot.docs) {
          Data.add(UserDoc.data());
        }
      }
    });

    notifyListeners();
  }

  // 데이터 create

  void create_data({Map<String, dynamic>? Parameter}) async {
    // random number init
    var rand = new Random().nextInt(100000000);

    // 저장
    await firestore.collection("User").doc("$rand").set(Parameter!);

    notifyListeners();
  }

  // 데이터 update
  void update_data(String DocId, {Map<String, dynamic>? Parameter}) async {
    // update
    await firestore.collection("User").doc(DocId).update(Parameter!);

    notifyListeners();
  }

  // 데이터 delete
  void delete_data(String DocId) async {
    // delete
    await firestore.collection("User").doc(DocId).delete();

    notifyListeners();
  }
}

// data example
// {
//                     'createdAt': FieldValue.serverTimestamp(),
//                     'email': Email,
//                     'nickname': Nickname,
//                     'password': Password,
//                     'phone': Phone,
//                     'name': Name,
//                     'profileimage': '',
//                     'marketing': Marketing,
//                   }
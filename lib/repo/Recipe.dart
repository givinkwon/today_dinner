import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

class RecipeRepo {
  List<dynamic> Data = []; // Recipe 데이터 호출
  dynamic Data_last_doc; // pagnation을 위해 호출 시 마지막 Doc 정보 저장
  dynamic Firebase_Query =
      firestore.collection("Recipe"); // 호출할 Query를 저장하고 마지막에 호출

  // 데이터 호출 : 필터 / 개수 / 검색 / activity(Home / Scrap / Mypage)
  Future<void> get_data(
      {List<dynamic>? Filter,
      int Limit = 10,
      String Search = "",
      String Activity = "Home",
      String? Email = "",
      bool Add = false}) async {
    // init
    var Pre_Data = Data;
    Data = [];

    Firebase_Query = firestore
        .collection("Recipe")
        .orderBy("createdAt", descending: true)
        .limit(Limit);

    // 1. Activity가 Mypage인 경우 => 내 글
    if (Activity == "Mypage") {
      Firebase_Query = Firebase_Query.where('user', isEqualTo: Email);
    }

    // ==================================================
    // 2. Activity가 Scrap인 경우 => 스크랩한 글
    if (Activity == "Scrap") {
      Firebase_Query = Firebase_Query.where('bookmark', arrayContains: Email);
    }

    // Filter가 있는 경우
    if (Filter != null) {
      Firebase_Query = Firebase_Query.where('filter', arrayContainsAny: Filter);
    }

    // Search가 있는 경우
    if (Search != "") {
      Firebase_Query = Firebase_Query.where('search', arrayContains: Search);
    }

    // 초기 호출이 아닌 경우
    if (Add == true) {
      Data = Pre_Data;
      Firebase_Query = Firebase_Query.startAfterDocument(Data_last_doc);
    }

    //호출
    await Firebase_Query.get().then((QuerySnapshot querySnapshot) async {
      // 데이터 있는 지 체크
      if (querySnapshot.docs.length > 0) {
        // 마지막 doc 체크
        Data_last_doc = querySnapshot.docs.last;

        for (var RecipeDoc in querySnapshot.docs) {
          Data.add(RecipeDoc.data());
        }
      }
    });

    print(Data);
  }

  // 데이터 create

  void create_data({Map<String, dynamic>? Parameter}) async {
    // random number init
    var rand = new Random().nextInt(100000000);

    // 저장
    await firestore.collection("Recipe").doc("$rand").set(Parameter!);
  }

  // 데이터 update
  void update_data(String DocId, String Field, dynamic Value,
      {Map<String, dynamic>? Parameter}) async {
    // array init
    var array_field = ['like', 'bookmark', 'reply', 'filter', 'search'];

    Firebase_Query = firestore.collection("Recipe").doc(DocId);

    // parmeter로 여러 field를 한 번에 수정하는 경우
    if (Parameter != null) {
      // update
      await Firebase_Query.update(Parameter);
    }

    // array update => like, bookmark, reply, filter, search
    else if (array_field.contains(Field)) {
      // update
      await Firebase_Query.update({
        Field: FieldValue.arrayUnion([Value])
      });
    }

    // 일반 field update
    else {
      // update
      await Firebase_Query.update({Field: Value});
    }
  }

  // 데이터 delete
  // 1. doc delete
  // 2. fleid delte
  void delete_data(String DocId, String State,
      {String Field = "", dynamic Value}) async {
    // array init
    // array update => like, bookmark, reply, filter, search
    var array_field = ['like', 'bookmark', 'reply', 'filter', 'search'];

    Firebase_Query = firestore.collection("Recipe").doc(DocId);

    // document 삭제의 경우
    if (State == "document") {
      // delete
      await Firebase_Query.delete();
    }

    // array field 삭제의 경우
    else if (array_field.contains(Field)) {
      // delete
      await Firebase_Query.update({
        Field: FieldValue.arrayRemove([Value])
      });
    }

    // 일반 field 삭제
    else {
      // delete
      await Firebase_Query.update({Field: FieldValue.delete()});
    }
  }
}

// data example
// {
//   'id': "${rand}",
//   'createdAt': FieldValue.serverTimestamp(),
//   'content': null,
//   'user': auth.currentUser?.email,
//   'nickname': null,
//   'image': null, // array
//   'filter': null, // array
// }
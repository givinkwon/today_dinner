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

class Feed with ChangeNotifier {
  List<dynamic> Data = []; // Feed 데이터 호출
  dynamic Data_last_doc; // pagnation을 위해 호출 시 마지막 Doc 정보 저장

  // 초기 데이터 호출 : 필터 / 개수 / 검색
  void get_data(
      {List<dynamic>? Filter, int Limit = 10, String Search = ""}) async {
    // init
    Data = [];

    // Filter & Search 동시 초기 호출
    if (Filter != null && Search != "") {
      await firestore
          .collection("Feed")
          .where('filter', arrayContainsAny: Filter)
          .where('search', arrayContains: Search)
          .orderBy("createdAt", descending: true)
          .limit(Limit)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        // 데이터 있는 지 체크
        if (querySnapshot.docs.length > 0) {
          // 마지막 doc 체크
          Data_last_doc = querySnapshot.docs.last;

          for (var FeedDoc in querySnapshot.docs) {
            Data.add(FeedDoc.data());
          }
        }
      });
    }

    // Filter 초기 호출
    else if (Filter != null) {
      await firestore
          .collection("Feed")
          .where('filter', arrayContainsAny: Filter)
          .orderBy("createdAt", descending: true)
          .limit(Limit)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        // 데이터 있는 지 체크
        if (querySnapshot.docs.length > 0) {
          // 마지막 doc 체크
          Data_last_doc = querySnapshot.docs.last;

          for (var FeedDoc in querySnapshot.docs) {
            Data.add(FeedDoc.data());
          }
        }
      });
    }

    // Search 초기 호출
    else if (Search != "") {
      await firestore
          .collection("Feed")
          .where('search', arrayContains: Search)
          .orderBy("createdAt", descending: true)
          .limit(Limit)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        // 데이터 있는 지 체크
        if (querySnapshot.docs.length > 0) {
          // 마지막 doc 체크
          Data_last_doc = querySnapshot.docs.last;

          for (var FeedDoc in querySnapshot.docs) {
            Data.add(FeedDoc.data());
          }
        }
      });
    }

    //초기 호출
    else {
      await firestore
          .collection("Feed")
          .orderBy("createdAt", descending: true)
          .limit(Limit)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        // 데이터 있는 지 체크
        if (querySnapshot.docs.length > 0) {
          // 마지막 doc 체크
          Data_last_doc = querySnapshot.docs.last;

          for (var FeedDoc in querySnapshot.docs) {
            Data.add(FeedDoc.data());
          }
        }
      });
    }

    notifyListeners();
  }

  // 추가 데이터 호출 : 필터 / 개수 / 검색
  void get_data_append(
      {List<dynamic>? Filter, int Limit = 10, String Search = ""}) async {
    // Filter & Search 동시 추가 호출
    if (Filter != null && Search != "") {
      await firestore
          .collection("Feed")
          .where('filter', arrayContainsAny: Filter)
          .where('search', arrayContains: Search)
          .orderBy("createdAt", descending: true)
          .startAfterDocument(Data_last_doc)
          .limit(Limit)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        // 데이터 있는 지 체크
        if (querySnapshot.docs.isNotEmpty) {
          // 마지막 doc 체크
          Data_last_doc = querySnapshot.docs.last;

          for (var FeedDoc in querySnapshot.docs) {
            Data.add(FeedDoc.data());
          }
        }
      });
    }

    // Filter 추가 호출
    else if (Filter != null) {
      await firestore
          .collection("Feed")
          .where('filter', arrayContainsAny: Filter)
          .orderBy("createdAt", descending: true)
          .startAfterDocument(Data_last_doc)
          .limit(Limit)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        // 데이터 있는 지 체크
        if (querySnapshot.docs.length > 0) {
          // 마지막 doc 체크
          Data_last_doc = querySnapshot.docs.last;

          for (var FeedDoc in querySnapshot.docs) {
            Data.add(FeedDoc.data());
          }
        }
      });
    }

    // Search 추가 호출
    else if (Search != "") {
      await firestore
          .collection("Feed")
          .where('search', arrayContains: Search)
          .orderBy("createdAt", descending: true)
          .startAfterDocument(Data_last_doc)
          .limit(Limit)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        // 데이터 있는 지 체크
        if (querySnapshot.docs.length > 0) {
          // 마지막 doc 체크
          Data_last_doc = querySnapshot.docs.last;

          for (var FeedDoc in querySnapshot.docs) {
            Data.add(FeedDoc.data());
          }
        }
      });
    }

    //일반 추가 호출
    else {
      await firestore
          .collection("Feed")
          .orderBy("createdAt", descending: true)
          .startAfterDocument(Data_last_doc)
          .limit(Limit)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        // 데이터 있는 지 체크
        if (querySnapshot.docs.length > 0) {
          // 마지막 doc 체크
          Data_last_doc = querySnapshot.docs.last;

          for (var FeedDoc in querySnapshot.docs) {
            Data.add(FeedDoc.data());
          }
        }
      });
    }

    notifyListeners();
  }

  // 데이터 create

  void create_data({Map<String, dynamic>? Parameter}) async {
    // random number init
    var rand = new Random().nextInt(100000000);

    // 저장
    await firestore.collection("Feed").doc("$rand").set(Parameter!);

    notifyListeners();
  }

  // 데이터 update
  void update_data(String DocId, String Field, dynamic Value,
      {Map<String, dynamic>? Parameter}) async {
    // array init
    var array_field = ['like', 'bookmark', 'reply', 'filter', 'search'];

    // parmeter로 여러 field를 한 번에 수정하는 경우
    if (Parameter != null) {
      // update
      await firestore.collection("Feed").doc(DocId).update(Parameter);
    }

    // array update => like, bookmark, reply, filter, search
    else if (array_field.contains(Field)) {
      // update
      await firestore
          .collection("Feed")
          .doc(DocId)
          .update({Field: FieldValue.arrayUnion(Value)});
    }

    // 일반 field update
    else {
      // update
      await firestore.collection("Feed").doc(DocId).update({Field: Value});
    }

    notifyListeners();
  }

  // 데이터 delete
  // 1. doc delete
  // 2. fleid delte
  void delete_data(String DocId, String State,
      {String Field = "", dynamic Value}) async {
    // array init
    // array update => like, bookmark, reply, filter, search
    var array_field = ['like', 'bookmark', 'reply', 'filter', 'search'];

    // document 삭제의 경우
    if (State == "document") {
      // delete
      await firestore.collection("Feed").doc(DocId).delete();
    }

    // array field 삭제의 경우
    else if (array_field.contains(Field)) {
      // delete
      await firestore
          .collection("Feed")
          .doc(DocId)
          .update({Field: FieldValue.arrayRemove(Value)});
    }

    // 일반 field 삭제
    else {
      // delete
      await firestore
          .collection("Feed")
          .doc(DocId)
          .update({Field: FieldValue.delete()});
    }

    notifyListeners();
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
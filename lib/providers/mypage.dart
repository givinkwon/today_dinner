import 'package:flutter/material.dart';

// firebase database => firestore
import 'package:cloud_firestore/cloud_firestore.dart';
// firebase storage
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// provider listener 이용
import 'package:flutter/foundation.dart';
// firebase auth
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class Mypage with ChangeNotifier {
  String EmailValue = "";
  List<String> Selected_list = []; // 필터 선택 박스

  bool check = true; // 선택된 필터가 있을 때 true일 때만 글을 보여주는 필터 관련 state

  int top_index = 1; // 메인페이지 상단 메뉴 1 : 피드, 2: 레시피, 3: 자유게시판

  // 피드 | 자유게시판 | 레시피 데이터 관련 시작

  List<dynamic> Feed = []; // Feed 데이터 호출

  List<dynamic> Freetalk = []; // Freetalk 데이터 호출

  List<dynamic> Recipe = []; // Recipe 데이터 호출

  bool Feed_like_loading = false; // 데이터 로딩 완료
  bool Feed_image_loading = false; // 데이터 로딩 완료
  bool Feed_reply_loading = false; // 데이터 로딩 완료
  bool Feed_bookmark_loading = false; // 데이터 로딩 완료

  bool Freetalk_like_loading = false; // 데이터 로딩 완료
  bool Freetalk_image_loading = false; // 데이터 로딩 완료
  bool Freetalk_reply_loading = false; // 데이터 로딩 완료
  bool Freetalk_bookmark_loading = false; // 데이터 로딩 완료

  bool Recipe_like_loading = false; // 데이터 로딩 완료
  bool Recipe_image_loading = false; // 데이터 로딩 완료
  bool Recipe_reply_loading = false; // 데이터 로딩 완료
  bool Recipe_bookmark_loading = false; // 데이터 로딩 완료

  List<dynamic> Ingredients = []; // Ingredients 데이터 호출

  List<dynamic> Ingredients_id = []; //Ingredients id 데이터 호출

  List<dynamic> Meal = []; // Meal 데이터 호출

  List<dynamic> Type = []; // Type 데이터 호출

  List<dynamic> User = []; // User 데이터 호출

  List<dynamic> Selected_data = []; // 선택된 데이터

  int Feed_index = 0;
  int Freetalk_index = 0;
  int Recipe_index = 0;
  int Bookmark_index = 0;

  // 피드 | 자유게시판 | 레시피 데이터 관련 끝

  // 필터 태그 선택 시
  void add_list(value) {
    Selected_list.add(value);
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // 필터 태그 삭제 시
  void remove_list(value) {
    Selected_list.remove(value);
    notifyListeners();
  }

  // 메인페이지 상단 메뉴 선택 시
  void select_top(value) {
    top_index = value;
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // 메인페이지 상단 메뉴 선택 시 데이터 호출
  void select_data() {
    if (top_index == 1) {
      Selected_data = Feed;
    }

    if (top_index == 2) {
      Selected_data = Freetalk;
    }

    if (top_index == 3) {
      Selected_data = Recipe;
    }
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // firestore 데이터 호출하기
  void data_init() async {
    Feed = [];
    Freetalk = [];
    Recipe = [];
    Ingredients = [];
    Meal = [];
    Type = [];
    User = [];
    Feed_index = 0;
    Freetalk_index = 0;
    Recipe_index = 0;

    Feed_image_loading = false; // image 데이터 로딩 완료
    Feed_like_loading = false; // iike 데이터 로딩 완료
    Feed_reply_loading = false; // reply 데이터 로딩 완료
    Feed_bookmark_loading = false; // reply 데이터 로딩 완료

    Freetalk_image_loading = false; // image 데이터 로딩 완료
    Freetalk_like_loading = false; // iike 데이터 로딩 완료
    Freetalk_reply_loading = false; // reply 데이터 로딩 완료
    Freetalk_bookmark_loading = false; // reply 데이터 로딩 완료

    Recipe_image_loading = false; // image 데이터 로딩 완료
    Recipe_like_loading = false; // iike 데이터 로딩 완료
    Recipe_reply_loading = false; // reply 데이터 로딩 완료
    Recipe_bookmark_loading = false; // reply 데이터 로딩 완료
  }

  void get_data(auth) async {
    //init
    data_init();

    // 피드 데이터 가져오기
    await firestore
        .collection("Feed")
        .where('user', isEqualTo: auth.currentUser?.email)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var Feed_doc in querySnapshot.docs) {
        Feed.add(Feed_doc.data());
        // subcollection data 호출
        getFeedimage(Feed_doc, Feed_index);
        getFeedlike(Feed_doc, Feed_index);
        getFeedreply(Feed_doc, Feed_index);
        getFeedfilter(Feed_doc, Feed_index);
        getFeedbookmark(Feed_doc, Feed_index);
        Feed_index += 1;
      }
    });

    // 자유 게시글 데이터 가져오기
    await firestore
        .collection("Freetalk")
        .where('user', isEqualTo: auth.currentUser?.email)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var Freetalk_doc in querySnapshot.docs) {
        Freetalk.add(Freetalk_doc.data());
        // subcollection data 호출
        getFreetalkimage(Freetalk_doc, Freetalk_index);
        getFreetalklike(Freetalk_doc, Freetalk_index);
        getFreetalkreply(Freetalk_doc, Freetalk_index);
        getFreetalkfilter(Freetalk_doc, Freetalk_index);
        getFreetalkbookmark(Freetalk_doc, Freetalk_index);
        Freetalk_index += 1;
      }
    });

    // 레시피 데이터 가져오기
    await firestore
        .collection("Recipe")
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var Recipe_doc in querySnapshot.docs) {
        Recipe.add(Recipe_doc.data());
        // subcollection data 호출
        getRecipeimage(Recipe_doc, Recipe_index);
        getRecipelike(Recipe_doc, Recipe_index);
        getRecipereply(Recipe_doc, Recipe_index);
        getRecipefilter(Recipe_doc, Recipe_index);
        getRecipebookmark(Recipe_doc, Recipe_index);
        Recipe_index += 1;
      }
    });

    // 식재료 데이터 가져오기
    await firestore
        .collection("Ingredients")
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var Ingredients_doc in querySnapshot.docs) {
        Ingredients.add(Ingredients_doc.data());
        Ingredients_id.add(Ingredients_doc.id);
      }
    });

    // 식사 데이터 가져오기
    await firestore
        .collection("Meal")
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var Meal_doc in querySnapshot.docs) {
        Meal.add(Meal_doc.data());
      }
    });

    // 식사 타입 데이터 가져오기
    await firestore
        .collection("Type")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var Type_doc in querySnapshot.docs) {
        Type.add(Type_doc.data());
      }
    });

    // 유저 타입 데이터 가져오기
    await firestore
        .collection("User")
        .where('email', isEqualTo: auth.currentUser?.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var User_doc in querySnapshot.docs) {
        User.add(User_doc.data());
      }
    });

    print(Feed);
    // print(Feed[0]['user'].id);
    //print(Freetalk);
    // print(Recipe);
    //Meal.forEach((data) => {print(data['value'])});
    // print(Ingredients_id);
    // print(Type);
    // print(User);
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // Feed sub collection 호출 시작
  void getFeedlike(Feed_doc, Feed_index) async {
    // Feed > data > iike 데이터 호출
    await firestore
        .collection('Feed/' + Feed_doc.id + '/like')
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var Feedlike_doc in querySnapshot.docs) {
        // init => init 안하면 null error
        Feed[Feed_index]['like'] = [];
        Feed[Feed_index]['like'].add(Feedlike_doc.data());
      }
    });
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
    Feed_like_loading = true; // 데이터 로딩 완료
  }

  void getFeedimage(Feed_doc, Feed_index) async {
    // Feed > data > image 데이터 호출
    await firestore
        .collection('Feed/' + Feed_doc.id + '/image')
        .get()
        .then((QuerySnapshot querySnapshot) {
      // init => init 안하면 null error
      Feed[Feed_index]['image'] = [];
      for (var Feedimage_doc in querySnapshot.docs) {
        Feed[Feed_index]['image'].add(Feedimage_doc.data());
      }
    });
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
    Feed_image_loading = true; // 데이터 로딩 완료
  }

  void getFeedreply(Feed_doc, Feed_index) async {
    // Feed > data > image 데이터 호출
    await firestore
        .collection('Feed/' + Feed_doc.id + '/reply')
        .get()
        .then((QuerySnapshot querySnapshot) {
      // init => init 안하면 null error
      Feed[Feed_index]['reply'] = [];
      for (var Feedreply_doc in querySnapshot.docs) {
        Feed[Feed_index]['reply'].add(Feedreply_doc.data());
      }
    });
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
    Feed_reply_loading = true; // 데이터 로딩 완료
  }

  void getFeedfilter(Feed_doc, Feed_index) async {
    // init => init 안하면 null error
    Feed[Feed_index]['filter'] = [];
    // Feed > data > filter 데이터 호출
    await firestore
        .collection('Feed/' + Feed_doc.id + '/filter')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var Feedfilter_doc in querySnapshot.docs) {
        Feed[Feed_index]['filter'].add(Feedfilter_doc.id);
      }
    });
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  void getFeedbookmark(Feed_doc, Feed_index) async {
    // init => init 안하면 null error
    Feed[Feed_index]['bookmark'] = [];
    // Feed > data > filter 데이터 호출
    await firestore
        .collection('Feed/' + Feed_doc.id + '/bookmark')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var Feedbookmark_doc in querySnapshot.docs) {
        Feed[Feed_index]['bookmark'].add(Feedbookmark_doc.data());
      }
    });
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }
  // Feed sub collection 호출 끝

  // Freetalk sub collection 호출 시작
  void getFreetalklike(Freetalk_doc, Freetalk_index) async {
    // Freetalk > data > iike 데이터 호출
    await firestore
        .collection('Freetalk/' + Freetalk_doc.id + '/like')
        .get()
        .then((QuerySnapshot querySnapshot) async {
      // init => init 안하면 null error
      Freetalk[Freetalk_index]['like'] = [];
      for (var Freetalklike_doc in querySnapshot.docs) {
        Freetalk[Freetalk_index]['like'].add(Freetalklike_doc.data());
      }
    });
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
    Freetalk_like_loading = true; // 데이터 로딩 완료
  }

  void getFreetalkimage(Freetalk_doc, Freetalk_index) async {
    // Freetalk > data > image 데이터 호출
    await firestore
        .collection('Freetalk/' + Freetalk_doc.id + '/image')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var Freetalkimage_doc in querySnapshot.docs) {
        // init => init 안하면 null error
        Freetalk[Freetalk_index]['image'] = [];
        Freetalk[Freetalk_index]['image'].add(Freetalkimage_doc.data());
      }
    });
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
    Freetalk_image_loading = true; // 데이터 로딩 완료
  }

  void getFreetalkreply(Freetalk_doc, Freetalk_index) async {
    // Feed > data > image 데이터 호출
    await firestore
        .collection('Freetalk/' + Freetalk_doc.id + '/reply')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var Freetalkreply_doc in querySnapshot.docs) {
        // init => init 안하면 null error
        Freetalk[Freetalk_index]['reply'] = [];
        Freetalk[Freetalk_index]['reply'].add(Freetalkreply_doc.data());
      }
    });
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
    Freetalk_reply_loading = true; // 데이터 로딩 완료
  }

  void getFreetalkfilter(Freetalk_doc, Freetalk_index) async {
    // init => init 안하면 null error
    Freetalk[Freetalk_index]['filter'] = [];
    // Feed > data > filter 데이터 호출
    await firestore
        .collection('Freetalk/' + Freetalk_doc.id + '/filter')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var Freetalkfilter_doc in querySnapshot.docs) {
        Freetalk[Freetalk_index]['filter'].add(Freetalkfilter_doc.id);
      }
    });
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  void getFreetalkbookmark(Freetalk_doc, Freetalk_index) async {
    // init => init 안하면 null error
    Freetalk[Freetalk_index]['bookmark'] = [];
    // Feed > data > filter 데이터 호출
    await firestore
        .collection('Freetalk/' + Freetalk_doc.id + '/bookmark')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var Freetalkbookmark_doc in querySnapshot.docs) {
        Freetalk[Freetalk_index]['bookmark'].add(Freetalkbookmark_doc.data());
      }
    });
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }
  // Freetalk sub collection 호출 끝

  // Recipe sub collection 호출 시작
  void getRecipelike(Recipe_doc, Recipe_index) async {
    // Recipe > data > iike 데이터 호출
    await firestore
        .collection('Recipe/' + Recipe_doc.id + '/like')
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var Recipelike_doc in querySnapshot.docs) {
        // init => init 안하면 null error
        Recipe[Recipe_index]['like'] = [];
        Recipe[Recipe_index]['like'].add(Recipelike_doc.data());
      }
    });
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
    Recipe_like_loading = true; // 데이터 로딩 완료
  }

  void getRecipeimage(Recipe_doc, Recipe_index) async {
    // Recipe > data > image 데이터 호출
    await firestore
        .collection('Recipe/' + Recipe_doc.id + '/image')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var Recipeimage_doc in querySnapshot.docs) {
        // init => init 안하면 null error
        Recipe[Recipe_index]['image'] = [];
        Recipe[Recipe_index]['image'].add(Recipeimage_doc.data());
      }
    });
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
    Recipe_image_loading = true; // 데이터 로딩 완료
  }

  void getRecipereply(Recipe_doc, Recipe_index) async {
    // Feed > data > image 데이터 호출
    await firestore
        .collection('Recipe/' + Recipe_doc.id + '/reply')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var Recipereply_doc in querySnapshot.docs) {
        // init => init 안하면 null error
        Recipe[Recipe_index]['reply'] = [];
        Recipe[Recipe_index]['reply'].add(Recipereply_doc.data());
      }
    });
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
    Recipe_reply_loading = true; // 데이터 로딩 완료
  }

  void getRecipefilter(Recipe_doc, Recipe_index) async {
    // init => init 안하면 null error
    Recipe[Recipe_index]['filter'] = [];
    // Feed > data > filter 데이터 호출
    await firestore
        .collection('Recipe/' + Recipe_doc.id + '/filter')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var Recipefilter_doc in querySnapshot.docs) {
        Recipe[Recipe_index]['filter'].add(Recipefilter_doc.id);
      }
    });
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  void getRecipebookmark(Recipe_doc, Recipe_index) async {
    // init => init 안하면 null error
    Recipe[Recipe_index]['bookmark'] = [];
    // Feed > data > filter 데이터 호출
    await firestore
        .collection('Recipe/' + Recipe_doc.id + '/bookmark')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var Recipebookmark_doc in querySnapshot.docs) {
        Recipe[Recipe_index]['bookmark'].add(Recipebookmark_doc.data());
      }
    });
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }
  // Recipe sub collection 호출 끝

  // like add
  Future<void> add_like(auth, user_email, id) async {
    // Feed
    if (top_index == 1) {
      //데이터베이스 저장
      firestore
          .collection("Feed")
          .doc(id)
          .collection("like")
          .doc(user_email)
          .set({
        'value': user_email,
      });
    }
    //Freetalk
    if (top_index == 2) {
      //데이터베이스 저장
      firestore
          .collection("Freetalk")
          .doc(id)
          .collection("like")
          .doc(user_email)
          .set({
        'value': user_email,
      });
    }
    // 구독 widget에게 변화 알려서 re-build
    get_data(auth);
    notifyListeners();
  }

  //like_remove
  Future<void> remove_like(auth, user_email, id) async {
    // Feed
    if (top_index == 1) {
      //데이터베이스 저장
      firestore
          .collection("Feed")
          .doc(id)
          .collection("like")
          .doc(user_email)
          .delete();
    }
    //Freetalk
    if (top_index == 2) {
      //데이터베이스 저장
      firestore
          .collection("Freetalk")
          .doc(id)
          .collection("like")
          .doc(user_email)
          .delete();
    }
    // 구독 widget에게 변화 알려서 re-build
    get_data(auth);
    notifyListeners();
  }

  //bookmark_remove
  Future<void> add_bookmark(auth, user_email, id) async {
    // Feed
    if (top_index == 1) {
      //데이터베이스 저장
      firestore
          .collection("Feed")
          .doc(id)
          .collection("bookmark")
          .doc(user_email)
          .set({
        'value': user_email,
      });
    }
    //Freetalk
    if (top_index == 2) {
      //데이터베이스 저장
      firestore
          .collection("Freetalk")
          .doc(id)
          .collection("bookmark")
          .doc(user_email)
          .set({
        'value': user_email,
      });
    }
    //Recipe
    if (top_index == 3) {
      //데이터베이스 저장
      firestore
          .collection("Recipe")
          .doc(id)
          .collection("bookmark")
          .doc(user_email)
          .set({
        'value': user_email,
      });
    }
    // 구독 widget에게 변화 알려서 re-build
    get_data(auth);
    notifyListeners();
  }

  //bookmark_remove
  Future<void> remove_bookmark(auth, user_email, id) async {
    // Feed
    if (top_index == 1) {
      //데이터베이스 저장
      firestore
          .collection("Feed")
          .doc(id)
          .collection("bookmark")
          .doc(user_email)
          .delete();
    }
    //Freetalk
    if (top_index == 2) {
      //데이터베이스 저장
      firestore
          .collection("Freetalk")
          .doc(id)
          .collection("bookmark")
          .doc(user_email)
          .delete();
    }
    //Recipe
    if (top_index == 2) {
      //데이터베이스 저장
      firestore
          .collection("Recipe")
          .doc(id)
          .collection("bookmark")
          .doc(user_email)
          .delete();
    }
    // 구독 widget에게 변화 알려서 re-build
    get_data(auth);
    notifyListeners();
  }
}

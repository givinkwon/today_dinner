import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// firebase database => firestore
import 'package:cloud_firestore/cloud_firestore.dart';
// firebase storage
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// provider listener 이용
import 'package:flutter/foundation.dart';
import 'package:today_dinner/providers/profile.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class Home with ChangeNotifier {
  String EmailValue = "";
  List<String> Selected_list = []; // 필터 선택 박스

  bool check = true; // 선택된 필터가 있을 때 true일 때만 글을 보여주는 필터 관련 state
  int filter_count = 0; // 선택된 필터 and 조건 => filter_count = len(Selected_list)

  bool checksearch = true; // 검색어가 있을 때 true일 때만 글을 보여주는 필터 관련 state

  bool checkblacklist = true; // 블랙리스트가 있을 때 true일 때만 글을 보여줌

  int top_index = 3; // 메인페이지 상단 메뉴 1 : 피드, 2: 레시피, 3: 자유게시판

  // 피드 | 자유게시판 | 레시피 데이터 관련 시작

  List<dynamic> Feed = []; // Feed 데이터 호출
  List<dynamic> Feed_index_list = []; // Subcollection 호출을 위한 Feed index list 저장

  List<dynamic> Freetalk = []; // Freetalk 데이터 호출
  List<dynamic> Freetalk_index_list =
      []; // Subcollection 호출을 위한 Freetalk index list 저장

  List<dynamic> Recipe = []; // Recipe 데이터 호출
  List<dynamic> Recipe_index_list =
      []; // Subcollection 호출을 위한 Recipe index list 저장

  bool Feed_like_loading = false; // 데이터 로딩 완료
  bool Feed_image_loading = false; // 데이터 로딩 완료
  bool Feed_reply_loading = false; // 데이터 로딩 완료
  bool Feed_bookmark_loading = false; // 데이터 로딩 완료
  bool Feed_profileimage_loading = false; // 데이터 로딩 완료

  bool Freetalk_like_loading = false; // 데이터 로딩 완료
  bool Freetalk_image_loading = false; // 데이터 로딩 완료
  bool Freetalk_reply_loading = false; // 데이터 로딩 완료
  bool Freetalk_bookmark_loading = false; // 데이터 로딩 완료
  bool Freetalk_profileimage_loading = false; // 데이터 로딩 완료

  bool Recipe_like_loading = false; // 데이터 로딩 완료
  bool Recipe_tag_loading = false; // 데이터 로딩 완료
  bool Recipe_reply_loading = false; // 데이터 로딩 완료
  bool Recipe_bookmark_loading = false; // 데이터 로딩 완료
  bool Recipe_profileimage_loading = false; // 데이터 로딩 완료

  List<dynamic> Ingredients = []; // Ingredients 데이터 호출

  List<dynamic> Ingredients_id = []; //Ingredients id 데이터 호출

  List<dynamic> Meal = []; // Meal 데이터 호출

  List<dynamic> Type = []; // Type 데이터 호출

  List<dynamic> Baby = []; // Baby 데이터 호출

  List<dynamic> Cook = []; // Cook 데이터 호출

  List<dynamic> User = []; // User 데이터 호출
  List<dynamic> User_index_list = []; // User index list

  List<dynamic> Selected_data = []; // 선택된 데이터

  int Feed_count = 0; // 현재 가져온 데이터 개수
  int Freetalk_count = 0; // 현재 가져온 데이터 개수
  int Recipe_count = 0; // 현재 가져온 데이터 개수
  int Bookmark_index = 0;

  int Fetch_count = 10; // 가져오는 ROW 개수
  int Row_index = 0; // 현재 가져오는 row 위치

  dynamic Feed_last_doc;
  dynamic Freetalk_last_doc;
  dynamic Recipe_last_doc;

  // 피드 | 자유게시판 | 레시피 데이터 관련 끝

  // 필터 태그 선택 시
  void add_list(value) {
    Selected_list.add(value);
    // 데이터 추가 호출
    get_data_append();
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

    // 필터 초기화
    Selected_list = [];

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
    Feed_index_list = [];
    Freetalk_index_list = [];
    Recipe_index_list = [];
    User_index_list = [];
    Feed = [];
    Freetalk = [];
    Recipe = [];
    Ingredients = [];
    Meal = [];
    Type = [];
    Baby = [];
    Cook = [];
    User = [];
    Feed_count = 0;
    Freetalk_count = 0;
    Recipe_count = 0;

    Feed_image_loading = false; // image 데이터 로딩 완료
    Feed_like_loading = false; // iike 데이터 로딩 완료
    Feed_reply_loading = false; // reply 데이터 로딩 완료
    Feed_bookmark_loading = false; // reply 데이터 로딩 완료
    Feed_profileimage_loading = false; // profileimage 데이터 로딩 완료

    Freetalk_image_loading = false; // image 데이터 로딩 완료
    Freetalk_like_loading = false; // iike 데이터 로딩 완료
    Freetalk_reply_loading = false; // reply 데이터 로딩 완료
    Freetalk_bookmark_loading = false; // reply 데이터 로딩 완료
    Freetalk_profileimage_loading = false; // profileimage 데이터 로딩 완료

    Recipe_tag_loading = false; // image 데이터 로딩 완료
    Recipe_like_loading = false; // iike 데이터 로딩 완료
    Recipe_reply_loading = false; // reply 데이터 로딩 완료
    Recipe_bookmark_loading = false; // reply 데이터 로딩 완료
    Recipe_profileimage_loading = false; // profileimage 데이터 로딩 완료

    Searchtext = ""; // 검색어 초기화
    Fetch_count = 10; // 가져오는 값 초기화
  }

  // data fetch index ++
  void update_fetch_index() {
    Row_index += 1;
  }

  // 처음 로딩 후 데이터 가져오기
  void get_data_append() async {
    if (Searchtext == "" && Selected_list == []) {
      Fetch_count = 10;
    } else {
      // 현재 firestore의 string 검색 기능이 없으므로
      // 50개를 가져와서 그냥 필터로 걸러주기
      Fetch_count = 100;
      print("더가져와");
    }
    // Feed 화면 로딩
    if (top_index == 1) {
      // 피드 데이터 가져오기
      await firestore
          .collection("Feed")
          .orderBy("createdAt", descending: true)
          .startAfterDocument(Feed_last_doc)
          .limit(Fetch_count)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        // 데이터 있는 지 체크
        if (querySnapshot.docs.length > 0) {
          // 마지막 doc 체크
          Feed_last_doc = querySnapshot.docs.last;
          for (var FeedDoc in querySnapshot.docs) {
            Feed.add(FeedDoc.data());
            Feed_index_list.add(FeedDoc);
          }

          Feed_index_list.asMap().forEach((FeedIndex, FeedDoc) => {
                // 기존에 호출되지 않은 사항 subcollection 호출 및 추가
                if (Feed_count <= FeedIndex)
                  {
                    print("${FeedIndex} ${FeedDoc.data()}"),
                    // subcollection data 호출
                    getFeedimage(FeedDoc, FeedIndex),
                    getFeedlike(FeedDoc, FeedIndex),
                    getFeedreply(FeedDoc, FeedIndex),
                    getFeedfilter(FeedDoc, FeedIndex),
                    getFeedbookmark(FeedDoc, FeedIndex),
                    // User의 프로필 이미지는 변경될 수 있으니 연동해서 가져오기
                    getFeedprofileimage(FeedDoc, FeedIndex),
                  }
              });
        }
      });
      // 데이터 개수 추가
      Feed_count += Fetch_count;
    }

    // Freetalk 화면 로딩
    if (top_index == 2) {
// 자유 게시판 데이터 가져오기
      await firestore
          .collection("Freetalk")
          .orderBy("createdAt", descending: true)
          .startAfterDocument(Freetalk_last_doc)
          .limit(Fetch_count)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        // 데이터 있는 지 체크
        if (querySnapshot.docs.length > 0) {
          // 마지막 doc 체크
          Freetalk_last_doc = querySnapshot.docs.last;
          for (var FreetalkDoc in querySnapshot.docs) {
            Freetalk.add(FreetalkDoc.data());
            Freetalk_index_list.add(FreetalkDoc);
          }

          Freetalk_index_list.asMap().forEach((FreetalkIndex, FreetalkDoc) => {
                // 기존에 호출되지 않은 사항 subcollection 호출 및 추가
                if (Freetalk_count <= FreetalkIndex)
                  {
                    print("${FreetalkIndex} ${FreetalkDoc.data()}"),
                    // subcollection data 호출
                    getFreetalklike(FreetalkDoc, FreetalkIndex),
                    getFreetalkimage(FreetalkDoc, FreetalkIndex),
                    getFreetalkreply(FreetalkDoc, FreetalkIndex),
                    getFreetalkfilter(FreetalkDoc, FreetalkIndex),
                    getFreetalkbookmark(FreetalkDoc, FreetalkIndex),
                    // User의 프로필 이미지는 변경될 수 있으니 연동해서 가져오기
                    getFreetalkprofileimage(FreetalkDoc, FreetalkIndex),
                  }
              });
        }
      });
      // 데이터 개수 추가
      Freetalk_count += Fetch_count;
    }

    // Recipe 화면 로딩
    if (top_index == 3) {
      await firestore
          .collection("Recipe")
          .orderBy("createdAt", descending: true)
          .startAfterDocument(Recipe_last_doc)
          .limit(Fetch_count)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        // 데이터 있는 지 체크
        if (querySnapshot.docs.length > 0) {
          // 마지막 doc 체크
          Recipe_last_doc = querySnapshot.docs.last;
          for (var RecipeDoc in querySnapshot.docs) {
            Recipe.add(RecipeDoc.data());
            Recipe_index_list.add(RecipeDoc);
          }

          Recipe_index_list.asMap().forEach((RecipeIndex, RecipeDoc) => {
                // 기존에 호출되지 않은 사항 subcollection 호출 및 추가
                if (Recipe_count <= RecipeIndex)
                  {
                    print("${RecipeIndex} ${RecipeDoc.data()}"),
                    // subcollection data 호출
                    getRecipelike(RecipeDoc, RecipeIndex),
                    getRecipeprimary(RecipeDoc, RecipeIndex),
                    getRecipesecondary(RecipeDoc, RecipeIndex),
                    getRecipetag(RecipeDoc, RecipeIndex),
                    getRecipereply(RecipeDoc, RecipeIndex),
                    getRecipefilter(RecipeDoc, RecipeIndex),
                    getRecipebookmark(RecipeDoc, RecipeIndex),
                    // User의 프로필 이미지는 변경될 수 있으니 연동해서 가져오기
                    getRecipeprofileimage(RecipeDoc, RecipeIndex),
                  }
              });
        }
      });
      // 데이터 개수 추가
      Recipe_count += Fetch_count;
    }

    notifyListeners();
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  void get_data() async {
    var email = auth.currentUser?.email;
    // init
    data_init();

    Fetch_count = 10;
    // 피드 데이터 가져오기
    await firestore
        .collection("Feed")
        .orderBy("createdAt", descending: true)
        .limit(Fetch_count)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      // 데이터 있는 지 체크
      if (querySnapshot.docs.length > 0) {
        // 마지막 doc 체크
        Feed_last_doc = querySnapshot.docs.last;
        for (var FeedDoc in querySnapshot.docs) {
          Feed.add(FeedDoc.data());
          Feed_index_list.add(FeedDoc);
          // Feed_index += 1;
        }

        Feed_index_list.asMap().forEach((FeedIndex, FeedDoc) => {
              // 현재 index

              // subcollection data 호출
              getFeedimage(FeedDoc, FeedIndex),
              getFeedlike(FeedDoc, FeedIndex),
              getFeedreply(FeedDoc, FeedIndex),
              getFeedfilter(FeedDoc, FeedIndex),
              getFeedbookmark(FeedDoc, FeedIndex),
              // User의 프로필 이미지는 변경될 수 있으니 연동해서 가져오기
              getFeedprofileimage(FeedDoc, FeedIndex),
            });
      }
    });

    // 자유 게시판 데이터 가져오기
    await firestore
        .collection("Freetalk")
        .orderBy("createdAt", descending: true)
        .limit(Fetch_count)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      // 데이터 있는 지 체크
      if (querySnapshot.docs.length > 0) {
        // 마지막 doc 체크
        Freetalk_last_doc = querySnapshot.docs.last;
        for (var FreetalkDoc in querySnapshot.docs) {
          Freetalk.add(FreetalkDoc.data());
          Freetalk_index_list.add(FreetalkDoc);
        }

        Freetalk_index_list.asMap().forEach((FreetalkIndex, FreetalkDoc) => {
              // subcollection data 호출
              getFreetalklike(FreetalkDoc, FreetalkIndex),
              getFreetalkimage(FreetalkDoc, FreetalkIndex),
              getFreetalkreply(FreetalkDoc, FreetalkIndex),
              getFreetalkfilter(FreetalkDoc, FreetalkIndex),
              getFreetalkbookmark(FreetalkDoc, FreetalkIndex),
              // User의 프로필 이미지는 변경될 수 있으니 연동해서 가져오기
              getFreetalkprofileimage(FreetalkDoc, FreetalkIndex),
            });
      }
    });

    // 레시피 데이터 가져오기
    await firestore
        .collection("Recipe")
        .orderBy("createdAt", descending: true)
        .limit(Fetch_count)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      // 데이터 있는 지 체크
      if (querySnapshot.docs.length > 0) {
        // 마지막 doc 체크
        Recipe_last_doc = querySnapshot.docs.last;
        for (var RecipeDoc in querySnapshot.docs) {
          Recipe.add(RecipeDoc.data());
          Recipe_index_list.add(RecipeDoc);
        }

        Recipe_index_list.asMap().forEach((RecipeIndex, RecipeDoc) => {
              print("${RecipeIndex} ${RecipeDoc}"),
              // subcollection data 호출
              getRecipelike(RecipeDoc, RecipeIndex),
              getRecipeprimary(RecipeDoc, RecipeIndex),
              getRecipesecondary(RecipeDoc, RecipeIndex),
              getRecipetag(RecipeDoc, RecipeIndex),
              getRecipereply(RecipeDoc, RecipeIndex),
              getRecipefilter(RecipeDoc, RecipeIndex),
              getRecipebookmark(RecipeDoc, RecipeIndex),
              // User의 프로필 이미지는 변경될 수 있으니 연동해서 가져오기
              getRecipeprofileimage(RecipeDoc, RecipeIndex),
            });
      }
    });

    // 식재료 데이터 가져오기
    await firestore
        .collection("Ingredients")
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var IngredientsDoc in querySnapshot.docs) {
        Ingredients.add(IngredientsDoc.data());
        Ingredients_id.add(IngredientsDoc.id);
      }
    });

    // 식사 데이터 가져오기
    await firestore
        .collection("Meal")
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var MealDoc in querySnapshot.docs) {
        Meal.add(MealDoc.data());
      }
    });

    // 식사 타입 데이터 가져오기
    await firestore
        .collection("Type")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var TypeDoc in querySnapshot.docs) {
        Type.add(TypeDoc.data());
      }
    });

    // 영유아식 데이터 가져오기
    await firestore
        .collection("Babyfood")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var BabyDoc in querySnapshot.docs) {
        Baby.add(BabyDoc.data());
      }
    });

    // 조리법 데이터 가져오기
    await firestore
        .collection("Cook")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var CookDoc in querySnapshot.docs) {
        Cook.add(CookDoc.data());
      }
    });

    // 유저 타입 데이터 가져오기
    getUser(email);

    print(User);
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();

    // fetch_index update
    // 데이터 개수 추가
    Feed_count += Fetch_count;
    Freetalk_count += Fetch_count;
    Recipe_count += Fetch_count;
  }

  // User 데이터 가져오기
  void getUser(email) async {
    User = [];
    // 유저 타입 데이터 가져오기
    await firestore
        .collection("User")
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var UserDoc in querySnapshot.docs) {
        User.add(UserDoc.data());
        User_index_list.add(UserDoc);
      }

      User_index_list.asMap().forEach((UserIndex, UserDoc) => {
            print("${UserIndex} ${UserDoc}"),
            // subcollection data 호출
            getUserBlacklist(UserDoc, UserIndex),
          });
    });
    // 데이터 가져오기
    if (User[0]['marketing'] != null) {
      Profile().Marketing = User[0]?['marketing'];
    }
  }

  // User sub collection = Blacklist 호출
  void getUserBlacklist(UserDoc, UserIndex) async {
    User[UserIndex]['blacklist'] = [];

    // User > data > blacklist 데이터 호출
    await firestore
        .collection('User/' + UserDoc.id + '/blacklist')
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var UserBlacklistDoc in querySnapshot.docs) {
        User[UserIndex]['blacklist'].add(UserBlacklistDoc.data());
      }
    });
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // Feed sub collection 호출 시작
  void getFeedlike(FeedDoc, FeedIndex) async {
    // init => init 안하면 null error
    Feed[FeedIndex]['like'] = [];
    // Feed > data > iike 데이터 호출
    await firestore
        .collection('Feed/' + FeedDoc.id + '/like')
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var FeedlikeDoc in querySnapshot.docs) {
        Feed[FeedIndex]['like'].add(FeedlikeDoc.data());
      }
    });
  }

  void getFeedimage(FeedDoc, FeedIndex) async {
    // init => init 안하면 null error
    Feed[FeedIndex]['image'] = [];
    // Feed > data > image 데이터 호출
    await firestore
        .collection('Feed/' + FeedDoc.id + '/image')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var FeedimageDoc in querySnapshot.docs) {
        Feed[FeedIndex]['image'].add(FeedimageDoc.data());
      }
    });
  }

  void getFeedreply(FeedDoc, FeedIndex) async {
    // init => init 안하면 null error
    Feed[FeedIndex]['reply'] = [];
    // Feed > data > image 데이터 호출
    await firestore
        .collection('Feed/' + FeedDoc.id + '/reply')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var FeedreplyDoc in querySnapshot.docs) {
        Feed[FeedIndex]['reply'].add(FeedreplyDoc.data());
      }
    });
  }

  void getFeedfilter(FeedDoc, FeedIndex) async {
    // init => init 안하면 null error
    Feed[FeedIndex]['filter'] = [];
    // Feed > data > filter 데이터 호출
    await firestore
        .collection('Feed/' + FeedDoc.id + '/filter')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var FeedfilterDoc in querySnapshot.docs) {
        Feed[FeedIndex]['filter'].add(FeedfilterDoc.id);
      }
    });
  }

  void getFeedbookmark(FeedDoc, FeedIndex) async {
    // init => init 안하면 null error
    Feed[FeedIndex]['bookmark'] = [];
    // Feed > data > filter 데이터 호출
    await firestore
        .collection('Feed/' + FeedDoc.id + '/bookmark')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var FeedbookmarkDoc in querySnapshot.docs) {
        Feed[FeedIndex]['bookmark'].add(FeedbookmarkDoc.data());
      }
    });
  }

  void getFeedprofileimage(FeedDoc, FeedIndex) async {
    // init => init 안하면 null error
    Feed[FeedIndex]['profileimage'] = [];
    // Feed > data > filter 데이터 호출
    await firestore
        .collection('User')
        .where('email', isEqualTo: Feed[FeedIndex]['user'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var FeedprofileimageDoc in querySnapshot.docs) {
        // object 유형은 ['']이 안되서 Map으로 바꿔주기
        var data = FeedprofileimageDoc.data() as Map;
        Feed[FeedIndex]['profileimage'].add(data['profileimage']);
      }
    });
  }
  // Feed sub collection 호출 끝

  // Freetalk sub collection 호출 시작
  void getFreetalklike(FreetalkDoc, FreetalkIndex) async {
    // init => init 안하면 null error
    Freetalk[FreetalkIndex]['like'] = [];
    // Freetalk > data > iike 데이터 호출
    await firestore
        .collection('Freetalk/' + FreetalkDoc.id + '/like')
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var FreetalklikeDoc in querySnapshot.docs) {
        Freetalk[FreetalkIndex]['like'].add(FreetalklikeDoc.data());
      }
    });
  }

  void getFreetalkimage(FreetalkDoc, FreetalkIndex) async {
    // init => init 안하면 null error
    Freetalk[FreetalkIndex]['image'] = [];
    // Freetalk > data > image 데이터 호출
    await firestore
        .collection('Freetalk/' + FreetalkDoc.id + '/image')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var FreetalkimageDoc in querySnapshot.docs) {
        Freetalk[FreetalkIndex]['image'].add(FreetalkimageDoc.data());
      }
    });
  }

  void getFreetalkreply(FreetalkDoc, FreetalkIndex) async {
    // init => init 안하면 null error
    Freetalk[FreetalkIndex]['reply'] = [];
    // Feed > data > image 데이터 호출
    await firestore
        .collection('Freetalk/' + FreetalkDoc.id + '/reply')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var FreetalkreplyDoc in querySnapshot.docs) {
        Freetalk[FreetalkIndex]['reply'].add(FreetalkreplyDoc.data());
      }
    });
  }

  void getFreetalkfilter(FreetalkDoc, FreetalkIndex) async {
    // init => init 안하면 null error
    Freetalk[FreetalkIndex]['filter'] = [];
    // Feed > data > filter 데이터 호출

    await firestore
        .collection('Freetalk/' + FreetalkDoc.id + '/filter')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var FreetalkfilterDoc in querySnapshot.docs) {
        Freetalk[FreetalkIndex]['filter'].add(FreetalkfilterDoc.id);
      }
    });
  }

  void getFreetalkbookmark(FreetalkDoc, FreetalkIndex) async {
    // init => init 안하면 null error
    Freetalk[FreetalkIndex]['bookmark'] = [];
    // Feed > data > filter 데이터 호출
    await firestore
        .collection('Freetalk/' + FreetalkDoc.id + '/bookmark')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var FreetalkbookmarkDoc in querySnapshot.docs) {
        Freetalk[FreetalkIndex]['bookmark'].add(FreetalkbookmarkDoc.data());
      }
    });
  }

  void getFreetalkprofileimage(FreetalkDoc, FreetalkIndex) async {
    // init => init 안하면 null error
    Freetalk[FreetalkIndex]['profileimage'] = [];
    // Feed > data > filter 데이터 호출
    await firestore
        .collection('User')
        .where('email', isEqualTo: Freetalk[FreetalkIndex]['user'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var FreetalkprofileimageDoc in querySnapshot.docs) {
        // object 유형은 ['']이 안되서 Map으로 바꿔주기
        var data = FreetalkprofileimageDoc.data() as Map;
        Freetalk[FreetalkIndex]['profileimage'].add(data['profileimage']);
      }
    });
  }
  // Freetalk sub collection 호출 끝

  // Recipe sub collection 호출 시작
  void getRecipelike(RecipeDoc, RecipeIndex) async {
    // init => init 안하면 null error
    Recipe[RecipeIndex]['like'] = [];
    // Recipe > data > iike 데이터 호출
    await firestore
        .collection('Recipe/' + RecipeDoc.id + '/like')
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var RecipelikeDoc in querySnapshot.docs) {
        Recipe[RecipeIndex]['like'].add(RecipelikeDoc.data());
      }
    });
  }

// 메인 식재료
  void getRecipeprimary(RecipeDoc, RecipeIndex) async {
    // init => init 안하면 null error
    Recipe[RecipeIndex]['primary'] = [];
    // Recipe > data > image 데이터 호출
    await firestore
        .collection('Recipe/' + RecipeDoc.id + '/primary')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var RecipeprimaryDoc in querySnapshot.docs) {
        Recipe[RecipeIndex]['primary'].add(RecipeprimaryDoc.data());
      }
    });
  }

  // 양념소스 식재료
  void getRecipesecondary(RecipeDoc, RecipeIndex) async {
    // init => init 안하면 null error
    Recipe[RecipeIndex]['secondary'] = [];
    // Recipe > data > image 데이터 호출
    await firestore
        .collection('Recipe/' + RecipeDoc.id + '/secondary')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var RecipesecondaryDoc in querySnapshot.docs) {
        Recipe[RecipeIndex]['secondary'].add(RecipesecondaryDoc.data());
      }
    });
  }

  // 레시피 태그 => 동영상 seek 기능
  void getRecipetag(RecipeDoc, RecipeIndex) async {
    // init => init 안하면 null error
    Recipe[RecipeIndex]['tag'] = [];
    // Recipe > data > image 데이터 호출
    await firestore
        .collection('Recipe/' + RecipeDoc.id + '/tag')
        .orderBy("seconds", descending: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var RecipetagDoc in querySnapshot.docs) {
        Recipe[RecipeIndex]['tag'].add(RecipetagDoc.data());
      }
    });
  }

  void getRecipereply(RecipeDoc, RecipeIndex) async {
    // Feed > data > image 데이터 호출
    // init => init 안하면 null error
    Recipe[RecipeIndex]['reply'] = [];
    await firestore
        .collection('Recipe/' + RecipeDoc.id + '/reply')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var RecipereplyDoc in querySnapshot.docs) {
        Recipe[RecipeIndex]['reply'].add(RecipereplyDoc.data());
      }
    });
  }

  void getRecipefilter(RecipeDoc, RecipeIndex) async {
    // init => init 안하면 null error
    Recipe[RecipeIndex]['filter'] = [];
    // Feed > data > filter 데이터 호출
    await firestore
        .collection('Recipe/' + RecipeDoc.id + '/filter')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var RecipefilterDoc in querySnapshot.docs) {
        Recipe[RecipeIndex]['filter'].add(RecipefilterDoc.id);
      }
    });
  }

  void getRecipebookmark(RecipeDoc, RecipeIndex) async {
    // init => init 안하면 null error
    Recipe[RecipeIndex]['bookmark'] = [];
    // Feed > data > filter 데이터 호출
    await firestore
        .collection('Recipe/' + RecipeDoc.id + '/bookmark')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var RecipebookmarkDoc in querySnapshot.docs) {
        Recipe[RecipeIndex]['bookmark'].add(RecipebookmarkDoc.data());
      }
    });
  }

  void getRecipeprofileimage(RecipeDoc, RecipeIndex) async {
    // init => init 안하면 null error
    Recipe[RecipeIndex]['profileimage'] = [];
    // Feed > data > filter 데이터 호출
    await firestore
        .collection('User')
        .where('email', isEqualTo: Recipe[RecipeIndex]['user'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var RecipeprofileimageDoc in querySnapshot.docs) {
        // object 유형은 ['']이 안되서 Map으로 바꿔주기
        var data = RecipeprofileimageDoc.data() as Map;
        Recipe[RecipeIndex]['profileimage'].add(data['profileimage']);
      }
    });
  }
  // Recipe sub collection 호출 끝

  // like add
  Future<void> add_like(auth, userEmail, id) async {
    // Feed
    if (top_index == 1) {
      //데이터베이스 저장
      firestore
          .collection("Feed")
          .doc(id)
          .collection("like")
          .doc(userEmail)
          .set({
        'value': userEmail,
      });
    }
    //Freetalk
    if (top_index == 2) {
      //데이터베이스 저장
      firestore
          .collection("Freetalk")
          .doc(id)
          .collection("like")
          .doc(userEmail)
          .set({
        'value': userEmail,
      });
    }
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  //like_remove
  Future<void> remove_like(auth, userEmail, id) async {
    // Feed
    if (top_index == 1) {
      //데이터베이스 저장
      firestore
          .collection("Feed")
          .doc(id)
          .collection("like")
          .doc(userEmail)
          .delete();
    }
    //Freetalk
    if (top_index == 2) {
      //데이터베이스 저장
      firestore
          .collection("Freetalk")
          .doc(id)
          .collection("like")
          .doc(userEmail)
          .delete();
    }
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  //bookmark_remove
  Future<void> add_bookmark(auth, userEmail, id) async {
    // Feed
    if (top_index == 1) {
      //데이터베이스 저장
      firestore
          .collection("Feed")
          .doc(id)
          .collection("bookmark")
          .doc(userEmail)
          .set({
        'value': userEmail,
      });
    }
    //Freetalk
    if (top_index == 2) {
      //데이터베이스 저장
      firestore
          .collection("Freetalk")
          .doc(id)
          .collection("bookmark")
          .doc(userEmail)
          .set({
        'value': userEmail,
      });
    }
    //Recipe
    if (top_index == 3) {
      //데이터베이스 저장
      firestore
          .collection("Recipe")
          .doc(id)
          .collection("bookmark")
          .doc(userEmail)
          .set({
        'value': userEmail,
      });
    }
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  //bookmark_remove
  Future<void> remove_bookmark(auth, userEmail, id) async {
    // Feed
    if (top_index == 1) {
      //데이터베이스 저장
      firestore
          .collection("Feed")
          .doc(id)
          .collection("bookmark")
          .doc(userEmail)
          .delete();
    }
    //Freetalk
    if (top_index == 2) {
      //데이터베이스 저장
      firestore
          .collection("Freetalk")
          .doc(id)
          .collection("bookmark")
          .doc(userEmail)
          .delete();
    }
    //Recipe
    if (top_index == 2) {
      //데이터베이스 저장
      firestore
          .collection("Recipe")
          .doc(id)
          .collection("bookmark")
          .doc(userEmail)
          .delete();
    }
    // 구독 widget에게 변화 알려서 re-build
    notifyListeners();
  }

  // 검색어
  String Searchtext = "";

  // 검색어 저장
  void setSearchText(value) {
    Searchtext = value;
  }

  // 검색어에 따라 호출
  void Search() async {
    Fetch_count = 100;

    // 피드 데이터 가져오기
    if (top_index == 1) {
      // init
      Feed_count = 0;
      Feed = [];
      Feed_index_list = [];
      await firestore
          .collection("Feed")
          .limit(Fetch_count)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        // 데이터 있는 지 체크
        if (querySnapshot.docs.length > 0) {
          // 마지막 doc 체크
          Feed_last_doc = querySnapshot.docs.last;
          for (var FeedDoc in querySnapshot.docs) {
            Feed.add(FeedDoc.data());
            Feed_index_list.add(FeedDoc);
            // Feed_index += 1;
          }

          Feed_index_list.asMap().forEach((FeedIndex, FeedDoc) => {
                print("${FeedIndex} ${FeedDoc.data()}"),
                // subcollection data 호출
                getFeedimage(FeedDoc, FeedIndex),
                getFeedlike(FeedDoc, FeedIndex),
                getFeedreply(FeedDoc, FeedIndex),
                getFeedfilter(FeedDoc, FeedIndex),
                getFeedbookmark(FeedDoc, FeedIndex),
                // User의 프로필 이미지는 변경될 수 있으니 연동해서 가져오기
                getFeedprofileimage(FeedDoc, FeedIndex),
              });
        }
      });

      notifyListeners();
    }

    if (top_index == 2) {
      // init
      Freetalk_count = 0;
      Freetalk = [];
      Freetalk_index_list = [];
      // 자유 게시판 데이터 가져오기
      await firestore
          .collection("Freetalk")
          .limit(Fetch_count)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        // 데이터 있는 지 체크
        if (querySnapshot.docs.length > 0) {
          // 마지막 doc 체크
          Freetalk_last_doc = querySnapshot.docs.last;
          for (var FreetalkDoc in querySnapshot.docs) {
            Freetalk.add(FreetalkDoc.data());
            Freetalk_index_list.add(FreetalkDoc);
          }

          Freetalk_index_list.asMap().forEach((FreetalkIndex, FreetalkDoc) => {
                print("${FreetalkIndex} ${FreetalkDoc.data()}"),
                // subcollection data 호출
                getFreetalklike(FreetalkDoc, FreetalkIndex),
                getFreetalkimage(FreetalkDoc, FreetalkIndex),
                getFreetalkreply(FreetalkDoc, FreetalkIndex),
                getFreetalkfilter(FreetalkDoc, FreetalkIndex),
                getFreetalkbookmark(FreetalkDoc, FreetalkIndex),
                // User의 프로필 이미지는 변경될 수 있으니 연동해서 가져오기
                getFreetalkprofileimage(FreetalkDoc, FreetalkIndex),
              });
        }
      });
    }

    if (top_index == 3) {
      // init
      Recipe_count = 0;
      Recipe = [];
      Recipe_index_list = [];

      // 레시피 데이터 가져오기
      await firestore
          .collection("Recipe")
          .limit(Fetch_count)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        // 데이터 있는 지 체크
        if (querySnapshot.docs.length > 0) {
          // 마지막 doc 체크
          Recipe_last_doc = querySnapshot.docs.last;
          for (var RecipeDoc in querySnapshot.docs) {
            Recipe.add(RecipeDoc.data());
            Recipe_index_list.add(RecipeDoc);
          }

          print("오앙");

          Recipe_index_list.asMap().forEach((RecipeIndex, RecipeDoc) => {
                print("${RecipeIndex} ${RecipeDoc.data()}"),
                // subcollection data 호출
                getRecipelike(RecipeDoc, RecipeIndex),
                getRecipeprimary(RecipeDoc, RecipeIndex),
                getRecipesecondary(RecipeDoc, RecipeIndex),
                getRecipetag(RecipeDoc, RecipeIndex),
                getRecipereply(RecipeDoc, RecipeIndex),
                getRecipefilter(RecipeDoc, RecipeIndex),
                getRecipebookmark(RecipeDoc, RecipeIndex),
                // User의 프로필 이미지는 변경될 수 있으니 연동해서 가져오기
                getRecipeprofileimage(RecipeDoc, RecipeIndex),
              });
        }
      });
    }

    // init
    Feed_count = Fetch_count;
    Freetalk_count = Fetch_count;
    Recipe_count = Fetch_count;
  }
}

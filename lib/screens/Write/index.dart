import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// provider listener 이용
import 'package:flutter/foundation.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:today_dinner/screens/Product/index.dart';
import 'package:today_dinner/screens/Scrap/index.dart';
import 'package:today_dinner/screens/Recipe/index.dart';
import 'package:today_dinner/screens/Shopping/index.dart';
import 'package:today_dinner/screens/Write/index.dart';
import 'package:today_dinner/screens/Home/index.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:today_dinner/screens/Mypage/index.dart';
// provider => watch는 값이 변화할 때 리렌더링, read는 값이 변화해도 렌더링 x
// => watch는 값을 보여주는 UI에 read는 변경이 필요없는 함수에 주로 사용
import 'package:today_dinner/providers/home.dart';
import 'package:today_dinner/providers/write.dart';

// firestorage.List feed_image = firestorage.ref('20210917_164240.jpg');
// var url = firestorage.ref('20210917_164240.jpg').getDownloadURL();

// firebase auth
import 'package:firebase_auth/firebase_auth.dart';

// 갤러리에서 이미지 가져오기
import 'package:image_picker/image_picker.dart';

// firebase 데이터 저장
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart'; // url 가져오기
import 'dart:io';

FirebaseAuth auth = FirebaseAuth.instance;

FileStorage _fileStoarge = Get.put(FileStorage());

class FileStorage extends GetxController {
  late FirebaseStorage storage; //= FirebaseStorage.instance; //storage instance
  late Reference storageRef; //= storage.ref().child(''); //storage

  FileStorage() {
    storage = FirebaseStorage.instance;
  }

  Future<String> uploadFile(String filePath, String uploadPath) async {
    File file = File(filePath);

    try {
      storageRef = storage.ref(uploadPath);
      await storageRef.putFile(file);
      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      return '-1';
    }
  }
}

// SelectedFilter 기본 class => 선택된 필터 종류 보여주는 박스
class SelectedFilter extends StatefulWidget {
  @override
  _SelectedFilterState createState() => _SelectedFilterState();
}

class _SelectedFilterState extends State<SelectedFilter> {
  @override
  Widget build(BuildContext context) {
    if (context.watch<Write>().Selected_list.length > 0) {
      return Container(
        height: 70.0,
        child: GridView.builder(
          padding: EdgeInsets.all(5.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 3.0,
            mainAxisSpacing: 20.0,
            childAspectRatio: 0.38,
          ),
          itemCount: context.watch<Write>().Selected_list.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, int index) {
            return Row(children: <Widget>[
              Text(
                context.watch<Write>().Selected_list[index],
                style: TextStyle(fontSize: 14, color: Colors.purple),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  context
                      .read<Write>()
                      .remove_list(context.read<Write>().Selected_list[index]);
                },
              ),
            ]);
          },
        ),
      );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }
}

// Filter 기본 class
class Filter extends StatefulWidget {
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  // bottomSheet 함수 => 1차 메뉴
  void _showbottom(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: new Text('식사'),
                onTap: () async {
                  _showbottomMeal(context);
                },
              ),
              ListTile(
                title: new Text('종류'),
                onTap: () {
                  _showbottomCategory(context);
                },
              ),
              ListTile(
                title: new Text('식재료'),
                onTap: () {
                  _showbottomFood(context);
                },
              ),
            ],
          );
        });
  }

  // bottomSheet 함수 => 2차 메뉴 : 식사
  void _showbottomMeal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (var data in context.watch<Home>().Meal)
                ListTile(
                  title: new Text(data['value']),
                  onTap: () {
                    context.read<Write>().add_list(data['value']);
                    // 2단계 종료
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
            ],
          );
        });
  }

  // bottomSheet 함수 => 2차 메뉴 : 종류
  void _showbottomCategory(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (var data in context.watch<Home>().Type)
                    ListTile(
                      title: new Text(data['value']),
                      onTap: () {
                        context.read<Write>().add_list(data['value']);
                        // 2단계 종료
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
            ],
          );
        });
  }

  // bottomSheet 함수 => 2차 메뉴 : 식재료
  void _showbottomFood(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int i = 0;
                  i < context.watch<Home>().Ingredients_id.length;
                  i++)
                ListTile(
                  title: new Text(context.watch<Home>().Ingredients_id[i]),
                  onTap: () {
                    _showbottomFoodSecondary(i);
                  },
                ),
            ],
          );
        });
  }

  // bottomSheet 함수 => 3차 메뉴 : 식재료
  void _showbottomFoodSecondary(int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView(children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (var key in context.watch<Home>().Ingredients[index].keys)
                  ListTile(
                    title: new Text(key),
                    onTap: () {
                      context.read<Write>().add_list(key);
                      // 3단계 종료
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                _showbottom(context);
              },
              child: Icon(
                Icons.filter_alt,
                color: Colors.purple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// TopBar 기본 class
class TopBar extends StatefulWidget {
  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 7, 0, 7),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                context.read<Write>().select_top(1);
                setState(() {});
              },
              child: Column(
                children: <Widget>[
                  Text(
                    '식사',
                    style: TextStyle(
                        fontSize: 18,
                        color: context.watch<Write>().top_index == 1
                            ? Colors.purple
                            : Colors.grey),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border(
                          bottom: BorderSide(
                              width: context.watch<Write>().top_index == 1
                                  ? 3.0
                                  : 2.0,
                              color: context.watch<Write>().top_index == 1
                                  ? Colors.purple
                                  : Colors.grey)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                context.read<Write>().select_top(2);
                setState(() {});
              },
              child: Column(
                children: <Widget>[
                  Text(
                    '자유 수다방',
                    style: TextStyle(
                        fontSize: 18,
                        color: context.watch<Write>().top_index ==
                                2 // 수정 시 재빌드하기 위해서는 watch를 사용
                            ? Colors.purple
                            : Colors.grey),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border(
                          bottom: BorderSide(
                              width: context.watch<Write>().top_index == 2
                                  ? 3.0
                                  : 2.0,
                              color: context.watch<Write>().top_index == 2
                                  ? Colors.purple
                                  : Colors.grey)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// appbar 지우기
class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}

// 로그인 기본 class
class WritePage extends StatefulWidget {
  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  // @override
  // void dispose() {
  //   Provider.of<Write>(context, listen: false).dispose();
  //   Provider.of<Home>(context, listen: false).dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    // 로그인 상태인지 확인
    print(auth.currentUser);
    if (auth.currentUser != null) {
      print(auth.currentUser!.uid);
    }

    // listener를 추가하여 비동기 변경이 발생했을 때 수정할 수 있도록 changeNotifier를 듣고 있음
    if (mounted) {
      Provider.of<Home>(context, listen: false).addListener(() => setState(() {
            print("리렌더링");
          }));

      // listener를 추가하여 비동기 변경이 발생했을 때 수정할 수 있도록 changeNotifier를 듣고 있음
      Provider.of<Write>(context, listen: false).addListener(() => setState(() {
            print("리렌더링");
          }));
    }
  }

  // bookmark icon 클릭했을 때
  Future<void> _onBookmarkButtonPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScrapPage()),
    );
  }

  // shopping icon 클릭했을 때
  Future<void> _onShoppingButtonPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShoppingPage()),
    );
  }

  // "글쓰기" 클릭했을 때
  Future<dynamic> _writeButtonPressed() async {
    context.read<Write>().writeComplete(context, context.read<Home>().User);
    // alert 창 띄우기
    if (context.read<Write>().AlertTitle != "") {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(context.read<Write>().AlertTitle),
              content: new Text(context.read<Write>().AlertContent),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text("닫기"),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 그리드 뷰 이미지
    List<String> images = [
      "assets/main.jpg",
    ];

    return Scaffold(
      appBar: EmptyAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.black38.withAlpha(10),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "레시피를 검색해보세요.",
                                  hintStyle: TextStyle(
                                    color: Colors.black.withAlpha(120),
                                  ),
                                  border: InputBorder.none,
                                ),
                                onChanged: (String keyword) {},
                              ),
                            ),
                            Icon(
                              Icons.search,
                              color: Colors.black.withAlpha(120),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // 메인 상단 메뉴
            TopBar(),
            // 본문 내용
            if (context.watch<Write>().ImageUrl.length > 0)
              Container(
                height: 350,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  itemCount: context.watch<Write>().ImageUrl.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, int index) {
                    for (var url in context.watch<Write>().ImageUrl)
                      return Container(
                        padding: EdgeInsets.all(5.0),
                        child: Image.network(
                          url,
                          width: 350,
                          height: 350,
                        ),
                      );
                    return Container();
                  },
                ),
              ),
            if (context.watch<Write>().ImageUrl.length > 0 ||
                context.read<Write>().top_index == 2)
              Container(
                child: Text("이미지 추가하기"),
              ),
            Container(
              height: context.watch<Write>().ImageUrl.length > 0 ||
                      context.read<Write>().top_index == 2
                  ? 100
                  : 350,
              child: GridView.builder(
                padding: EdgeInsets.all(5.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 12.0,
                ),
                itemCount: context.watch<Write>().ImageUrl.length > 0 ? 16 : 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, int index) {
                  return GestureDetector(
                    onTap: () {
                      context.read<Write>().getGalleryImage(index).then((_) {
                        setState(() {});
                      });
                    },
                    child: Container(
                      color: Colors.grey[300],
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: Icon(Icons.add),
                      ),
                    ),
                  );
                },
              ),
            ),
            // 필터 선택 tagbox
            Container(
              child: TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: context.read<Write>().top_index == 1
                      ? '사진에 대해 설명해주세요.'
                      : '내용을 작성해주세요.',
                ),
                onChanged: (text) {
                  // watch가 아니라 read를 호출해야함 => read == listen : false => 이벤트 함수는 업데이트 변경 사항을 수신하지 않고 변경 작업을 수행해야함.
                  context.read<Write>().setContent(text);
                },
              ),
            ),
            Filter(),

            Container(
              child: Text(
                '필터를 선택해주세요.',
              ),
            ),

            // 필터 선택 tagbox
            SelectedFilter(),
            Container(
              width: 300,
              child: TextButton(
                onPressed: _writeButtonPressed,
                style: TextButton.styleFrom(
                    primary: Colors.purple,
                    backgroundColor: Colors.purple,
                    side: BorderSide(color: Colors.purple, width: 2)),
                child: Text(
                  "글쓰기",
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (index) => {
                // 홈
                if (index == 0)
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    ),
                  },

                // 스크랩
                if (index == 1)
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WritePage()),
                    ),
                  },

                // 스크랩
                if (index == 2)
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScrapPage()),
                    ),
                  },

                // 마이페이지
                if (auth.currentUser != null && index == 3)
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyPage()),
                    ),
                  },
              },
          currentIndex: 0,
          items: [
            new BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('홈'),
            ),
            if (auth.currentUser != null)
              new BottomNavigationBarItem(
                icon: Icon(Icons.add),
                title: Text('글쓰기'),
              ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              title: Text('스크랩'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('마이페이지'),
            )
          ]),
    );
  }
}

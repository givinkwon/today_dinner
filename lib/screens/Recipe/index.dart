import 'package:flutter/material.dart';
import 'package:today_dinner/screens/Product/index.dart';

// provider => watch는 값이 변화할 때 리렌더링, read는 값이 변화해도 렌더링 x
// => watch는 값을 보여주는 UI에 read는 변경이 필요없는 함수에 주로 사용
import 'package:today_dinner/providers/home.dart';
import 'package:today_dinner/providers/write.dart';
import 'package:today_dinner/providers/recipe.dart';

// firestorage.List feed_image = firestorage.ref('20210917_164240.jpg');
// var url = firestorage.ref('20210917_164240.jpg').getDownloadURL();

// firebase auth
import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';
// provider listener 이용
import 'package:flutter/foundation.dart';

FirebaseAuth auth = FirebaseAuth.instance;

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
class RecipePage extends StatefulWidget {
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  // @override
  // void dispose() {
  //   Provider.of<Write>(context, listen: false).dispose();
  //   Provider.of<Home>(context, listen: false).dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    // 로그인 상태인지 확인
    // print(auth.currentUser);
    if (auth.currentUser != null) {
      // print(auth.currentUser!.uid);
    }

    // listener를 추가하여 비동기 변경이 발생했을 때 수정할 수 있도록 changeNotifier를 듣고 있음
    Provider.of<Home>(context, listen: false).addListener(() => setState(() {
          print("리렌더링");
        }));

    // listener를 추가하여 비동기 변경이 발생했을 때 수정할 수 있도록 changeNotifier를 듣고 있음
    Provider.of<Write>(context, listen: false).addListener(() => setState(() {
          print("리렌더링");
        }));
    // listener를 추가하여 비동기 변경이 발생했을 때 수정할 수 있도록 changeNotifier를 듣고 있음
    Provider.of<Recipe>(context, listen: false).addListener(() => setState(() {
          print("리렌더링");
        }));
  }

  @override
  Widget build(BuildContext context) {
    // 그리드 뷰 이미지
    List<String> images = [
      "assets/main.jpg",
    ];

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(context.read<Recipe>().Selected_data['user'])),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              if (context.read<Recipe>().Selected_data['mainimage'] !=
                  null) // null일 때 예외 처리
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Image.network(
                    context.read<Recipe>().Selected_data['mainimage'],
                    fit: BoxFit.cover,
                  ),
                ),
              // 제품 제목
              Container(
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text: context.read<Recipe>().Selected_data['title'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // 제품 태그
              Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(
                      Radius.circular(10.0) //         <--- border radius here
                      ),
                ),
                child: Column(children: [
                  // 난이도
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text:
                          "난이도 : ${context.read<Recipe>().Selected_data['difficulty']}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  // 소요시간
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text:
                          "소요시간 : ${context.read<Recipe>().Selected_data['spendtime']}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  // 인분
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text:
                          "인분 : ${context.read<Recipe>().Selected_data['serving']}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ]),
              ),

              // 재료 소개 => 기본재료
              Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(
                      Radius.circular(10.0) //         <--- border radius here
                      ),
                ),
                child: Column(children: [
                  // 제목
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text:
                          "기본재료 : ${context.read<Recipe>().Selected_data['serving']}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),

                  // 내용
                  for (var primary_data
                      in context.read<Recipe>().Selected_data['primary'])
                    ListTile(
                      title: new Text(primary_data['title']),
                      onTap: () async {},
                      trailing: new Text(primary_data['content']),
                    ),
                ]),
              ),

              // 재료 소개 => 서브재료
              Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(
                      Radius.circular(10.0) //         <--- border radius here
                      ),
                ),
                child: Column(children: [
                  // 제목
                  RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text:
                          "양념소스재료 : ${context.read<Recipe>().Selected_data['serving']}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),

                  // 내용
                  for (var primary_data
                      in context.read<Recipe>().Selected_data['secondary'])
                    ListTile(
                      title: new Text(primary_data['title']),
                      onTap: () async {},
                      trailing: new Text(primary_data['content']),
                    ),
                ]),
              ),

              // 본문 이미지 && 글
              for (var primary_data
                  in context.read<Recipe>().Selected_data['content'])
                Column(children: [
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    height: 250,
                    child: Image(
                      image: NetworkImage(primary_data['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        text: primary_data['content'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ]),

              // 상세 하단 경게선
              Container(child: Divider(color: Colors.grey, thickness: 2.0)),

              // 상세 하단 메뉴 1
              Container(
                margin: EdgeInsets.all(5.0),
                child: Text("남은 식재료 활용 밑반찬"),
              ),
              Container(
                height: 120.0,
                child: GridView.builder(
                  padding: EdgeInsets.all(5.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 12.0,
                  ),
                  itemCount: 16,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, int index) {
                    return GestureDetector(
                      onTap: () {
                        // 제품 상세 페이지로 이동하기
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RecipePage()),
                        );
                      },
                      child: Container(
                        color: Colors.grey[300],
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text("GridView $index"),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 상세 하단 메뉴 2
              Container(
                margin: EdgeInsets.all(5.0),
                child: Text("후기 좋은 밀키트 모음 ♥"),
              ),
              Container(
                height: 120.0,
                child: GridView.builder(
                  padding: EdgeInsets.all(5.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 12.0,
                  ),
                  itemCount: 16,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, int index) {
                    return GestureDetector(
                      onTap: () {
                        // 제품 상세 페이지로 이동하기
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductPage()),
                        );
                      },
                      child: Container(
                        color: Colors.grey[300],
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text("GridView $index"),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: Row(
          children: <Widget>[
            // 네비게이션바 메뉴 1
            Expanded(
              flex: 1,
              child: Align(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Icon(
                      Icons.bookmark,
                      color: Colors.grey,
                      size: 24.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                  ),
                ),
              ),
            ),
            // 네비게이션바 메뉴 2
            Expanded(
              flex: 1,
              child: Align(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Icon(
                      Icons.mediation,
                      color: Colors.grey,
                      size: 24.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                  ),
                ),
              ),
            ),
            // 간편식 모아보기 버튼
            Expanded(
              flex: 2,
              child: Align(
                child: Container(
                  color: Colors.grey,
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: "간편식 모아보기",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

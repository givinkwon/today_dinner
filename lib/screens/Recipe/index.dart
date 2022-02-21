import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:today_dinner/main.dart';
// provider listener 이용
import 'package:today_dinner/providers/Recipe.dart';
import 'package:today_dinner/screens/Recipe/detail.dart';
import 'package:today_dinner/utils/BottomNavigationBar.dart';
import 'package:today_dinner/utils/Loading.dart';
import 'package:today_dinner/utils/NoResult.dart';

// 검색 text controller
var SearchController = TextEditingController();

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreen createState() => _RecipeScreen();
}

class _RecipeScreen extends State<RecipeScreen> {
// 현재 pixel 확인
  ScrollController _scrollController = new ScrollController();

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(seconds: 3), curve: Curves.linear);
  }

  @override
  void initState() {
    super.initState();

    // 컨트롤러 전달
    context.read<RecipeViewModel>().SetController(_scrollController);

    //  데이터 가져오기
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context
            .read<RecipeViewModel>()
            .add_data(Search: context.read<RecipeViewModel>().search_text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<RecipeViewModel>().data_loading == true) {
      return Scaffold(
        resizeToAvoidBottomInset: false, // 공사장 해결
        appBar: AppBar(
          bottomOpacity: 0.0,
          elevation: 0.0,
          backgroundColor: Colors.white,
          toolbarHeight: 0,
        ),
        body: Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          color: Color.fromRGBO(255, 255, 255, 1),
          child: Column(
            children: <Widget>[
              // 검색창
              Search(),
              // 필터
              Filter(context),
              // 경계선
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        width: 1, color: Color.fromRGBO(221, 227, 233, 1)),
                  ),
                ),
              ),
              // 레시피
              Expanded(
                child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    itemCount: context.read<RecipeViewModel>().Data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Recipe(index);
                    }),
              ),
              // 데이터 없을 때
              if (context.watch<RecipeViewModel>().Data.length == 0)
                NoResult(context),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(),
      );
    } else {
      return Loading(context);
    }
  }
}

// 검색창
class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 4,
        left: MediaQuery.of(context).size.width * 0.044,
        right: MediaQuery.of(context).size.width * 0.044,
        bottom: 20,
      ),
      width: MediaQuery.of(context).size.width,
      height: 40,
      decoration: BoxDecoration(
        color: Color.fromRGBO(241, 244, 246, 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "레시피를 검색해보세요.",
                hintStyle: TextStyle(
                  color: Color.fromRGBO(129, 128, 128, 1),
                ),
                border: InputBorder.none,
              ),
              controller: SearchController,
              style: TextStyle(fontSize: 16),
              onChanged: (text) {
                context.read<RecipeViewModel>().search_text = text;
              },
              onSubmitted: (value) {
                // Enter 누르기
                context.read<RecipeViewModel>().Search();
              },
              textInputAction: TextInputAction.search,
            ),
          ),
        ),
        // 검색 버튼
        GestureDetector(
          onTap: () async {
            context.read<RecipeViewModel>().Search();
          },
          child: Container(
              margin: EdgeInsets.only(right: 12),
              child: Icon(Icons.search, color: Colors.black)),
        ),
      ]),
    );
  }
}

// 필터
Widget Filter(BuildContext context) {
  var Filter = {
    "전체": 'all',
    "아이 반찬": 'child',
    "밑반찬": 'side_dish',
    "메인요리": 'main_dish',
    "간단 국": 'soup',
    "간단 한끼": 'meal',
    "냉털": 'inventory',
    "간식": 'snack'
  };

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Container(
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.044, bottom: 17),
      child: Row(
        children: [
          for (String key in Filter.keys)
            GestureDetector(
              onTap: () async {
                SearchController.text = "";
                await context.read<RecipeViewModel>().SelectFilter(key);
              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child:
                        // 필터 이미지
                        Image.asset(
                      'assets/recipe/${Filter[key]}.jpg',
                      width: 100,
                      height: 64,
                    ),
                  ),
                  // 필터 텍스트
                  Positioned(
                    bottom: 0,
                    child: Container(
                        alignment: Alignment.center,
                        width: 92,
                        height: 22,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(36, 39, 43, 0.7),
                        ),
                        margin: EdgeInsets.only(left: 4, right: 4, bottom: 5),
                        child: Text(
                          key,
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        )),
                  ),
                ]),
              ),
            ),
        ],
      ),
    ),
  );
}

class Recipe extends StatefulWidget {
  final int index;
  Recipe(this.index);

  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  var BookMark = false;

  _CheckBookmark() {
    // 북마크가 있으면
    if (context.read<RecipeViewModel>().Data[widget.index]['bookmark'] !=
            null &&
        context
            .read<RecipeViewModel>()
            .Data[widget.index]['bookmark']
            .contains(auth.currentUser?.email)) {
      BookMark = true;
    } else {
      BookMark = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 북마크 체크하기
    _CheckBookmark();
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Container(
          height: 20,
        ),
        Stack(
          children: [
            GestureDetector(
              onTap: () async {
                // gtag
                await analytics.logEvent(
                    name: 'click_recipe_detail',
                    parameters: {
                      'recipe_name': context
                          .read<RecipeViewModel>()
                          .Data[widget.index]['title']
                    });

                // 데이터 전달하기
                context.read<RecipeViewModel>().SelectRecipe(
                    context.read<RecipeViewModel>().Data[widget.index]);

                // 페이지 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecipeDetailScreen()),
                );
              },
              child: Container(
                height: 160,
                margin: EdgeInsets.only(left: 15, right: 15),
                width: MediaQuery.of(context).size.width - 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage(
                    imageErrorBuilder: (context, exception, stackTrace) {
                      return Container(
                        width: 100.0,
                        height: 100.0,
                        child: Image.asset('assets/loading.gif'),
                      );
                    },
                    image: NetworkImage(
                      context
                                  .read<RecipeViewModel>()
                                  .Data[widget.index]['videourl']
                                  .split("=")
                                  .length ==
                              2
                          ? "https://img.youtube.com/vi/${context.read<RecipeViewModel>().Data[widget.index]['videourl'].split("=")[1]}/0.jpg"
                          : "https://img.youtube.com/vi/tg7w12Eyzbk/0.jpg",
                    ),
                    placeholder: AssetImage("assets/loading.gif"),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            if (auth.currentUser != null)
              Positioned(
                top: MediaQuery.of(context).size.height * 0.14,
                left: MediaQuery.of(context).size.width - 100,
                right: 0,
                child: IconButton(
                  icon: BookMark
                      ? Icon(Icons.bookmark, color: Colors.white, size: 32)
                      : Icon(Icons.bookmark_outline,
                          color: Colors.white, size: 32),
                  onPressed: () {
                    context.read<RecipeViewModel>().ClickBookmark(
                        context.read<RecipeViewModel>().Data[widget.index],
                        widget.index);
                  },
                ),
              ),

            // 레시피 조리 시간
            Positioned(
              top: 16,
              right: 32,
              child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 102, 53, 1),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  height: 24,
                  width: MediaQuery.of(context).size.width * 0.23,
                  padding:
                      EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                  child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 3.3),
                            child: Icon(
                              Icons.watch_later_outlined,
                              size: 13.3,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            context.read<RecipeViewModel>().Data[widget.index]
                                ['spendtime'],
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                  )),
            ),
          ],
        ),

        // 제목
        Container(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Text(
            context.read<RecipeViewModel>().Data[widget.index]['title'],
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(40, 40, 40, 1),
                fontWeight: FontWeight.bold),
          ),
        ),
      ]),
    );
  }
}

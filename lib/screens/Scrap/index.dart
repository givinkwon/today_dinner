import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:today_dinner/main.dart';
// provider listener 이용
import 'package:today_dinner/providers/Recipe.dart';
import 'package:today_dinner/providers/Scrap.dart';
import 'package:today_dinner/screens/Recipe/detail.dart';
import 'package:today_dinner/utils/BottomNavigationBar.dart';
import 'package:today_dinner/utils/Loading.dart';
import 'package:today_dinner/utils/NoScrap.dart';

class ScrapScreen extends StatefulWidget {
  const ScrapScreen({Key? key}) : super(key: key);
  @override
  _ScrapScreen createState() => _ScrapScreen();
}

class _ScrapScreen extends State<ScrapScreen> {
  // 현재 pixel 확인
  ScrollController _scrollController = new ScrollController();

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(seconds: 3), curve: Curves.linear);
  }

  @override
  void initState() {
    // 스크랩 데이터로 초기화

    context.read<ScrapViewModel>().load_data();

    //  데이터 가져오기
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<ScrapViewModel>().add_data();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<ScrapViewModel>().data_loading == true) {
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
              Expanded(
                child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    itemCount: context.read<ScrapViewModel>().Data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Recipe(index);
                    }),
              ),
              // 데이터 없을 때
              if (context.watch<ScrapViewModel>().Data.length == 0)
                NoScrap(context),
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
    if (context.read<ScrapViewModel>().Data[widget.index]['bookmark'] != null &&
        context
            .read<ScrapViewModel>()
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
                await analytics
                    .logEvent(name: 'click_recipe_detail', parameters: {
                  'recipe_name':
                      context.read<ScrapViewModel>().Data[widget.index]['title']
                });

                // 데이터 전달하기
                context.read<RecipeViewModel>().SelectRecipe(
                    context.read<ScrapViewModel>().Data[widget.index]);

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
                                  .read<ScrapViewModel>()
                                  .Data[widget.index]['videourl']
                                  .split("=")
                                  .length ==
                              2
                          ? "https://img.youtube.com/vi/${context.read<ScrapViewModel>().Data[widget.index]['videourl'].split("=")[1]}/0.jpg"
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
                    context.read<ScrapViewModel>().ClickBookmark(
                        context.read<ScrapViewModel>().Data[widget.index],
                        widget.index);
                  },
                ),
              ),
          ],
        ),

        // 제목
        Container(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Text(
            context.read<ScrapViewModel>().Data[widget.index]['title'],
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

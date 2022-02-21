import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:today_dinner/main.dart';
import 'package:today_dinner/providers/Recipe.dart';
import 'package:today_dinner/providers/Video.dart';
import 'package:today_dinner/screens/Login/index.dart';
import 'package:today_dinner/screens/Mypage/index.dart';
import 'package:today_dinner/screens/Recipe/index.dart';
import 'package:today_dinner/screens/Scrap/index.dart';
import 'package:today_dinner/screens/Video/index.dart';

var nav_index = 0;

class BottomNavBar extends StatelessWidget {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: context.watch<VideoViewModel>().bottom_index,
        backgroundColor: context.read<VideoViewModel>().bottom_index == 2
            ? Colors.black.withOpacity(0.1)
            : Colors.white,
        elevation: 0,
        selectedItemColor: Color.fromRGBO(201, 92, 57, 1),
        unselectedItemColor: context.read<VideoViewModel>().bottom_index == 2
            ? Colors.white
            : Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => {
              context.read<VideoViewModel>().bottom_index = index,
              // 비디오 정지
              context.read<VideoViewModel>().controller.pause(),
              // 레시피
              if (index == 0)
                {
                  // 데이터 로딩
                  context.read<RecipeViewModel>().load_data(),
                  // 페이지 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecipeScreen()),
                  ),
                },

              // 레시피
              if (index == 1)
                {
                  if (auth.currentUser != null)
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ScrapScreen()),
                      ),
                    }
                  else
                    {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text("로그인"),
                              content: new Text("로그인이 필요합니다."),
                              actions: <Widget>[
                                new FlatButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LoginIndexScreen()),
                                    );
                                  },
                                  child: new Text("로그인 페이지로 이동"),
                                ),
                              ],
                            );
                          }),
                    }
                },

              // 스크랩
              if (index == 2)
                {
                  context.read<VideoViewModel>().play_video(),
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => VideoScreen()),
                  ),
                },

              // 마이페이지
              if (index == 3)
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyPage()),
                  ),
                },
            },
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: '스크랩',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: '오늘 뭐먹지?',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이페이지',
          )
        ]);
  }
}

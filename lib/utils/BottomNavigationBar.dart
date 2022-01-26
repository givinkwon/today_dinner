import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:today_dinner/providers/Video.dart';
import 'package:today_dinner/screens/Mypage/index.dart';
import 'package:today_dinner/screens/Recipe/index.dart';
import 'package:today_dinner/screens/Scrap/index.dart';
import 'package:today_dinner/screens/Video/index.dart';

var nav_index = 0;

Widget bottomNavigation(BuildContext context) {
  return BottomNavigationBar(
      currentIndex: nav_index,
      backgroundColor:
          nav_index == 0 ? Colors.black.withOpacity(0.1) : Colors.white,
      elevation: 0,
      selectedItemColor: Color.fromRGBO(201, 92, 57, 1),
      unselectedItemColor: nav_index == 0 ? Colors.white : Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => {
            // 인덱스 값 저장
            nav_index = index,
            // 비디오 정지
            context.read<VideoViewModel>().controller.pause(),
            // 레시피
            if (index == 0)
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VideoScreen()),
                ),
              },

            // 레시피
            if (index == 1)
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecipeScreen()),
                ),
              },

            // 스크랩
            if (index == 2)
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScrapScreen()),
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
          title: Text('홈'),
        ),
        new BottomNavigationBarItem(
          icon: Icon(Icons.food_bank),
          title: Text('레시피'),
        ),
        new BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          title: Text('스크랩'),
        ),
        new BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('마이페이지'),
        )
      ]);
}

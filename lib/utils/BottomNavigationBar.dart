import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:today_dinner/providers/Video.dart';
import 'package:today_dinner/screens/Recipe/index.dart';
import 'package:today_dinner/screens/Video/index.dart';

class bottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        elevation: 0,
        selectedItemColor: Color.fromRGBO(201, 92, 57, 1),
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => {
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
              if (index == 2) {},

              // 마이페이지
              if (index == 3)
                {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => MyPage()),
                  // ),
                },
            },
        currentIndex: 0,
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
}

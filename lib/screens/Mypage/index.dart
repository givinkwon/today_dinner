import 'package:flutter/material.dart';
import 'package:today_dinner/main.dart';
import 'package:today_dinner/screens/Scrap/index.dart';
import 'package:today_dinner/utils/BottomNavigationBar.dart';
import 'package:url_launcher/url_launcher.dart';

// 로그인 기본 class
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromRGBO(40, 40, 40, 1), //색변경
        ),
        backgroundColor: Colors.white,
        title: Text(
          "마이페이지",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(40, 40, 40, 1)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromRGBO(255, 255, 255, 1),
          height: 800,
          child: ListView(
            children: <Widget>[
              if (auth.currentUser != null)
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScrapScreen(),
                      ),
                    );
                  },
                  leading: Icon(Icons.bookmark),
                  title: Text('스크랩한 글'),
                ),
              if (auth.currentUser != null)
                ListTile(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => AccountPage(),
                    //   ),
                    // );
                  },
                  leading: Icon(Icons.people),
                  title: Text('계정 설정'),
                ),
              if (auth.currentUser != null)
                ListTile(
                  onTap: () {
                    auth.signOut();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => HomePage(),
                    //   ),
                    // );
                  },
                  leading: Icon(Icons.exit_to_app),
                  title: Text('로그아웃'),
                ),
              if (auth.currentUser == null)
                ListTile(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => LoginIndexPage(),
                    //   ),
                    // );
                  },
                  leading: Icon(Icons.login),
                  title: Text('로그인'),
                ),
              if (auth.currentUser == null)
                ListTile(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => SignupPage(),
                    //   ),
                    // );
                  },
                  leading: Icon(Icons.people),
                  title: Text('회원가입'),
                ),
              ListTile(
                onTap: () {
                  launch('https://forms.gle/EQuQTbkH64W93JHF7');
                },
                leading: Icon(Icons.dvr),
                title: Text('피드백 남기기'),
              ),
              // if (context.watch<Profile>().Marketing == true &&
              //     auth.currentUser != null)
              //   ListTile(
              //     onTap: () {
              //       context.read<Profile>().changeMarketing(
              //           context,
              //           auth.currentUser?.email,
              //           context.read<Profile>().Marketing);
              //     },
              //     leading: Icon(Icons.search),
              //     title: Text('혜택/정보 수신 동의 해제'),
              //   ),
              // if (context.watch<Profile>().Marketing == false &&
              //     auth.currentUser != null)
              //   ListTile(
              //     onTap: () {
              //       context.read<Profile>().changeMarketing(
              //           context,
              //           auth.currentUser?.email,
              //           context.read<Profile>().Marketing);
              //     },
              //     leading: Icon(Icons.search),
              //     title: Text('혜택/정보 수신 동의'),
              //   ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigation(context),
    );
  }
}

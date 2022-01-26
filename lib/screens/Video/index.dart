import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:today_dinner/providers/Video.dart';
import 'package:today_dinner/utils/BottomNavigationBar.dart';
import 'package:today_dinner/utils/Loading.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (context.watch<VideoViewModel>().data_loading == true) {
      return Scaffold(
          appBar: AppBar(
            bottomOpacity: 0.0,
            elevation: 0.0,
            backgroundColor: Color.fromRGBO(251, 246, 240, 1),
            toolbarHeight: 0,
          ),
          body: Stack(children: [
            PageView.builder(
              controller: PageController(
                initialPage: 0,
                viewportFraction: 1, // 화면 전체를 가림
              ),
              itemCount: context.read<VideoViewModel>().Video_length,
              onPageChanged: (index) {
                index = index % (context.read<VideoViewModel>().Video_length);
                context.read<VideoViewModel>().changeVideo(index);
              },
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return videoCard();
              },
            ),
            // 검색
            Positioned(
              top: 20,
              right: 20,
              child: Icon(Icons.search, size: 36.0, color: Colors.white),
            ),

            // 스크랩 추가
            Positioned(
              bottom: 200,
              right: 20,
              child: Icon(Icons.bookmark_add_outlined,
                  size: 36.0, color: Colors.white),
            ),
            Positioned(
              bottom: 180,
              right: 25,
              child: Text(
                "스크랩",
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            // 스크랩 추가
            Positioned(
              bottom: 120,
              right: 20,
              child: Icon(Icons.shortcut_outlined,
                  size: 36.0, color: Colors.white),
            ),
            Positioned(
              bottom: 100,
              right: 17,
              child: Text(
                "레시피보기",
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ]),
          bottomNavigationBar: bottomNavigation(context),
          extendBody: true);
    } else {
      return Loading(context);
    }
  }
}

class videoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (context.watch<VideoViewModel>().change_loading == true) {
      return Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (context.read<VideoViewModel>().controller.value.isPlaying) {
                context.read<VideoViewModel>().controller.pause();
              } else {
                context.read<VideoViewModel>().controller.play();
              }
            },
            child: SizedBox.expand(
                child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: context
                        .read<VideoViewModel>()
                        .controller
                        .value
                        .size
                        .width ??
                    0,
                height: context
                        .read<VideoViewModel>()
                        .controller
                        .value
                        .size
                        .height ??
                    0,
                child: VideoPlayer(context.read<VideoViewModel>().controller),
              ),
            )),
          )
        ],
      );
    } else {
      return Container(
          color: Color.fromRGBO(255, 255, 255, 1),
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            'assets/loading.gif',
          ));
    }
  }
}

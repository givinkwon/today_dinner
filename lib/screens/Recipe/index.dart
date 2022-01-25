import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// provider listener 이용
import 'package:today_dinner/providers/Recipe.dart';
import 'package:today_dinner/utils/BottomNavigationBar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Recipe extends StatefulWidget {
  final int index;
  Recipe(this.index);

  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// youtube video
class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'iLnmTe5Q2Qw',
      flags: const YoutubePlayerFlags(
        mute: true,
        autoPlay: true,
        disableDragSeek: true,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(children: [
        YoutubePlayer(
          key: ObjectKey(_controller),
          controller: _controller,
          actionsPadding: const EdgeInsets.only(left: 16.0),
          bottomActions: [
            CurrentPosition(),
            const SizedBox(width: 10.0),
            ProgressBar(isExpanded: true),
            const SizedBox(width: 10.0),
            RemainingDuration(),
            //FullScreenButton(),
          ],
        ),
        TextButton(
          onPressed: () {
            _controller.seekTo(Duration(seconds: 50));
          },
          style: TextButton.styleFrom(
              primary: Color.fromRGBO(201, 92, 57, 1),
              backgroundColor: Colors.white,
              side:
                  BorderSide(color: Color.fromRGBO(201, 92, 57, 1), width: 2)),
          child: Text(
            "이동하기",
            style:
                TextStyle(fontSize: 12, color: Color.fromRGBO(201, 92, 57, 1)),
          ),
        ),
      ]),
    );
  }
}

// 로그인 기본 class
class RecipeScreen extends StatelessWidget {
  // 현재 pixel 확인
  ScrollController _scrollController = new ScrollController();

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(seconds: 3), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: Colors.white,
        toolbarHeight: 0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                itemCount: context.watch<RecipeViewmodel>().Data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Recipe(index);
                }),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigation(),
    );
  }
}

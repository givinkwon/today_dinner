import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:today_dinner/main.dart';
import 'package:today_dinner/providers/Recipe.dart';
import 'package:provider/provider.dart';

import 'package:today_dinner/utils/BottomNavigationBar.dart';

// youtube
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// 로그인 기본 class
class RecipeDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    if (currentOrientation == Orientation.portrait) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Color.fromRGBO(40, 40, 40, 1), //색변경
          ),
          backgroundColor: Colors.white,
          title: Text(
            context.read<RecipeViewModel>().recipe_data['title'],
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(40, 40, 40, 1)),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(children: <Widget>[
              Player(context.read<RecipeViewModel>().recipe_data),

              // 제품 태그
              ListTile(
                //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
                title:
                    Text('음식정보', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        width: 1, color: Color.fromRGBO(40, 40, 40, 1)),
                  ),
                ),
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Column(children: [
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 1, color: Colors.grey.shade300),
                      ),
                    ),
                    child: ListTile(
                      dense: true,
                      visualDensity: VisualDensity(vertical: -4),
                      //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
                      title: Text('난이도',
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          )),
                      trailing: Text(
                        context
                            .read<RecipeViewModel>()
                            .recipe_data['difficulty'],
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 1, color: Colors.grey.shade300),
                      ),
                    ),
                    child: ListTile(
                      dense: true,
                      visualDensity: VisualDensity(vertical: -4),
                      //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
                      title: Text('소요시간',
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          )),
                      trailing: Text(
                        context
                            .read<RecipeViewModel>()
                            .recipe_data['spendtime'],
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 1, color: Colors.grey.shade300),
                      ),
                    ),
                    child: ListTile(
                      dense: true,
                      visualDensity: VisualDensity(vertical: -4),
                      //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
                      title: Text('인분',
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          )),
                      trailing: Text(
                        context.read<RecipeViewModel>().recipe_data['serving'],
                        style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),

              // 제품 태그
              ListTile(
                //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
                title: Text('기본 재료',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        width: 1, color: Color.fromRGBO(40, 40, 40, 1)),
                  ),
                ),
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Column(children: [
                  // 내용
                  for (var key in context
                      .read<RecipeViewModel>()
                      .recipe_data['primary']
                      .keys)
                    Container(
                      height: 30,
                      constraints: BoxConstraints(maxHeight: 150),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(width: 1, color: Colors.grey.shade300),
                        ),
                      ),
                      child: ListTile(
                          dense: true,
                          visualDensity: VisualDensity(vertical: -4),
                          minLeadingWidth: 200,
                          leading: Text(key,
                              style: TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                              )),
                          onTap: () async {},
                          trailing: Container(
                            width: MediaQuery.of(context).size.width - 200,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  context
                                      .read<RecipeViewModel>()
                                      .recipe_data['primary'][key],
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          )),
                    ),
                ]),
              ),

              if (context.read<RecipeViewModel>().recipe_data['secondary'] !=
                      null &&
                  (context.read<RecipeViewModel>().recipe_data['secondary']
                              as Map<String, dynamic>)
                          .length >
                      0)
                ListTile(
                  //leading. 타일 앞에 표시되는 위젯. 참고로 타일 뒤에는 trailing 위젯으로 사용 가능
                  title: Text('양념/소스 재료',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              if (context.read<RecipeViewModel>().recipe_data['secondary'] !=
                      null &&
                  (context.read<RecipeViewModel>().recipe_data['secondary']
                              as Map<String, dynamic>)
                          .length >
                      0)
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          width: 1, color: Color.fromRGBO(40, 40, 40, 1)),
                    ),
                  ),
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Column(children: [
                    // 내용
                    for (var key in context
                        .read<RecipeViewModel>()
                        .recipe_data['secondary']
                        .keys)
                      Container(
                        constraints:
                            BoxConstraints(minHeight: 30, maxHeight: 150),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                width: 1, color: Colors.grey.shade300),
                          ),
                        ),
                        child: ListTile(
                            dense: true,
                            visualDensity: VisualDensity(vertical: -4),
                            minLeadingWidth: 200,
                            leading: Text(key,
                                style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                )),
                            onTap: () async {},
                            trailing: Container(
                              width: MediaQuery.of(context).size.width - 200,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    context
                                        .read<RecipeViewModel>()
                                        .recipe_data['secondary'][key],
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            )),
                      ),
                  ]),
                ),
            ]),
          ),
        ),
        bottomNavigationBar: BottomNavBar(),
      );
    } else {
      return Scaffold(
        appBar: null,
        body: SingleChildScrollView(
          child: Container(
            child: Column(children: <Widget>[
              Container(
                child: Column(children: <Widget>[
                  Player(context.read<RecipeViewModel>().recipe_data),
                ]),
              ),
            ]),
          ),
        ),
      );
    }
  }
}

// youtube video
class Player extends StatefulWidget {
  var data;

  Player(this.data);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late YoutubePlayerController _controller;
  var videoId;
  @override
  void initState() {
    super.initState();
    videoId = YoutubePlayer.convertUrlToId("${widget.data['videourl']}");
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? "zkKqPiSYMAc",
      flags: const YoutubePlayerFlags(
        mute: false,
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
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: currentOrientation == Orientation.portrait
            ? 340
            : MediaQuery.of(context).size.width,
        width: currentOrientation == Orientation.portrait
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width - 100,
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
              PlaybackSpeedButton(),
              FullScreenButton(),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var key in widget.data?['tag'].keys)
                    Container(
                        margin: EdgeInsets.only(left: 10, top: 5),
                        child: TextButton(
                          onPressed: () async {
                            // gtag
                            await analytics
                                .logEvent(name: 'click_timelink', parameters: {
                              'recipe_name': widget.data['title'],
                              'recipe_tag_name': key,
                            });

                            // 동영상 초 이동
                            _controller.seekTo(Duration(
                                seconds: int.parse(widget.data?['tag'][key])));
                          },
                          style: TextButton.styleFrom(
                              primary: Color.fromRGBO(201, 92, 57, 1),
                              backgroundColor: Colors.white,
                              side: BorderSide(
                                  color: Color.fromRGBO(201, 92, 57, 1),
                                  width: 2)),
                          child: Text(
                            key,
                            style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(201, 92, 57, 1)),
                          ),
                        )),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

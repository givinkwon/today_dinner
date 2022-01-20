import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:today_dinner/providers/Video.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (context.watch<VideoViewModel>().Video_length != 0) {
      return Stack(
        children: [
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
              index = index % (context.read<VideoViewModel>().Video_length);
              return videoCard(context);
            },
          ),
        ],
      );
    } else {
      return Container(
          color: Color.fromRGBO(255, 255, 255, 1),
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            'assets/loading.png',
          ));
    }
  }

  Widget videoCard(BuildContext context) {
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
              width:
                  context.read<VideoViewModel>().controller.value.size.width ??
                      0,
              height:
                  context.read<VideoViewModel>().controller.value.size.height ??
                      0,
              child: VideoPlayer(context.read<VideoViewModel>().controller),
            ),
          )),
        )
      ],
    );
  }
}

// provider listener 이용 => ChangeNotifier import => listener에게 setState()와 동일하게 신호를 보내 rebuild하도록 함
import 'package:flutter/foundation.dart';

import 'package:today_dinner/providers/repo/Video.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel with ChangeNotifier {
  late final VideoRepo _VideoRepo; // video Reopsitory
  late final VideoPlayerController _controller; // video 컨트롤러
  get video_controller => _controller;

  int index = 0; // 현재 video index
  int Video_length = 0; // 현재 video_list length

  // 생성자
  VideoViewModel() {
    // repo instance
    _VideoRepo = VideoRepo();
    // video 호출
    load_data();
  }

  // video 호출
  Future<void> load_data() async {
    await _VideoRepo.get_data();
    Video_length = _VideoRepo.Data.length; // 가져온 비디오 리스트의 길이
    set_data(index);
  }

  // video 설정
  Future<void> set_data(index) async {
    var index_url = _VideoRepo.Data[index]['url']; // 현재 index의 영상 url
    // 현재 index의 영상 url build
    _controller = VideoPlayerController.network(index_url);
    await _controller.initialize(); // 컨트롤러 초기화
    _controller.setLooping(true); // 반복 재생

    // video 재생
    play_video();
  }

  // video 재생
  Future<void> play_video() async {
    if (_VideoRepo.Data.length > index) {
      _controller.play();
      notifyListeners();
    }
  }

  // 화면 드래그 시에 호출
  void changeVideo(index) async {
    set_data(index);
  }
}

// provider listener 이용 => ChangeNotifier import => listener에게 setState()와 동일하게 신호를 보내 rebuild하도록 함
import 'package:flutter/foundation.dart';

import 'package:today_dinner/repo/Video.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel with ChangeNotifier {
  late var _VideoRepo = VideoRepo();
  var controller = null; // video 컨트롤러

  int index = 0; // 현재 video index
  int Video_length = 0; // 현재 video_list length

  // 생성자
  VideoViewModel() {
    _VideoRepo = VideoRepo();
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
    controller = VideoPlayerController.network(
        "https://firebasestorage.googleapis.com/v0/b/today-dinner-10161.appspot.com/o/%EC%B9%98%ED%82%A8%EB%B3%B4%EB%8B%A4%20%EC%8B%BC%20%EC%99%95%EC%83%88%EC%9A%B0%EB%A1%9C%20%EB%A7%8C%EB%93%9C%EB%8A%94%20%ED%92%80%EC%BD%94%EC%8A%A4%20%EC%9A%94%EB%A6%AC%20%EC%87%BC%EC%B8%A0%20%EB%B2%84%EC%A0%84%EC%9E%85%EB%8B%88%EB%8B%A4%20Shorts.mp4?alt=media&token=9f0edc29-4532-49c6-a682-cf9f84791c89");
    await controller.initialize(); // 컨트롤러 초기화
    controller.setLooping(true); // 반복 재생

    // video 재생
    play_video();
  }

  // video 재생
  Future<void> play_video() async {
    if (_VideoRepo.Data.length > index) {
      Video_length = _VideoRepo.Data.length; // 가져온 비디오 리스트의 길이
      controller.play();
    }
    notifyListeners();
  }

  // 화면 드래그 시에 호출
  void changeVideo(index) async {
    await controller.pause();
    await controller.dispose();
    Video_length = 0;
    notifyListeners();
    set_data(index);
  }
}

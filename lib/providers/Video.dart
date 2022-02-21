// provider listener 이용 => ChangeNotifier import => listener에게 setState()와 동일하게 신호를 보내 rebuild하도록 함
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/src/provider.dart';
import 'package:today_dinner/providers/Recipe.dart';

import 'package:today_dinner/repo/Video.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel with ChangeNotifier {
  late var _VideoRepo = VideoRepo();
  var controller = null; // video 컨트롤러
  var Data = [];
  int index = 0; // 현재 video index
  int Video_length = 0; // 현재 video_list length
  bool data_loading = false; // data patch 중에 로딩
  bool change_loading = false; // change 시에 로딩
  var init = true;

  // 생성자
  VideoViewModel() {
    _VideoRepo = VideoRepo();
    load_data();
  }

  // video 호출
  Future<void> load_data() async {
    await _VideoRepo.get_data(Init: true);
    Data = _VideoRepo.Data;
    Video_length = _VideoRepo.Data.length; // 가져온 비디오 리스트의 길이
    await set_data(index);
    data_loading = true;
    change_loading = true;
  }

  // video 추가 호출
  Future<void> add_data() async {
    await _VideoRepo.get_data(Add: true);
    Data = _VideoRepo.Data;
    Video_length = _VideoRepo.Data.length; // 가져온 비디오 리스트의 길이
  }

  // video 설정
  Future<void> set_data(index) async {
    print("1 ${_VideoRepo.Data[index]['url']}");
    var index_url = _VideoRepo.Data[index]['url']; // 현재 index의 영상 url
    // 현재 index의 영상 url build
    controller = VideoPlayerController.network(index_url);
    await controller.initialize(); // 컨트롤러 초기화
    controller.setLooping(true); // 반복 재생
    change_loading = true;
    notifyListeners();
    // video 재생
    if (init == false) {
      play_video();
    } else {
      init = false;
    }
  }

  // video 재생
  Future<void> play_video() async {
    controller.play();
  }

  // 화면 드래그 시에 호출
  void changeVideo(index) async {
    await controller.pause();
    await controller.dispose();
    change_loading = false;
    notifyListeners();
    set_data(index);
  }

  // bottom index 저장
  var bottom_index = 0;
  Future<void> ChangeBottomIndex(value) async {
    bottom_index = value;

    notifyListeners();
  }
}

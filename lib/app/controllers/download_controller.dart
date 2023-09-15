import 'dart:io';

import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/app/widgets/playbutton.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:at_tareeq/core/utils/downloader.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class DownloadController extends GetxController with StateMixin<List<File>> {
  final audioPlayer = Dependancies.audioPlayer();
  final Rx<Duration> duration = Duration.zero.obs;
  final Rx<Duration> position = Duration.zero.obs;
  bool get isPlaying => playingStatus.value == PlayingStatus.playing;
  final Rx<int?> currPlayingIndex = Rxn(null);
  Rx<PlayingStatus> playingStatus = PlayingStatus.stopped.obs;


  final RxBool isReady = false.obs;
  final RxList<File> downloads = <File>[].obs;

  void fetchDownloads() async {
    try {
      downloads.clear();
      change(null, status: RxStatus.loading());
      final lDownloads = await Downloader.getDownloads();
      if (lDownloads.isEmpty) {
        change(lDownloads, status: RxStatus.empty());
      } else {
        downloads.addAll(lDownloads);
        currPlayingIndex.value=0;
        change(lDownloads, status: RxStatus.success());
      }
    } on Exception catch (e) {
        Dependancies.errorService
            .addStateMixinError(stateChanger: change as dynamic, exception: e);
      }
    downloads.refresh();
  }

  @override
  void onInit() {
    fetchDownloads();
    // setAudio();
    audioPlayer.onPlayerComplete.listen((event) {
      playNext();
    });
    audioPlayer.onPlayerStateChanged.listen((state) {
      switch(state){
        
        case PlayerState.stopped:
        playingStatus.value =PlayingStatus.stopped;
          break;
        case PlayerState.playing:
        playingStatus.value =PlayingStatus.playing;
          break;
        case PlayerState.paused:
        playingStatus.value =PlayingStatus.paused;
          break;
        case PlayerState.completed:
        playingStatus.value =PlayingStatus.stopped;
          break;
      }
    });
    audioPlayer.onDurationChanged.listen((d) {
      duration.value = d;
    });
    audioPlayer.onPositionChanged.listen((p) {
      position.value = p;
    });
    super.onInit();
  }

  Future setAudio(int index) async {
    // String url = widget.lecture.url;
    await audioPlayer.setSourceDeviceFile(downloads[index].path);
    currPlayingIndex.value = index;
    isReady.value = true;
  }

  Future playNext() async {
    var nextindex = (currPlayingIndex.value ?? -1) + 1;
    if (nextindex >= downloads.length) {
      nextindex = 0;
    }
    await setAudio(nextindex);
    await audioPlayer.resume();
      playingStatus.value = PlayingStatus.playing;
    // isPlaying.value = true;
  }

  Future playPrev() async {
    var previndex = (currPlayingIndex.value ?? 0) - 1;
    if (previndex < 0) {
      previndex = 0;
    }
    await setAudio(previndex);
    await audioPlayer.resume();
      playingStatus.value = PlayingStatus.playing;

    // isPlaying.value = true;
  }

  Future playAudio() async {
    await audioPlayer.resume();
    playingStatus.value = PlayingStatus.playing;

    // isPlaying.value = true;
  }

  Future replayAudio() async {
    await audioPlayer.seek(Duration.zero);
    await audioPlayer.resume();
    playingStatus.value = PlayingStatus.playing;

    // isPlaying.value = true;
  }

  Future stopAudio() async {
    await audioPlayer.stop();
    playingStatus.value = PlayingStatus.stopped;
  }

  Future pauseAudio() async {
    await audioPlayer.pause();
    playingStatus.value = PlayingStatus.paused;
    }

  Future play(int i) async{
    await setAudio(i);
    playAudio();
  }

  deleteItem(File item) {
    item.delete();
    fetchDownloads();
  }
}

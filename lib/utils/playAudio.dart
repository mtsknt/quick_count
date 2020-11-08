import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'dart:developer';

class Audio {
  final player = AudioCache();

  Audio() {
    initPlayer();
  }

  initPlayer() {
    player.loadAll([
      'good.mp3',
      'start.mp3',
      'failed.mp3',
      'select.mp3',
    ]);
  }

  playLocal(String soundPath) async {
    AudioPlayer audio = await player.play(soundPath);

    audio.onPlayerStateChanged.listen((AudioPlayerState s) {
      log('data: $s');
    });

    audio.onPlayerCompletion.listen((event) {
      log('audio completed');
      audio.release();
    });
  }
}

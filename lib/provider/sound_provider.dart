import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

class SoundProvider extends ChangeNotifier {
  final _player = AudioPlayer();
  final song =
      'https://pagalfree.com/musics/128-Bhool%20Bhulaiyaa%203%20-%20Title%20Track%20(Feat.%20Pitbull)%20-%20Bhool%20Bhulaiyaa%203%20128%20Kbps.mp3';
  final image =
      'https://pagalfree.com/images/128Bhool%20Bhulaiyaa%203%20-%20Title%20Track%20(Feat.%20Pitbull)%20-%20Bhool%20Bhulaiyaa%203%20128%20Kbps.jpg';
  Duration duration = Duration(seconds: 0);
  double position = 0;

  Future<void> loadAudio() async {
    duration = await _player.setUrl(song) ?? Duration(seconds: 0);
    notifyListeners();
  }

  SoundProvider() {
    loadAudio();
  }

  Future<void> playAudio() async {
    await _player.play();
  }

  Future<void> pauseAudio() async {
    await _player.pause();
  }

  Future<void> seekAudio(var value) async {
   await _player.seek(Duration(seconds: position.toInt()));
  }
  Stream<Duration> sliderPlaySeek()
  {
    return _player.positionStream;
  }
}

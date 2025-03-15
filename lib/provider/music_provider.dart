import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';


import '../modal/songclass.dart';
import '../services/api_helper.dart';
import '../services/database_helper.dart';

class SongProvider extends ChangeNotifier {
  SongModel? songModel;
  bool isFavorite = false;
  final _player = AudioPlayer();
  String searchFiled = '';
  int currentMusinIndex = 0;
  var txtSearch = TextEditingController();
  Duration duration = Duration(seconds: 0);
  double position = 0;
  bool isPlay = false;
  List<Map<String, dynamic>> favouriteSongs = [];

  Future<SongModel> fetchSongFromApi(String search) async {
    final data = await ApiService.apiService.fetchApiData(search);
    songModel = SongModel.fromMap(data);
    notifyListeners();
    return songModel!;
  }


  Future<List<Map<String, dynamic>>> fetchFromSql() async {
    final data = await DbHelper.instance.fetchDataFromDatabase();

    if (data.isEmpty) {
      print("No data found in database.");
    }

    favouriteSongs = data.map((e) => Map<String, dynamic>.from(e)).toList();
    notifyListeners();
    return favouriteSongs;
  }


  void updateIndex(int index) {
    currentMusinIndex = index;
    notifyListeners();
  }

  Future<void> loadAudio() async {
    if (songModel != null && songModel!.data.result.isNotEmpty) {
      log(" ${songModel!.data.result[currentMusinIndex].downloadUrl[2].url}");
      duration =
          await _player.setUrl(
            songModel!.data.result[currentMusinIndex].downloadUrl[2].url,
          ) ??
          Duration(seconds: 0);
      notifyListeners();
    }
  }

  void searchSong(var search) {
    searchFiled = search;
    fetchSongFromApi(searchFiled);
    notifyListeners();
  }

  Future<void> playAudio(var value) async {
    isPlay = !value;
    notifyListeners();
    if (!isPlay) {
      await _player.pause();
    } else {
      await _player.play();
    }
    notifyListeners();
  }
  void setFavorite(bool value) {
    isFavorite = value;
    notifyListeners();
  }


  Future<void> seekAudio(double value) async {
    await _player.seek(Duration(seconds: value.toInt()));

    notifyListeners();
  }

  Stream<Duration> sliderPlaySeek() {
    return _player.positionStream;
  }
}

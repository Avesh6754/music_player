import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../provider/music_provider.dart';
import '../services/database_helper.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SongProvider>().loadAudio();

  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SongProvider>(context, listen: false);
    var songProvider = context.watch<SongProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          'Playing Music',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child:
                  provider.songModel == null
                      ? CircularProgressIndicator()
                      : Image.network(
                        songProvider
                            .songModel!
                            .data
                            .result[songProvider.currentMusinIndex]
                            .images[2]
                            .url,
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 200, // Set a fixed width for overflow handling
                child: Text(
                  provider.songModel == null
                      ? 'Not Found'
                      : provider
                          .songModel!
                          .data
                          .result[provider.currentMusinIndex]
                          .name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1, // Limit to one line
                  overflow:
                      TextOverflow
                          .ellipsis, // Add ellipsis (...) if text is too long
                ),
              ),

              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 30,
                ),
                onPressed: () async {
                  String songName = provider.songModel!.data.result[provider.currentMusinIndex].name;

                  bool isAlreadyInFavorites = await DbHelper.instance.isSongFavorite(songName);

                  if (isAlreadyInFavorites) {

                    await DbHelper.instance.deleteSong(songName);
                    songProvider.setFavorite(true);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleted Successfully'),duration: Duration(seconds: 1),));// Update provider state
                  } else {
                    // Add to favorites
                    await DbHelper.instance.insertData(
                      name: songName,
                      song: songProvider.songModel!.data.result[songProvider.currentMusinIndex].downloadUrl[2].url,
                      image: songProvider.songModel!.data.result[songProvider.currentMusinIndex].images[2].url,
                      label: provider.songModel!.data.result[provider.currentMusinIndex].label,
                      fav: 1, // Mark as favorite
                    );
                    songProvider.setFavorite(false);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Add Successfully'),duration: Duration(seconds: 1)));
                    songProvider.setFavorite(true);// Update provider state
                  }
                },

              ),

            ],
          ),
          SizedBox(
            width: 280,
            child: Text(
              provider.songModel == null
                  ? 'Not Found'
                  : provider
                      .songModel!
                      .data
                      .result[provider.currentMusinIndex]
                      .label,
              style: TextStyle(fontSize: 16, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          StreamBuilder(
            stream: context.read<SongProvider>().sliderPlaySeek(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                String formatTime(Duration duration) {
                  String minutes = duration.inMinutes
                      .remainder(60)
                      .toString()
                      .padLeft(2, '0');
                  String seconds = duration.inSeconds
                      .remainder(60)
                      .toString()
                      .padLeft(2, '0');
                  return '$minutes:$seconds';
                }

                return Column(
                  children: [
                    Slider(
                      activeColor: Colors.red,
                      inactiveColor: Colors.grey,
                      thumbColor: Colors.white,
                      min: 0,
                      max: songProvider.duration.inSeconds.toDouble(),
                      value: data.inSeconds.toDouble().clamp(
                        0,
                        songProvider.duration.inSeconds.toDouble(),
                      ),
                      onChanged: (value) async {
                        await context.read<SongProvider>().seekAudio(value);
                      },
                    ),
                    Row(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          formatTime(data),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          formatTime(songProvider.duration),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              return CircularProgressIndicator();
            },
          ),

          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.skip_previous,
                  size: 40,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (songProvider.currentMusinIndex > 0) {
                    provider
                      ..updateIndex(songProvider.currentMusinIndex - 1)
                      ..loadAudio();
                  }
                },
              ),
              IconButton(
                icon:
                    songProvider.isPlay
                        ? Icon(
                          Icons.pause_circle,
                          size: 60,
                          color: Colors.white,
                        )
                        : Icon(
                          Icons.play_circle_fill,
                          size: 60,
                          color: Colors.white,
                        ),
                onPressed: () async {
                  await Provider.of<SongProvider>(
                    context,
                    listen: false,
                  ).playAudio(provider.isPlay);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.skip_next,
                  size: 40,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (songProvider.currentMusinIndex <
                      provider.songModel!.data.result.length - 1) {
                    provider
                      ..updateIndex(songProvider.currentMusinIndex + 1)
                      ..loadAudio();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

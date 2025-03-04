import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:music_player/provider/sound_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Music_App());
}

class Music_App extends StatefulWidget {
  const Music_App({super.key});

  @override
  State<Music_App> createState() => _Music_AppState();
}

class _Music_AppState extends State<Music_App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SoundProvider()),
      ],
      builder: (context, child) => MaterialApp(
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Music Player',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
        elevation: 1,
        shadowColor: Colors.white,
      ),
      body: Center(
        child: Container(
          height: 500,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                height: 300,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(context.watch<SoundProvider>().image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20), // Added spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton.filledTonal(
                    iconSize: 30,
                    onPressed: () async {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'Music Play',
                        ),
                        duration: Duration(seconds: 1),
                      ));
                      await context.read<SoundProvider>().playAudio();
                    },
                    icon: const Icon(Icons.play_arrow),
                  ),
                  IconButton.filledTonal(
                    iconSize: 30,
                    onPressed: () async {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'Music Pause',
                        ),
                        duration: Duration(seconds: 1),
                      ));
                      await context.read<SoundProvider>().pauseAudio();
                    },
                    icon: const Icon(Icons.pause),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Added spacing
              StreamBuilder(stream:context.read<SoundProvider>().sliderPlaySeek(), builder: (context, snapshot) {
                if(snapshot.hasData)
                  {
                    final data=snapshot.data!;
                    return Column(
                        children: [
                          Slider(
                            min: 0,
                            max: double.parse(context
                                .watch<SoundProvider>()
                                .duration
                                .inSeconds
                                .toString()),
                            value: data.inSeconds.toDouble(),
                            onChanged: (value) async {
                              await context.read<SoundProvider>().seekAudio(value);
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                '${(data.inMinutes.toInt() ~/ 60).toString().padLeft(2, '0')}:${(data.inSeconds.toInt() % 60).toString().padLeft(2, '0')}',
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 10), // Add some spacing
                              Text(
                                '${(context.watch<SoundProvider>().duration.inMinutes).toString().padLeft(2, '0')}:${(context.watch<SoundProvider>().duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}',
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                            ],
                          )
                        ],
                    );
                  }
                else if(snapshot.hasError)
                  {
                    return Center(child: Text(snapshot.error.toString()),);
                  }
                return CircularProgressIndicator();
              },)
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:music_player/provider/auth_provider.dart';
import 'package:music_player/provider/music_provider.dart';
import 'package:music_player/screens/splash_screen.dart';
import 'package:music_player/services/database_helper.dart';

import 'package:provider/provider.dart';

import 'modal/songclass.dart';


 SongProvider songProvider=SongProvider();
late SongModel songModel;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await songProvider.fetchSongFromApi("Hindi");
  await DbHelper.instance.database;
  await DbHelper.instance.fetchDataFromDatabase();
  runApp(Music_App());
}
class Music_App extends StatelessWidget {
  const Music_App({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
        providers: [
        ChangeNotifierProvider(
        create: (context) => SongProvider(),

    ),
          ChangeNotifierProvider(
            create: (context) => AuthProvider(),

          ),
    ],
     child:  MaterialApp(debugShowCheckedModeBanner: false,home: SplashScreen(),),
    );
  }
}


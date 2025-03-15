import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../modal/songclass.dart';
import '../provider/auth_provider.dart';
import '../provider/music_provider.dart';

import '../utils/global.dart';
import 'component/artist_music.dart';
import 'component/favorite_artist.dart';
import 'component/favourite._screen.dart';
import 'component/popular_music.dart';
import 'music_play.dart';


class MusicHomeScreen extends StatefulWidget {
  @override
  State<MusicHomeScreen> createState() => _MusicHomeScreenState();
}

class _MusicHomeScreenState extends State<MusicHomeScreen> {
  @override
  Widget build(BuildContext context) {
    int currentIndex=0;
    var provider = Provider.of<SongProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Hi , ${context.watch<AuthProvider>().userName + " 🎸"}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border,color: Colors.white,),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Favourite(),));
            },
          ),

        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage('assets/image/banner.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black.withOpacity(0.4),
                    ),
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Enjoy premium service only",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "\$5 /Month",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                FutureBuilder(
                  future: provider.fetchSongFromApi('Hindi'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'No Song Found',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      SongModel songData = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              provider.updateIndex(index);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MusicPlayerScreen(),
                                ),
                              );
                            },
                            leading: Container(
                              width: 50, // Adjust size as needed
                              height: 50, // Adjust size as needed
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                // Slight rounding, use 0 for sharp edges
                                image: DecorationImage(
                                  image: NetworkImage(
                                    songData.data.result[index].images[1].url,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              songData.data.result[index].name,
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              songData.data.result[index].label,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "New Release Songs",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "View All",
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 30,
                    children: List.generate(
                      newRelease.length,
                      (index) => MusicCard(
                        imageUrl: newRelease[index]['image']!,
                        title: newRelease[index]['title']!,
                        artist: newRelease[index]['artist']!,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Favorite Artists",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "View All",
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 10,
                    children: List.generate(
                      artists.length,
                      (index) => GestureDetector(
                        onTap: () async {
                          var temp=await provider.fetchSongFromApi(artists[index]['name']!);

                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistMusic(temp: temp.data.result,currentIndex: index),));

                        },
                        child: ArtistCircle(
                          title: artists[index]['name']!,
                          imageUrl: artists[index]['image']!,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                FutureBuilder(
                  future: provider.fetchSongFromApi('Hindi'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'No Song Found',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      SongModel songData = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: songData.data.result.length,

                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              provider.updateIndex(index);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MusicPlayerScreen(),
                                ),
                              );
                            },
                            leading: Container(
                              width: 50, // Adjust size as needed
                              height: 50, // Adjust size as needed
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                // Slight rounding, use 0 for sharp edges
                                image: DecorationImage(
                                  image: NetworkImage(
                                    songData.data.result[index].images[1].url,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              songData.data.result[index].name,
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              songData.data.result[index].label,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

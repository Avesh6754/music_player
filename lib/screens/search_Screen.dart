import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../modal/songclass.dart';
import '../provider/music_provider.dart';
import 'music_play.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SongProvider songProvider;
  Future<SongModel>? searchResults; // Store API results

  @override
  void initState() {
    super.initState();
    songProvider = Provider.of<SongProvider>(context, listen: false);
  }

  void searchSongs(String query) {
    if (query.isNotEmpty) {
      setState(() {
        searchResults = songProvider.fetchSongFromApi(query);
      });
    } else {
      setState(() {
        searchResults = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "All Search",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.redAccent),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: songProvider.txtSearch,
              onChanged: searchSongs, // Trigger search dynamically
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                labelText: "Search",
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Expanded(
            child: searchResults == null
                ? Center(
              child: Text(
                "Search for a song...",
                style: TextStyle(color: Colors.white54),
              ),
            )
                : FutureBuilder<SongModel>(
              future: searchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || snapshot.data == null) {
                  return Center(
                    child: Text(
                      'No Song Found',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                SongModel songData = snapshot.data!;
                if (songData.data.result.isEmpty) {
                  return Center(
                    child: Text(
                      'No Song Found',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: songData.data.result.length, // Use full length
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        songProvider.updateIndex(index);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MusicPlayerScreen(),
                          ),
                        );
                      },
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
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
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

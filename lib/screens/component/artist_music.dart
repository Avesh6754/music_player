import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../modal/songclass.dart';
import '../../provider/music_provider.dart';
import '../music_play.dart';
class ArtistMusic extends StatelessWidget {
   ArtistMusic({super.key,required this.temp,required this.currentIndex});
List<Result> temp;
final currentIndex;
  @override
  Widget build(BuildContext context) {
    var provider=Provider.of<SongProvider>(context,listen: false);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Music App",
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
      body: ListView.builder(itemCount: temp.length,itemBuilder: (context, index) =>ListTile(
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
                  temp[index].images[1].url
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
            temp[index].name,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          temp[index].label,
          style: TextStyle(color: Colors.white),
        ),
      ),),
    );
  }
}

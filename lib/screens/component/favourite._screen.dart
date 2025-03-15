
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../provider/music_provider.dart';
import '../../services/database_helper.dart';
import '../music_play.dart';

class Favourite extends StatelessWidget {
  const Favourite({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SongProvider>(context, listen: true);
    var providerFalse = Provider.of<SongProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "Favourite",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String,dynamic>>>(
        future: providerFalse.fetchFromSql(),
        builder: (context, snapshot) {
          if (!snapshot.hasData ) {
            return const Center(
              child: Text('No Song Data', style: TextStyle(color: Colors.white)),
            );
          }

          List<Map<String, dynamic>> favouriteList = snapshot.data!;

          return (snapshot.hasData)?ListView.builder(
            itemCount: favouriteList.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                provider.updateIndex(index); // Fix: Pass the correct index
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
                    image: NetworkImage(favouriteList[index]['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                favouriteList[index]['name'] ?? "Unknown",
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                favouriteList[index]['label'] ?? "No Label",
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: IconButton(onPressed: () {
                DbHelper.instance.delete(favouriteList[index]['id']);
              }, icon: Icon(Icons.delete)),
            ),
          ):Text('');
        },
      ),
    );
  }
}

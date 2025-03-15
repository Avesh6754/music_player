
// Artist Circle Widget
import 'package:flutter/material.dart';

class ArtistCircle extends StatelessWidget {
  final String imageUrl;
  final String title;

  ArtistCircle({required this.imageUrl, required this.title,});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Column(
        spacing: 10,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage(imageUrl),
          ),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
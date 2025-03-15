// Music Card Widget
import 'package:flutter/material.dart';

class MusicCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String artist;

  MusicCard({required this.imageUrl, required this.title, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imageUrl,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          artist,
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
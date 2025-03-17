import 'dart:async';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import 'home_screen.dart';
import 'intro_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          final authProvider = context.read<AuthProvider>();
          print("User logged in: ${authProvider.isLoggedIn}"); // Debugging

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => authProvider.isLoggedIn
                  ? MusicHomeScreen()
                  : MusicLoginScreen(),
            ),
          );
        }
      });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff080605),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/image/logo.webp', height: 150),
            const Text(
              'Lyricist App',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

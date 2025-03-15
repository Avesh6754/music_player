import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



import '../provider/auth_provider.dart';
import 'component/bottom_navigation_bar.dart';

class MusicLoginScreen extends StatefulWidget {
  @override
  _MusicLoginScreenState createState() => _MusicLoginScreenState();
}

class _MusicLoginScreenState extends State<MusicLoginScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/music.webp'), // Add your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.4), Colors.black.withOpacity(0.8)],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Find your favorite music",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // Name Input Field
                TextField(
                  controller: _nameController,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    labelText: "Enter your name",
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
                SizedBox(height: 15),
                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      String name = _nameController.text.trim();
                      if (name.isNotEmpty) {
                        authProvider.login(name);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen(),));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter your name")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Submit", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Terms & Privacy Policy
                Center(
                  child: Text(
                    "By continuing, you agree to the Terms of Service & Privacy Policy",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

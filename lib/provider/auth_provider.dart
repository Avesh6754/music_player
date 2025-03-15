import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String user_Name = "";
  bool isLogged = false;

  String get userName => user_Name;
  bool get isLoggedIn => isLogged;

  AuthProvider() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_Name = prefs.getString('userName') ?? "";
    isLogged = user_Name.isNotEmpty;
    notifyListeners();
  }

  Future<void> login(String name) async {
    if (name.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', name);
      user_Name = name;
      isLogged = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');
    user_Name = "";
    isLogged = false;
    notifyListeners();
  }
}

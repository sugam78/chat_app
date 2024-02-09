import 'package:chat_app/Themes/dark_mode.dart';
import 'package:chat_app/Themes/light_mode.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier{

  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;


  void onChange(){
    if(_themeData == lightMode){
      _themeData = darkMode;
    }
    else{
      _themeData = lightMode;
    }

      notifyListeners();
  }
}
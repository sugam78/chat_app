import 'package:flutter/material.dart';

class LoadingProvider with ChangeNotifier{
  bool _loading = false;
  bool get loading => _loading;

  Change(){
    _loading = !_loading;
    notifyListeners();
  }
}
import 'package:flutter/cupertino.dart';

class MyGlobalVariable with ChangeNotifier {
  int _value = 0;

  int get value => _value;

  set value(int newValue) {
    _value = newValue;
    notifyListeners();
  }
}
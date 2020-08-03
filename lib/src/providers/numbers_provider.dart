import 'package:flutter/material.dart';

class NumberProvider with ChangeNotifier {
  double _currentIndex = 0.0;

  double get currentIndex => this._currentIndex;

  set currentIndex(double value) {
    this._currentIndex = value;
    notifyListeners();
  }
}

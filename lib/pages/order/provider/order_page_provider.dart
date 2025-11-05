import 'package:flutter/material.dart';

class OrderPageProvider extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void refresh(int index) {
    notifyListeners(); // 刷新界面
  }

  void setIndex(int index) {
    _index = index;
    refresh(index);
  }
}

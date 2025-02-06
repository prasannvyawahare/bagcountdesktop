import 'package:flutter/cupertino.dart';

class SerialPortProvider with ChangeNotifier {
  String _data = '';

  String get data => _data;

  void updateData(String newData) {
    _data = newData;
    notifyListeners();
  }
}
import 'package:flutter/material.dart';

class LanguageManager extends ChangeNotifier {
  bool _isKorean = true;
  bool get isKorean => _isKorean;

  set isKorean(bool value) {
    if (_isKorean != value) {
      _isKorean = value;
      notifyListeners();
    }
  }

  void toggleLanguage() {
    _isKorean = !_isKorean;
    notifyListeners();
  }

  /// Override the current language flag from outside widgets
  void setIsKorean(bool value) {
    _isKorean = value;
    notifyListeners();
  }
}

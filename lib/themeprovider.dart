import 'package:flutter/material.dart';
import 'theme.dart';
class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = Themes.lightTheme;

  ThemeData getTheme() => _themeData;

  void setTheme(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == Themes.lightTheme) {
      setTheme(Themes.darkTheme);
    } else {
      setTheme(Themes.lightTheme);
    }
  }
}

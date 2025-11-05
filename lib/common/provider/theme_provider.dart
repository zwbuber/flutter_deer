import 'package:flutter/material.dart';
import 'package:flutter_deer/common/constant/colors.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData getTheme({bool isDarkMode = false}) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: isDarkMode ? Colours.dark_app_main : Colours.app_main,
        secondary: isDarkMode ? Colours.dark_app_main : Colours.app_main,
        error: isDarkMode ? Colours.dark_red : Colours.red,
      ),
    );
  }
}

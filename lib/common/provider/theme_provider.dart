import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deer/res/colors.dart';
import 'package:flutter_deer/res/styles.dart';
import 'package:flutter_deer/util/theme_utils.dart';

class ThemeProvider extends ChangeNotifier {

  ThemeData getTheme({bool isDarkMode = false}) {
    return ThemeData(
      primaryColor: isDarkMode ? Colours.dark_app_main : Colours.app_main,
      colorScheme: ColorScheme.fromSeed(
        seedColor: isDarkMode ? Colours.dark_app_main : Colours.app_main,
        secondary: isDarkMode ? Colours.dark_app_main : Colours.app_main,
        error: isDarkMode ? Colours.dark_red : Colours.red,
      ),
      // 主要用于Material背景色
      canvasColor: isDarkMode ? Colours.dark_material_bg : Colors.white,
      // 页面背景色
      scaffoldBackgroundColor: isDarkMode
          ? Colours.dark_bg_color
          : Colors.white,
      // 文字样式
      textTheme: TextTheme(
        // TextField输入文字颜色
        titleMedium: isDarkMode ? TextStyles.textDark : TextStyles.text,
        // Text文字样式
        bodyMedium: isDarkMode ? TextStyles.textDark : TextStyles.text,
        titleSmall: isDarkMode
            ? TextStyles.textDarkGray12
            : TextStyles.textGray12,
      ),
      // 输入框样式
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: isDarkMode
            ? TextStyles.textHint14
            : TextStyles.textDarkGray14,
      ),
      // AppBar样式
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        backgroundColor: isDarkMode ? Colours.dark_bg_color : Colors.white,
        systemOverlayStyle: isDarkMode ? ThemeUtils.light : ThemeUtils.dark,
      ),
      // 分割线样式
      dividerTheme: DividerThemeData(
        color: isDarkMode ? Colours.dark_line : Colours.line,
        space: 0.6,
        thickness: 0.6,
      ),
      // 卡片样式
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
    );
  }
}

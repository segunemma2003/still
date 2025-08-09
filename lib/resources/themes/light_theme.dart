import 'package:flutter/material.dart';
import '/config/design.dart';
import '/resources/themes/styles/color_styles.dart';
import '/resources/themes/text_theme/default_text_theme.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* Light Theme
|--------------------------------------------------------------------------
| Theme Config - config/theme.dart
|-------------------------------------------------------------------------- */

ThemeData lightTheme(ColorStyles color) {
  TextTheme lightTheme =
      getAppTextTheme(appFont, defaultTextTheme.merge(_textTheme(color)));

  return ThemeData(
    useMaterial3: true,
    fontFamily: 'PlusJakartaSans', // 🔥 GLOBAL FONT SETTING
    primaryColor: color.content,
    primaryColorLight: color.primaryAccent,
    focusColor: color.content,
    scaffoldBackgroundColor: color.background,
    hintColor: color.primaryAccent,
    dividerTheme: DividerThemeData(color: Colors.grey[100]),
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      backgroundColor: color.appBarBackground,
      titleTextStyle: lightTheme.titleLarge!.copyWith(
        color: color.appBarPrimaryContent,
        fontFamily: '',
        fontWeight: FontWeight.w600, // SemiBold for app bar
      ),
      iconTheme: IconThemeData(color: color.appBarPrimaryContent),
      elevation: 1.0,
      // systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: color.buttonContent,
      colorScheme: ColorScheme.light(primary: color.buttonBackground),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: color.content,
        textStyle: TextStyle(
          fontFamily: '',
          fontWeight: FontWeight.w500, // Medium for text buttons
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: color.buttonContent,
        backgroundColor: color.buttonBackground,
        textStyle: TextStyle(
          fontFamily: '',
          fontWeight: FontWeight.w600, // SemiBold for elevated buttons
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: color.bottomTabBarBackground,
      unselectedIconTheme:
          IconThemeData(color: color.bottomTabBarIconUnselected),
      selectedIconTheme: IconThemeData(color: color.bottomTabBarIconSelected),
      unselectedLabelStyle: TextStyle(
        color: color.bottomTabBarLabelUnselected,
        fontFamily: '',
        fontWeight: FontWeight.w400, // Regular for unselected
      ),
      selectedLabelStyle: TextStyle(
        color: color.bottomTabBarLabelSelected,
        fontFamily: '',
        fontWeight: FontWeight.w500, // Medium for selected
      ),
      selectedItemColor: color.bottomTabBarLabelSelected,
    ),
    textTheme: lightTheme,
    colorScheme: ColorScheme.light(
      surface: color.background,
      onSecondary: Color(0xFFE8E7EA),
      primary: color.primaryAccent,
    ),
  );
}

/* Light Text Theme
|-------------------------------------------------------------------------*/

TextTheme _textTheme(ColorStyles colors) {
  TextTheme textTheme = const TextTheme().apply(
    displayColor: colors.content,
    fontFamily: '', // Apply Jakarta Sans to all text
  );
  return textTheme.copyWith(
      labelLarge: TextStyle(
    color: colors.content.withAlpha((255.0 * 0.8).round()),
    fontFamily: '',
    fontWeight: FontWeight.w500, // Medium for labels
  ));
}

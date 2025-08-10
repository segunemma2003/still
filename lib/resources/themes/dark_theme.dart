import 'package:flutter/material.dart';
import '/config/design.dart';
import '/resources/themes/styles/color_styles.dart';
import '/resources/themes/text_theme/default_text_theme.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* Dark Theme
|--------------------------------------------------------------------------
| Theme Config - config/theme.dart
|-------------------------------------------------------------------------- */

ThemeData darkTheme(ColorStyles color) {
  TextTheme darkTheme =
      getAppTextTheme(appFont, defaultTextTheme.merge(_textTheme(color)));
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'PlusJakartaSans', // 🔥 GLOBAL FONT SETTING
    primaryColor: color.content,
    primaryColorDark: color.content,
    focusColor: color.content,
    scaffoldBackgroundColor: color.background,
    brightness: Brightness.dark,
    datePickerTheme: DatePickerThemeData(
      headerForegroundColor: Color(0xFFE8E7EA),
      weekdayStyle: TextStyle(
        color: Color(0xFFE8E7EA),
        fontFamily: 'PlusJakartaSans',
      ),
      dayForegroundColor:
          WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.black; // Color for selected date
        }
        return Color(0xFFE8E7EA); // Color for unselected dates
      }),
    ),
    timePickerTheme: TimePickerThemeData(
      hourMinuteTextColor: Color(0xFFE8E7EA),
      dialTextColor: Color(0xFFE8E7EA),
      dayPeriodTextColor: Color(0xFFE8E7EA),
      helpTextStyle: TextStyle(
        color: Color(0xFFE8E7EA),
        fontFamily: 'PlusJakartaSans',
      ),
      // For the AM/PM selector
      dayPeriodBorderSide: BorderSide(color: Color(0xFFE8E7EA)),
      // For the dial background
      dialBackgroundColor: Colors.grey[800],
      // For the input decoration if using text input mode
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          color: Color(0xFFE8E7EA),
          fontFamily: 'PlusJakartaSans',
        ),
        hintStyle: TextStyle(
          color: Color(0xFFE8E7EA),
          fontFamily: 'PlusJakartaSans',
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      backgroundColor: color.appBarBackground,
      titleTextStyle: darkTheme.titleLarge!.copyWith(
        color: color.appBarPrimaryContent,
        fontFamily: 'PlusJakartaSans',
        fontWeight: FontWeight.w600, // SemiBold for app bar
      ),
      iconTheme: IconThemeData(color: color.appBarPrimaryContent),
      elevation: 1.0,
      // systemOverlayStyle: SystemUiOverlayStyle.dark
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: color.primaryAccent,
      colorScheme: ColorScheme.light(primary: color.buttonBackground),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: color.content,
        textStyle: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontWeight: FontWeight.w500, // Medium for text buttons
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: color.buttonContent,
        backgroundColor: color.buttonBackground,
        textStyle: TextStyle(
          fontFamily: 'PlusJakartaSans',
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
        fontFamily: 'PlusJakartaSans',
        fontWeight: FontWeight.w400, // Regular for unselected
      ),
      selectedLabelStyle: TextStyle(
        color: color.bottomTabBarLabelSelected,
        fontFamily: 'PlusJakartaSans',
        fontWeight: FontWeight.w500, // Medium for selected
      ),
      selectedItemColor: color.bottomTabBarLabelSelected,
    ),
    textTheme: darkTheme,
    colorScheme: ColorScheme.dark(
      primary: color.primaryAccent,
      onSurface: Colors.black,
    ),
  );
}

/* Dark Text Theme
|-------------------------------------------------------------------------*/

TextTheme _textTheme(ColorStyles colors) {
  TextTheme textTheme = const TextTheme().apply(
    displayColor: colors.content,
    bodyColor: colors.content,
    fontFamily: 'PlusJakartaSans', // Apply Jakarta Sans to all text
  );
  return textTheme.copyWith(
      titleLarge: TextStyle(
        color: colors.content.withAlpha((255.0 * 0.8).round()),
        fontFamily: 'PlusJakartaSans',
        fontWeight: FontWeight.w600, // SemiBold for titles
      ),
      labelLarge: TextStyle(
        color: colors.content.withAlpha((255.0 * 0.8).round()),
        fontFamily: 'PlusJakartaSans',
        fontWeight: FontWeight.w500, // Medium for labels
      ),
      bodySmall: TextStyle(
        color: colors.content.withAlpha((255.0 * 0.8).round()),
        fontFamily: 'PlusJakartaSans',
        fontWeight: FontWeight.w400, // Regular for body small
      ),
      bodyMedium: TextStyle(
        color: colors.content.withAlpha((255.0 * 0.8).round()),
        fontFamily: 'PlusJakartaSans',
        fontWeight: FontWeight.w400, // Regular for body medium
      ));
}

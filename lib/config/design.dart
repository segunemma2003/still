import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '/config/toast_notification_styles.dart';
import '/resources/widgets/loader_widget.dart';
import '/resources/widgets/logo_widget.dart';
import '/resources/widgets/toast_notification_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* Design
|--------------------------------------------------------------------------
| Contains App Font + Widgets used in the Nylo.
| Learn more: https://nylo.dev/docs/6.x/themes-and-styling#design
|-------------------------------------------------------------------------- */

/* Font
|--------------------------------------------------------------------------
| Uses Google Fonts - https://pub.dev/packages/google_fonts
| You can use any font from Google Fonts library.
| -------------------------------------------------------------------------- */

// final TextStyle appFont = TextStyle(fontFamily: 'PlusJakartaSans');

final TextStyle appFont = _getSystemFont();

TextStyle _getSystemFont() {
  if (kIsWeb) {
    // For web, use Inter which is close to Helvetica Neue
    return GoogleFonts.inter();
  }

  try {
    if (Platform.isIOS || Platform.isMacOS) {
      // Use system font on iOS/macOS (Helvetica Neue/San Francisco)
      return const TextStyle(fontFamily: '.SF UI Text');
    } else if (Platform.isAndroid) {
      // Use Roboto on Android (system default)
      return const TextStyle(fontFamily: 'Roboto');
    } else {
      // Fallback for other platforms
      return GoogleFonts.inter();
    }
  } catch (e) {
    // Fallback if Platform detection fails
    return GoogleFonts.inter();
  }
}
// GoogleFonts.outfit();
// e.g. final TextStyle appThemeFont = GoogleFonts.lato();

/* App Logo
|--------------------------------------------------------------------------
| This is the logo for your application.
| Use the Logo() widget or Nylo.getAppLogo() display your logo
| -------------------------------------------------------------------------- */

final Widget logo = const Logo();
// File: resources/widgets/logo_widget.dart

/* Loader
|--------------------------------------------------------------------------
| This is the loading widget for your application.
| Use the Loader() widget or Nylo.getAppLoader() display your loader
| -------------------------------------------------------------------------- */

final Widget loader = const Loader();
// File: resources/widgets/loader_widget.dart

/* Toast Notification
|--------------------------------------------------------------------------
| This is the toast notification widget for your application.
| Here you can handle the toast notification style.
| -------------------------------------------------------------------------- */

Widget getToastNotificationWidget(
    {required ToastNotificationStyleType style,
    Function(ToastNotificationStyleMetaHelper helper)?
        toastNotificationStyleMeta,
    Function? onDismiss}) {
  if (toastNotificationStyleMeta == null) return const SizedBox.shrink();

  ToastMeta toastMeta =
      toastNotificationStyleMeta(NyToastNotificationStyleMetaHelper(style));

  return ToastNotification(toastMeta, onDismiss: onDismiss);
}
// File: resources/widgets/toast_notification_styles.dart

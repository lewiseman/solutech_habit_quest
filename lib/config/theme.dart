import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();
  static const poppinsFont = 'Poppins';

  static const Color primaryBlue = Color(0xFF0066cc);

  static const systemUiOverlayStyleLight = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static final ThemeData darkTheme = ThemeData.light().copyWith(
    platform: TargetPlatform.iOS,
    primaryColor: primaryBlue,
    colorScheme: const ColorScheme.light(primary: primaryBlue),
  );

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    platform: TargetPlatform.iOS,
    primaryColor: primaryBlue,
    colorScheme: const ColorScheme.light(primary: primaryBlue),
  );
}

extension AppThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  bool get isDarkMode => theme.brightness == Brightness.dark;
}

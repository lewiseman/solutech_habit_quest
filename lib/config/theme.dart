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

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    platform: TargetPlatform.iOS,
    primaryColor: primaryBlue,
    colorScheme: const ColorScheme.light(primary: primaryBlue),
    cardColor: Colors.black,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
    dividerColor: Colors.white,
    textTheme: ThemeData.dark()
        .textTheme
        .apply(
          fontFamily: poppinsFont,
        )
        .copyWith(
          bodyMedium: const TextStyle(
            color: Colors.white,
          ),
        ),
    brightness: Brightness.dark,
    tabBarTheme: const TabBarTheme(
      unselectedLabelColor: Colors.white,
    ),
  );

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    platform: TargetPlatform.iOS,
    primaryColor: primaryBlue,
    colorScheme: const ColorScheme.light(primary: primaryBlue),
    brightness: Brightness.light,
    cardColor: Colors.white,
  );
}

extension AppThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  bool get isDarkMode => theme.brightness == Brightness.dark;
  bool isDesktop() {
    return MediaQuery.sizeOf(this).width > 600;
  }
}

// ignore_for_file: use_build_context_synchronously, document_ignores

import 'dart:async';

import 'package:habit_quest/common.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openLink(String url, [BuildContext? context]) async {
  final uri = Uri.parse(url);
  final canlaunch = await canLaunchUrl(uri);
  if (!canlaunch) {
    if (context == null) return;
    AppDialog.alert(
      context,
      message: 'Could not open the link',
    );
  }
  unawaited(launchUrl(uri));
}

   ThemeMode getThemeMode(String name) {
    switch (name) {
      case 'system':
        return ThemeMode.system;
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.light;
    }
  }
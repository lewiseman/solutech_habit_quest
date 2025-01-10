import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:habit_quest/firebase_options.dart';
import 'package:habit_quest/repositories/repositories.dart';
import 'package:timezone/data/latest.dart' as tz;

class AppDependencies {
  static Future<void> initialize() async {
    // Required if you'll ran any code before runApp

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await CacheStorage.instance.initialize();
    await AppRepository.initialize();
    if (kIsWeb) {
      usePathUrlStrategy();
    }
    tz.initializeTimeZones();
  }
}

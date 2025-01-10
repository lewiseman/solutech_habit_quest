import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:habit_quest/common.dart';
import 'package:habit_quest/firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:habit_quest/router.dart';

void main() async {
  // Required if you'll ran any code before runApp
  WidgetsFlutterBinding.ensureInitialized();
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
  runApp(
    const ProviderScope(child: HabitQuest()),
  );
}

class HabitQuest extends ConsumerWidget {
  const HabitQuest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questUser = ref.watch(authServiceProvider);
    ref
      ..read(syncServiceProvider)
      ..read(notificationsServiceProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      themeMode: getThemeMode(
        questUser?.themeMode ?? 'light',
      ),
      darkTheme: AppTheme.darkTheme,
      theme: AppTheme.lightTheme,
      title: 'Habit Quest',
    );
  }
}

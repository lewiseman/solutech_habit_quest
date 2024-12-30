import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:habit_quest/common.dart';
import 'package:habit_quest/router.dart';

void main() {
  // Required if you'll ran any code before runApp
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  if (kIsWeb) {
    usePathUrlStrategy();
  }
  runApp(
    const ProviderScope(child: HabitQuest()),
  );
}

class HabitQuest extends ConsumerWidget {
  const HabitQuest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      themeMode: ThemeMode.light,
      darkTheme: AppTheme.darkTheme,
      theme: AppTheme.lightTheme,
      title: 'Habit Quest',
    );
  }
}

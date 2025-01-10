import 'package:habit_quest/common.dart';
import 'package:habit_quest/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDependencies.initialize();
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

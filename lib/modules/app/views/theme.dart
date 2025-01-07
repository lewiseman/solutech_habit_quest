import 'package:flutter/cupertino.dart';
import 'package:habit_quest/common.dart';

class SelectThemePage extends ConsumerWidget {
  const SelectThemePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final settings = ref.watch(settingsServiceProvider);
    final user = ref.watch(userServiceProvider);
    final themename = user?.prefs.data['theme_mode'] as String? ?? 'light';
    final themes = [
      (
        name: 'System',
        value: 'system',
        mode: ThemeMode.system,
        icon: CupertinoIcons.device_phone_portrait
      ),
      (
        name: 'Dark Mode',
        value: 'dark',
        mode: ThemeMode.dark,
        icon: CupertinoIcons.moon_circle
      ),
      (
        name: 'Light Mode',
        value: 'light',
        mode: ThemeMode.light,
        icon: CupertinoIcons.sun_min
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'SELECT THEME',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: AppTheme.poppinsFont,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 24,
            ),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: Column(
                children: [
                  for (int x = 0; x < themes.length; x++)
                    ...() {
                      final theme = themes[x];
                      final selected = theme.value == themename;
                      return [
                        ListTile(
                          leading: Icon(theme.icon),
                          title: Text(theme.name),
                          trailing: selected
                              ? const Icon(CupertinoIcons.checkmark)
                              : null,
                          onTap: () {
                            context.showInfoLoad('Updating theme...');
                            ref
                                .read(userServiceProvider.notifier)
                                .update(
                                  themeMode: theme.value,
                                )
                                .then((_) {
                              context.pop();
                            }).onError((error, stack) {
                              context
                                ..pop()
                                ..showErrorToast(error.toString());
                            });
                          },
                        ),
                        if (x != themes.length - 1)
                          const Divider(
                            height: .1,
                            thickness: .1,
                          ),
                      ];
                    }(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:habit_quest/common.dart';

class SelectThemePage extends ConsumerWidget {
  const SelectThemePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final questUser = ref.watch(authServiceProvider);
    final themename = questUser?.themeMode ?? 'light';
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
        backgroundColor: theme.scaffoldBackgroundColor,
        title: const Text(
          'SELECT THEME',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: AppTheme.poppinsFont,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: maxPageWidth,
          ),
          child: Column(
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
                  color: theme.cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Column(
                    children: [
                      for (int x = 0; x < themes.length; x++)
                        ...() {
                          final themedata = themes[x];
                          final selected = themedata.value == themename;
                          return [
                            ListTile(
                              leading: Icon(
                                themedata.icon,
                                color: theme.textTheme.bodyMedium!.color,
                              ),
                              title: Text(
                                themedata.name,
                                style: TextStyle(
                                  color: theme.textTheme.bodyMedium!.color,
                                  fontFamily: AppTheme.poppinsFont,
                                ),
                              ),
                              trailing: selected
                                  ? Icon(
                                      CupertinoIcons.checkmark,
                                      color: theme.textTheme.bodyMedium!.color,
                                    )
                                  : null,
                              onTap: questUser != null
                                  ? () {
                                      context.showInfoLoad('Updating theme...');
                                      ref
                                          .read(authServiceProvider.notifier)
                                          .update(
                                            questUser.copyWith(
                                              themeMode: themedata.value,
                                            ),
                                          )
                                          .then((_) {
                                        context.pop();
                                      }).onError((error, stack) {
                                        context
                                          ..pop()
                                          ..showErrorToast(error.toString());
                                      });
                                    }
                                  : null,
                            ),
                            if (x != themes.length - 1)
                              Divider(
                                height: .1,
                                thickness: .1,
                                color: theme.dividerColor,
                              ),
                          ];
                        }(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

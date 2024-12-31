import 'package:flutter/services.dart';
import 'package:habit_quest/common.dart';

class RootApp extends StatefulWidget {
  const RootApp({required this.child, super.key});
  final Widget child;

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  @override
  Widget build(BuildContext context) {
    final currPath = GoRouterState.of(context).uri.path;
    final currPage = _pages.where((page) => page.page == currPath).firstOrNull;
    print(currPage);
    print('currPath: $currPath');
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        extendBody: true,
        body: widget.child,
        appBar: switch (currPath) {
          '/' => HabitsPage.appBar(context),
          '/user' => UserPage.appBar(context),
          _ => null
        },
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(
              height: 1,
              thickness: .3,
            ),
            BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              currentIndex: _pages.indexWhere((page) => page.page == currPath),
              onTap: (index) {
                context.go(_pages[index].page);
              },
              items: [
                for (final page in _pages)
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 4),
                      child: Icon(
                        page.page == currPath ? page.activeIcon : page.icon,
                        size: page.page == currPath ? 35 : 30,
                      ),
                    ),
                    label: page.name,
                  ),
              ],
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

final _pages = [
  (
    name: 'Habits',
    icon: CustomIcons.target,
    activeIcon: CustomIcons.target_filled,
    page: '/'
  ),
  (
    name: 'Journey',
    icon: CustomIcons.trending,
    activeIcon: CustomIcons.trending_filled,
    page: '/journey'
  ),
  (
    name: 'Profile',
    icon: CustomIcons.user,
    activeIcon: CustomIcons.user_filled,
    page: '/user'
  ),
];

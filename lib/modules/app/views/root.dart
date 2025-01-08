import 'package:flutter/foundation.dart';
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
  void initState() {
    super.initState();
    if (!kIsWeb) NotificationHelper.init();
  }

  @override
  Widget build(BuildContext context) {
    final currPath = GoRouterState.of(context).uri.path;
    final currPage = _pages.where((page) => page.page == currPath).firstOrNull;
    final isDesktop = context.isDesktop();
    final theme = Theme.of(context);
    return AnnotatedRegion(
      value:  SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: theme.scaffoldBackgroundColor
      ),
      child: Scaffold(
        extendBody: true,
        body: isDesktop
            ? Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30, right: 16, left: 16),
                    child: SizedBox(
                      width: 250,
                      child: Column(
                        children: [
                          for (final page in _pages)
                            () {
                              final selected = page.page == currPath;
                              return Card(
                                elevation: selected ? 1 : 0,
                                color: selected
                                    ? AppTheme.primaryBlue
                                    : Colors.transparent,
                                child: ListTile(
                                  leading: Icon(
                                    selected ? page.activeIcon : page.icon,
                                    size: 35,
                                    color: selected
                                        ? theme.colorScheme.onPrimary
                                        : theme.textTheme.bodyMedium!.color,
                                  ),
                                  title: Text(
                                    page.name,
                                    style: TextStyle(
                                      color: page.page == currPath
                                          ? theme.colorScheme.onPrimary
                                          : theme.textTheme.bodyMedium!.color,
                                      fontFamily: AppTheme.poppinsFont,
                                      fontWeight: selected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  onTap: () {
                                    context.go(page.page);
                                  },
                                ),
                              );
                            }(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: maxPageWidth,
                        ),
                        child: widget.child,
                      ),
                    ),
                  ),
                ],
              )
            : widget.child,
        appBar: switch (currPath) {
          '/' => HabitsPage.appBar(context),
          '/user' => UserPage.appBar(context),
          '/journey' => JourneyPage.appBar(context),
          _ => null
        },
        floatingActionButton: currPage?.page == '/'
            ? (isDesktop
                ? FloatingActionButton(
                    elevation: 1,
                    onPressed: () {
                      context.push('/create_habit');
                    },
                    backgroundColor: AppTheme.primaryBlue,
                    child: const Icon(Icons.add),
                  )
                : FloatingActionButton.small(
                    elevation: 1,
                    onPressed: () {
                      context.push('/create_habit');
                    },
                    backgroundColor: AppTheme.primaryBlue,
                    child: const Icon(Icons.add),
                  ))
            : null,
        bottomNavigationBar: isDesktop
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(
                    height: .9,
                    thickness: .1,
                  ),
                  BottomNavigationBar(
                    elevation: 0,
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: AppTheme.primaryBlue,
                    currentIndex:
                        _pages.indexWhere((page) => page.page == currPath),
                    onTap: (index) {
                      context.go(_pages[index].page);
                    },
                    items: [
                      for (final page in _pages)
                        BottomNavigationBarItem(
                          icon: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 4),
                            child: Icon(
                              page.page == currPath
                                  ? page.activeIcon
                                  : page.icon,
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

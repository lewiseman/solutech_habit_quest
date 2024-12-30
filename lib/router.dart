import 'package:habit_quest/common.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: '/auth',
    routes: [
      GoRoute(
        path: '/auth',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: AuthSplashPage(),
        ),
        routes: [
          GoRoute(
            path: 'login',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const LoginPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeTransition(
                opacity: animation,
                child: child,
              ),
            ),
          ),
        ],
      ),
      ShellRoute(
        pageBuilder: (context, state, child) => NoTransitionPage(
          child: RootApp(child: child),
        ),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
        ],
      ),
    ],
  );
});

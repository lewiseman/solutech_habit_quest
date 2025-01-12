import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_quest/common.dart';

final _rootNAvigatorKey = GlobalKey<NavigatorState>();
final _routeService = AppRouteService();
final router = GoRouter(
  initialLocation: '/',
  refreshListenable: _routeService,
  navigatorKey: _rootNAvigatorKey,
  restorationScopeId: 'solutech_router',
  redirect: _routeService.handleRedirect,
  routes: [
    // Auth routes
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
        GoRoute(
          path: 'register',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const RegisterPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),
        GoRoute(
          path: 'onboarding',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const OnboardingPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
          routes: [
            GoRoute(
              path: 'questions',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const OnboardingQuestionPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'forgot_password',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const ForgotPasswordPage(),
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
            child: HabitsPage(),
          ),
          routes: [
            GoRoute(
              parentNavigatorKey: _rootNAvigatorKey,
              path: 'create_habit',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: CreateHabitPage(),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _rootNAvigatorKey,
              path: 'edit_habit/:habitId',
              pageBuilder: (context, state) => NoTransitionPage(
                child: CreateHabitPage(
                  habitId: state.pathParameters['habitId'],
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/journey',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: JourneyPage(),
          ),
        ),
        GoRoute(
          path: '/user',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: UserPage(),
          ),
          routes: [
            GoRoute(
              parentNavigatorKey: _rootNAvigatorKey,
              path: 'avatars',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const PickAvatarPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        SlideTransition(
                  position: animation.drive(
                    Tween(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeInOut)),
                  ),
                  child: child,
                ),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _rootNAvigatorKey,
              path: 'profile',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const ProfileEditPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        SlideTransition(
                  position: animation.drive(
                    Tween(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeInOut)),
                  ),
                  child: child,
                ),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _rootNAvigatorKey,
              path: 'badges',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const BadgesPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        SlideTransition(
                  position: animation.drive(
                    Tween(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeInOut)),
                  ),
                  child: child,
                ),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _rootNAvigatorKey,
              path: 'notifications',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const NotificationSettingsPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        SlideTransition(
                  position: animation.drive(
                    Tween(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeInOut)),
                  ),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/notifications',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: NotificationPage(),
      ),
    ),
    GoRoute(
      path: '/theme',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: SelectThemePage(),
      ),
    ),
  ],
);

final appRouteService = ChangeNotifierProvider(
  (ref) => AppRouteService(),
);

class AppRouteService extends ChangeNotifier {
  AppRouteService() {
    FirebaseAuth.instance.authStateChanges().listen((value) {
      user = value;
      if (value == null) {
        notifyListeners();
      }
    });
  }
  User? user = FirebaseAuth.instance.currentUser;

  String? handleRedirect(BuildContext context, GoRouterState state) {
    final pathLocaton = state.matchedLocation;
    if (user == null) {
      if (pathLocaton.startsWith('/auth')) {
        return null;
      }
      return '/auth';
    }
    return null;
  }
}

import 'package:habit_quest/common.dart';

final _rootNAvigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider(
  (ref) {
    return GoRouter(
      initialLocation: '/auth',
      navigatorKey: _rootNAvigatorKey,
      restorationScopeId: 'solutech_router',
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
                    child: const ProfileEditPAge(),
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
      ],
    );
  },
);

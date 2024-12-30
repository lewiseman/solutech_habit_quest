import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:habit_quest/common.dart';

class AuthSplashPage extends StatefulWidget {
  const AuthSplashPage({super.key});

  @override
  State<AuthSplashPage> createState() => _AuthSplashPageState();
}

class _AuthSplashPageState extends State<AuthSplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _colorAnimation;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _scaleAnimation = Tween<double>(begin: 5, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0,
          0.5,
          curve: Curves.easeOutCirc,
        ), // First half of the animation
      ),
    );

    _colorAnimation = Tween<double>(begin: .2, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.5,
          1,
          curve: Curves.easeInOut,
        ), // Second half of the animation
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final screenPadding = MediaQuery.viewPaddingOf(context);
    return Material(
      child: Stack(
        children: [
          if (!kIsWeb)
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  AppTheme.primaryBlue.withOpacity(_colorAnimation.value * 0.8),
                  BlendMode.srcATop,
                ),
                child: Opacity(
                  opacity: 1,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Image.asset(
                      'assets/images/bg_pattern.png',
                      repeat: ImageRepeat.repeat,
                      // fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          Positioned.fill(
            child: AnimatedOpacity(
              duration: const Duration(seconds: 2),
              opacity: kIsWeb ? 1 : (_controller.value == 1 ? 1 : 0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppTheme.primaryBlue.withOpacity(.1),
                      AppTheme.primaryBlue.withOpacity(.3),
                      AppTheme.primaryBlue.withOpacity(.8),
                      AppTheme.primaryBlue,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: screenPadding.bottom + 4,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                    maxHeight: 800,
                  ),
                  child: Column(
                    children: [
                      const Spacer(),
                      AnimatedOpacity(
                        duration: const Duration(seconds: 2),
                        opacity: kIsWeb ? 1 : (_controller.value == 1 ? 1 : 0),
                        child: Hero(
                          tag: 'splash_mascot',
                          child: Image.asset(
                            kIsWeb
                                ? 'assets/images/blue_logo.png'
                                : 'assets/images/white_logo.png',
                            width: size.width * 0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 1500),
                        opacity: kIsWeb ? 1 : (_controller.value == 1 ? 1 : 0),
                        child: Column(
                          children: [
                            const Text(
                              'HABIT QUEST',
                              style: TextStyle(
                                fontFamily: AppTheme.poppinsFont,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Text(
                              '''Embark on a journey to build better habits, one quest at a time. Track your progress, earn rewards, and level up your life.''',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontFamily: AppTheme.poppinsFont,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Hero(
                              tag: 'splash_filled_button',
                              child: FilledButton(
                                onPressed: () {
                                  context.push('/onboarding');
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor:
                                      const Color.fromARGB(255, 139, 75, 3),
                                  fixedSize:
                                      const Size.fromWidth(double.maxFinite),
                                ),
                                child: const Text(
                                  'GET STARTED',
                                  style: TextStyle(
                                    fontFamily: AppTheme.poppinsFont,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton(
                              onPressed: () {
                                context.push('/auth/login');
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                backgroundColor: Colors.white.withOpacity(0.05),
                                fixedSize:
                                    const Size.fromWidth(double.maxFinite),
                              ),
                              child: const Text(
                                'I ALREADY HAVE AN ACCOUNT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: AppTheme.poppinsFont,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              '''By continuing you agree to our Terms of Service and Privacy Policy''',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.65),
                                fontFamily: AppTheme.poppinsFont,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

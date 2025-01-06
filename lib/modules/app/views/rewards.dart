import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:habit_quest/config/config.dart';

class SingleCoinAnimation extends StatefulWidget {
  const SingleCoinAnimation({super.key});

  @override
  State<SingleCoinAnimation> createState() => _SingleCoinAnimationState();
}

class _SingleCoinAnimationState extends State<SingleCoinAnimation> {
  @override
  Widget build(BuildContext context) {
    const initialTop = -kToolbarHeight;
    return Positioned(
      top: initialTop,
      left: 0,
      right: 0,
      child: Center(
        child: Image.asset(
          'assets/images/banana/money.png',
          height: 50,
          width: 50,
        )
            .animate(
              delay: 200.ms,
            )
            .moveY(end: 70, begin: initialTop, duration: 500.ms)
            .then()
            .scaleXY(
              end: 3,
              duration: 500.ms,
              curve: Curves.easeIn,
            )
            .then(delay: 400.ms)
            .shake(
              hz: 2,
              duration: 2.seconds,
            )
            .then()
            .moveY(
              begin: 70,
              end: initialTop + -100,
              duration: 400.ms,
            )
            .scaleXY(end: 0),
      ),
    );
  }
}

class NextLevelPop extends StatefulWidget {
  const NextLevelPop({super.key});

  @override
  State<NextLevelPop> createState() => _NextLevelPopState();
}

class _NextLevelPopState extends State<NextLevelPop> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'CONGRATULATIONS!',
                    style: TextStyle(
                      fontFamily: AppTheme.poppinsFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20, width: double.maxFinite),
                  Image.asset(
                    'assets/images/banana/trophy.png',
                    height: 100,
                    width: 100,
                  )
                      .animate(
                        onPlay: (controller) => controller.loop(),
                      )
                      .shake(
                        hz: 3,
                      ),
                  const SizedBox(height: 20),
                  const Text(
                    'LEVEL 2',
                    style: TextStyle(
                      fontFamily: AppTheme.poppinsFont,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    'You have reached a new level!',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              fixedSize: const Size.fromWidth(double.maxFinite),
            ),
            child: const Text('Close'),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

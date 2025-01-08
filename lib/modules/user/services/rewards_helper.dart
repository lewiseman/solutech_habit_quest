import 'package:flutter/cupertino.dart';
import 'package:habit_quest/common.dart';
import 'package:habit_quest/modules/app/views/rewards.dart';

class RewardsHelper {
  static void activityCompleted(BuildContext context, int coins) {
    if (coins % 5 == 0) {
      showNextLevel(context, coins);
    } else {
      showSinglePoint(context);
    }
  }

  static void showNextLevel(BuildContext context, int coins) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) {
        return NextLevelPop(
          coins: coins,
        );
      },
    );
  }

  Future<void> removeCoins(int coins) async {
    // final newCoins = state.coins - coins;
    // await CacheStorage.instance.updateCoins(newCoins);
    // state = state.copyWith(coins: newCoins);
  }

  static void showSinglePoint(BuildContext context) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => const SingleCoinAnimation(),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 6), overlayEntry.remove);
  }
}

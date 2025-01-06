import 'package:flutter/cupertino.dart';
import 'package:habit_quest/common.dart';
import 'package:habit_quest/modules/app/views/rewards.dart';

final rewardsServiceProvider =
    StateNotifierProvider<RewardsNotifier, RewardsState>((ref) {
  return RewardsNotifier();
});

class RewardsNotifier extends StateNotifier<RewardsState> {
  RewardsNotifier() : super(RewardsState.initial());

  void activityCompleted(BuildContext context) {
    final coin = state.coins + 1;
    CacheStorage.instance.updateCoins(coin);
    state = state.copyWith(coins: coin);
    showNextLevel(context);
    // if (state.coins % 5 == 0) {
    // } else {
    //   showSinglePoint(context);
    // }
  }

  void showNextLevel(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) {
        return const NextLevelPop();
      },
    );
  }

  Future<void> removeCoins(int coins) async {
    final newCoins = state.coins - coins;
    await CacheStorage.instance.updateCoins(newCoins);
    state = state.copyWith(coins: newCoins);
  }

  void showSinglePoint(BuildContext context) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => const SingleCoinAnimation(),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 6), overlayEntry.remove);
  }
}

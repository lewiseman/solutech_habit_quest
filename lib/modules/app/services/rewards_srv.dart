// import 'package:flutter/cupertino.dart';
// import 'package:habit_quest/common.dart';
// import 'package:habit_quest/modules/app/views/rewards.dart';
// import 'package:appwrite/models.dart' as models;

// final rewardsServiceProvider =
//     StateNotifierProvider<RewardsNotifier, RewardsState>((ref) {
//   final user = ref.watch(userServiceProvider);
//   return RewardsNotifier(
//     user: user,
//   );
// });

// class RewardsNotifier extends StateNotifier<RewardsState> {
//   RewardsNotifier({required this.user}) : super(RewardsState.initial());

//   final models.User? user;

//   // void activityCompleted(BuildContext context) {
//   //   final coin = state.coins + 1;
//   //   CacheStorage.instance.updateCoins(coin);
//   //   state = state.copyWith(coins: coin);
//   //   showNextLevel(context);
//   //   // if (state.coins % 5 == 0) {
//   //   // } else {
//   //   //   showSinglePoint(context);
//   //   // }
//   // }

//   // void showNextLevel(BuildContext context) {
//   //   showCupertinoModalPopup<void>(
//   //     context: context,
//   //     builder: (_) {
//   //       return const NextLevelPop();
//   //     },
//   //   );
//   // }

//   // Future<void> removeCoins(int coins) async {
//   //   final newCoins = state.coins - coins;
//   //   await CacheStorage.instance.updateCoins(newCoins);
//   //   state = state.copyWith(coins: newCoins);
//   // }

//   // void showSinglePoint(BuildContext context) {
//   //   final overlay = Overlay.of(context);
//   //   final overlayEntry = OverlayEntry(
//   //     builder: (context) => const SingleCoinAnimation(),
//   //   );

//   //   overlay.insert(overlayEntry);
//   //   Future.delayed(const Duration(seconds: 6), overlayEntry.remove);
//   // }
// }

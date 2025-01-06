import 'package:habit_quest/common.dart';

class RewardsState {
  const RewardsState({
    required this.coins,
    required this.permanentCoins,
  });

  factory RewardsState.initial() {
    final coin = CacheStorage.instance.coins;
    return RewardsState(
      coins: coin,
      permanentCoins: coin,
    );
  }

  final int coins;
  final int permanentCoins;

  RewardsState copyWith({
    int? coins,
    int? permanentCoins,
  }) {
    return RewardsState(
      coins: coins ?? this.coins,
      permanentCoins: permanentCoins ?? this.permanentCoins,
    );
  }
}

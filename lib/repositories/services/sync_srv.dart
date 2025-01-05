import 'package:habit_quest/common.dart';
import 'package:habit_quest/repositories/models/sync_entry.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

final syncServiceProvider =
    StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  return SyncNotifier(
    ref: ref,
  );
});

class SyncNotifier extends StateNotifier<SyncState> {
  SyncNotifier({required this.ref}) : super(const LoadingSyncState()) {
    init();
  }

  final Ref ref;

  Future<void> init() async {
    await initialSync();
    continuousSync();
  }

  Future<void> initialSync() async {
    final pendingSyncEntries =
        Hive.box<SyncEntry>('syncdata_box').values.toList();
    try {
      final remoteHabits =
          await AppRepository.instance.remoteRepository.getHabits();
      state = SyncedSyncState(DateTime.now());
    } catch (e) {
      state = ErrorSyncState('Error syncing data');
    }
  }

  void continuousSync() {
    Hive.box<SyncEntry>('syncdata_box').watch().listen((event) async {
      if (event.deleted) return;
      final syncEntry = event.value;
      if (syncEntry is SyncEntry) {
        if (syncEntry.item == SyncItem.habit) {
          return handleHabitItemSync(syncEntry);
        }
      }
    });
  }

  Future<void> handleHabitItemSync(SyncEntry syncEntry) async {
    if (syncEntry.action == SyncAction.delete) {
      await AppRepository.instance.remoteRepository.deleteHabit(
        syncEntry.itemId,
      );

      return deleteSyncEntry(syncEntry);
    }
    final habit = await AppRepository.instance.localRepository.getHabit(
      syncEntry.itemId,
    );
    if (habit == null) return;
    if (syncEntry.action == SyncAction.create) {
      await AppRepository.instance.remoteRepository.createHabit(
        habit,
      );
      return deleteSyncEntry(syncEntry);
    } else if (syncEntry.action == SyncAction.update) {
      await AppRepository.instance.remoteRepository.updateHabit(
        habit,
      );
      return deleteSyncEntry(syncEntry);
    }
  }

  Future<void> deleteSyncEntry(SyncEntry syncEntry) async {
    await Hive.box<SyncEntry>('syncdata_box').delete(syncEntry.id);
  }
}

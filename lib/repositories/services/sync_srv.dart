import 'package:habit_quest/common.dart';
import 'package:habit_quest/modules/habits/services/habits_action_srv.dart';
import 'package:habit_quest/repositories/models/sync_entry.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:appwrite/models.dart' as models;

final syncServiceProvider =
    StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  return SyncNotifier(
    ref: ref,
    user: ref.watch(userServiceProvider),
  );
});

class SyncNotifier extends StateNotifier<SyncState> {
  SyncNotifier({required this.ref, required this.user})
      : super(const InactiveSyncState()) {
    if (user != null) init();
  }

  final Ref ref;
  final models.User? user;

  Future<void> init() async {
    state = const LoadingSyncState();
    await Future<void>.delayed(const Duration(seconds: 3));
    await initialSync();
    continuousSync();
  }

  Future<void> initialSync() async {
    final syncEntries = await validSyncEntries();
    await habitsInitialSync(
      syncEntries.where((e) => e.item == SyncItem.habit).toList(),
    );
    await habitsActionInitialSync(
      syncEntries.where((e) => e.item == SyncItem.habitActivity).toList(),
    );
  }

  Future<List<SyncEntry>> validSyncEntries() async {
    final pendingSyncEntries =
        Hive.box<SyncEntry>('syncdata_box').values.toList();

    final invalidSyncEntriesItemId = pendingSyncEntries.where((enty) {
      final obsolete = enty.action == SyncAction.delete &&
          pendingSyncEntries
              .where((e) => e.itemId == enty.itemId)
              .any((e) => e.action == SyncAction.create);
      return obsolete;
    }).map((e) => e.id);
    final invalidSyncEntries = pendingSyncEntries.where((entry) {
      return invalidSyncEntriesItemId.contains(entry.itemId);
    });
    await deleteSyncEntries(invalidSyncEntries.map((e) => e.id).toList());
    final validSyncEntries = pendingSyncEntries
        .where((entry) => !invalidSyncEntriesItemId.contains(entry.id))
        .toList();
    return validSyncEntries;
  }

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///

  Future<void> habitsActionInitialSync(List<SyncEntry> syncEntries) async {
    final List<HabitAction> remoteHabitsActions;

    try {
      remoteHabitsActions =
          await AppRepository.instance.remoteRepository.getHabitActions(
        user!.$id,
      );
    } catch (e) {
      print(e);
      setSyncFailed('Unable to fetch remote data');
      return;
    }

    final localHabitActions =
        await AppRepository.instance.localRepository.getHabitActions(
      user!.$id,
    );

    if (localHabitActions.isEmpty && remoteHabitsActions.isEmpty) {
      setSyncOk();
      return;
    }

    if (localHabitActions.isEmpty && remoteHabitsActions.isNotEmpty) {
      await AppRepository.instance.localRepository
          .createHabitActions(remoteHabitsActions);
      ref
          .read(habitsActionServiceProvider.notifier)
          .updateFromSync(remoteHabitsActions);
      setSyncOk();
      return;
    }

    final actions = getHabitActivitiesSyncActions(
      remoteActionHabits: remoteHabitsActions,
      localActionHabits: localHabitActions,
      pendingActions: syncEntries,
    );

    final remoteActions = actions.where((a) => !a.forLocal);
    final localActions = actions.where((a) => a.forLocal);

    await doActivityHabitLocalActions(localActions);

    final latestdata =
        await AppRepository.instance.localRepository.getHabitActions(
      user!.$id,
    );
    ref.read(habitsActionServiceProvider.notifier).updateFromSync(latestdata);

    try {
      await doActivityHabitRemoteActions(remoteActions);
      await deleteAllSyncEntries();
      setSyncOk();
    } catch (e) {
      print(e);
      setSyncFailed('Unable to sync remote data');
    }
  }

  List<({SyncAction action, HabitAction? data, bool forLocal})>
      getHabitActivitiesSyncActions({
    required List<HabitAction> remoteActionHabits,
    required List<HabitAction> localActionHabits,
    required List<SyncEntry> pendingActions,
  }) {
    final remoteMap = {for (final habit in remoteActionHabits) habit.id: habit};
    final localMap = {for (final habit in localActionHabits) habit.id: habit};
    final syncActions =
        <({SyncAction action, HabitAction? data, bool forLocal})>[];

    // Process pending actions
    for (final action in pendingActions) {
      final actionType = action.action;
      final habitId = action.itemId;
      final habitData = localMap[habitId];

      if (actionType == SyncAction.create) {
        // Create in remote if not exists
        if (!remoteMap.containsKey(habitId) && localMap.containsKey(habitId)) {
          syncActions.add(
            (action: SyncAction.create, data: habitData, forLocal: false),
          );
        }
      } else if (actionType == SyncAction.update) {
        // Update in remote if exists
        if (remoteMap.containsKey(habitId) && localMap.containsKey(habitId)) {
          syncActions.add(
            (action: SyncAction.update, data: habitData, forLocal: false),
          );
        }
      } else if (actionType == SyncAction.delete) {
        // Delete in remote if exists
        if (remoteMap.containsKey(habitId)) {
          syncActions.add(
            (
              action: SyncAction.delete,
              data: HabitAction.justId(habitId),
              forLocal: false
            ),
          );
        }
      }
    }

    // Check for discrepancies between local and remote
    for (final habit in remoteActionHabits) {
      final habitId = habit.id;
      if (!localMap.containsKey(habitId)) {
        // Missing locally, fetch from remote
        syncActions.add(
          (action: SyncAction.create, data: habit, forLocal: true),
        );
      }
    }

    for (final habit in localActionHabits) {
      final habitId = habit.id;
      if (!remoteMap.containsKey(habitId)) {
        // Missing remotely, push to remote
        syncActions.add(
          (action: SyncAction.create, data: habit, forLocal: false),
        );
      }
    }

    return syncActions;
  }

  Future<void> doActivityHabitLocalActions(
    Iterable<({SyncAction action, HabitAction? data, bool forLocal})> actions,
  ) async {
    final deleteActions = actions.where((a) => a.action == SyncAction.delete);
    final updateActions = actions.where((a) => a.action == SyncAction.update);
    final createActions = actions.where((a) => a.action == SyncAction.create);

    if (createActions.isNotEmpty || updateActions.isNotEmpty) {
      final nonEmptyHabits = createActions.where((a) => a.data != null);
      await AppRepository.instance.localRepository.createHabitActions(
        nonEmptyHabits.map((a) => a.data!).toList(),
      );
    }

    if (deleteActions.isNotEmpty) {
      final nonEmptyHabits = updateActions.where((a) => a.data != null);
      await AppRepository.instance.localRepository.deleteHabitActions(
        nonEmptyHabits.map((a) => a.data!.id).toList(),
      );
    }
  }

  Future<void> doActivityHabitRemoteActions(
    Iterable<({SyncAction action, HabitAction? data, bool forLocal})> actions,
  ) async {
    final deleteActions = actions.where((a) => a.action == SyncAction.delete);
    final updateActions = actions.where((a) => a.action == SyncAction.update);
    final createActions = actions.where((a) => a.action == SyncAction.create);

    if (createActions.isNotEmpty) {
      final nonEmptyHabits = createActions.where((a) => a.data != null);
      await AppRepository.instance.remoteRepository.createHabitActions(
        nonEmptyHabits.map((a) => a.data!).toList(),
      );
    }

    if (updateActions.isNotEmpty) {
      final nonEmptyHabits = createActions.where((a) => a.data != null);
      await AppRepository.instance.remoteRepository.updateHabitActions(
        nonEmptyHabits.map((a) => a.data!).toList(),
      );
    }

    if (deleteActions.isNotEmpty) {
      final nonEmptyHabits = updateActions.where((a) => a.data != null);
      await AppRepository.instance.remoteRepository.deleteHabitActions(
        nonEmptyHabits.map((a) => a.data!.id).toList(),
      );
    }
  }

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///

  Future<void> habitsInitialSync(List<SyncEntry> syncEntries) async {
    final List<Habit> remoteHabits;

    try {
      remoteHabits = await AppRepository.instance.remoteRepository.getHabits(
        user!.$id,
      );
    } catch (e) {
      print(e);
      setSyncFailed('Unable to fetch remote data');
      return;
    }

    final localHabits = await AppRepository.instance.localRepository.getHabits(
      user!.$id,
    );

    if (localHabits.isEmpty && remoteHabits.isEmpty) {
      setSyncOk();
      return;
    }

    if (localHabits.isEmpty && remoteHabits.isNotEmpty) {
      await AppRepository.instance.localRepository.createHabits(remoteHabits);
      ref.read(habitsServiceProvider.notifier).updateFromSync(remoteHabits);
      setSyncOk();
      return;
    }

    final actions = getHabitSyncActions(
      remoteHabits: remoteHabits,
      localHabits: localHabits,
      pendingActions: syncEntries,
    );

    final remoteActions = actions.where((a) => !a.forLocal);
    final localActions = actions.where((a) => a.forLocal);

    await doHabitLocalActions(localActions);

    final latestdata = await AppRepository.instance.localRepository.getHabits(
      user!.$id,
    );
    ref.read(habitsServiceProvider.notifier).updateFromSync(latestdata);

    try {
      await doHabitRemoteActions(remoteActions);
      await deleteAllSyncEntries();
      setSyncOk();
    } catch (e) {
      print(e);
      setSyncFailed('Unable to sync remote data');
    }
  }

  Future<void> doHabitRemoteActions(
    Iterable<({SyncAction action, Habit? data, bool forLocal})> actions,
  ) async {
    final deleteActions = actions.where((a) => a.action == SyncAction.delete);
    final updateActions = actions.where((a) => a.action == SyncAction.update);
    final createActions = actions.where((a) => a.action == SyncAction.create);

    if (createActions.isNotEmpty) {
      final nonEmptyHabits = createActions.where((a) => a.data != null);
      await AppRepository.instance.remoteRepository.createHabits(
        nonEmptyHabits.map((a) => a.data!).toList(),
      );
    }

    if (updateActions.isNotEmpty) {
      final nonEmptyHabits = createActions.where((a) => a.data != null);
      await AppRepository.instance.remoteRepository.updateHabits(
        nonEmptyHabits.map((a) => a.data!).toList(),
      );
    }

    if (deleteActions.isNotEmpty) {
      final nonEmptyHabits = updateActions.where((a) => a.data != null);
      await AppRepository.instance.remoteRepository.deleteHabits(
        nonEmptyHabits.map((a) => a.data!.id).toList(),
      );
    }
  }

  Future<void> doHabitLocalActions(
    Iterable<({SyncAction action, Habit? data, bool forLocal})> actions,
  ) async {
    final deleteActions = actions.where((a) => a.action == SyncAction.delete);
    final updateActions = actions.where((a) => a.action == SyncAction.update);
    final createActions = actions.where((a) => a.action == SyncAction.create);

    if (createActions.isNotEmpty || updateActions.isNotEmpty) {
      final nonEmptyHabits = createActions.where((a) => a.data != null);
      await AppRepository.instance.localRepository.createHabits(
        nonEmptyHabits.map((a) => a.data!).toList(),
      );
    }

    if (deleteActions.isNotEmpty) {
      final nonEmptyHabits = updateActions.where((a) => a.data != null);
      await AppRepository.instance.localRepository.deleteHabits(
        nonEmptyHabits.map((a) => a.data!.id).toList(),
      );
    }
  }

  List<({SyncAction action, Habit? data, bool forLocal})> getHabitSyncActions({
    required List<Habit> remoteHabits,
    required List<Habit> localHabits,
    required List<SyncEntry> pendingActions,
  }) {
    final remoteMap = {for (final habit in remoteHabits) habit.id: habit};
    final localMap = {for (final habit in localHabits) habit.id: habit};
    final syncActions = <({SyncAction action, Habit? data, bool forLocal})>[];

    // Process pending actions
    for (final action in pendingActions) {
      final actionType = action.action;
      final habitId = action.itemId;
      final habitData = localMap[habitId];

      if (actionType == SyncAction.create) {
        // Create in remote if not exists
        if (!remoteMap.containsKey(habitId) && localMap.containsKey(habitId)) {
          syncActions.add(
            (action: SyncAction.create, data: habitData, forLocal: false),
          );
        }
      } else if (actionType == SyncAction.update) {
        // Update in remote if exists
        if (remoteMap.containsKey(habitId) && localMap.containsKey(habitId)) {
          syncActions.add(
            (action: SyncAction.update, data: habitData, forLocal: false),
          );
        }
      } else if (actionType == SyncAction.delete) {
        // Delete in remote if exists
        if (remoteMap.containsKey(habitId)) {
          syncActions.add(
            (
              action: SyncAction.delete,
              data: Habit.justId(habitId),
              forLocal: false
            ),
          );
        }
      }
    }

    // Check for discrepancies between local and remote
    for (final habit in remoteHabits) {
      final habitId = habit.id;
      if (!localMap.containsKey(habitId)) {
        // Missing locally, fetch from remote
        syncActions.add(
          (action: SyncAction.create, data: habit, forLocal: true),
        );
      }
    }

    for (final habit in localHabits) {
      final habitId = habit.id;
      if (!remoteMap.containsKey(habitId)) {
        // Missing remotely, push to remote
        syncActions.add(
          (action: SyncAction.create, data: habit, forLocal: false),
        );
      }
    }

    return syncActions;
  }

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///

  setSyncOk() {
    state = SyncedSyncState(DateTime.now());
  }

  setSyncFailed(String message) {
    state = ErrorSyncState(message);
  }

  void continuousSync() {
    Hive.box<SyncEntry>('syncdata_box').watch().listen((event) async {
      if (event.deleted) return;
      final syncEntry = event.value;
      if (syncEntry is SyncEntry) {
        if (syncEntry.item == SyncItem.habit) {
          return handleHabitItemSync(syncEntry);
        }
        if (syncEntry.item == SyncItem.habitActivity) {
          return handleHabitActionSync(syncEntry);
        }
      }
    });
  }

  Future<void> handleHabitActionSync(SyncEntry syncEntry) async {
    if (syncEntry.action == SyncAction.delete) {
      await AppRepository.instance.remoteRepository.deleteHabitAction(
        syncEntry.itemId,
      );

      return deleteSyncEntry(syncEntry);
    }
    final habitAction =
        await AppRepository.instance.localRepository.getHabitAction(
      syncEntry.itemId,
    );
    if (habitAction == null) return;
    if (syncEntry.action == SyncAction.create) {
      await AppRepository.instance.remoteRepository.createHabitAction(
        habitAction,
      );
      return deleteSyncEntry(syncEntry);
    } else if (syncEntry.action == SyncAction.update) {
      await AppRepository.instance.remoteRepository.updateHabitAction(
        habitAction,
      );
      return deleteSyncEntry(syncEntry);
    }
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

  Future<void> deleteAllSyncEntries() async {
    await Hive.box<SyncEntry>('syncdata_box').clear();
  }

  Future<void> deleteSyncEntries(List<String> syncEntriesId) async {
    await Hive.box<SyncEntry>('syncdata_box').deleteAll(syncEntriesId);
  }
}

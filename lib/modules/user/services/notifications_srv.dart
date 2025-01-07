import 'package:flutter/foundation.dart';
import 'package:habit_quest/common.dart';

final notificationsServiceProvider =
    StateNotifierProvider<NotificationsNotifier, List<HabitNotification>>(
        (ref) {
  return NotificationsNotifier(
    ref: ref,
  );
});

class NotificationsNotifier extends StateNotifier<List<HabitNotification>> {
  NotificationsNotifier({required this.ref}) : super([]) {
    if (!kIsWeb) _init();
  }

  final Ref ref;

  Future<void> _init() async {
    final habits = ref.read(habitsServiceProvider).data();
    final processedNotifications = await processNotifications(habits ?? []);
    if (mounted) state = processedNotifications.good;
    await deleteNotifications(processedNotifications.toRemove);
    await createNotifications(processedNotifications.toAdd).then((value) {
      if (mounted) state = [...state, ...value];
    });
  }

  void reset() {
    state = [];
  }

  Future<List<HabitNotification>> createNotifications(
    List<HabitNotification> notifications,
  ) async {
    final created = <HabitNotification>[];
    for (final notification in notifications) {
      if (mounted) {
        try {
          await NotificationHelper.createNotification(notification.habit);
          created.add(notification);
        } catch (e) {
          print(e);
        }
      }
    }
    return created;
  }

  Future<void> deleteNotifications(List<int> notifications) async {
    for (final notificationId in notifications) {
      if (mounted) {
        try {
          await NotificationHelper.instance.cancel(notificationId);
        } catch (e) {
          print(e);
        }
      }
    }
  }

  Future<
      ({
        List<HabitNotification> good,
        List<HabitNotification> toAdd,
        List<int> toRemove,
      })> processNotifications(List<Habit> habits) async {
    final pendingNotificationData =
        await NotificationHelper.instance.pendingNotificationRequests();
    final activeNotificationsData =
        await NotificationHelper.instance.getActiveNotifications();
    final allNotifications = [
      ...pendingNotificationData.map((e) => (payload: e.payload, id: e.id)),
      ...activeNotificationsData.map((e) => (payload: e.payload, id: e.id)),
    ];
    final okHabitNotifications = <HabitNotification>[];
    final notificationsTobeRemoved = <int>[];
    final notificationsTobeAdded = <HabitNotification>[];

    for (final habit in habits) {
      final isOk = allNotifications.any((notification) {
        return (notification.payload == habit.id && habit.reminder) ||
            (notification.payload != habit.id && !habit.reminder);
      });

      if (isOk) {
        okHabitNotifications.add(HabitNotification(habit: habit));
        continue;
      }

      final needsCreation = allNotifications.any((notification) {
            return notification.payload != habit.id && habit.reminder;
          }) ||
          (allNotifications.isEmpty && habit.reminder);
      if (needsCreation) {
        notificationsTobeAdded.add(HabitNotification(habit: habit));
        continue;
      }

      final needsRemoval = allNotifications.any((notification) {
        return notification.payload == habit.id && !habit.reminder;
      });
      if (needsRemoval) {
        notificationsTobeRemoved.add(habit.notificationId);
      }
    }

    for (final notification in allNotifications) {
      final isOk = okHabitNotifications.any((habitNotification) {
        return habitNotification.habit.id == notification.payload;
      });
      if (!isOk) {
        notificationsTobeRemoved.add(notification.id ?? 0);
      }
    }

    return (
      good: okHabitNotifications,
      toRemove: notificationsTobeRemoved,
      toAdd: notificationsTobeAdded
    );
  }
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_quest/common.dart';
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // handle action
}

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin instance =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@drawable/ic_stat_name',
    );

    final initializationSettingsIOS = DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          'habitCategory',
          actions: [
            DarwinNotificationAction.plain(
              'markDone',
              'Done',
            ),
            DarwinNotificationAction.plain(
              'markSkip',
              'Skip',
            ),
          ],
          options: {
            DarwinNotificationCategoryOption.allowAnnouncement,
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        ),
      ],
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await instance.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    await instance
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> deleteAll() async {
    await instance.cancelAll();
  }

  static Future<void> createNotification(Habit habit) async {
    final title = habit.title;
    final body = 'In the next ${habit.reminderMinutes} minutes';
    final notificationId = habit.notificationId;
    final payload = habit.id;

    final timeofday = habit.timeValue().removeMinutes(habit.reminderMinutes);
    final time = DateTime.now().copyWith(
      day: habit.startDate.day,
      month: habit.startDate.month,
      hour: timeofday.hour,
      minute: timeofday.minute,
    );

    if (habit.frequency == HabitFrequency.daily) {
      return scheduledNotification(
        time: time,
        payload: payload,
        title: title,
        body: body,
        notificationId: notificationId,
        components: DateTimeComponents.time,
      );
    }
    if (habit.frequency == HabitFrequency.weekly) {
      // create loop for each day of the week
      return scheduledNotification(
        time: DateTime(
          habit.startDate.year,
          habit.startDate.month,
          habit.startDate.day,
          timeofday.hour,
          timeofday.minute,
        ),
        payload: payload,
        title: title,
        body: body,
        notificationId: notificationId,
        components: DateTimeComponents.dayOfWeekAndTime,
      );
    }

    if (habit.frequency == HabitFrequency.once) {
      return scheduledNotification(
        time: DateTime(
          habit.startDate.year,
          habit.startDate.month,
          habit.startDate.day,
          timeofday.hour,
          timeofday.minute,
        ),
        payload: payload,
        title: title,
        body: body,
        notificationId: notificationId,
        components: DateTimeComponents.dateAndTime,
      );
    }
  }

  static void onDidReceiveNotificationResponse(NotificationResponse response) {}

  static showInstantTest() async {
    const platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'testchannel',
        'Test Notification',
        color: AppTheme.primaryBlue,
        colorized: true,
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        largeIcon: DrawableResourceAndroidBitmap('app_icon'),
      ),
      iOS: DarwinNotificationDetails(),
    );

    await instance.show(
      0,
      'plain title',
      'plain body',
      platformChannelSpecifics,
    );
  }

  static Future<void> scheduledNotification({
    required DateTime time,
    required String title,
    required String body,
    required int notificationId,
    required String payload,
    required DateTimeComponents components,
  }) async {
    const platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'habitReminders',
        'Habit Reminders',
        channelDescription: 'Control each habit notification in the app',
        color: AppTheme.primaryBlue,
        colorized: true,
        importance: Importance.max,
        priority: Priority.high,
        largeIcon: DrawableResourceAndroidBitmap('app_icon'),
      ),
      iOS: DarwinNotificationDetails(
        threadIdentifier: 'habit_actions',
      ),
    );

    await instance.zonedSchedule(
      notificationId,
      title,
      body,
      payload: payload,
      tz.TZDateTime.from(time, tz.local),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: components,
    );
  }

  static showPlannedTest() async {
    const platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'testchannel',
        'Test Notification',
        channelDescription: 'your channel description',
        color: AppTheme.primaryBlue,
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(
        threadIdentifier: 'habit_actions',
      ),
    );
    final time = DateTime.now().add(const Duration(seconds: 2));

    await instance.zonedSchedule(
      0,
      'A scheduled notification',
      'Comes up in 3 minutes',
      tz.TZDateTime.from(time, tz.local),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}

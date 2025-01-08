import 'package:habit_quest/common.dart';

class NotificationSettingsPage extends ConsumerWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsServiceProvider);
    final active = notifications.where((element) => element.habit.reminder);
    final inactive =
        notifications.where((element) => !element.habit.reminder).toList();
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: const Text(
          'NOTIFICATIONS\nSETTINGS',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: AppTheme.poppinsFont,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          ref.invalidate(notificationsServiceProvider);
          return Future.value();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: maxPageWidth,
                ),
                child: Card(
                  color: theme.cardColor,
                  clipBehavior: Clip.hardEdge,
                  child: SwitchListTile(
                    title: Text(
                      'Notifications Enabled',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textTheme.bodyMedium!.color,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppTheme.poppinsFont,
                      ),
                    ),
                    subtitle: Text(
                      '''If you're experiencing problems try and enable them manually in the settings.''',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: AppTheme.poppinsFont,
                        color: theme.textTheme.bodyMedium!.color,
                      ),
                    ),
                    value: false,
                    onChanged: (value) async {},
                  ),
                ),
              ),
            ),
            if (active.isNotEmpty)
              sectionCard(active, 'ACTIVE', context, theme),
            if (inactive.isNotEmpty)
              sectionCard(inactive, 'IN-ACTIVE', context, theme),
          ],
        ),
      ),
    );
  }

  Widget sectionCard(
    Iterable<HabitNotification> active,
    String title,
    BuildContext context,
    ThemeData theme,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: maxPageWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Card(
            color: theme.cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTheme.poppinsFont,
                    ),
                  ),
                ),
                for (final notification in active) ...[
                  ListTile(
                    title: Text(
                      notification.habit.title,
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium!.color,
                        fontFamily: AppTheme.poppinsFont,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      context.push('/edit_habit/${notification.habit.id}');
                    },
                    subtitle: Text(
                      notification.habit.remainderTime(),
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodyMedium!.color,
                        fontFamily: AppTheme.poppinsFont,
                      ),
                    ),
                  ),
                  if (notification.habit.id != active.last.habit.id)
                    Divider(
                      thickness: .1,
                      endIndent: 16,
                      indent: 16,
                      color: theme.dividerColor,
                    ),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

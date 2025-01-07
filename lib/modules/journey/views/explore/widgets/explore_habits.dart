import 'package:habit_quest/common.dart';

class PopularHabits extends ConsumerWidget {
  const PopularHabits({
    required this.data,
    super.key,
  });
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (data.isEmpty) {
      return const SizedBox();
    }
    final habits =
        (data['habits'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (habits.isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['title'] as String,
            style: const TextStyle(
              fontFamily: AppTheme.poppinsFont,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Text(
            data['description'] as String,
            style: const TextStyle(
              fontFamily: AppTheme.poppinsFont,
              fontSize: 12,
            ),
          ),
          ListView.builder(
            itemCount: habits.length,
            padding: const EdgeInsets.only(top: 20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final habit = habits[index];
              final days = habit['days'] as List?;
              return Card(
                clipBehavior: Clip.hardEdge,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    title: Text(habit['name'] as String),
                    childrenPadding: const EdgeInsets.only(
                      bottom: 16,
                      top: 16,
                      left: 24,
                      right: 24,
                    ),
                    children: [
                      Row(
                        children: [
                          const Expanded(child: Text('Frequency')),
                          Text(habit['frequency'] as String),
                        ],
                      ),
                      const Divider(
                        thickness: .2,
                      ),
                      Row(
                        children: [
                          const Expanded(child: Text('Time')),
                          Text(habit['time'] as String),
                        ],
                      ),
                      if (days != null) ...[
                        const Divider(
                          thickness: .2,
                        ),
                        Row(
                          children: [
                            const Expanded(child: Text('Days')),
                            Text(days.join(', ')),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () {
                          onCreate(habit, context, ref);
                        },
                        style: FilledButton.styleFrom(
                          fixedSize: const Size.fromWidth(double.maxFinite),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text('Add to my habits'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void onCreate(
    Map<String, dynamic> habit,
    BuildContext context,
    WidgetRef ref,
  ) {
    context.showInfoLoad('Creating habit...');
    final days = (habit['days'] as List?)?.map((e) => e as String);
    ref
        .read(habitsServiceProvider.notifier)
        .createHabit(
          Habit(
            id: AppRepository.getUniqueID(),
            title: habit['display_name'] as String,
            emoji: habit['emoji'] as String,
            time: habit['time'] as String,
            startDate: DateTime.now(),
            days: days?.toList(),
            frequency: HabitFrequency.values.firstWhere(
              (e) => e.displayName == habit['frequency'] as String,
            ),
            paused: false,
            userId: ref.read(userServiceProvider)?.$id ?? '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            reminder: true,
            reminderMinutes: 10,
            notificationId: Habit.generateNotificationId(),
          ),
        )
        .then((_) {
      context
        ..pop()
        ..showSuccessToast('Habit added successfully');
    }).onError((error, stack) {
      debugPrint(error.toString());
      context
        ..pop()
        ..showErrorToast('Failed to create habit');
    });
  }
}

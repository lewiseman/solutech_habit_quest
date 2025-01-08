import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:habit_quest/common.dart';

class MyHabitsSection extends ConsumerWidget {
  const MyHabitsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsService = ref.watch(habitsServiceProvider);
    final habits = habitsService.data();
    if (habits == null || habits.isEmpty) {
      return emptyBanana(
        message: habits == null
            ? 'Your habits have not loaded yet'
            : 'You have no habits yet',
      );
    }
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 200),
      child: Column(
        children: [
          const SizedBox(height: 30),
          HeaderSummary(
            habits: habits,
            theme: theme,
          ),
          ListView.separated(
            shrinkWrap: true,
            itemCount: habits.length,
            padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final habit = habits[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: Text(habit.emoji),
                ),
                title: Text(
                  habit.title,
                  style: TextStyle(
                    fontFamily: AppTheme.poppinsFont,
                    color: theme.textTheme.bodyMedium!.color,
                  ),
                ),
                trailing: habit.paused
                    ? Container(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.amber.shade200,
                          ),
                        ),
                        child: Text(
                          'PAUSED',
                          style: TextStyle(
                            color: Colors.amber.shade900,
                            fontFamily: AppTheme.poppinsFont,
                          ),
                        ),
                      )
                    : null,
                subtitle: Text(
                  '''${habit.frequency.displayName} • ${habit.timeValue().format(context)}''',
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium!.color,
                  ),
                ),
                onTap: () => onHabitTap(context, habit, ref),
              );
            },
            separatorBuilder: (context, index) => const Divider(
              thickness: .2,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  onHabitTap(BuildContext context, Habit habit, WidgetRef ref) async {
    final res = await showCupertinoModalPopup<String>(
      context: context,
      builder: (context) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxPageWidth),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: CupertinoActionSheet(
              title: Text(habit.title),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context, 'pause');
                  },
                  child: Text(
                    habit.paused ? 'Un-pause' : 'Pause',
                    style: const TextStyle(
                      fontFamily: AppTheme.poppinsFont,
                    ),
                  ),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context, 'edit');
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      fontFamily: AppTheme.poppinsFont,
                    ),
                  ),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context, 'delete');
                  },
                  isDestructiveAction: true,
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      fontFamily: AppTheme.poppinsFont,
                    ),
                  ),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: AppTheme.poppinsFont,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    if (res != null) {
      if (res == 'edit') {
        context.push('/edit_habit/${habit.id}');
      } else if (res == 'pause') {
        context.showInfoLoad('Pausing habit');
        unawaited(
          ref.read(habitsServiceProvider.notifier).pauseHabit(habit).then((_) {
            context.pop();
          }).onError((error, stack) {
            context
              ..pop()
              ..showErrorToast(error.toString());
          }),
        );
      } else if (res == 'delete') {
        context.showInfoLoad('Deleting habit');
        unawaited(
          ref.read(habitsServiceProvider.notifier).deleteHabit(habit).then((_) {
            context.pop();
          }).onError((error, stack) {
            context
              ..pop()
              ..showErrorToast(error.toString());
          }),
        );
      }
    }
  }
}

class HeaderSummary extends StatelessWidget {
  const HeaderSummary({
    required this.habits,
    required this.theme,
    super.key,
  });
  final List<Habit> habits;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(.06),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text(
                  'TOTAL',
                  style: TextStyle(
                    fontFamily: AppTheme.poppinsFont,
                  ),
                ),
                Text(
                  habits.length.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTheme.poppinsFont,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text(
                  'ACTIVE',
                  style: TextStyle(
                    fontFamily: AppTheme.poppinsFont,
                  ),
                ),
                Text(
                  habits.where((e) => !e.paused).length.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTheme.poppinsFont,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text(
                  'PAUSED',
                  style: TextStyle(
                    fontFamily: AppTheme.poppinsFont,
                  ),
                ),
                Text(
                  habits.where((e) => e.paused).length.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTheme.poppinsFont,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

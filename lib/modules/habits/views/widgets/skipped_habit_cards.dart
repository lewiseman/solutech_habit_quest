import 'package:flutter/cupertino.dart';
import 'package:habit_quest/common.dart';

class SkippedHabitCards extends StatelessWidget {
  const SkippedHabitCards({
    required this.actionHabits,
    required this.selectedDate,
    required this.ref,
    super.key,
  });
  final List<({HabitAction action, Habit habit})> actionHabits;
  final DateTime selectedDate;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final isdarkmode = context.isDarkMode;
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SKIPPED',
            style: TextStyle(
              fontSize: 16,
              fontFamily: AppTheme.poppinsFont,
              color: Colors.grey,
            ),
          ),
          for (var i = 0; i < actionHabits.length; i++)
            () {
              final actionHabit = actionHabits[i];
              return Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isdarkmode
                      ? Colors.grey.shade900.withOpacity(.5)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isdarkmode
                        ? Colors.grey.shade300.withOpacity(.3)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      actionHabit.habit.emoji,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            actionHabit.habit.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppTheme.poppinsFont,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                          ),
                          Text(
                            actionHabit.habit.timeValue().format(context),
                            style: const TextStyle(
                              fontFamily: AppTheme.poppinsFont,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        final today = DateTime.now();
                        final showComplete = selectedDate.day == today.day &&
                            selectedDate.month == today.month &&
                            selectedDate.year == today.year;
                        showCupertinoModalPopup<void>(
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: CupertinoActionSheet(
                                title: Text(
                                  actionHabit.habit.title,
                                  style: const TextStyle(
                                    fontFamily: AppTheme.poppinsFont,
                                  ),
                                ),
                                actions: [
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ref
                                          .read(
                                            habitsActionServiceProvider
                                                .notifier,
                                          )
                                          .undoCompletedAction(
                                            actionHabit.action,
                                          )
                                          .onError((error, stack) {
                                        context.showErrorToast(
                                          'Unable to perform action',
                                        );
                                      });
                                    },
                                    child: const Text(
                                      'Undo',
                                      style: TextStyle(
                                        fontFamily: AppTheme.poppinsFont,
                                      ),
                                    ),
                                  ),
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      context
                                        ..pop()
                                        ..push(
                                          '/edit_habit/${actionHabit.habit.id}',
                                        );
                                    },
                                    child: const Text(
                                      'Edit',
                                      style: TextStyle(
                                        fontFamily: AppTheme.poppinsFont,
                                      ),
                                    ),
                                  ),
                                  if (showComplete)
                                    CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        ref
                                            .read(
                                              habitsActionServiceProvider
                                                  .notifier,
                                            )
                                            .skipToCompletion(
                                              actionHabit.action,
                                            )
                                            .onError((error, stack) {
                                          context.showErrorToast(
                                            'Unable to perform action',
                                          );
                                        });
                                      },
                                      child: const Text(
                                        'Completed',
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
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        CustomIcons.next,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }(),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:habit_quest/common.dart';
import 'package:intl/intl.dart';

class CompletedHabitCards extends StatelessWidget {
  const CompletedHabitCards({
    required this.actionHabits,
    required this.ref,
    super.key,
  });
  final List<({HabitAction action, Habit habit})> actionHabits;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final isdarkmode = context.isDarkMode;
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'COMPLETED',
            style: TextStyle(
              fontSize: 16,
              fontFamily: AppTheme.poppinsFont,
              color: Colors.green,
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
                      ? Colors.green.shade900.withOpacity(.5)
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade300),
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
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppTheme.poppinsFont,
                            ),
                            maxLines: 1,
                          ),
                          Text(
                            '''COMPLETED AT ${DateFormat.jm().format(actionHabit.action.updatedAt)}''',
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showCupertinoModalPopup(
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
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ref
                                          .read(
                                            habitsActionServiceProvider
                                                .notifier,
                                          )
                                          .skipAction(
                                            actionHabit.action,
                                          )
                                          .onError((error, stack) {
                                        context.showErrorToast(
                                          'Unable to perform action',
                                        );
                                      });
                                    },
                                    child: const Text(
                                      'Skipped',
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
                        CustomIcons.checklist,
                        color: Colors.green,
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

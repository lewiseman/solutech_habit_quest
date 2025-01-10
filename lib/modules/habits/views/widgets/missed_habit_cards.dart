import 'package:flutter/cupertino.dart';
import 'package:habit_quest/common.dart';

class MissedHabitCards extends StatelessWidget {
  const MissedHabitCards({required this.habits, required this.ref, super.key});
  final List<Habit> habits;
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
            'MISSED',
            style: TextStyle(
              fontSize: 16,
              fontFamily: AppTheme.poppinsFont,
              color: Colors.red,
            ),
          ),
          for (var i = 0; i < habits.length; i++)
            () {
              final habit = habits[i];
              return Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isdarkmode
                      ? Colors.red.shade900.withOpacity(.3)
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Row(
                  children: [
                    Text(
                      habit.emoji,
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
                            habit.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppTheme.poppinsFont,
                            ),
                            maxLines: 1,
                          ),
                          Text(
                            habit.timeValue().format(context),
                            style: const TextStyle(
                              fontFamily: AppTheme.poppinsFont,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showCupertinoModalPopup<void>(
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: CupertinoActionSheet(
                                title: Text(
                                  habit.title,
                                  style: const TextStyle(
                                    fontFamily: AppTheme.poppinsFont,
                                  ),
                                ),
                                actions: [
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      context
                                        ..pop()
                                        ..push(
                                          '/edit_habit/${habit.id}',
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
                                          .createSkipAction(
                                            habit,
                                          )
                                          .onError((error, stack) {
                                        context.showErrorToast(
                                          'Unable to perform action',
                                        );
                                      });
                                    },
                                    child: const Text(
                                      'Skip',
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
                                          .sendCompleteAction(
                                            habit,
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
                        CustomIcons.arrow_miss,
                        color: Colors.red,
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

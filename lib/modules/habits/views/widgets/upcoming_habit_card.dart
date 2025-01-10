import 'package:flutter/cupertino.dart';
import 'package:habit_quest/common.dart';

class UpcomingHabitCard extends StatelessWidget {
  const UpcomingHabitCard({
    required this.habits,
    required this.ref,
    required this.selectedDate,
    super.key,
    this.title,
  });
  final String? title;
  final List<Habit> habits;
  final WidgetRef ref;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title!,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: AppTheme.poppinsFont,
              ),
            ),
          for (var i = 0; i < habits.length; i++)
            () {
              final habit = habits[i];
              return Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.dividerColor.withOpacity(.3)),
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
                                      Navigator.pop(context);
                                      if (title == null) {
                                        ref
                                            .read(
                                              habitsActionServiceProvider
                                                  .notifier,
                                            )
                                            .skipFutureAction(
                                              habit,
                                              selectedDate,
                                            )
                                            .onError((error, stack) {
                                          context.showErrorToast(
                                            'Unable to perform action',
                                          );
                                        });
                                      } else {
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
                                      }
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
                                  if (title == 'UPCOMING')
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
                                            .then((_) {
                                          ref
                                              .read(
                                                authServiceProvider.notifier,
                                              )
                                              .addCoin(context);
                                        }).onError((error, stack) {
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
                      icon: Icon(
                        CustomIcons.upcoming,
                        color: theme.textTheme.bodyMedium!.color,
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

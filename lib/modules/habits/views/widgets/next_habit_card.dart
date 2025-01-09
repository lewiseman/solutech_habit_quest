import 'package:flutter/cupertino.dart';
import 'package:habit_quest/common.dart';

class NextHabitCard extends StatelessWidget {
  const NextHabitCard({
    required this.habit,
    required this.openedHabitId,
    required this.ref,
    required this.updateOpened,
    super.key,
  });
  final Habit habit;
  final String? openedHabitId;
  final WidgetRef ref;
  final void Function(String? value) updateOpened;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: Material(
        color: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          onTap: () {
            if (openedHabitId == habit.id) {
              updateOpened(null);
            } else {
              updateOpened(habit.id);
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'NEXT ITEM ?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      habit.timeValue().format(context),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: AppTheme.poppinsFont,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
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
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                          ),
                          Text(
                            'IN THE NEXT ${habit.timeValue().remainingStr().toUpperCase()}',
                            style: const TextStyle(
                              fontFamily: AppTheme.poppinsFont,
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 2),
                    if (openedHabitId != habit.id)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          CustomIcons.trace,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
                if (openedHabitId == habit.id)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: FilledButton(
                                onPressed: () {
                                  ref
                                      .read(
                                        habitsActionServiceProvider.notifier,
                                      )
                                      .sendCompleteAction(habit)
                                      .then((_) {
                                    updateOpened(null);

                                    ref
                                        .read(userServiceProvider.notifier)
                                        .addCoin(context);
                                  }).onError((error, stack) {
                                    context.showErrorToast(
                                      'Failed to perform action',
                                    );
                                  });
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      CustomIcons.trace,
                                      color: Colors.white,
                                    ),
                                    Text('DONE'),
                                    SizedBox.shrink(),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            FilledButton(
                              onPressed: () {
                                showCupertinoModalPopup(
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
                                                fontFamily:
                                                    AppTheme.poppinsFont,
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
                                                fontFamily:
                                                    AppTheme.poppinsFont,
                                              ),
                                            ),
                                          ),
                                        ],
                                        cancelButton:
                                            CupertinoActionSheetAction(
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
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child:
                                  const Icon(Icons.keyboard_arrow_down_rounded),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

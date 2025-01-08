import 'package:flutter/cupertino.dart';
import 'package:habit_quest/common.dart';
import 'package:intl/intl.dart';

class HabitsPage extends ConsumerStatefulWidget {
  const HabitsPage({super.key});

  static AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      scrolledUnderElevation: 1,
      shadowColor: Colors.black,
      leading: Image.asset('assets/images/banana/hero.png'),
      centerTitle: false,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HABIT QUEST',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text('Friday, 12 March 2021', style: TextStyle(fontSize: 12)),
        ],
      ),
      actions: [
        IconButton.outlined(
          padding: const EdgeInsets.all(6),
          constraints: const BoxConstraints(),
          onPressed: () {
            // NotificationHelper.showPlannedTest();
            context.showInfoLoad('Loading ...');
          },
          icon: const Icon(CustomIcons.calendar, size: 20),
        ),
      ],
    );
  }

  @override
  ConsumerState<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends ConsumerState<HabitsPage> {
  DateTime selectedDate = DateTime.now();
  String? openedHabitId;
  @override
  Widget build(BuildContext context) {
    final habitsState = ref.watch(habitsServiceProvider);
    final habitActions = ref.watch(habitsActionServiceProvider);
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () {
          ref.invalidate(habitsServiceProvider);
        });
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 200),
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 16),
            HorizontalWeekCalendar(
              minDate: DateTime(2023, 12, 31),
              maxDate: DateTime(2025, 1, 10),
              selectedDate: selectedDate,
              onDateChange: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
              onWeekChange: (p0) {
                print('New week \n\n$p0');
              },
              showTopNavbar: false,
              monthFormat: 'MMMM yyyy',
              activeNavigatorColor: Colors.deepPurple,
              inactiveNavigatorColor: Colors.grey,
              monthColor: Colors.deepPurple,
            ),
            const SizedBox(height: 24),
            ...() {
              if (habitsState is LoadingHabitsState) {
                return [
                  SizedBox(
                    height: 320,
                    child: bananaSearch(message: 'Loading habits ...'),
                  ),
                ];
              }

              if (habitsState is DataHabitsState) {
                final habits = habitsState.habits.where((habit) {
                  return habit.relevant(selectedDate);
                }).toList();
                if (habits.isEmpty) {
                  return [
                    SizedBox(
                      height: 300,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: emptyBanana(
                          message:
                              '''Nothing for today\nCreate a habit from the  bottom right button''',
                        ),
                      ),
                    ),
                  ];
                }

                habits.sort((a, b) => a.time.compareTo(b.time));
                final todaysActions = habitActions.where((action) {
                  return action.createdAt.day == selectedDate.day &&
                      action.createdAt.month == selectedDate.month &&
                      action.createdAt.year == selectedDate.year;
                });
                final remainingHabits = () {
                  if (habits.isEmpty) {
                    return <Habit>[];
                  }
                  final remainingHabits = habits.where((habit) {
                    final now = TimeOfDay.now();
                    final hasPassed = habit.timeValue().compareTo(now);
                    return hasPassed > 0;
                  }).toList();
                  final withNoActions = remainingHabits.where((habit) {
                    return todaysActions.every((action) {
                      return action.habitId != habit.id;
                    });
                  }).toList();
                  final today = DateTime.now();
                  if (selectedDate.day == today.day) {
                    return withNoActions;
                  }
                  return <Habit>[];
                }();

                final actionedHabits = () {
                  final withaction = habits.where((habit) {
                    return habitActions.any((action) {
                      return action.habitId == habit.id &&
                          action.createdAt.day == selectedDate.day &&
                          action.createdAt.month == selectedDate.month &&
                          action.createdAt.year == selectedDate.year;
                    });
                  }).toList();
                  return withaction;
                }();

                final actionedHabitsWithActions = () {
                  final habitsAction = actionedHabits.map((habit) {
                    final action = todaysActions.firstWhere((action) {
                      return habit.id == action.habitId;
                    });
                    return (habit: habit, action: action);
                  }).toList();
                  return habitsAction;
                }();
                final completedHabits = () {
                  final thehabits = actionedHabitsWithActions.where((habit) {
                    return habit.action.action == HabitActionType.done;
                  }).toList();
                  return thehabits;
                }();

                final skippedHabits = () {
                  final thehabits = actionedHabitsWithActions.where((habit) {
                    return habit.action.action == HabitActionType.skipped;
                  }).toList();
                  return thehabits;
                }();

                final upcomingHabits = () {
                  if (remainingHabits.length <= 1) {
                    return null;
                  }
                  return remainingHabits.sublist(1);
                }();

                final nextHabit = () {
                  if (remainingHabits.isEmpty) {
                    return null;
                  }
                  return remainingHabits.first;
                }();

                final futureHabits = () {
                  final today = DateTime.now();
                  if (selectedDate.day <= today.day) {
                    return null;
                  }
                  final notSkipped = habits.where((habit) {
                    return skippedHabits.every((action) {
                      return habit.id != action.habit.id;
                    });
                  }).toList();
                  return notSkipped;
                }();

                final missedHabits = () {
                  final filter1 = habits.where((habit) {
                    final inupcoming = (upcomingHabits ?? []).any((upcoming) {
                      return habit.id == upcoming.id;
                    });
                    return !inupcoming;
                  });

                  final filter2 = filter1.where((habit) {
                    final incompleted = completedHabits.any((upcoming) {
                      return habit.id == upcoming.habit.id;
                    });
                    return !incompleted;
                  });

                  final filter3 = filter2.where((habit) {
                    return habit.id != nextHabit?.id;
                  });

                  final filter4 = filter3.where((habit) {
                    final incompleted = skippedHabits.any((upcoming) {
                      return habit.id == upcoming.habit.id;
                    });
                    return !incompleted;
                  });

                  final filter5 = filter4.where((habit) {
                    final incompleted = (futureHabits ?? []).any((future) {
                      return habit.id == future.id;
                    });
                    return !incompleted;
                  });

                  final res = filter5;
                  return res.toList();
                }();
                return [
                  if (nextHabit != null) nextCard(habit: nextHabit),
                  if (upcomingHabits != null && upcomingHabits.isNotEmpty)
                    upcomingCards(
                      habits: upcomingHabits,
                      context: context,
                      title: 'UPCOMING',
                    ),
                  if (futureHabits != null && futureHabits.isNotEmpty)
                    upcomingCards(
                      habits: futureHabits,
                      context: context,
                    ),
                  if (missedHabits.isNotEmpty)
                    missedCards(
                      habits: missedHabits,
                    ),
                  if (skippedHabits.isNotEmpty)
                    skippedCards(
                      actionHabits: skippedHabits,
                    ),
                  if (completedHabits.isNotEmpty)
                    completedCard(
                      actionHabits: completedHabits,
                    ),
                ];
              }

              return [const SizedBox.shrink()];
            }(),
          ],
        ),
      ),
    );
  }

  Widget missedCards({
    required List<Habit> habits,
  }) {
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
                  color: Colors.red.shade50,
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

  Widget completedCard({
    required List<({HabitAction action, Habit habit})> actionHabits,
  }) {
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
                  color: Colors.green.shade50,
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

  Widget skippedCards({
    required List<({HabitAction action, Habit habit})> actionHabits,
  }) {
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
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
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

  Widget upcomingCards({
    required List<Habit> habits,
    required BuildContext context,
    String? title,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
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
                      icon: const Icon(CustomIcons.upcoming),
                    ),
                  ],
                ),
              );
            }(),
        ],
      ),
    );
  }

  Widget nextCard({required Habit habit}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: Material(
        color: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          onTap: () {
            if (openedHabitId == habit.id) {
              setState(() {
                openedHabitId = null;
              });
            } else {
              setState(() {
                openedHabitId = habit.id;
              });
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
                                    setState(() {
                                      openedHabitId = null;
                                    });
                                    ref
                                        .read(rewardsServiceProvider.notifier)
                                        .activityCompleted(context);
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

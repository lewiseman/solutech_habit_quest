import 'package:habit_quest/common.dart';

class HabitsPage extends ConsumerStatefulWidget {
  const HabitsPage({super.key});

  static AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // leading: const Padding(
      //   padding: EdgeInsets.all(8),
      //   child: Icon(
      //     CustomIcons.habit_quest,
      //     color: AppTheme.primaryBlue,
      //   ),
      // ),
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
          onPressed: () {},
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
  @override
  Widget build(BuildContext context) {
    final habitsState = ref.watch(habitsServiceProvider);
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
                habits.sort((a, b) => a.time.compareTo(b.time));
                final remainingHabits = () {
                  if (habits.isEmpty) {
                    return <Habit>[];
                  }
                  final remainingHabits = habits.where((habit) {
                    final now = TimeOfDay.now();
                    final hasPassed = habit.timeValue().compareTo(now);
                    return hasPassed > 0;
                  }).toList();
                  final today = DateTime.now();
                  if (selectedDate.day == today.day) {
                    return remainingHabits;
                  }
                  return <Habit>[];
                }();
                final upcomingHabits = () {
                  if (remainingHabits.length <= 1) {
                    return null;
                  }
                  return remainingHabits.sublist(0, remainingHabits.length - 1);
                }();

                final nextHabit = () {
                  if (remainingHabits.isEmpty) {
                    return null;
                  }
                  return remainingHabits.last;
                }();

                final futureHabits = () {
                  final today = DateTime.now();
                  if (selectedDate.day <= today.day) {
                    return null;
                  }
                  return habits;
                }();
                return [
                  if (nextHabit != null) nextCard(habit: nextHabit),
                  if (upcomingHabits != null)
                    upcomingCards(
                      habits: upcomingHabits,
                      context: context,
                      title: 'UPCOMING',
                    ),
                  if (futureHabits != null)
                    upcomingCards(
                      habits: futureHabits,
                      context: context,
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
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
                        for (var i = 0; i < 2; i++)
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade300),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  '💪🏼',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Evening Walk',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                      ),
                                      Text('6:00 PM'),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    CustomIcons.arrow_miss,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
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
                        for (var i = 0; i < 2; i++)
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade300),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  '💪🏼',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Evening Walk',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                      ),
                                      Text('6:00 PM'),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    CustomIcons.checklist,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
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
                      onPressed: () {},
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
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NEXT ITEM ?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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
        ],
      ),
    );
  }
}

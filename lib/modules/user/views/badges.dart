import 'package:habit_quest/common.dart';

class BadgesPage extends ConsumerWidget {
  const BadgesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsState = ref.watch(habitsServiceProvider);
    final habitActions = ref.watch(habitsActionServiceProvider);
    final habits = () {
      if (habitsState is DataHabitsState) {
        return habitsState.habits;
      }
      return <Habit>[];
    }();
    final badges = badgesCalc(habits: habits, actions: habitActions);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 1,
        shadowColor: Colors.black,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'BADGES',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: AppTheme.poppinsFont,
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: maxPageWidth,
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Wrap(
                runSpacing: 16,
                spacing: 16,
                children: [
                  for (final badge in badges)
                    SizedBox(
                      width: 100,
                      child: Column(
                        children: [
                          if (!badge.achieved)
                            ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                Colors.grey.withOpacity(0.5),
                                BlendMode.srcIn,
                              ),
                              child: Image.asset(
                                badge.image,
                                height: 100,
                                width: 100,
                              ),
                            )
                          else
                            Image.asset(
                              badge.image,
                              height: 100,
                              width: 100,
                            ),
                          Text(
                            badge.title.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: AppTheme.poppinsFont,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<({String description, String image, String title, bool achieved})>
    badgesCalc({
  required List<Habit> habits,
  required List<HabitAction> actions,
}) {
  return [
    (
      title: 'First Habit Completed',
      description: '',
      achieved: () {
        return actions
            .where((action) => action.action == HabitActionType.done)
            .isNotEmpty;
      }(),
      image: 'assets/images/banana/money.png'
    ),
    (
      title: 'First Habit Created',
      description: '',
      achieved: () {
        return habits.isNotEmpty;
      }(),
      image: 'assets/images/banana/money.png'
    ),
    (
      title: 'Perfect Week',
      description: '',
      achieved: () {
        final today = DateTime.now();
        final lastWeek = today.subtract(const Duration(days: 7));
        final actionsLastWeek = actions.where((action) {
          return action.createdAt.isAfter(lastWeek) &&
              action.createdAt.isBefore(today);
        });
        final actionsLastWeekCount = actionsLastWeek.length;
        return actionsLastWeekCount == 7;
      }(),
      image: 'assets/images/banana/money.png'
    ),
    (
      title: 'Perfect Month',
      description: '',
      achieved: () {
        final today = DateTime.now();
        final lastMonth = today.subtract(const Duration(days: 30));
        final actionsLastMonth = actions.where((action) {
          return action.createdAt.isAfter(lastMonth) &&
              action.createdAt.isBefore(today);
        });
        final actionsLastMonthCount = actionsLastMonth.length;
        return actionsLastMonthCount >= 28;
      }(),
      image: 'assets/images/banana/money.png'
    ),
  ];
}

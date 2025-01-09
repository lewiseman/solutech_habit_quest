import 'package:habit_quest/common.dart';
import 'package:habit_quest/modules/habits/views/calc_data.dart';
import 'package:habit_quest/modules/habits/views/widgets/completed_habit_cards.dart';
import 'package:habit_quest/modules/habits/views/widgets/missed_habit_cards.dart';
import 'package:habit_quest/modules/habits/views/widgets/next_habit_card.dart';
import 'package:habit_quest/modules/habits/views/widgets/skipped_habit_cards.dart';
import 'package:habit_quest/modules/habits/views/widgets/upcoming_habit_card.dart';
import 'package:intl/intl.dart';

final selectedHabitDate = StateProvider((ref) => DateTime.now());

class HabitsPage extends ConsumerStatefulWidget {
  const HabitsPage({super.key});

  static AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      scrolledUnderElevation: 1,
      shadowColor: Colors.black,
      leading: Image.asset('assets/images/banana/hero.png'),
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'HABIT QUEST',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Consumer(
            builder: (context, ref, _) {
              final date = ref.watch(selectedHabitDate);
              return Text(
                DateFormat('EEEE, d MMMM yyyy').format(date),
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: AppTheme.poppinsFont,
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        Consumer(
          builder: (context, ref, _) {
            return IconButton.outlined(
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(),
              onPressed: () {
                NotificationHelper.showInstantTest();
                // showDatePicker(
                //   context: context,
                //   firstDate: DateTime(2024),
                //   currentDate: ref.read(selectedHabitDate),
                //   lastDate: DateTime(2028),
                // ).then((value) {
                //   if (value != null) {
                //     ref.read(selectedHabitDate.notifier).update(
                //           (state) => value,
                //         );
                //   }
                // });
              },
              icon: const Icon(CustomIcons.calendar, size: 20),
            );
          },
        ),
      ],
    );
  }

  @override
  ConsumerState<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends ConsumerState<HabitsPage> {
  String? openedHabitId;
  @override
  Widget build(BuildContext context) {
    final habitsState = ref.watch(habitsServiceProvider);
    final habitActions = ref.watch(habitsActionServiceProvider);
    final selectedDate = ref.watch(selectedHabitDate);
    final isdesktop = context.isDesktop();
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1), () {
          ref.invalidate(habitsServiceProvider);
        });
      },
      child: ListView(
        padding: const EdgeInsets.only(bottom: 200),
        physics: const ClampingScrollPhysics(),
        children: [
          const SizedBox(height: 16),
          HorizontalWeekCalendar(
            weekStartFrom: WeekStartFrom.sunday,
            key: ValueKey(selectedDate),
            minDate: DateTime(2024),
            maxDate: DateTime(
              2028,
            ),
            selectedDate: selectedDate,
            onDateChange: (date) {
              ref.read(selectedHabitDate.notifier).update((state) => date);
            },
            showTopNavbar: isdesktop,
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

              final calcdata = HabitsCalcData(
                habits: habits,
                selectedDate: selectedDate,
                habitActions: habitActions,
              );

              return [
                if (calcdata.nextHabit != null)
                  NextHabitCard(
                    habit: calcdata.nextHabit!,
                    openedHabitId: openedHabitId,
                    ref: ref,
                    updateOpened: (id) => setState(() {
                      openedHabitId = id;
                    }),
                  ),
                if (calcdata.upcomingHabits.isNotEmpty)
                  UpcomingHabitCard(
                    habits: calcdata.upcomingHabits,
                    ref: ref,
                    selectedDate: selectedDate,
                    title: 'UPCOMING',
                  ),
                if (calcdata.futureHabits.isNotEmpty)
                  UpcomingHabitCard(
                    habits: calcdata.futureHabits,
                    ref: ref,
                    selectedDate: selectedDate,
                  ),
                if (calcdata.missedHabits.isNotEmpty)
                  MissedHabitCards(
                    habits: calcdata.missedHabits,
                    ref: ref,
                  ),
                if (calcdata.skippedHabits.isNotEmpty)
                  SkippedHabitCards(
                    actionHabits: calcdata.skippedHabits,
                    ref: ref,
                    selectedDate: selectedDate,
                  ),
                if (calcdata.completedHabits.isNotEmpty)
                  CompletedHabitCards(
                    actionHabits: calcdata.completedHabits,
                    ref: ref,
                  ),
              ];
            }

            return [const SizedBox.shrink()];
          }(),
        ],
      ),
    );
  }
}

import 'package:habit_quest/common.dart';
import 'package:intl/intl.dart';

class CreateHabitPage extends ConsumerStatefulWidget {
  const CreateHabitPage({super.key, this.habitId}) : isEdit = habitId != null;
  final bool isEdit;
  final String? habitId;

  @override
  ConsumerState<CreateHabitPage> createState() => _CreateHabitPageState();
}

class _CreateHabitPageState extends ConsumerState<CreateHabitPage> {
  final days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  HabitFrequency selectedFrequency = HabitFrequency.daily;
  List<String> selectedDays = [];
  TimeOfDay selectedTime = TimeOfDay.fromDateTime(DateTime.now());
  DateTime startDate = DateTime.now();
  String emoji = '🙂';
  final titleController = TextEditingController();
  String titleValue = '';

  void onCreate() {
    if (selectedFrequency == 'Weekly' && selectedDays.isEmpty) {
      AppDialog.alert(
        context,
        title: 'No days selected',
        message: 'Please select at least one day',
      );
      return;
    }
    context.showInfoLoad('Creating habit...');
    ref
        .read(habitsServiceProvider.notifier)
        .createHabit(
          Habit(
            id: AppRepository.getUniqueID(),
            title: titleController.text.trim(),
            emoji: emoji,
            time: selectedTime,
            startDate: startDate,
            days: selectedDays.join(','),
            frequency: selectedFrequency,
          ),
        )
        .then((_) {
      context
        ..pop()
        ..pop()
        ..showSuccessToast('Habit created successfully');
    }).onError((error, stack) {
      context
        ..pop()
        ..showErrorToast('Failed to create habit');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black,
        scrolledUnderElevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            Material(
              color: Colors.white,
              elevation: .8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  EmojiPicker.pick(context).then((res) {
                    if (res != null && res.isNotEmpty) {
                      setState(() {
                        emoji = res;
                      });
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 14,
                  ),
                  child: Text(
                    emoji,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50, top: 20),
              child: TextField(
                controller: titleController,
                onChanged: (value) => setState(() {
                  titleValue = value;
                }),
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppTheme.poppinsFont,
                  fontSize: 20,
                ),
                minLines: 1,
                maxLines: 4,
                maxLength: 100,
                decoration: const InputDecoration(
                  labelText: 'eg. Drink water',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  alignLabelWithHint: true,
                  hintText: '',
                  labelStyle: TextStyle(
                    fontFamily: AppTheme.poppinsFont,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: .8,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Frequency',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: AppTheme.poppinsFont,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          for (int i = 0; i < HabitFrequency.values.length; i++)
                            ...() {
                              final selected =
                                  selectedFrequency == HabitFrequency.values[i];
                              return [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedFrequency =
                                            HabitFrequency.values[i];
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: selected
                                          ? AppTheme.primaryBlue
                                          : Colors.white,
                                      foregroundColor: selected
                                          ? Colors.white
                                          : AppTheme.primaryBlue,
                                      side: BorderSide(
                                        color: AppTheme.primaryBlue,
                                        width: selected ? 0 : 1,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      HabitFrequency.values[i].displayName,
                                      style: const TextStyle(
                                        fontFamily: AppTheme.poppinsFont,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                if (i != HabitFrequency.values.length - 1)
                                  const SizedBox(width: 10),
                              ];
                            }(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Material(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: .8,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Time',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: AppTheme.poppinsFont,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedTime.format(context),
                              style: const TextStyle(
                                fontFamily: AppTheme.poppinsFont,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                              ).then((time) {
                                if (time != null) {
                                  setState(() {
                                    selectedTime = time;
                                  });
                                }
                              });
                            },
                            child: const Row(
                              children: [
                                Text(
                                  'CHANGE',
                                  style: TextStyle(
                                    fontFamily: AppTheme.poppinsFont,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.timer_outlined,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: .2,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        (selectedFrequency == 'Once' ? 'Date' : 'Start Date'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: AppTheme.poppinsFont,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              DateFormat.MMMEd().format(startDate),
                              style: const TextStyle(
                                fontFamily: AppTheme.poppinsFont,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: startDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              ).then((date) {
                                if (date != null) {
                                  setState(() {
                                    startDate = date;
                                  });
                                }
                              });
                            },
                            child: const Row(
                              children: [
                                Text(
                                  'CHANGE',
                                  style: TextStyle(
                                    fontFamily: AppTheme.poppinsFont,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.calendar_month_rounded,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (selectedFrequency == 'Weekly')
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: .8,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Days',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: AppTheme.poppinsFont,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                          width: double.maxFinite,
                        ),
                        Text(
                          selectedDays.isNotEmpty
                              ? selectedDays.join(', ')
                              : 'Select at least one day',
                          style: const TextStyle(
                            fontFamily: AppTheme.poppinsFont,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (int i = 0; i < days.length; i++)
                              ...() {
                                final day = days[i];
                                final selected = selectedDays.contains(day);
                                return [
                                  IconButton.outlined(
                                    onPressed: () {
                                      if (selected) {
                                        setState(() {
                                          selectedDays.remove(day);
                                        });
                                      } else {
                                        setState(() {
                                          selectedDays.add(day);
                                        });
                                      }
                                    },
                                    style: IconButton.styleFrom(
                                      backgroundColor: selected
                                          ? AppTheme.primaryBlue
                                          : Colors.white,
                                      foregroundColor: selected
                                          ? Colors.white
                                          : AppTheme.primaryBlue,
                                      side: BorderSide(
                                        color: AppTheme.primaryBlue,
                                        width: selected ? 0 : 1,
                                      ),
                                    ),
                                    icon: Text(
                                      day.substring(0, 2),
                                      style: TextStyle(
                                        fontFamily: AppTheme.poppinsFont,
                                        color: selected
                                            ? Colors.white
                                            : AppTheme.primaryBlue,
                                      ),
                                    ),
                                  ),
                                ];
                              }(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FilledButton(
                onPressed: titleValue.length < 3 ? null : onCreate,
                style: fullBtnStyle(),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

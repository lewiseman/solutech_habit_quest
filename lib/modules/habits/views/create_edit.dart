import 'package:flutter/cupertino.dart';
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
  Habit? updateHabit;
  bool reminder = true;
  int remiderMinutes = 10;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      updateHabit = ref.read(habitsServiceProvider).data()?.firstWhere(
            (e) => e.id == widget.habitId,
            orElse: () => Habit(
              id: '',
              title: '',
              emoji: '',
              time: TimeOfDay.now().toTimeString(),
              startDate: DateTime.now(),
              frequency: HabitFrequency.daily,
              paused: false,
              userId: '',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              reminder: false,
              reminderMinutes: 10,
              notificationId: 0,
            ),
          );
      if (updateHabit != null) {
        prefillData(updateHabit!);
      }
    }
  }

  void prefillData(Habit habit) {
    titleController.text = habit.title;
    titleValue = habit.title;
    emoji = habit.emoji;
    selectedTime = habit.timeValue();
    startDate = habit.startDate;
    selectedFrequency = habit.frequency;
    selectedDays = habit.days ?? [];
    reminder = habit.reminder;
    remiderMinutes = habit.reminderMinutes;
  }

  void onAction() {
    if (selectedFrequency == HabitFrequency.weekly && selectedDays.isEmpty) {
      AppDialog.alert(
        context,
        title: 'No days selected',
        message: 'Please select at least one day',
      );
      return;
    }
    if (widget.isEdit && updateHabit != null) {
      onUpdate(updateHabit!);
    } else {
      onCreate();
    }
  }

  void onUpdate(Habit oldHabit) {
    context.showInfoLoad('Updating habit...');
    ref
        .read(habitsServiceProvider.notifier)
        .updateHabit(
          oldHabit.copyWith(
            title: titleController.text.trim(),
            emoji: emoji,
            time: selectedTime.toTimeString(),
            startDate: startDate,
            days: selectedDays,
            frequency: selectedFrequency,
            reminder: reminder,
            reminderMinutes: remiderMinutes,
          ),
        )
        .then((_) {
      context
        ..pop()
        ..pop()
        ..showSuccessToast('Habit updated successfully');
    }).onError((error, stack) {
      debugPrint(error.toString());
      context
        ..pop()
        ..showErrorToast('Failed to update habit');
    });
  }

  void onCreate() {
    context.showInfoLoad('Creating habit...');
    ref
        .read(habitsServiceProvider.notifier)
        .createHabit(
          Habit(
            id: AppRepository.getUniqueID(),
            title: titleController.text.trim(),
            emoji: emoji,
            time: selectedTime.toTimeString(),
            startDate: startDate,
            days: selectedDays,
            frequency: selectedFrequency,
            paused: false,
            userId: ref.read(authServiceProvider)?.id ?? '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            reminder: reminder,
            reminderMinutes: remiderMinutes,
            notificationId: Habit.generateNotificationId(),
          ),
        )
        .then((_) {
      context
        ..pop()
        ..pop()
        ..showSuccessToast('Habit created successfully');
    }).onError((error, stack) {
      debugPrint(error.toString());
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
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxPageWidth),
            child: Column(
              children: [
                Text(
                  'Tap to change emoji',
                  style: TextStyle(
                    fontFamily: AppTheme.poppinsFont,
                    fontSize: 12,
                    color: theme.textTheme.bodyMedium!.color,
                  ),
                ),
                const SizedBox(height: 6),
                Material(
                  color: theme.cardColor,
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
                    decoration: InputDecoration(
                      labelText: 'eg. Drink water',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      alignLabelWithHint: true,
                      hintText: '',
                      labelStyle: TextStyle(
                        fontFamily: AppTheme.poppinsFont,
                        color: theme.textTheme.bodyMedium!.color,
                      ),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppTheme.primaryBlue,
                        ),
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
                    color: theme.cardColor,
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
                              for (int i = 0;
                                  i < HabitFrequency.values.length;
                                  i++)
                                ...() {
                                  final selected = selectedFrequency ==
                                      HabitFrequency.values[i];
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
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                    color: theme.cardColor,
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
                            (selectedFrequency == HabitFrequency.once
                                ? 'Date'
                                : 'Start Date'),
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
                if (selectedFrequency == HabitFrequency.weekly)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: Material(
                      color: theme.cardColor,
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
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Material(
                    color: theme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: .8,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Reminder',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppTheme.poppinsFont,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      'Remind me before it starts',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: AppTheme.poppinsFont,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: reminder,
                                onChanged: (value) {
                                  setState(() {
                                    reminder = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          if (reminder) const SizedBox(height: 16),
                          if (reminder)
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '$remiderMinutes mins',
                                    style: const TextStyle(
                                      fontFamily: AppTheme.poppinsFont,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    showCupertinoModalPopup<int>(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: 216,
                                          margin: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom,
                                          ),
                                          color: CupertinoColors
                                              .systemBackground
                                              .resolveFrom(context),
                                          child: SafeArea(
                                            top: false,
                                            child: CupertinoPicker(
                                              magnification: 1.22,
                                              squeeze: 1.2,
                                              useMagnifier: true,
                                              itemExtent: 32,
                                              scrollController:
                                                  FixedExtentScrollController(
                                                initialItem: remiderMinutes - 1,
                                              ),
                                              onSelectedItemChanged: (index) {
                                                setState(() {
                                                  remiderMinutes = index + 1;
                                                });
                                              },
                                              children: [
                                                for (int i = 1; i <= 60; i++)
                                                  Text(
                                                    '$i mins',
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          AppTheme.poppinsFont,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ).then((value) {
                                      if (value != null) {
                                        setState(() {
                                          remiderMinutes = value;
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
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FilledButton(
                    onPressed: titleValue.length < 3 ? null : onAction,
                    style: fullBtnStyle(),
                    child: Text(widget.isEdit ? 'Update' : 'Done'),
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

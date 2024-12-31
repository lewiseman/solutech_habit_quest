import 'package:habit_quest/common.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  static AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: const Padding(
        padding: EdgeInsets.all(8),
        child: Icon(
          CustomIcons.habit_quest,
          color: AppTheme.primaryBlue,
        ),
      ),
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
  Widget build(BuildContext context) {
    return const Column();
  }
}

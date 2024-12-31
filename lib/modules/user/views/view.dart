import 'package:habit_quest/common.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

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
      title: const Text(
        'PROFILE',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton.outlined(
          padding: const EdgeInsets.all(6),
          constraints: const BoxConstraints(),
          onPressed: () {},
          icon: const Icon(CustomIcons.bell, size: 20),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Column();
  }
}

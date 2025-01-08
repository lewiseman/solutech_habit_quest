import 'package:habit_quest/common.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'NOTIFICATIONS',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: AppTheme.poppinsFont,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/banana/mail.png',
            width: 120,
            height: 120,
          ),
          const SizedBox(
            height: 8,
            width: double.maxFinite,
          ),
          const Text(
            'Notifications\nComing Soon',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: AppTheme.poppinsFont,
            ),
          ),
        ],
      ),
    );
  }
}

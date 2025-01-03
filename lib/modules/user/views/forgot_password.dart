import 'package:habit_quest/common.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenPadding = MediaQuery.paddingOf(context);
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          bottom: screenPadding.bottom + 16,
          left: 20,
          right: 20,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                const Spacer(),
                const Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: AppTheme.poppinsFont,
                    fontSize: 24,
                  ),
                ),
                const Text(
                  'Enter your email to receive a password reset link',
                  style: TextStyle(
                    fontFamily: AppTheme.poppinsFont,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (size.height > 600)
                  const SizedBox(
                    height: 50,
                  )
                else
                  const Spacer(),
                HabitTextInput(
                  label: 'Email',
                  controller: emailController,
                  type: HabitTextInputType.email,
                  autofillHints: const [AutofillHints.email],
                  bSpacing: 24,
                ),
                if (size.height > 600)
                  const SizedBox(
                    height: 70,
                  )
                else
                  const Spacer(),
                FilledButton(
                  style: fullBtnStyle(),
                  onPressed: () {},
                  child: const Text('SEND'),
                ),
                const Spacer(
                  flex: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

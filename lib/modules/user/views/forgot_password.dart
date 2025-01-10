import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_quest/common.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  bool emailSent = false;
  int secondsRemaining = 0;
  final formKey = GlobalKey<FormState>();
  late Timer timer;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

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
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Spacer(),
                  if (emailSent)
                    sentDisplay()
                  else ...[
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
                      validator: emailValidation,
                      bSpacing: 24,
                    ),
                    if (size.height > 600)
                      const SizedBox(
                        height: 70,
                      )
                    else
                      const Spacer(),
                  ],
                  if (emailSent)
                    sentActions(context)
                  else
                    FilledButton(
                      style: fullBtnStyle(),
                      onPressed: loading ? null : sendEmail,
                      child: const Text('SUBMIT'),
                    ),
                  const Spacer(
                    flex: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row sentActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: () => context.go('/auth/login'),
            style: fullBtnStyle(),
            child: const Text('LOGIN'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: secondsRemaining == 0
                ? () => setState(() => emailSent = false)
                : null,
            style: fullBtnStyle(),
            child: Text(
              'TRY AGAIN ${secondsRemaining != 0 ? '$secondsRemaining s' : ''}',
              style: const TextStyle(
                fontFamily: AppTheme.poppinsFont,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Text sentDisplay() {
    return Text.rich(
      TextSpan(
        children: [
          const WidgetSpan(
            child: Icon(
              Icons.mark_email_read_outlined,
              size: 28,
            ),
          ),
          const TextSpan(text: '\n\nAn email has been sent to '),
          TextSpan(
            text: emailController.text,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const TextSpan(
            text: ' with instructions on how to reset your password',
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Future<void> sendEmail() async {
    if (formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      setState(() {
        loading = true;
        emailSent = false;
      });
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      setState(() {
        emailSent = true;
        secondsRemaining = 45;
      });
    }
  }
}

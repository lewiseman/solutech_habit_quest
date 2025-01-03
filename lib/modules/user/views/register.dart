import 'package:habit_quest/common.dart';
import 'package:lottie/lottie.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool obscureText = true;
  bool obscure2Text = true;

  final fromKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final password2Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          TextButton(
            onPressed: () {
              openLink('https://www.solutech.co.ke/');
            },
            child: const Text('Need help ?'),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: -60,
            right: 0,
            child: Transform.flip(
              flipY: true,
              child: Lottie.asset(
                'assets/lottie/waves.json',
                height: size.height * .3,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400,
                  minHeight: size.height,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25),
                    const Text(
                      'Sign in',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: AppTheme.poppinsFont,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Form(
                      key: fromKey,
                      child: AutofillGroup(
                        child: Column(
                          children: [
                            HabitTextInput(
                              label: 'Name',
                              controller: nameController,
                              type: HabitTextInputType.email,
                              autofillHints: const [AutofillHints.email],
                              bSpacing: 24,
                            ),
                            HabitTextInput(
                              label: 'Email',
                              controller: emailController,
                              type: HabitTextInputType.email,
                              autofillHints: const [AutofillHints.email],
                              bSpacing: 24,
                            ),
                            HabitTextInput(
                              label: 'Password',
                              controller: passwordController,
                              type: HabitTextInputType.password,
                              autofillHints: const [AutofillHints.password],
                              textInputAction: TextInputAction.done,
                              obscureText: obscureText,
                              bSpacing: 24,
                              onSuffixTap: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                            ),
                            HabitTextInput(
                              label: 'Password',
                              controller: password2Controller,
                              type: HabitTextInputType.password,
                              autofillHints: const [AutofillHints.password],
                              textInputAction: TextInputAction.done,
                              obscureText: obscure2Text,
                              onSuffixTap: () {
                                setState(() {
                                  obscure2Text = !obscure2Text;
                                });
                              },
                            ),
                            const SizedBox(height: 40),
                            FilledButton(
                              style: fullBtnStyle(),
                              onPressed: () {},
                              child: const Text('Sign in'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 40,
                                right: 40,
                                top: 20,
                                bottom: 20,
                              ),
                              child: SizedBox(
                                height: 20,
                                width: double.maxFinite,
                                child: Stack(
                                  children: [
                                    const Positioned(
                                      left: 0,
                                      right: 0,
                                      top: 10,
                                      child: Divider(
                                        thickness: .3,
                                        height: 1,
                                      ),
                                    ),
                                    Align(
                                      child: Container(
                                        color: theme.scaffoldBackgroundColor,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        child: const Text('or'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                // asyncFn(
                                //   ref.read(userServiceProvider.notifier).googleSignIn,
                                // ).then(
                                //   ref.read(userServiceProvider.notifier).afterAuth,
                                // );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                side: BorderSide(
                                  color: Colors.black.withOpacity(.3),
                                ),
                                fixedSize: const Size(double.maxFinite, 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: false
                                  ? null
                                  : Image.asset(
                                      'assets/images/google_logo.png',
                                      height: 20,
                                    ),
                              label: const Text(
                                'Sign in with Google',
                                style: TextStyle(
                                  fontFamily: AppTheme.poppinsFont,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

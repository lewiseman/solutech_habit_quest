import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:habit_quest/common.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool obscureText = true;
  final fromKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final screenPadding = MediaQuery.paddingOf(context);
    final screenInsets = MediaQuery.viewInsetsOf(context);
    final theme = Theme.of(context);
    final screenHeight = size.height -
        (screenInsets.bottom +
            screenInsets.top +
            screenPadding.top +
            screenPadding.bottom);
    final shrink = screenHeight < 610;
    return AnnotatedRegion(
      value: AppTheme.systemUiOverlayStyleLight,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
            top: screenPadding.top,
            bottom: screenPadding.bottom + 16,
            left: 20,
            right: 20,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!shrink) ...[
                    const Spacer(),
                    Align(
                      child: Hero(
                        tag: 'auth_logo',
                        child: Image.asset(
                          'assets/images/banana/write.png',
                          width: 110,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
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
                            validator: passwordValidation,
                            autofillHints: const [AutofillHints.password],
                            textInputAction: TextInputAction.done,
                            obscureText: obscureText,
                            onSuffixTap: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                context.push('/auth/forgot_password');
                              },
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  fontFamily: AppTheme.poppinsFont,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          FilledButton(
                            style: fullBtnStyle(),
                            onPressed: () {
                              if (fromKey.currentState!.validate()) {
                                context.showInfoLoad('Signing in...');
                                ref
                                    .read(authServiceProvider.notifier)
                                    .login(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                    )
                                    .then((_) {
                                  context
                                    ..pop()
                                    ..showSuccessToast(
                                      'Signed in successfully',
                                    )
                                    ..go('/');
                                }).onError((error, stack) {
                                  var msg = error.toString();
                                  if (error is AppwriteException) {
                                    msg = error.message ?? error.toString();
                                  }
                                  context
                                    ..pop()
                                    ..showErrorToast(msg);
                                });
                              }
                            },
                            child: const Text('Sign in'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!shrink ) ...[
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
                        context.showInfoLoad('Signing in...');
                        ref
                            .read(authServiceProvider.notifier)
                            .googleSignIn()
                            .then((_) {
                          context
                            ..pop()
                            ..showSuccessToast(
                              'Signed in successfully',
                            )
                            ..go('/');
                        }).onError((error, stack) {
                          var msg = error.toString();
                          if (error is FirebaseAuthException) {
                            msg = error.message ?? error.toString();
                          }
                          context
                            ..pop()
                            ..showErrorToast(msg);
                        });
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
                      icon: Image.asset(
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
                  if (screenHeight > 800)
                    const SizedBox(height: 16)
                  else
                    Spacer(flex: shrink ? 1 : 2),
                  Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      children: [
                        TextSpan(
                          text: 'Create one',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.push('/auth/register');
                            },
                        ),
                      ],
                    ),
                    style: const TextStyle(
                      fontFamily: AppTheme.poppinsFont,
                    ),
                  ),
                  if (screenHeight > 800)
                    const Spacer(flex: 3)
                  else
                    const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

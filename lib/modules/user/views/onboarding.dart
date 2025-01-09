import 'package:flutter/cupertino.dart';
import 'package:habit_quest/common.dart';
import 'package:intl/intl.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenPadding = MediaQuery.viewPaddingOf(context);
    final size = MediaQuery.sizeOf(context);
    return Material(
      color: AppTheme.primaryBlue,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
              maxHeight: 800,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: screenPadding.top + 4,
                ),
                Row(
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        context.canPop() ? context.pop() : context.go('/auth');
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Hero(
                          tag: 'splash_back_button',
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const ChatBubble(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Let's ask you a few questions to get started",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppTheme.poppinsFont,
                      ),
                    ),
                  ),
                ).animate(delay: 500.ms).fadeIn().slideY(),
                const SizedBox(height: 16),
                Hero(
                  tag: 'splash_mascot',
                  child: Image.asset(
                    'assets/images/banana/speech.png',
                    width: size.width * .3,
                  ),
                ),
                const Spacer(),
                Hero(
                  tag: 'splash_filled_button',
                  child: FilledButton(
                    onPressed: () {
                      context.push('/auth/onboarding/questions');
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 139, 75, 3),
                      fixedSize: const Size.fromWidth(double.maxFinite),
                    ),
                    child: const Text(
                      "Let's go",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: AppTheme.poppinsFont,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenPadding.bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingQuestionPage extends StatefulWidget {
  const OnboardingQuestionPage({super.key});

  @override
  State<OnboardingQuestionPage> createState() => _OnboardingQuestionPageState();
}

class _OnboardingQuestionPageState extends State<OnboardingQuestionPage> {
  late final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        currPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  DateTime wakeUpTime = DateTime.now().copyWith(hour: 6, minute: 0);
  DateTime sleepTime = DateTime.now().copyWith(hour: 22, minute: 0);
  List<({String image, String name})> selectedAchievements = [];
  int currPage = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final screenPadding = MediaQuery.viewPaddingOf(context);
    return Material(
      color: AppTheme.primaryBlue,
      child: Padding(
        padding: EdgeInsets.only(
          top: screenPadding.top,
          bottom: screenPadding.bottom,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
              maxHeight: 800,
            ),
            child: LayoutBuilder(
              builder: (context, cs) {
                final size = cs.biggest;
                return Column(
                  children: [
                    Row(
                      children: [
                        Hero(
                          tag: 'splash_back_button',
                          child: IconButton(
                            onPressed: () {
                              context.canPop()
                                  ? context.pop()
                                  : context.go('/auth/onboarding');
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.blue.shade900,
                            backgroundColor: Colors.blue,
                            value: (currPage + 1) / 3,
                            strokeWidth: 6,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 20, top: 8),
                      child: Row(
                        children: [
                          Hero(
                            tag: 'splash_mascot',
                            child: Image.asset(
                              'assets/images/banana/hero.png',
                              width: size.width * .3,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: () {
                              Widget msg(String value) {
                                return ChatBubble(
                                  arrowPosition: ArrowPosition.left,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: AppTheme.poppinsFont,
                                      ),
                                    ),
                                  ),
                                )
                                    .animate(delay: 300.ms)
                                    .fadeIn()
                                    .slideX(begin: .2, end: 0)
                                    .then()
                                    .shake();
                              }

                              if (!_pageController.hasClients) {
                                return msg('What time do you usually wake up?');
                              }
                              if (_pageController.page == 0) {
                                return msg('What time do you usually wake up?');
                              } else if (_pageController.page == 1) {
                                return msg('What time do you usually sleep?');
                              } else if (_pageController.page == 2) {
                                return msg('What do you hope to achieve?');
                              }
                              return const SizedBox.shrink();
                            }(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        children: [
                          wakeUpTimeSec(),
                          sleepTimeSec(),
                          achieveSec(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Hero(
                        tag: 'splash_filled_button',
                        child: FilledButton(
                          onPressed: () {
                            if ((_pageController.page ?? 0) <= 1) {
                              _pageController.nextPage(
                                duration: 500.ms,
                                curve: Curves.easeInOut,
                              );
                            } else {
                              context.push('/auth/register');
                            }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor:
                                const Color.fromARGB(255, 139, 75, 3),
                            fixedSize: const Size.fromWidth(double.maxFinite),
                          ),
                          child: const Text(
                            'CONTINUE',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: AppTheme.poppinsFont,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget achieveSec() {
    const achievements = [
      (name: 'Work Out', image: 'training.png'),
      (name: 'Eat Food', image: 'burger.png'),
      (name: 'Music', image: 'music.png'),
      (name: 'Art & Design', image: 'palette.png'),
      (name: 'Traveling', image: 'travelling.png'),
      (name: 'Read', image: 'books.png'),
      (name: 'Gaming', image: 'console.png'),
      (name: 'Mechanic', image: 'mechanic.png'),
    ];
    return GridView.builder(
      shrinkWrap: true,
      itemCount: achievements.length,
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        final value = achievements[index % achievements.length];
        final selected = selectedAchievements.contains(value);
        return InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            setState(() {
              if (selectedAchievements.contains(value)) {
                selectedAchievements.remove(value);
              } else {
                selectedAchievements.add(value);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: selected
                  ? const Color.fromARGB(255, 9, 57, 112)
                  : Colors.blue.shade400.withOpacity(.5),
              border: Border.all(color: Colors.blue.shade400),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/achievements/${value.image}',
                  fit: BoxFit.contain,
                  width: 60,
                ),
                Text(
                  value.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget wakeUpTimeSec() => Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Wake up time',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    DateFormat('hh:mm a').format(wakeUpTime),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: CupertinoDatePicker(
              initialDateTime: wakeUpTime,
              mode: CupertinoDatePickerMode.time,
              onDateTimeChanged: (DateTime value) {
                setState(() {
                  wakeUpTime = value;
                });
              },
            ),
          ),
        ],
      );

  Widget sleepTimeSec() => Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sleep time',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    DateFormat('hh:mm a').format(sleepTime),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: CupertinoDatePicker(
              initialDateTime: wakeUpTime,
              mode: CupertinoDatePickerMode.time,
              onDateTimeChanged: (DateTime value) {
                setState(() {
                  sleepTime = value;
                });
              },
            ),
          ),
        ],
      );
}

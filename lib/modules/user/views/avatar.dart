import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_quest/common.dart';

class PickAvatarPage extends ConsumerWidget {
  const PickAvatarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userServiceProvider);

    final theme = Theme.of(context);
    final isdarkmode = user?.prefs.data['theme_mode'] == 'dark';

    final coins = ref.watch(rewardsServiceProvider).coins;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black,
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.yellow.shade900.withOpacity(.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '💰 $coins',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
              fontFamily: AppTheme.poppinsFont,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              openLink('https://www.dicebear.com/');
            },
            child: SvgPicture.network(
              'https://www.dicebear.com/${isdarkmode ? 'logo-dark' : 'logo'}.svg',
              height: 10,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: maxPageWidth,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Avatar Styles',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: double.maxFinite),
                  Text('Pick a style to generate a unique avatar'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: maxPageWidth,
              ),
              child: LayoutBuilder(
                builder: (context, cs) {
                  final size = cs.biggest;
                  return Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    children: dicebearStyles.map((dicebear) {
                      return SizedBox(
                        width: size.width / 2 - 26,
                        child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: () {
                              pickedIcon(context, dicebear, ref, coins);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  SvgPicture.network(
                                    'https://api.dicebear.com/9.x/${dicebear.url}/svg',
                                    height: 100,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(dicebear.name),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> pickedIcon(
    BuildContext context,
    ({String name, String url}) style,
    WidgetRef ref,
    int coins,
  ) async {
    var count = 1;
    final confirmedurl = await AppDialog.custom<String>(
      context,
      builder: (theme, size) {
        return StatefulBuilder(
          builder: (context, void Function(void Function()) setState) {
            return ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: maxPageWidth - 100,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: size.height * .4,
                    ),
                    child: SvgPicture.network(
                      'https://api.dicebear.com/9.x/${style.url}/svg?seed=$count',
                      key: ValueKey('avatar-$count'),
                      width: size.width * .5,
                      height: size.height * .4,
                      placeholderBuilder: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        count++;
                      });
                    },
                    style: FilledButton.styleFrom(
                      fixedSize: const Size.fromWidth(double.maxFinite),
                    ),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('RANDOMIZE'),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: (coins >= 2)
                        ? () {
                            Navigator.pop(
                              context,
                              'https://api.dicebear.com/9.x/${style.url}/svg?seed=$count',
                            );
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      fixedSize: const Size.fromWidth(double.maxFinite),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('CONFIRM'),
                        Text('💰 2'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (confirmedurl != null) {
      // ignore: use_build_context_synchronously
      context.showInfoLoad('Updating profile image ...');
      try {
        await ref
            .read(userServiceProvider.notifier)
            .update(avatar: confirmedurl);
        await ref.read(rewardsServiceProvider.notifier).removeCoins(2);
        Navigator.of(context)
          ..pop()
          ..pop();
      } catch (e) {
        Navigator.of(context).pop();
        AppDialog.alert(
          context,
          message: 'Unable to update the avatar',
        );
      }
    }
  }

  static const dicebearStyles = [
    (name: 'Adventurer', url: 'adventurer'),
    (name: 'Avataaars', url: 'avataaars'),
    (name: 'Big Ears', url: 'big-ears'),
    (name: 'Big Smile', url: 'big-smile'),
    (name: 'Bottts', url: 'bottts'),
    (name: 'Croodles', url: 'croodles'),
    (name: 'Croodles Neutral', url: 'croodles-neutral'),
    (name: 'Lorelei', url: 'lorelei'),
    (name: 'Micah', url: 'micah'),
    (name: 'Miniavs', url: 'miniavs'),
    (name: 'Notionists', url: 'notionists'),
    (name: 'Open Peeps', url: 'open-peeps'),
    (name: 'Personas', url: 'personas'),
    (name: 'Pixel Art', url: 'pixel-art'),
  ];
}

import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_quest/common.dart';

class PickAvatarPage extends ConsumerWidget {
  const PickAvatarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isdarkmode = context.isDarkMode;
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Avatar Styles',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Pick a style to generate a unique avatar'),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
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
                      pickedIcon(context, dicebear, ref);
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
  ) async {
    var count = 1;
    final confirmedurl = await AppDialog.custom<String>(
      context,
      builder: (theme, size) {
        return StatefulBuilder(
          builder: (context, void Function(void Function()) setState) {
            return Column(
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
                  onPressed: () {
                    Navigator.pop(
                      context,
                      'https://api.dicebear.com/9.x/${style.url}/svg?seed=$count',
                    );
                  },
                  style: FilledButton.styleFrom(
                    fixedSize: const Size.fromWidth(double.maxFinite),
                  ),
                  child: const Text('CONFIRM'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmedurl != null) {
      // ignore: use_build_context_synchronously
      // context.showInfoLoad('Updating profile image ...');
      // try {
      //   await ref.read(wiseNoteUserServiceProvider.notifier).updateProfile({
      //     'photo_url': confirmedurl,
      //   });
      //   Navigator.of(context)
      //     ..pop()
      //     ..pop();
      // } catch (e) {
      //   Navigator.of(context).pop();
      //   AppDialog.alert(
      //     context,
      //     message: 'Unable to update profile image',
      //   );
      // }
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

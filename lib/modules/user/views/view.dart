import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          onPressed: () {
            context.push('/notifications');
          },
          icon: const Icon(CustomIcons.bell, size: 20),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          SvgPicture.network(
            'https://api.dicebear.com/9.x/adventurer-neutral/svg?radius=50',
            height: 160,
            placeholderBuilder: (context) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            },
          ),
          const SizedBox(height: 16),
          settingsGroup(
            actions: [
              (
                name: 'Avatars',
                subtitle: 'Buy or change your avatar',
                action: () {},
                leading: const Icon(CustomIcons.group),
              ),
              (
                name: 'My Badges',
                subtitle: null,
                action: () {},
                leading: const Icon(CustomIcons.achieve),
              ),
              (
                name: 'My Profile',
                subtitle: null,
                action: () {},
                leading: const Icon(CustomIcons.user_avatar),
              ),
            ],
          ),
          settingsGroup(
            title: 'Settings',
            actions: [
              (
                name: 'Notifications',
                subtitle: null,
                action: () {},
                leading: const Icon(CustomIcons.bell),
              ),
              (
                name: 'Theme',
                subtitle: null,
                action: () {},
                leading: const Icon(CustomIcons.theme),
              ),
            ],
          ),
          settingsGroup(
            title: 'Other',
            actions: [
              (
                name: 'Privacy Policy',
                subtitle: null,
                action: () {},
                leading: const Icon(CustomIcons.file),
              ),
              (
                name: 'Share with friends',
                subtitle: null,
                action: () {},
                leading: const Icon(CustomIcons.share),
              ),
              (
                name: 'Rate us',
                subtitle: null,
                action: () {},
                leading: const Icon(CustomIcons.rate),
              ),
              (
                name: 'Feedback',
                subtitle: null,
                action: () {},
                leading: const Icon(CustomIcons.copy_writing),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Version 1.0.0',
            style: TextStyle(
              fontFamily: AppTheme.poppinsFont,
            ),
          ),
          const SizedBox(height: 200),
        ],
      ),
    );
  }

  Padding settingsGroup({
    required List<
            ({
              String name,
              VoidCallback action,
              String? subtitle,
              Widget? leading
            })>
        actions,
    String? title,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title,
              style: const TextStyle(
                fontFamily: AppTheme.poppinsFont,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          const SizedBox(height: 8),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: Column(
                children: [
                  for (int x = 0; x < actions.length; x++)
                    ...() {
                      final action = actions[x];
                      return [
                        ListTile(
                          leading: action.leading,
                          title: Text(action.name),
                          onTap: action.action,
                          subtitle: action.subtitle != null
                              ? Text(action.subtitle!)
                              : null,
                          trailing: const Icon(
                            CupertinoIcons.chevron_right,
                            size: 20,
                          ),
                        ),
                        if (x != actions.length - 1)
                          const Divider(
                            height: .1,
                            thickness: .1,
                          ),
                      ];
                    }(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

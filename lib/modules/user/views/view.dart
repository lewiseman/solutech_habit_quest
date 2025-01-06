import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_quest/common.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class UserPage extends ConsumerWidget {
  const UserPage({super.key});

  static AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: Image.asset('assets/images/banana/coffee.png'),
      scrolledUnderElevation: 1,
      shadowColor: Colors.black,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PROFILE',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Consumer(
            builder: (context, ref, _) {
              final user = ref.watch(userServiceProvider);
              return Text(
                user?.name ?? '',
                style: const TextStyle(fontSize: 12),
              );
            },
          ),
        ],
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
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncServiceProvider);
    final user = ref.watch(userServiceProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          SvgPicture.network(
            (user?.prefs.data['avatar'] as String?) ??
                'https://api.dicebear.com/9.x/adventurer-neutral/svg?radius=50',
            height: 160,
            placeholderBuilder: (context) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            },
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 24,
              bottom: 20,
            ),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/banana/trophy.png',
                        height: 50,
                      ),
                      const Text(
                        'LEVEL',
                        style: TextStyle(
                          fontFamily: AppTheme.poppinsFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        '5',
                        style: TextStyle(
                          fontFamily: AppTheme.poppinsFont,
                        ),
                      ),
                    ],
                  ),
                  const VerticalDivider(
                    thickness: .2,
                    indent: 10,
                    endIndent: 6,
                  ),
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/banana/diamond.png',
                        height: 50,
                      ),
                      const Text(
                        'COINS',
                        style: TextStyle(
                          fontFamily: AppTheme.poppinsFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        '48',
                        style: TextStyle(
                          fontFamily: AppTheme.poppinsFont,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          syncCard(
            syncState: syncState,
          ),
          settingsGroup(
            actions: [
              (
                name: 'Avatars',
                subtitle: 'Buy or change your avatar',
                action: () {
                  context.push('/user/avatars');
                },
                leading: const Icon(CustomIcons.group),
              ),
              (
                name: 'My Badges',
                subtitle: null,
                action: () {
                  context.push('/user/badges');
                },
                leading: const Icon(CustomIcons.achieve),
              ),
              (
                name: 'My Profile',
                subtitle: null,
                action: () {
                  context.push('/user/profile');
                },
                leading: const Icon(CustomIcons.user_edit),
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
                action: () {
                  context.push('/theme');
                },
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
                action: () {
                  openLink(
                    'https://www.solutech.co.ke/policies-2/#privacy-policy',
                  );
                },
                leading: const Icon(CustomIcons.file),
              ),
              (
                name: 'Share with friends',
                subtitle: null,
                action: () {
                  Share.share(
                    '''Check out the amaizing Habit Quest app by Solutech\n\nhttps://play.google.com/store/apps/details?id=com.solutech.sat.solutech_sat&hl=en&pli=1''',
                    subject: 'Habit Quest',
                  );
                },
                leading: const Icon(CustomIcons.share),
              ),
              (
                name: 'Rate us',
                subtitle: null,
                action: () {
                  openLink(
                    'https://play.google.com/store/apps/details?id=com.solutech.sat.solutech_sat&hl=en&pli=1',
                  );
                },
                leading: const Icon(CustomIcons.rate),
              ),
              (
                name: 'Feedback',
                subtitle: null,
                action: () {
                  openLink('https://www.solutech.co.ke/contact-us/');
                },
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

  Widget syncCard({required SyncState syncState}) {
    return Container(
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
      ),
      padding: const EdgeInsets.all(12),
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: AppTheme.primaryBlue,
      ),
      child: Row(
        children: [
          const Icon(
            CustomIcons.cloud_sync,
            color: Colors.white,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  () {
                    if (syncState is LoadingSyncState) {
                      return 'SYNCING...';
                    }
                    if (syncState is ErrorSyncState) {
                      return 'SYNC ERROR';
                    }
                    if (syncState is SyncedSyncState) {
                      return 'DATA SYNCED';
                    }
                    return '';
                  }(),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Last synced ${() {
                    if (syncState is SyncedSyncState) {
                      return DateFormat.yMEd().add_jm().format(syncState.time);
                    }
                    return '';
                  }()}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.6),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            CupertinoIcons.check_mark,
            color: Colors.white,
          ),
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

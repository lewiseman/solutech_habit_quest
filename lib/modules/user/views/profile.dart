import 'package:habit_quest/common.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          TextButton.icon(
            onPressed: () {
              AppDialog.confirm(
                context,
                title: 'LOG OUT ?',
                message: 'Are you sure you want to log out?',
              ).then((res) {
                if (res ?? false) {
                  // ignore: use_build_context_synchronously
                  context.showInfoLoad('Logging out...');
                  ref.read(userServiceProvider.notifier).logout();
                }
              });
            },
            label: const Text('Log Out'),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 50,
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              HabitTextInput(
                controller: nameController,
                fillColor: Colors.white,
                label: 'Name',
              ),
              const SizedBox(height: 40),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  fixedSize: const Size.fromWidth(double.maxFinite),
                ),
                child: const Text('UPDATE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

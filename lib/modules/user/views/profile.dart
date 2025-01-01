import 'package:flutter/material.dart';
import 'package:habit_quest/components/inputs.dart';

class ProfileEditPAge extends StatefulWidget {
  const ProfileEditPAge({super.key});

  @override
  State<ProfileEditPAge> createState() => _ProfileEditPAgeState();
}

class _ProfileEditPAgeState extends State<ProfileEditPAge> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          TextButton.icon(
            onPressed: () {},
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
              const SizedBox(height: 20),
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

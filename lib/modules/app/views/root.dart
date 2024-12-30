import 'package:habit_quest/common.dart';

class RootApp extends StatefulWidget {
  const RootApp({required this.child, super.key});
  final Widget child;

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

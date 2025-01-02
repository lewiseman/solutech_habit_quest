import 'package:habit_quest/common.dart';
import 'package:habit_quest/modules/journey/views/explore/explore.dart';
import 'package:habit_quest/modules/journey/views/my_habits/my_habits.dart';
import 'package:habit_quest/modules/journey/views/summary/summary.dart';

class JourneyPage extends StatefulWidget {
  const JourneyPage({super.key});

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
        'MY JOURNEY',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  State<JourneyPage> createState() => _JourneyPageState();
}

class _JourneyPageState extends State<JourneyPage>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(
    length: 3,
    vsync: this,
    initialIndex: 1,
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          dividerHeight: 0,
          tabs: const [
            Tab(text: 'SUMMARY'),
            Tab(text: 'EXPLORE'),
            Tab(text: 'MY HABITS'),
          ],
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: AppTheme.poppinsFont,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: AppTheme.poppinsFont,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              SummarySection(),
              ExploreSection(),
              MyHabitsSection(),
            ],
          ),
        ),
      ],
    );
  }
}

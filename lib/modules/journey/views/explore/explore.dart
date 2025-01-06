import 'package:habit_quest/common.dart';
import 'package:habit_quest/modules/journey/services/explore_srv.dart';
import 'package:habit_quest/modules/journey/views/explore/widgets/explore_categories.dart';
import 'package:habit_quest/modules/journey/views/explore/widgets/explore_habits.dart';
import 'package:habit_quest/modules/journey/views/explore/widgets/explore_header.dart';
import 'package:habit_quest/modules/journey/views/explore/widgets/explore_sections.dart';

class ExploreSection extends ConsumerWidget {
  const ExploreSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final exploreService = ref.watch(exploreServiceDataProvider);
    return exploreService.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        print(error);
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/banana/cry.png',
                width: 100,
              ),
              const SizedBox(height: 16),
              const Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontFamily: AppTheme.poppinsFont,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text('Please try again later'),
              const SizedBox(height: 16),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  ref.invalidate(exploreServiceDataProvider);
                },
              ),
            ],
          ),
        );
      },
      data: (apidata) {
        return RefreshIndicator(
          onRefresh: () => ref.refresh(exploreServiceDataProvider.future),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 200),
            child: Column(
              children: [
                const SizedBox(height: 30),
                ExploreHeader(
                  data: (apidata['carousel'] as List?)
                          ?.cast<Map<String, dynamic>>() ??
                      [],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Container(
                          width: 2,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text.rich(
                              TextSpan(
                                text: '${(apidata['quote']! as Map)['text']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppTheme.poppinsFont,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        '  - ${(apidata['quote']! as Map)['author']}',
                                    style: const TextStyle(
                                      fontFamily: AppTheme.poppinsFont,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ExploreCategories(
                  size: size,
                  data: (apidata['main_categories'] as List?)
                          ?.cast<Map<String, dynamic>>() ??
                      [],
                  link: apidata['main_category_link'] as String? ??
                      'https://www.google.com/',
                ),
                const SizedBox(height: 30),
                for (final section in (apidata['sections']! as List?)
                        ?.cast<Map<String, dynamic>>() ??
                    [])
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 30,
                    ),
                    child: CommonRow(
                      size: size,
                      title: section['title']! as String,
                      items: (section['items'] as List?)
                              ?.cast<Map<String, dynamic>>() ??
                          [],
                    ),
                  ),
                PopularHabits(
                  data: (apidata['popular_habits'] as Map?)
                          ?.cast<String, dynamic>() ??
                      {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:habit_quest/common.dart';

class ExploreSection extends StatelessWidget {
  const ExploreSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 200),
      child: Column(
        children: [
          const SizedBox(height: 30),
          const ExploreHeader(),
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
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: Text.rich(
                        TextSpan(
                          text:
                              '''Without struggle, no progress and no result. Every breaking of habit produces a change in the machine  ''',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppTheme.poppinsFont,
                          ),
                          children: [
                            TextSpan(
                              text: '  - George Gurdjieff',
                              style: TextStyle(
                                fontFamily: AppTheme.poppinsFont,
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Text(
                      //   '''Without struggle, no progress and no result. Every breaking of habit produces a change in the machine''',
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.w500,
                      //     fontFamily: AppTheme.poppinsFont,
                      //   ),
                      // ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          ExploreCommonCards(
            size: size,
          ),
          const SizedBox(height: 30),
          CommonRow(
            size: size,
            title: 'New and Trending',
          ),
          const SizedBox(height: 30),
          const PopularHabits(),

          // Text('row 1'),
          // Text('row 2'),
          // Text('col'),
        ],
      ),
    );
  }
}

class PopularHabits extends StatelessWidget {
  const PopularHabits({
    super.key,
  });
  static const commondata = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular Habits',
            style: TextStyle(
              fontFamily: AppTheme.poppinsFont,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const Text(
            'Popular habits collection that are proven to improve your life. Tap to add them.',
            style: TextStyle(
              fontFamily: AppTheme.poppinsFont,
              fontSize: 12,
            ),
          ),
          ListView.builder(
            itemCount: 5,
            padding: const EdgeInsets.only(top: 20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  elevation: .5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  color: Colors.white,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Early morning routine with exercise',
                                style: TextStyle(
                                  fontFamily: AppTheme.poppinsFont,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CommonRow extends StatelessWidget {
  const CommonRow({
    required this.size,
    this.title,
    super.key,
  });
  final Size size;
  final String? title;

  static const images = [
    'https://i.pinimg.com/736x/e0/75/f2/e075f279caa46badc42d8026cc51d6e4.jpg',
    'https://as2.ftcdn.net/v2/jpg/06/19/61/59/1000_F_619615985_dU5yY1utplbIVIUhsHzVO2FAyDlYOqGJ.jpg',
    'https://i.pinimg.com/736x/a8/87/57/a887578456af1270a206761fc2ced4cd.jpg',
    'https://i.pinimg.com/originals/eb/87/2f/eb872fef5a96b0dba49bc268dccfdbbb.png',
    'https://i.pinimg.com/736x/1f/cd/5b/1fcd5b784f1439fc2c76386d5513f829.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title!,
                    style: const TextStyle(
                      fontFamily: AppTheme.poppinsFont,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Row(
                    children: [
                      Text(
                        'ALL',
                        style: TextStyle(
                          fontFamily: AppTheme.poppinsFont,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        SizedBox(
          width: size.width,
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            padding: const EdgeInsets.only(left: 20, right: 20),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final image = images[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {},
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      height: double.maxFinite,
                      width: 150,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ExploreCommonCards extends StatelessWidget {
  const ExploreCommonCards({
    required this.size,
    super.key,
  });
  final Size size;

  static const commondata = [
    (
      title: 'Refreshing jogging',
      bgImage: 'explore_shoes.png',
      link: '',
    ),
    (
      title: 'Stoic Man',
      bgImage: 'explore_fire.png',
      link: '',
    ),
    (
      title: 'Selfcare time',
      bgImage: 'explore_drops.png',
      link: '',
    ),
    (
      title: 'That Girl',
      bgImage: 'explore_girl.png',
      link: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: size.width,
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: commondata.length + 1,
        padding: const EdgeInsets.only(left: 20, right: 20),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (index == commondata.length) {
            return TextButton(
              onPressed: () {},
              child: const Row(
                children: [
                  Text(
                    'VIEW ALL',
                    style: TextStyle(
                      fontFamily: AppTheme.poppinsFont,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_ios_rounded, size: 20),
                ],
              ),
            );
          }
          final data = commondata[index];
          return Container(
            clipBehavior: Clip.hardEdge,
            width: 120,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppTheme.primaryBlue,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      AppTheme.primaryBlue.withOpacity(.7),
                      BlendMode.srcATop,
                    ),
                    child: Image.asset(
                      'assets/images/temp/${data.bgImage}',
                      fit: BoxFit.cover,
                      width: double.maxFinite,
                      height: double.maxFinite,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.arrow_outward_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        data.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: AppTheme.poppinsFont,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ExploreHeader extends StatefulWidget {
  const ExploreHeader({
    super.key,
  });

  @override
  State<ExploreHeader> createState() => _ExploreHeaderState();
}

class _ExploreHeaderState extends State<ExploreHeader> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: [
            Container(
              margin: const EdgeInsets.only(right: 20, left: 20),
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: Image.network(
                'https://images.unsplash.com/photo-1522898467493-49726bf28798?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                fit: BoxFit.cover,
                width: double.maxFinite,
                height: double.maxFinite,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20, left: 20),
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: Image.network(
                'https://images.unsplash.com/photo-1522898467493-49726bf28798?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                fit: BoxFit.cover,
                width: double.maxFinite,
                height: double.maxFinite,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20, left: 20),
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: Image.network(
                'https://images.unsplash.com/photo-1522898467493-49726bf28798?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                fit: BoxFit.cover,
                width: double.maxFinite,
                height: double.maxFinite,
              ),
            ),
          ],
          options: CarouselOptions(
            height: 200,
            viewportFraction: 1,
            enlargeFactor: 0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 8),
            onPageChanged: (index, reason) {
              setState(() => _current = index);
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [1, 2, 3].map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry),
              child: Container(
                width: 12,
                height: 6,
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withAlpha(
                    _current == entry ? 255 : 100,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

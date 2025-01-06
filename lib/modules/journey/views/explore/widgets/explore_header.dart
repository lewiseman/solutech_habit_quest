import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:habit_quest/common.dart';

class ExploreHeader extends StatefulWidget {
  const ExploreHeader({
    required this.data,
    super.key,
  });
  final List<Map<String, dynamic>> data;

  @override
  State<ExploreHeader> createState() => _ExploreHeaderState();
}

class _ExploreHeaderState extends State<ExploreHeader> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        CarouselSlider(
          items: [
            for (final item in widget.data)
              Container(
                margin: const EdgeInsets.only(right: 20, left: 20),
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                child: Stack(
                  children: [
                    Image.network(
                      item['image'] as String,
                      fit: BoxFit.cover,
                      width: double.maxFinite,
                      height: double.maxFinite,
                    ),
                    Container(
                      color: Colors.black.withOpacity(.2),
                      padding: const EdgeInsets.all(16),
                      width: double.maxFinite,
                      child: Text(
                        item['title'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppTheme.poppinsFont,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          options: CarouselOptions(
            aspectRatio: 2,
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
          children: widget.data.indexed.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.$1),
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
                    _current == entry.$1 ? 255 : 100,
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

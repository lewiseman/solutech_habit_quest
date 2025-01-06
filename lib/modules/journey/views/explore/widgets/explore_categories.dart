import 'package:habit_quest/common.dart';

class ExploreCategories extends StatelessWidget {
  const ExploreCategories({
    required this.size,
    required this.data,
    required this.link,
    super.key,
  });
  final Size size;
  final List<Map<String, dynamic>> data;
  final String link;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: size.width,
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length + 1,
        padding: const EdgeInsets.only(left: 20, right: 20),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (index == data.length) {
            return TextButton(
              onPressed: () {
                openLink(link);
              },
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
          final category = data[index];
          return Container(
            clipBehavior: Clip.hardEdge,
            width: 120,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppTheme.primaryBlue,
            ),
            child: InkWell(
              onTap: () {
                openLink(category['link'] as String);
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        AppTheme.primaryBlue.withOpacity(.7),
                        BlendMode.srcATop,
                      ),
                      child: Image.network(
                        category['bg_image'] as String,
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
                          category['title'] as String,
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
            ),
          );
        },
      ),
    );
  }
}

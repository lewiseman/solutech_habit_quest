import 'package:habit_quest/common.dart';

class CommonRow extends StatelessWidget {
  const CommonRow({
    required this.size,
    required this.items,
    this.title,
    super.key,
  });
  final Size size;
  final String? title;
  final List<Map<String, dynamic>> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox();
    }
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
            itemCount: items.length,
            padding: const EdgeInsets.only(left: 20, right: 20),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final data = items[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      openLink(data['link'] as String);
                    },
                    child: Stack(
                      children: [
                        Image.network(
                          data['image'] as String,
                          fit: BoxFit.cover,
                          height: double.maxFinite,
                          width: 150,
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            color: Colors.black.withOpacity(.4),
                            padding: const EdgeInsets.all(8),
                            width: 150,
                            child: Text(
                              data['title'] as String,
                              style: const TextStyle(
                                fontFamily: AppTheme.poppinsFont,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
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

import 'package:flutter/material.dart';

class EmojiPicker extends StatefulWidget {
  const EmojiPicker({required this.scrollController, super.key});
  final ScrollController scrollController;

  static Future<String?> pick(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, controller) {
            return EmojiPicker(
              scrollController: controller,
            );
          },
        );
      },
    );
  }

  @override
  State<EmojiPicker> createState() => _EmojiPickerState();
}

class _EmojiPickerState extends State<EmojiPicker> {
  final List<String> emojis = List.generate(
    80,
    (index) => String.fromCharCode(0x1F600 + index), // Emojis from 😀 onwards.
  );

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: widget.scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
      ),
      itemBuilder: (context, index) {
        final emoji = emojis[index];
        return InkWell(
          onTap: () {
            Navigator.of(context).pop(emoji);
          },
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        );
      },
      itemCount: emojis.length,
    );
  }
}

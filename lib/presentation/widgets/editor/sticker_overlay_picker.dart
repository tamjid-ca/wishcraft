import 'package:flutter/material.dart';

class StickerOverlayPicker extends StatelessWidget {
  final ValueChanged<String> onSelectSticker;

  // Simulate sticker assets using emojis for simplicity and fallback
  static const List<String> stickers = [
    '❤️', '💖', '💝', '✨', '⭐', '🌟', '🎈', '🎉',
    '🎂', '🎄', '🎁', '🌹', '🌸', '🕊️', '👑', '🍀'
  ];

  const StickerOverlayPicker({
    super.key,
    required this.onSelectSticker,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Sticker to Add',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: stickers.length,
            itemBuilder: (context, idx) {
              final sticker = stickers[idx];
              return InkWell(
                onTap: () {
                  onSelectSticker(sticker);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      sticker,
                      style: const TextStyle(fontSize: 32),
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

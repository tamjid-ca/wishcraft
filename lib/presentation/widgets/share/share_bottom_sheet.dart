import 'package:flutter/material.dart';

class ShareBottomSheet extends StatelessWidget {
  final VoidCallback onShareWhatsApp;
  final VoidCallback onShareTelegram;
  final VoidCallback onShareMessenger;
  final VoidCallback onSaveGallery;
  final VoidCallback onMore;

  const ShareBottomSheet({
    super.key,
    required this.onShareWhatsApp,
    required this.onShareTelegram,
    required this.onShareMessenger,
    required this.onSaveGallery,
    required this.onMore,
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
            'Share Card Via',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ShareTarget(
                icon: Icons.chat,
                color: Colors.green,
                label: 'WhatsApp',
                onTap: () {
                  Navigator.pop(context);
                  onShareWhatsApp();
                },
              ),
              _ShareTarget(
                icon: Icons.telegram,
                color: Colors.blue,
                label: 'Telegram',
                onTap: () {
                  Navigator.pop(context);
                  onShareTelegram();
                },
              ),
              _ShareTarget(
                icon: Icons.message,
                color: Colors.purple,
                label: 'Messenger',
                onTap: () {
                  Navigator.pop(context);
                  onShareMessenger();
                },
              ),
              _ShareTarget(
                icon: Icons.save_alt,
                color: Colors.teal,
                label: 'Gallery',
                onTap: () {
                  Navigator.pop(context);
                  onSaveGallery();
                },
              ),
              _ShareTarget(
                icon: Icons.more_horiz,
                color: Colors.grey,
                label: 'More',
                onTap: () {
                  Navigator.pop(context);
                  onMore();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShareTarget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _ShareTarget({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

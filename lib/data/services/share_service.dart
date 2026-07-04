import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class ShareService {
  Future<void> shareAsImage(File imageFile, {String? text}) async {
    await Share.shareXFiles(
      [XFile(imageFile.path, mimeType: 'image/png')],
      text: text ?? '',
    );
  }

  Future<void> shareToWhatsApp(File imageFile) => shareAsImage(imageFile);
  Future<void> shareToTelegram(File imageFile) => shareAsImage(imageFile);
  Future<void> shareToMessenger(File imageFile) => shareAsImage(imageFile);

  Future<void> copyWishText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}

import 'dart:io';
import 'package:share_plus/share_plus.dart';

Future<void> shareFileToApp(File file, {String? text}) async {
  await Share.shareXFiles(
    [XFile(file.path, mimeType: 'image/png')],
    text: text ?? '',
  );
}

import 'dart:io';
import '../../data/services/share_service.dart';

class ShareCardUsecase {
  final ShareService _shareService;
  ShareCardUsecase(this._shareService);

  Future<void> shareAsImage(File file) => _shareService.shareAsImage(file);
  Future<void> copyWishText(String text) => _shareService.copyWishText(text);
}

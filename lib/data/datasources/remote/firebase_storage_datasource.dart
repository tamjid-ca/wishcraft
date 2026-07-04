import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../core/errors/app_exception.dart';

class FirebaseStorageDatasource {
  final FirebaseStorage _storage;
  FirebaseStorageDatasource(this._storage);

  Future<String> uploadThumbnail(String uid, String cardId, File file) async {
    try {
      final ref = _storage.ref('users/$uid/thumbnails/$cardId.png');
      await ref.putFile(file, SettableMetadata(contentType: 'image/png'));
      return await ref.getDownloadURL();
    } catch (e) {
      throw AppException('Failed to upload thumbnail: $e');
    }
  }

  Future<void> deleteThumbnail(String uid, String cardId) async {
    try {
      await _storage.ref('users/$uid/thumbnails/$cardId.png').delete();
    } catch (_) {
      // Safe to ignore if not found
    }
  }
}

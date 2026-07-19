import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/wish_card_model.dart';
import 'card_repository.dart';

class CardRepositoryImpl implements CardRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  CardRepositoryImpl(this._firestore, this._storage, this._auth);

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw StateError('No signed-in user.');
    return uid;
  }

  CollectionReference<Map<String, dynamic>> get _cardsRef =>
      _firestore.collection('users/$_uid/wish_cards');

  @override
  Stream<List<WishCardModel>> watchCards() {
    return _cardsRef.orderBy('updatedAt', descending: true).snapshots().map(
          (snap) => snap.docs
              .map((d) => WishCardModel.fromJson(d.data(), d.id))
              .toList(),
        );
  }

  @override
  Future<void> saveCard(WishCardModel card, {File? thumbnailFile}) async {
    await _cardsRef.doc(card.id).set(
          card.toJson()
            ..['updatedAt'] = FieldValue.serverTimestamp()
            ..putIfAbsent('createdAt', () => FieldValue.serverTimestamp()),
          SetOptions(merge: true),
        );
  }

  @override
  Future<void> deleteCard(String cardId) async {
    await _cardsRef.doc(cardId).delete();
  }
}

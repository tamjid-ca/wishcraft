import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/wish_card_model.dart';
import '../../models/user_preferences_model.dart';

class FirestoreDatasource {
  final FirebaseFirestore _firestore;
  FirestoreDatasource(this._firestore);

  CollectionReference<Map<String, dynamic>> _cardsRef(String uid) =>
      _firestore.collection('users/$uid/wish_cards');

  DocumentReference<Map<String, dynamic>> _prefsRef(String uid) =>
      _firestore.doc('users/$uid/preferences/settings');

  DocumentReference<Map<String, dynamic>> _quotaRef(String uid) =>
      _firestore.doc('users/$uid/meta/quota');

  Stream<List<WishCardModel>> watchCards(String uid) {
    return _cardsRef(uid).orderBy('updatedAt', descending: true).snapshots().map(
          (snap) => snap.docs
              .map((d) => WishCardModel.fromJson(d.data(), d.id))
              .toList(),
        );
  }

  Future<void> saveCard(String uid, WishCardModel card) async {
    await _cardsRef(uid).doc(card.id).set(
          card.toJson()
            ..['updatedAt'] = FieldValue.serverTimestamp()
            ..putIfAbsent('createdAt', () => FieldValue.serverTimestamp()),
          SetOptions(merge: true),
        );
  }

  Future<void> deleteCard(String uid, String cardId) async {
    await _cardsRef(uid).doc(cardId).delete();
  }

  Future<UserPreferencesModel?> getPreferences(String uid) async {
    final snap = await _prefsRef(uid).get();
    if (!snap.exists || snap.data() == null) return null;
    return UserPreferencesModel.fromJson(snap.data()!);
  }

  Future<void> savePreferences(String uid, UserPreferencesModel prefs) async {
    await _prefsRef(uid).set(prefs.toJson(), SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getQuota(String uid) async {
    final snap = await _quotaRef(uid).get();
    return snap.data();
  }
}

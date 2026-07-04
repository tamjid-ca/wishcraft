"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteAccount = void 0;
const https_1 = require("firebase-functions/v2/https");
const firestore_1 = require("firebase-admin/firestore");
const storage_1 = require("firebase-admin/storage");
const auth_1 = require("firebase-admin/auth");
exports.deleteAccount = (0, https_1.onCall)({ timeoutSeconds: 60 }, async (request) => {
    if (!request.auth) {
        throw new https_1.HttpsError("unauthenticated", "Sign in required.");
    }
    const uid = request.auth.uid;
    const db = (0, firestore_1.getFirestore)();
    const cardsSnap = await db.collection(`users/${uid}/wish_cards`).get();
    const batch = db.batch();
    cardsSnap.docs.forEach((doc) => batch.delete(doc.ref));
    batch.delete(db.doc(`users/${uid}/preferences/settings`));
    batch.delete(db.doc(`users/${uid}/meta/quota`));
    batch.delete(db.doc(`users/${uid}`));
    await batch.commit();
    const bucket = (0, storage_1.getStorage)().bucket();
    await bucket.deleteFiles({ prefix: `users/${uid}/thumbnails/` });
    await (0, auth_1.getAuth)().deleteUser(uid);
    return { success: true };
});
//# sourceMappingURL=deleteAccount.js.map
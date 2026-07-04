import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import { getAuth } from "firebase-admin/auth";

export const deleteAccount = onCall({ timeoutSeconds: 60 }, async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Sign in required.");
  }
  const uid = request.auth.uid;
  const db = getFirestore();

  const cardsSnap = await db.collection(`users/${uid}/wish_cards`).get();
  const batch = db.batch();
  cardsSnap.docs.forEach((doc) => batch.delete(doc.ref));
  batch.delete(db.doc(`users/${uid}/preferences/settings`));
  batch.delete(db.doc(`users/${uid}/meta/quota`));
  batch.delete(db.doc(`users/${uid}`));
  await batch.commit();

  const bucket = getStorage().bucket();
  await bucket.deleteFiles({ prefix: `users/${uid}/thumbnails/` });

  await getAuth().deleteUser(uid);

  return { success: true };
});

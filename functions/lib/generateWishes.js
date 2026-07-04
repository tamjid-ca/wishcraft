"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateWishes = void 0;
const https_1 = require("firebase-functions/v2/https");
const params_1 = require("firebase-functions/params");
const firestore_1 = require("firebase-admin/firestore");
const generative_ai_1 = require("@google/generative-ai");
const uuid_1 = require("uuid");
const GEMINI_API_KEY = (0, params_1.defineSecret)("GEMINI_API_KEY");
const DAILY_LIMIT = 20;
const SEPARATOR = "---WISH_SEPARATOR---";
exports.generateWishes = (0, https_1.onCall)({ secrets: [GEMINI_API_KEY], timeoutSeconds: 30, memory: "256MiB" }, async (request) => {
    if (!request.auth) {
        throw new https_1.HttpsError("unauthenticated", "Sign in required.");
    }
    const uid = request.auth.uid;
    const { occasion, recipientName, relationship, tone, personalNote } = request.data;
    if (!occasion || !recipientName || !relationship || !tone) {
        throw new https_1.HttpsError("invalid-argument", "Missing required fields.");
    }
    const db = (0, firestore_1.getFirestore)();
    const quotaRef = db.doc(`users/${uid}/meta/quota`);
    await db.runTransaction(async (tx) => {
        const snap = await tx.get(quotaRef);
        const today = new Date().toISOString().slice(0, 10);
        const data = snap.data();
        if (!snap.exists || data?.date !== today) {
            tx.set(quotaRef, { date: today, count: 1 });
            return;
        }
        if ((data.count ?? 0) >= DAILY_LIMIT) {
            throw new https_1.HttpsError("resource-exhausted", "You've reached today's generation limit. Try again tomorrow.");
        }
        tx.update(quotaRef, { count: firestore_1.FieldValue.increment(1) });
    });
    const prompt = buildPrompt({ occasion, recipientName, relationship, tone, personalNote });
    let rawText;
    try {
        const genAI = new generative_ai_1.GoogleGenerativeAI(GEMINI_API_KEY.value());
        const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });
        const result = await model.generateContent(prompt);
        rawText = result.response.text().trim();
    }
    catch (err) {
        throw new https_1.HttpsError("internal", "Could not reach the AI service. Please try again.");
    }
    const variants = rawText
        .split(SEPARATOR)
        .map((t) => t.trim())
        .filter((t) => t.length > 0)
        .slice(0, 3)
        .map((text) => ({ id: (0, uuid_1.v4)(), text }));
    if (variants.length === 0) {
        throw new https_1.HttpsError("internal", "Could not generate wishes. Please try again.");
    }
    return { variants };
});
function buildPrompt(params) {
    const { occasion, recipientName, relationship, tone, personalNote } = params;
    return `You are a creative wish card writer. Generate exactly 3 distinct wish messages for a ${occasion} card.

Details:
- Recipient Name: ${recipientName}
- Relationship: ${relationship}
- Tone: ${tone}
${personalNote ? `- Personal Note: ${personalNote}` : ""}

Rules:
- Each wish must be 2 to 5 sentences
- Separate each wish with the exact separator: ${SEPARATOR}
- Do NOT add numbering, labels, or any extra text
- Make each wish distinctly different in style and imagery
- Naturally include the recipient name "${recipientName}" in each wish
- Strictly match the "${tone}" tone throughout

Output ONLY the 3 wishes separated by ${SEPARATOR} with no other text:`;
}
//# sourceMappingURL=generateWishes.js.map
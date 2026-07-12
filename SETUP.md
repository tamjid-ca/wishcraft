# 🚀 WishCraft — Setup & Run Guide

Complete step-by-step guide to get WishCraft running from scratch.

---

## Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| Flutter SDK | ≥ 3.13.0 | https://docs.flutter.dev/get-started/install |
| Dart SDK | ≥ 3.1.0 | Bundled with Flutter |
| Node.js | ≥ 18 LTS | https://nodejs.org |
| Firebase CLI | latest | `npm install -g firebase-tools` |
| FlutterFire CLI | latest | `dart pub global activate flutterfire_cli` |
| Android Studio / Xcode | latest | For emulators & device builds |

Verify everything works:
```bash
flutter doctor -v
firebase --version
flutterfire --version
```

---

## Phase 0 — Firebase Project Setup

### 0.1 Create Firebase Project

1. Go to **https://console.firebase.google.com**
2. Click **Add project** → name it `WishCraft` → continue
3. Enable Google Analytics (optional) → **Create project**

### 0.2 Enable Firebase Services

In the Firebase Console sidebar, enable each service:

| Service | Path | Notes |
|---------|------|-------|
| Authentication | Build → Authentication → Get started → Sign-in method → **Google** → Enable | Set project support email |
| Firestore | Build → Firestore Database → Create database → **Production mode** → pick region | Recommend `us-central1` |
| Storage | Build → Storage → Get started → Production mode | Same region as Firestore |
| Cloud Functions | Build → Functions → Get started | Requires **Blaze (pay-as-you-go)** plan |
| App Check | Build → App Check → Get started | Configure after registering apps below |

### 0.3 Register Android App

1. Firebase Console → Project Settings (⚙️) → **Add app** → Android
2. Android package name: `com.example.wishcraft`
   *(or your custom package name from `android/app/build.gradle.kts`)*
3. App nickname: `WishCraft Android`
4. **SHA-1 and SHA-256** — required for Google Sign-In. Get them:

```bash
# Debug keystore (for development)
keytool -list -v \
  -keystore ~/.android/debug.keystore \
  -alias androiddebugkey \
  -storepass android \
  -keypass android

# Copy the SHA-1 and SHA-256 values from the output
```

> **⚠️ Important:** Add BOTH debug AND release SHA fingerprints. Without this, Google Sign-In fails silently with `ApiException: 10`.

5. Click **Register app**
6. Download **`google-services.json`** → place it at:
```
wishcraft/android/app/google-services.json
```

### 0.4 Register iOS App

1. Firebase Console → Project Settings → **Add app** → iOS
2. iOS bundle ID: `com.example.wishcraft`
   *(match exactly what's in `ios/Runner/Info.plist` → `CFBundleIdentifier`)*
3. App nickname: `WishCraft iOS`
4. Click **Register app**
5. Download **`GoogleService-Info.plist`** → place it at:
```
wishcraft/ios/Runner/GoogleService-Info.plist
```

### 0.5 Add iOS URL Scheme (REVERSED_CLIENT_ID)

Required for Google Sign-In to work on iOS.

1. Open `ios/Runner/GoogleService-Info.plist`
2. Find the value for key `REVERSED_CLIENT_ID`
   It looks like: `com.googleusercontent.apps.XXXXXXXXX-YYYYYY`
3. Open `ios/Runner/Info.plist` in a text editor
4. Add this block inside the top-level `<dict>`:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>YOUR_REVERSED_CLIENT_ID_HERE</string>
    </array>
  </dict>
</array>
```

Replace `YOUR_REVERSED_CLIENT_ID_HERE` with the actual value from step 2.

> **⚠️ Important:** Without this, tapping "Sign in with Google" on iOS does nothing.

### 0.6 Enable App Check (Optional but Recommended)

1. Firebase Console → App Check → Register your apps
2. **Android:** Choose **Play Integrity**
3. **iOS:** Choose **App Attest**
4. For local development, add a **debug token**:
   - Run the app once — Firebase prints a debug token in logcat/Xcode console
   - Firebase Console → App Check → Apps → your app → Add debug token

---

## Phase 1 — Generate firebase_options.dart

This file links your Flutter app to Firebase and is **required** by `main.dart`.

```bash
cd wishcraft

# Login to Firebase
firebase login

# Link this project to your Firebase project
flutterfire configure
```

When prompted:
- Select your Firebase project (`WishCraft`)
- Select platforms: **android, ios** (deselect web/linux/macos/windows unless needed)
- This generates `lib/firebase_options.dart` automatically ✅

> **⚠️ Never commit `firebase_options.dart` to a public repo** — it contains your Firebase config IDs.
> Add it to `.gitignore` if the repo is public.

---

## Phase 2 — Install Flutter Dependencies

```bash
cd wishcraft
flutter pub get
```

---

## Phase 3 — Firebase Cloud Functions Setup

The Gemini AI integration lives entirely in Cloud Functions — the Flutter app never calls Gemini directly.

### 3.1 Install Function Dependencies

```bash
cd wishcraft/functions
npm install
```

### 3.2 Set the Gemini API Key Secret

Get your API key from **https://aistudio.google.com/app/apikey**

```bash
# From the project root (not functions/)
cd wishcraft

# Set it as a Firebase secret (stored securely, never in code)
firebase functions:secrets:set GEMINI_API_KEY
# Paste your key when prompted, then press Enter
```

Verify it was set:
```bash
firebase functions:secrets:access GEMINI_API_KEY
```

### 3.3 Deploy Cloud Functions and Security Rules

```bash
cd wishcraft  # must be at project root

# Deploy everything at once
firebase deploy --only functions,firestore:rules,storage:rules
```

Expected output:
```
✔  functions[generateWishes]: Successful create operation.
✔  functions[deleteAccount]: Successful create operation.
✔  firestore: Released rules wishcraft/firestore.rules
✔  storage: Released rules wishcraft/storage.rules
```

> **⚠️ Requires Blaze plan.** The Spark (free) plan cannot deploy functions that make external network calls (Gemini API). Upgrade at console.firebase.google.com → your project → Spark → Upgrade.

### 3.4 Smoke-Test the Cloud Function

Firebase Console → Functions → `generateWishes` → **Test function** tab:

```json
{
  "data": {
    "occasionId": "birthday",
    "recipientName": "Alice",
    "relationship": "friend",
    "tone": "Heartfelt",
    "personalNote": "She loves coffee"
  }
}
```

Expected: a response with 3 wish variants.
If it returns `unauthenticated`, that's expected from the console — it works correctly from the Flutter app where the user is signed in.

---

## Phase 4 — Android Permissions

Open `android/app/src/main/AndroidManifest.xml` and add before `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
    android:maxSdkVersion="32"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="29"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
```

---

## Phase 5 — Build and Run

### Run on Android (Emulator or Physical Device)

```bash
# List connected devices / emulators
flutter devices

# Run debug build
flutter run

# Run on a specific device
flutter run -d <device-id>
```

### Run on iOS (Simulator or Physical Device)

```bash
# Open Xcode first — required to configure signing
open ios/Runner.xcworkspace
```

In Xcode:
1. Select `Runner` target → **Signing & Capabilities**
2. Select your **Team** (Apple Developer account)
3. Set **Bundle Identifier** to match what you registered in Firebase

```bash
# Then run from terminal
flutter run -d <ios-device-id>
```

### Build Release APK (Android)

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

For Play Store (AAB format):
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### Build Release IPA (iOS)

```bash
flutter build ipa
# Output: build/ios/ipa/wishcraft.ipa
```

---

## Phase 6 — First Launch Checklist

Go through this after first launch to verify everything works:

- [ ] Onboarding screens appear on first launch
- [ ] Google Sign-In button works and signs you in
- [ ] Home screen shows your Google profile photo and name
- [ ] Occasion selection shows all 12 occasion types
- [ ] Wish Generator — fill in recipient + tone → tap Generate → 3 wishes appear (calls Cloud Function)
- [ ] Card Editor — template, font, color pickers all work
- [ ] Preview screen — card renders correctly
- [ ] Save to Cloud — card appears in Saved Cards tab (Firestore + Storage)
- [ ] Share — share sheet opens and sends image
- [ ] Settings — shows account info, Sign Out works, daily quota indicator shows

---

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| `ApiException: 10` on Android Sign-In | Missing SHA fingerprint | Add debug SHA-1/SHA-256 to Firebase console → Project Settings → your Android app |
| iOS Sign-In button does nothing | Missing `REVERSED_CLIENT_ID` URL scheme | Add to `ios/Runner/Info.plist` (see Phase 0.5) |
| `generateWishes` returns `unauthenticated` | App Check blocking dev builds | Register App Check debug token in Firebase console |
| `PERMISSION_DENIED` on Firestore | Security rules not deployed | Run `firebase deploy --only firestore:rules` |
| `firebase_options.dart` not found | `flutterfire configure` not run | Run Phase 1 |
| Cloud Functions deploy fails — billing error | Spark (free) plan | Upgrade to Blaze plan in Firebase Console |
| Gemini returns nothing / function errors | API key not set | Run `firebase functions:secrets:set GEMINI_API_KEY` |
| `google-services.json` not found | File not placed correctly | Must be at `android/app/google-services.json` |
| `GoogleService-Info.plist` not found | File not placed correctly | Must be at `ios/Runner/GoogleService-Info.plist` |
| App Check blocks requests in dev | Debug token not registered | Firebase Console → App Check → add debug token |

---

## Files You Must Add Manually

| File | Source | Destination |
|------|--------|-------------|
| `google-services.json` | Firebase Console → Android app → download | `android/app/google-services.json` |
| `GoogleService-Info.plist` | Firebase Console → iOS app → download | `ios/Runner/GoogleService-Info.plist` |
| `lib/firebase_options.dart` | Run `flutterfire configure` (auto-generated) | `lib/firebase_options.dart` |
| Gemini API key | https://aistudio.google.com/app/apikey | Firebase secret via CLI (never in code) |

---

## Project Structure Quick Reference

```
wishcraft/
├── android/app/
│   └── google-services.json          ← YOU ADD THIS (download from Firebase)
├── ios/Runner/
│   ├── GoogleService-Info.plist      ← YOU ADD THIS (download from Firebase)
│   └── Info.plist                    ← YOU EDIT THIS (add REVERSED_CLIENT_ID URL scheme)
├── lib/
│   ├── firebase_options.dart         ← YOU GENERATE THIS (flutterfire configure)
│   ├── main.dart
│   ├── core/                         ← Theme, router, constants, utils
│   ├── data/                         ← Models, repositories, services, datasources
│   ├── domain/                       ← Entities, use cases
│   ├── presentation/                 ← Screens, widgets, viewmodels
│   └── providers/providers.dart      ← All Riverpod providers
├── functions/
│   └── src/
│       ├── index.ts                  ← Cloud Function exports
│       ├── generateWishes.ts         ← Gemini proxy (AI never called from client)
│       └── deleteAccount.ts          ← Account deletion cascade
├── firestore.rules                   ← Firestore security rules (deploy via CLI)
├── storage.rules                     ← Storage security rules (deploy via CLI)
└── pubspec.yaml
```

---

## Quick Command Reference

```bash
# Install deps
flutter pub get && cd functions && npm install && cd ..

# Login + link Firebase
firebase login
flutterfire configure

# Set Gemini key
firebase functions:secrets:set GEMINI_API_KEY

# Deploy backend
firebase deploy --only functions,firestore:rules,storage:rules

# Run app
flutter run

# Build release APK
flutter build apk --release
```

---

*Last updated: 2026-07-09*

# 🎴 WishCraft — AI-Powered Wish Card Flutter App
## Complete Agent Build Context & Specification (Production-Grade / Firebase Edition)

---

## 📖 App Overview

**App Name:** WishCraft
**Platform:** Flutter (iOS + Android)
**Architecture:** MVVM (Model–View–ViewModel) with Riverpod
**Auth:** Firebase Authentication — Google Sign-In
**Database:** Cloud Firestore (per-user cloud sync) + Firestore offline persistence
**File Storage:** Firebase Storage (card thumbnails / exported images)
**AI Backend:** Google Gemini API, called **server-side** via a Firebase Cloud Function (never from the client)
**Backend runtime:** Firebase Cloud Functions (Node.js / TypeScript, 2nd gen)
**Min SDK:** Android 23 (required by `google_sign_in` + Firebase) / iOS 13

WishCraft is a beautifully designed, production-grade Flutter application that lets users create, customize, and share AI-generated greeting/wish cards for any occasion — Father's Day, Mother's Day, Birthdays, Eid, Christmas, New Year, Diwali, Anniversaries, and more. Users sign in with their Google account, and Gemini generates heartfelt, personalized wishes through a secured backend. Cards are synced to the cloud (Firestore + Storage) so they're available across devices. Users can customize card templates, preview them, then share directly to WhatsApp, Messenger, Telegram, or export as high-resolution PNG/PDF.

**Why the architecture changed from the original prototype spec:**
- Storing an end-user-supplied Gemini API key on-device (the original "bring your own key" flow) is not viable for a real product — it pushes billing/complexity onto users and is a support burden. Production apps proxy the LLM call through their own backend.
- Local-only Hive storage means cards are lost on uninstall/device change. A real product needs an account and cloud sync.
- Google Sign-In gives us a stable user identity to scope Firestore data, apply security rules, and rate-limit AI usage per user.

---

## ✨ Core Features

### 1. Authentication (NEW)
- Google Sign-In via Firebase Authentication (`firebase_auth` + `google_sign_in`)
- Persistent session — user stays signed in across app restarts (`authStateChanges()` stream)
- Sign out from Settings, with confirmation dialog
- Account deletion flow (removes Firebase Auth user + all Firestore/Storage data — required for App Store/Play Store compliance)
- Anonymous/guest fallback is **not** included by default; sign-in is required before creating or saving a card. (Optional stretch goal noted in Phase 14 of the agent guide if the team wants a guest preview mode.)

### 2. Occasion Selection
- Predefined occasion categories with icons and color themes
- Occasions: Father's Day, Mother's Day, Birthday, Anniversary, Eid, Christmas, New Year, Diwali, Graduation, Valentine's Day, Friendship Day, Custom
- Each occasion has a unique color palette, icon, and default card themes

### 3. AI Wish Generation (Gemini API via Cloud Function)
- User enters: recipient name, relationship, optional personal note, tone (Heartfelt / Funny / Formal / Poetic)
- Client calls the `generateWishes` **Firebase Callable Function** (Flutter `cloud_functions` package) — the client never talks to Gemini directly and never holds a Gemini API key
- The Cloud Function calls Gemini (`gemini-1.5-flash` or `gemini-2.0-flash`, configurable) using a key stored in Cloud Functions' secret manager, and returns 3 wish variants
- Regenerate individual variants with one tap (calls the function again)
- Users can also manually edit the generated wish text
- Server-side per-user daily quota enforcement (tracked in Firestore) to control cost and abuse, independent of Gemini's own rate limits

### 4. Card Customization
- 6+ card templates per occasion (backgrounds, decorative elements)
- Font family picker (6 font options: elegant serif, handwritten, bold, minimal, etc.)
- Font size slider
- Text color picker (preset palette)
- Background/gradient chooser
- Decorative sticker overlays (hearts, stars, flowers, balloons, etc.)
- Recipient name display toggle
- Sender name field

### 5. Card Preview
- Full-screen real-time preview using Flutter's `RepaintBoundary`
- Zoom and pan to inspect card details
- Card flips between front (design) and back (message) views

### 6. Export & Share
- **Export as PNG** — high-resolution (1080×1080 or 1080×1920)
- **Export as PDF** — single-page A4 or square format
- **Share to WhatsApp** — direct intent share
- **Share to Messenger** — via share_plus
- **Share to Telegram** — via share_plus
- **Share to Instagram Stories** — image share
- **Copy to Clipboard** — wish text only
- **General Share Sheet** — OS-native share sheet for any app

### 7. Saved Cards (Cloud-Synced)
- Cards are saved to **Cloud Firestore** under `users/{uid}/wish_cards/{cardId}`, with the exported thumbnail PNG uploaded to **Firebase Storage** under `users/{uid}/thumbnails/{cardId}.png`
- Firestore's built-in **offline persistence** is enabled, so the gallery works offline and syncs automatically when back online
- Gallery view of all saved cards with thumbnails (`StreamBuilder`/`StreamProvider` on a Firestore query, ordered by `updatedAt desc`)
- Edit previously saved cards
- Delete cards (deletes both the Firestore doc and the Storage thumbnail)
- Data is private per-user, enforced by Firestore Security Rules (see reference doc)

### 8. Onboarding
- 3-screen feature-intro onboarding on first launch (unchanged content-wise, minus the Gemini-explanation screen since users no longer manage a key)
- **Google Sign-In screen** replaces the old "API Key Setup" screen
- No API key is ever collected from or stored on the user's device

### 9. Settings
- Account section: profile photo, display name, email (from Google account), Sign Out, Delete Account
- Default font/theme preferences
- App theme toggle (Light / Dark / System)
- Daily AI generation quota indicator ("12 of 20 generations used today")
- About screen with version info

---

## 🏗️ Architecture: MVVM

```
UI Layer (View)        →  Flutter Widgets / Screens
ViewModel Layer        →  ChangeNotifier / StateNotifier classes
Model Layer            →  Data classes, repositories, services
Backend Layer (NEW)    →  Firebase Cloud Functions (Gemini proxy, quota enforcement)
```

### Data Flow
```
View → calls method on ViewModel
ViewModel → calls Repository/Service
Service → calls Firebase SDK (Auth / Firestore / Storage / Functions) or local cache
Cloud Function → calls Gemini API server-side (never the client)
ViewModel ← receives result, updates state
View ← rebuilds via Consumer/watch
```

### State Management: **Riverpod** (flutter_riverpod)
- `StateNotifierProvider` for ViewModels
- `StreamProvider` for Firebase Auth state and live Firestore queries (saved cards gallery)
- `FutureProvider` for one-shot async calls (Cloud Function invocations)
- `Provider` for services/repositories

---

## 📁 Folder Structure

```
wishcraft/
├── android/
├── ios/
├── functions/                              # Firebase Cloud Functions (NEW) — Node.js/TypeScript
│   ├── src/
│   │   ├── index.ts                        # Exports all callable functions
│   │   ├── generateWishes.ts               # Gemini proxy callable function
│   │   ├── quota.ts                        # Per-user daily quota check/increment
│   │   └── deleteAccount.ts                # Cascade-deletes user data on account deletion
│   ├── package.json
│   └── tsconfig.json
├── lib/
│   ├── main.dart                          # App entry point — Firebase.initializeApp()
│   ├── app.dart                           # MaterialApp, theme, router setup
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart            # Color palette constants
│   │   │   ├── app_strings.dart           # All string literals
│   │   │   ├── app_dimensions.dart        # Spacing, radius, sizes
│   │   │   └── app_assets.dart            # Asset path constants
│   │   ├── theme/
│   │   │   ├── app_theme.dart             # Light + Dark ThemeData
│   │   │   ├── text_styles.dart           # Typography definitions
│   │   │   └── occasion_themes.dart       # Per-occasion color themes
│   │   ├── router/
│   │   │   └── app_router.dart            # GoRouter route definitions, auth-aware redirect
│   │   ├── errors/
│   │   │   ├── app_exception.dart         # Custom exception classes
│   │   │   └── failure.dart               # Failure sealed class
│   │   └── utils/
│   │       ├── image_utils.dart           # RepaintBoundary → PNG/PDF
│   │       ├── share_utils.dart           # Share helpers (WA, TG, etc.)
│   │       ├── validators.dart            # Form validators
│   │       └── logger.dart               # Debug logger wrapper
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── occasion_model.dart        # Occasion data model
│   │   │   ├── card_template_model.dart   # Card template config model
│   │   │   ├── wish_card_model.dart       # Main WishCard model (Firestore, JSON-serializable)
│   │   │   ├── wish_variant_model.dart    # AI-generated wish text model
│   │   │   ├── user_model.dart            # App-level user profile (from FirebaseAuth.User)
│   │   │   └── user_preferences_model.dart# User settings model (Firestore doc)
│   │   ├── repositories/
│   │   │   ├── auth_repository.dart       # Abstract interface (NEW)
│   │   │   ├── auth_repository_impl.dart  # FirebaseAuth + GoogleSignIn implementation
│   │   │   ├── card_repository.dart       # Abstract interface
│   │   │   ├── card_repository_impl.dart  # Firestore + Storage implementation
│   │   │   ├── ai_repository.dart         # Abstract AI interface
│   │   │   └── ai_repository_impl.dart    # Cloud Functions implementation
│   │   ├── datasources/
│   │   │   ├── local/
│   │   │   │   └── local_cache_datasource.dart # Lightweight prefs cache (shared_preferences), NOT the source of truth
│   │   │   └── remote/
│   │   │       ├── firebase_auth_datasource.dart   # Google Sign-In + FirebaseAuth calls
│   │   │       ├── firestore_datasource.dart       # WishCard CRUD + preferences doc
│   │   │       ├── firebase_storage_datasource.dart# Thumbnail upload/delete
│   │   │       └── gemini_functions_datasource.dart# Calls the `generateWishes` Callable Function
│   │   └── services/
│   │       ├── gemini_service.dart        # Thin wrapper around the functions datasource + parsing
│   │       ├── export_service.dart        # PNG + PDF export logic
│   │       └── share_service.dart         # Platform share logic
│   │
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── occasion.dart              # Pure entity (no Firestore deps)
│   │   │   ├── wish_card.dart             # Pure wish card entity
│   │   │   ├── wish_variant.dart          # Pure wish variant entity
│   │   │   └── app_user.dart              # Pure user entity
│   │   └── usecases/
│   │       ├── sign_in_with_google_usecase.dart # NEW
│   │       ├── sign_out_usecase.dart            # NEW
│   │       ├── delete_account_usecase.dart      # NEW
│   │       ├── generate_wish_usecase.dart       # Orchestrates Cloud Function call
│   │       ├── save_card_usecase.dart           # Saves card to Firestore + thumbnail to Storage
│   │       ├── export_card_usecase.dart         # Triggers export pipeline
│   │       └── share_card_usecase.dart          # Triggers share pipeline
│   │
│   ├── presentation/
│   │   ├── viewmodels/
│   │   │   ├── auth_viewmodel.dart        # Auth state + sign-in/out actions (NEW)
│   │   │   ├── home_viewmodel.dart        # Home screen state
│   │   │   ├── occasion_viewmodel.dart    # Occasion list + selection
│   │   │   ├── wish_generator_viewmodel.dart # AI gen state + variants
│   │   │   ├── card_editor_viewmodel.dart # All card customization state
│   │   │   ├── preview_viewmodel.dart     # Preview + export/share state
│   │   │   └── saved_cards_viewmodel.dart # Saved gallery state (streams Firestore)
│   │   │
│   │   ├── screens/
│   │   │   ├── onboarding/
│   │   │   │   ├── onboarding_screen.dart
│   │   │   │   └── sign_in_screen.dart         # Replaces api_key_setup_screen.dart
│   │   │   ├── home/
│   │   │   │   └── home_screen.dart
│   │   │   ├── occasion/
│   │   │   │   └── occasion_selection_screen.dart
│   │   │   ├── wish_generator/
│   │   │   │   └── wish_generator_screen.dart
│   │   │   ├── card_editor/
│   │   │   │   └── card_editor_screen.dart
│   │   │   ├── preview/
│   │   │   │   └── card_preview_screen.dart
│   │   │   ├── saved_cards/
│   │   │   │   └── saved_cards_screen.dart
│   │   │   └── settings/
│   │   │       └── settings_screen.dart
│   │   │
│   │   └── widgets/
│   │       ├── cards/
│   │       │   ├── wish_card_widget.dart       # Main renderable card widget
│   │       │   ├── card_template_selector.dart # Horizontal template scroller
│   │       │   └── saved_card_thumbnail.dart   # Grid thumbnail widget
│   │       ├── occasion/
│   │       │   ├── occasion_chip.dart          # Single occasion pill/chip
│   │       │   └── occasion_grid.dart          # Grid of occasion chips
│   │       ├── editor/
│   │       │   ├── font_picker.dart            # Font family selector
│   │       │   ├── color_palette_picker.dart   # Color dot picker
│   │       │   ├── sticker_overlay_picker.dart # Sticker selector sheet
│   │       │   └── text_editor_panel.dart      # Font/size/color panel
│   │       ├── wish/
│   │       │   ├── wish_variant_card.dart      # Single AI wish option card
│   │       │   └── wish_variants_list.dart     # 3-variant display
│   │       ├── share/
│   │       │   └── share_bottom_sheet.dart     # Share options sheet
│   │       ├── auth/
│   │       │   └── google_sign_in_button.dart  # Branded Google button (NEW)
│   │       └── common/
│   │           ├── loading_overlay.dart
│   │           ├── error_snackbar.dart
│   │           ├── gradient_button.dart
│   │           └── app_scaffold.dart
│   │
│   └── providers/
│       ├── providers.dart                 # All provider declarations
│       └── provider_overrides.dart        # Test overrides (fake Firebase instances)
│
├── assets/
│   ├── fonts/
│   │   ├── Playfair/                      # Elegant serif
│   │   ├── Dancing_Script/                # Handwritten
│   │   ├── Montserrat/                    # Bold modern
│   │   ├── Lato/                          # Clean minimal
│   │   ├── Sacramento/                    # Flowing cursive
│   │   └── Nunito/                        # Friendly rounded
│   ├── images/
│   │   ├── templates/                     # Card background PNGs (per occasion)
│   │   │   ├── fathers_day/
│   │   │   ├── mothers_day/
│   │   │   ├── birthday/
│   │   │   ├── christmas/
│   │   │   ├── eid/
│   │   │   └── general/
│   │   ├── stickers/                      # Decorative PNG overlays
│   │   │   ├── hearts/
│   │   │   ├── flowers/
│   │   │   ├── stars/
│   │   │   ├── balloons/
│   │   │   └── confetti/
│   │   └── onboarding/                   # Onboarding illustrations
│   ├── icons/
│   │   └── app_icon.png
│   └── lottie/
│       ├── loading_sparkle.json           # AI generating animation
│       ├── success_confetti.json          # Share/export success
│       └── heart_pulse.json              # Card saved animation
│
├── test/
│   ├── unit/
│   │   ├── viewmodels/
│   │   ├── repositories/
│   │   └── services/
│   └── widget/
│       ├── screens/
│       └── widgets/
│
├── firebase.json                          # Firebase project config (Functions, Firestore, Storage)
├── .firebaserc
├── firestore.rules                        # Security rules (NEW)
├── firestore.indexes.json
├── storage.rules                          # Security rules for Storage (NEW)
├── pubspec.yaml
├── pubspec.lock
├── analysis_options.yaml
└── README.md
```

---

## 📦 pubspec.yaml Dependencies

```yaml
name: wishcraft
description: AI-powered wish card creator
version: 1.0.0+1

environment:
  sdk: '>=3.1.0 <4.0.0'
  flutter: '>=3.13.0'

dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3

  # Navigation
  go_router: ^12.1.3

  # Firebase (NEW — replaces direct HTTP + FlutterSecureStorage for API keys)
  firebase_core: ^2.27.0
  firebase_auth: ^4.17.4
  cloud_firestore: ^4.15.4
  firebase_storage: ^11.6.6
  cloud_functions: ^4.6.4
  firebase_app_check: ^0.2.1+15     # Attests requests to Cloud Functions/Firestore come from the real app
  google_sign_in: ^6.2.1

  # Local (lightweight cache only — Firestore is the source of truth)
  shared_preferences: ^2.2.2        # Theme choice, first-launch flag, cached prefs

  # Image & PDF Export
  screenshot: ^2.1.0                  # Widget → PNG capture
  pdf: ^3.10.7                        # PDF generation
  printing: ^5.12.0                   # PDF preview/share
  image: ^4.1.7                       # Image processing
  path_provider: ^2.1.2
  gallery_saver: ^2.3.2               # Save to gallery

  # Sharing
  share_plus: ^7.2.1

  # UI & Animation
  lottie: ^3.0.0
  flutter_animate: ^4.3.0
  shimmer: ^3.0.0
  cached_network_image: ^3.3.1        # Loads Firebase Storage thumbnail URLs
  smooth_page_indicator: ^1.1.0       # Onboarding dots
  flutter_colorpicker: ^1.0.3
  google_fonts: ^6.1.0

  # Utilities
  uuid: ^4.3.3
  intl: ^0.18.1
  permission_handler: ^11.2.0
  url_launcher: ^6.2.4
  equatable: ^2.0.5
  dartz: ^0.10.1                      # Functional error handling (Either)
  freezed_annotation: ^2.4.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.7
  freezed: ^2.4.6
  riverpod_generator: ^2.3.9
  json_serializable: ^6.7.1
  flutter_lints: ^3.0.1
  mockito: ^5.4.4
  fake_cloud_firestore: ^2.4.9        # Unit-testing Firestore repositories
  firebase_auth_mocks: ^0.13.0        # Unit-testing auth flows
```

> **Removed from the original spec:** `hive`, `hive_flutter`, `hive_generator`, `flutter_secure_storage`, `dio`, `google_generative_ai`, `flutter_share_me`. Hive/secure-storage are replaced by Firebase; Dio/the Gemini SDK are replaced by `cloud_functions` since Gemini is now only called from the backend.

---

## 🗃️ Key File Implementations

### `lib/main.dart`
```dart
// WidgetsFlutterBinding.ensureInitialized()
// await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
// Activate Firebase App Check (Play Integrity on Android, DeviceCheck/App Attest on iOS)
// Enable Firestore offline persistence (on by default for mobile, but set cache size explicitly)
// Run app wrapped in ProviderScope
// Router decides initial route based on authStateChangesProvider (see app_router.dart)
```

### `lib/app.dart`
```dart
// MaterialApp.router with GoRouter
// Theme mode from provider (light/dark/system)
// Global error boundary
```

---

## 🤖 Gemini Integration (Server-Side, via Cloud Functions)

### Why not call Gemini from the Flutter client?
A production app must never ship a Gemini/any paid API key inside the app binary — it can be extracted via reverse engineering and abused, running up the developer's bill. Instead:

1. The Flutter client calls a **Firebase Callable Function** named `generateWishes`, authenticated automatically via the signed-in user's Firebase Auth ID token (the `cloud_functions` SDK attaches this for you).
2. The Cloud Function verifies the caller is authenticated, checks/increments a **daily quota document** in Firestore (`users/{uid}/meta/quota`), then calls the Gemini API using a key stored in **Cloud Functions secrets** (`firebase functions:secrets:set GEMINI_API_KEY`) — never bundled in client code or source control.
3. The function returns the parsed wish variants (or a structured error) back to the client.

### `functions/src/generateWishes.ts` (conceptual)

**Model:** `gemini-1.5-flash` (or `gemini-2.0-flash` — configurable via a Functions parameter so it can be upgraded without a client release)
**Trigger:** `onCall` (Firebase Callable Function, 2nd gen)
**Auth:** Enforced by `request.auth` — reject with `unauthenticated` if missing

**Prompt Template (unchanged from the original design, built server-side):**
```
You are a creative wish card writer. Generate 3 distinct wish messages for a {occasion} card.

Details:
- Recipient Name: {recipientName}
- Relationship: {relationship}
- Personal Note (optional): {personalNote}
- Tone: {tone} (Heartfelt / Funny / Formal / Poetic)

Rules:
- Each wish should be 2–5 sentences
- Separate each wish with "---WISH_SEPARATOR---"
- Do NOT add numbering or labels
- Make each wish distinct in style and imagery
- Include the recipient's name naturally in each wish
- Match the tone strictly

Output format (only the wishes, no extra text):
[Wish 1 text]
---WISH_SEPARATOR---
[Wish 2 text]
---WISH_SEPARATOR---
[Wish 3 text]
```

**Quota enforcement (server-side, cannot be bypassed by the client):**
- Read `users/{uid}/meta/quota` (fields: `date`, `count`)
- If `date` != today → reset `count` to 0
- If `count >= DAILY_LIMIT` (e.g. 20) → throw `resource-exhausted`
- Otherwise increment `count` in the same transaction as the Gemini call succeeding

**Response Parsing (same rule as before, now server-side):**
- Split response by `"---WISH_SEPARATOR---"`
- Trim each part
- Return as a JSON array of `{ id, text }` objects to the client

**Error Handling (mapped to Firebase Functions error codes):**
- Missing/invalid auth → `unauthenticated`
- Quota exceeded → `resource-exhausted` ("You've used today's AI generations — try again tomorrow.")
- Gemini `429` → `resource-exhausted` with a retry-after hint
- Gemini `400`/malformed prompt → `invalid-argument`
- Empty/unparseable Gemini response → `internal` ("Could not generate wishes, please try again.")

The Flutter client (`gemini_functions_datasource.dart`) catches `FirebaseFunctionsException` and maps `.code` to a user-friendly `AppException` message — the client-facing error handling story from the original spec is preserved, just sourced from Functions error codes instead of raw HTTP status codes.

---

## 🎨 Card Rendering Architecture

### `lib/presentation/widgets/cards/wish_card_widget.dart`

The card is a pure Flutter widget wrapped in `RepaintBoundary` for pixel-perfect image export. (Unchanged from the original design.)

**Card Layers (bottom to top):**
1. `Container` with gradient or image background (template)
2. Decorative illustration image (occasion-specific SVG/PNG)
3. Sticker overlays (positioned, user-placed)
4. Occasion label text (e.g., "Happy Father's Day")
5. Wish text (scrollable, styled with chosen font)
6. Recipient name text (bold, prominent)
7. Sender name text (bottom right, italic)
8. Decorative border frame (optional)

**Card Size:** 1080×1080px logical (scaled for display, exported at full res)

**Export Logic in `lib/core/utils/image_utils.dart`:**
```dart
Future<Uint8List> captureCardAsPng(GlobalKey repaintKey) async {
  RenderRepaintBoundary boundary = repaintKey.currentContext!
      .findRenderObject() as RenderRepaintBoundary;
  ui.Image image = await boundary.toImage(pixelRatio: 3.0); // 3× for HQ
  ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}
```

---

## ☁️ Cloud Sync: Firestore + Storage

### Firestore data model
```
users/{uid}                              # profile doc: displayName, email, photoUrl, createdAt
users/{uid}/wish_cards/{cardId}          # one doc per saved card
users/{uid}/preferences/settings         # single doc: defaultFont, defaultTone, themeMode
users/{uid}/meta/quota                   # single doc: date, count (AI generation quota)
```

### `WishCardModel` document shape (Firestore)
Stored as a plain JSON-serializable map (via `toJson`/`fromJson`, no Hive annotations needed):
```json
{
  "id": "uuid",
  "occasionId": "fathers_day",
  "recipientName": "Dad",
  "senderName": "Alex",
  "wishText": "...",
  "templateId": "template_02",
  "fontFamily": "Playfair Display",
  "fontSize": 20.0,
  "textColor": 4294967295,
  "stickerIds": ["heart_01", "star_03"],
  "showBorder": true,
  "thumbnailUrl": "https://firebasestorage.googleapis.com/.../thumbnails/uuid.png",
  "createdAt": "Timestamp",
  "updatedAt": "Timestamp"
}
```
`thumbnailPath` (a local file path in the original Hive design) becomes `thumbnailUrl` — a Firebase Storage download URL, since the thumbnail must be reachable across devices.

### Firebase Storage layout
```
users/{uid}/thumbnails/{cardId}.png      # low-res (pixelRatio: 1.0) capture of the card
```

### Security Rules (high-level intent — full rules in the implementation reference doc)
- **Firestore:** a user may only read/write documents under their own `users/{uid}/...` path; `request.auth.uid == uid` is required on every rule.
- **Storage:** identical pattern — a user may only read/write objects under `users/{uid}/...`.
- **Cloud Functions:** `generateWishes` and `deleteAccount` both require `request.auth != null`.

### Offline behavior
Cloud Firestore's mobile SDK caches reads/writes locally by default. `SavedCardsViewModel` subscribes to a `Stream<QuerySnapshot>`, so the gallery renders instantly from cache and reconciles automatically once connectivity returns — no custom sync code required.

---

## 🔒 Permissions & Platform Setup Required

### Firebase / Google Sign-In (all platforms)
- Create a Firebase project, register Android + iOS apps, download `google-services.json` / `GoogleService-Info.plist`
- Enable **Google** as a sign-in provider in Firebase Authentication
- Android: add the app's **SHA-1 and SHA-256** release + debug fingerprints in the Firebase console (Google Sign-In fails silently without this — see pitfalls table)
- iOS: add the **reversed client ID** URL scheme to `Info.plist` (from `GoogleService-Info.plist`'s `REVERSED_CLIENT_ID`)
- Run `flutterfire configure` to generate `lib/firebase_options.dart`

### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="29"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
```

### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>WishCraft needs access to save your wish cards to Photos</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>WishCraft needs access to save your wish cards to Photos</string>
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>REVERSED_CLIENT_ID_FROM_GOOGLESERVICE_INFO_PLIST</string>
    </array>
  </dict>
</array>
```

---

## 🔄 App Navigation Flow

```
Splash → [authStateChanges() stream]
            ├── Signed out + first launch → Onboarding → Google Sign-In → Home
            ├── Signed out, not first launch → Google Sign-In → Home
            └── Signed in → Home
                        ├── Occasion Selection
                        │       └── Wish Generator
                        │               └── Card Editor
                        │                       └── Card Preview
                        │                               ├── Share Sheet
                        │                               │     ├── WhatsApp
                        │                               │     ├── Telegram
                        │                               │     ├── Messenger
                        │                               │     └── More...
                        │                               ├── Export PNG
                        │                               └── Export PDF
                        ├── Saved Cards (streamed from Firestore)
                        │       └── Card Editor (edit mode)
                        └── Settings
                                └── Sign Out / Delete Account
```

**GoRouter Routes:**
```dart
/                    → SplashScreen
/onboarding          → OnboardingScreen
/sign-in             → SignInScreen            // replaces /api-setup
/home                → HomeScreen
/occasions           → OccasionSelectionScreen
/wish-generator/:occasionId  → WishGeneratorScreen
/card-editor         → CardEditorScreen  (receives card state)
/preview             → CardPreviewScreen
/saved-cards         → SavedCardsScreen
/settings            → SettingsScreen
```

The router's `redirect` callback watches `authStateChangesProvider` (a `StreamProvider<User?>` wrapping `FirebaseAuth.instance.authStateChanges()`) instead of the old `hasApiKeyProvider`.

---

## 🧪 Testing Strategy

### Unit Tests
- `GeminiService` / `GeminiFunctionsDatasource` — mock `FirebaseFunctions`, test request payload + response parsing
- `AuthRepository` — use `firebase_auth_mocks` to test sign-in/sign-out state transitions
- `CardRepository` — use `fake_cloud_firestore` to test CRUD operations without a real project
- `WishGeneratorViewModel` — test state transitions
- `CardEditorViewModel` — test undo/redo, state mutations
- `ExportService` — test file creation logic
- **Cloud Functions:** `firebase-functions-test` for unit-testing `generateWishes` and quota logic in isolation

### Widget Tests
- `WishCardWidget` — snapshot test for different templates
- `OccasionGrid` — tap interaction
- `ShareBottomSheet` — button visibility
- `SignInScreen` — renders Google button, shows loading/error states

### Security Rules Tests
- Use the Firebase Emulator Suite (`firebase emulators:start`) with `@firebase/rules-unit-testing` to assert a user cannot read/write another user's `wish_cards` documents or Storage objects.

---

## ⚙️ Build & Run Instructions

```bash
# 1. Install the FlutterFire CLI and configure Firebase
dart pub global activate flutterfire_cli
flutterfire configure   # generates lib/firebase_options.dart, links Android/iOS apps

# 2. Install Flutter dependencies
flutter pub get

# 3. Generate Freezed models + Riverpod providers
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Install & deploy Cloud Functions
cd functions
npm install
firebase functions:secrets:set GEMINI_API_KEY
firebase deploy --only functions
cd ..

# 5. Deploy Firestore & Storage security rules
firebase deploy --only firestore:rules,storage:rules

# 6. (Optional but recommended) Run against local emulators during development
firebase emulators:start --only auth,firestore,storage,functions

# 7. Run the app
flutter run

# 8. Build release APK / IPA
flutter build apk --release
flutter build ipa --release
```

---

## 🚨 Important Implementation Notes for Agent

1. **RepaintBoundary GlobalKey** must be defined at Screen level (not inside build), passed down to the card widget, and kept stable across rebuilds.

2. **Gemini API calls now happen only inside Cloud Functions.** Never add `google_generative_ai`, a raw Gemini HTTP call, or any Gemini API key to the Flutter app. If the agent finds itself writing `dio.post('...generativelanguage.googleapis.com...')` inside `lib/`, stop — that logic belongs in `functions/src/generateWishes.ts`.

3. **Cloud Function calls** must always handle `FirebaseFunctionsException` and map `.code` (`unauthenticated`, `resource-exhausted`, `invalid-argument`, `internal`, `deadline-exceeded`) to user-friendly messages — including a clear message for quota exhaustion.

4. **Firebase must be initialized before `runApp()`** in `main.dart` (`await Firebase.initializeApp(...)`), and App Check should be activated immediately after.

5. **Auth state drives routing.** `SavedCardsViewModel`, `HomeViewModel`, and any Firestore-backed provider should assume `FirebaseAuth.instance.currentUser` is non-null — screens behind the auth redirect should never be reachable while signed out.

6. **Card thumbnails** for the saved gallery: capture a low-res version (pixelRatio: 1.0), upload it to Firebase Storage at `users/{uid}/thumbnails/{cardId}.png`, and store the resulting **download URL** (not a local path) in the Firestore document's `thumbnailUrl` field.

7. **Font loading** via `google_fonts` is async — preload fonts on app start or show shimmer while loading.

8. **Permission handling** with `permission_handler`: always check + request before gallery save, handle permanent denial gracefully.

9. **Sticker placement**: implement using `Stack` + `Positioned` widgets. Store sticker positions as `Offset` normalized to card dimensions (0.0–1.0) so they scale correctly on export.

10. **Undo/redo** in `CardEditorViewModel`: maintain a `List<CardEditorState>` history (max 20 items) and a current index pointer.

11. **Account deletion** must cascade: delete the Firebase Auth user, all `users/{uid}/wish_cards/*` Firestore docs, the `users/{uid}` profile doc, and all `users/{uid}/thumbnails/*` Storage objects. Do this via the `deleteAccount` Cloud Function (triggered before the client calls `user.delete()`), not client-side loops, so it can't be interrupted mid-way by a network drop.

12. **Never commit `google-services.json`, `GoogleService-Info.plist`, or any Firebase config containing sensitive values to a public repo without checking your organization's policy** — they contain project identifiers (not secrets by themselves, but still handle deliberately). The Gemini API key must **only** ever live in Cloud Functions secrets, never in `pubspec.yaml`, `.env` files bundled into the client, or Firestore.

---

## 📝 Sample Occasions List

```dart
const List<OccasionModel> occasions = [
  OccasionModel(id: 'fathers_day',    displayName: "Father's Day",    emoji: '👨'),
  OccasionModel(id: 'mothers_day',    displayName: "Mother's Day",    emoji: '👩'),
  OccasionModel(id: 'birthday',       displayName: 'Birthday',        emoji: '🎂'),
  OccasionModel(id: 'anniversary',    displayName: 'Anniversary',     emoji: '💑'),
  OccasionModel(id: 'eid',            displayName: 'Eid Mubarak',     emoji: '🌙'),
  OccasionModel(id: 'christmas',      displayName: 'Christmas',       emoji: '🎄'),
  OccasionModel(id: 'new_year',       displayName: 'New Year',        emoji: '🎆'),
  OccasionModel(id: 'diwali',         displayName: 'Diwali',          emoji: '🪔'),
  OccasionModel(id: 'graduation',     displayName: 'Graduation',      emoji: '🎓'),
  OccasionModel(id: 'valentine',      displayName: "Valentine's Day", emoji: '❤️'),
  OccasionModel(id: 'friendship',     displayName: 'Friendship Day',  emoji: '🤝'),
  OccasionModel(id: 'get_well',       displayName: 'Get Well Soon',   emoji: '🌻'),
  OccasionModel(id: 'thank_you',      displayName: 'Thank You',       emoji: '🙏'),
  OccasionModel(id: 'congratulations',displayName: 'Congratulations', emoji: '🏆'),
  OccasionModel(id: 'custom',         displayName: 'Custom',          emoji: '✨'),
];
```

---

## 🎨 Occasion Themes

```dart
// lib/core/theme/occasion_themes.dart

const occasionThemes = {
  'fathers_day': OccasionTheme(
    primaryColor: Color(0xFF1A3C5E),    // Navy blue
    secondaryColor: Color(0xFFD4A853),  // Gold
    accentColor: Color(0xFFE8F4FD),
    gradientColors: [Color(0xFF1A3C5E), Color(0xFF2E6DA4)],
  ),
  'mothers_day': OccasionTheme(
    primaryColor: Color(0xFFE91E8C),    // Deep pink
    secondaryColor: Color(0xFFFFF0F5),  // Lavender blush
    accentColor: Color(0xFFFF6BB5),
    gradientColors: [Color(0xFFFF6BB5), Color(0xFFFF9ED8)],
  ),
  'birthday': OccasionTheme(
    primaryColor: Color(0xFF7B2FBE),    // Purple
    secondaryColor: Color(0xFFFFD700),  // Gold
    accentColor: Color(0xFFFF6B6B),
    gradientColors: [Color(0xFF7B2FBE), Color(0xFFE040FB)],
  ),
  'christmas': OccasionTheme(
    primaryColor: Color(0xFF1B5E20),    // Christmas green
    secondaryColor: Color(0xFFC62828),  // Christmas red
    accentColor: Color(0xFFFFD700),
    gradientColors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
  ),
  'eid': OccasionTheme(
    primaryColor: Color(0xFF00695C),    // Teal green
    secondaryColor: Color(0xFFFFD700),  // Gold
    accentColor: Color(0xFFE8F5E9),
    gradientColors: [Color(0xFF00695C), Color(0xFF00897B)],
  ),
  // ... more occasions
};
```

---

## 📱 Screens Specification

### 1. Onboarding Screen (`onboarding_screen.dart`)
- 3 pages using `PageView`
- Page 1: App intro — "Create Beautiful Wish Cards in Seconds"
- Page 2: "Powered by AI" — Gemini explanation (generic, no key setup mentioned)
- Page 3: "Share Instantly" — sharing features
- `SmoothPageIndicator` for dots
- Skip button top-right
- "Get Started" on last page → Sign-In Screen

### 2. Sign-In Screen (`sign_in_screen.dart`) — replaces API Key Setup Screen
- App logo + tagline
- Single **"Continue with Google"** branded button (`google_sign_in_button.dart`)
- Loading state while the Google + Firebase Auth flow completes
- Friendly error state (e.g., network failure, user cancelled) with a retry button
- Short privacy note + link to a privacy policy (required by Google Sign-In branding guidelines and app store review)
- On success → Home Screen

### 3. Home Screen (`home_screen.dart`)
- App bar with logo, user avatar (from Google profile photo), and settings icon
- "Saved Cards" shortcut (if any)
- Occasion grid (2-col grid of occasion cards)
- Recent cards horizontal scroll (last 3 saved, streamed from Firestore)
- FAB: "Create New Card"

### 4. Occasion Selection Screen (`occasion_selection_screen.dart`)
- Search bar to filter occasions
- Animated grid of occasion cards
- Each card: icon, name, color theme preview
- Tap → navigates to Wish Generator

### 5. Wish Generator Screen (`wish_generator_screen.dart`)
- **Form fields:**
  - Recipient Name (required)
  - Relationship (dropdown: Mom, Dad, Friend, Wife, Husband, Child, Boss, Custom)
  - Personal note (optional, multiline)
  - Tone selector (chip group: Heartfelt, Funny, Formal, Poetic)
- "Generate Wishes" button → shows loading (Lottie sparkle) while the Cloud Function runs
- Shows remaining daily quota if the user is close to the limit
- **Results section:**
  - 3 `WishVariantCard` widgets
  - Each shows text, a "Use This" button, a "Regenerate" icon
  - Selected variant highlighted with border
- "Next: Customize Card" button → Card Editor

### 6. Card Editor Screen (`card_editor_screen.dart`)
- **Top half:** Live card preview (non-repaint key, interactive)
- **Bottom half:** Tabbed editor panel
  - Tab 1 — Templates: horizontal scroll of template thumbs
  - Tab 2 — Text: font picker, size slider, color picker
  - Tab 3 — Stickers: grid of sticker PNGs (drag to card)
  - Tab 4 — Layout: sender name, recipient name toggle, border toggle
- Undo/Redo buttons in app bar
- "Preview & Share" FAB

### 7. Card Preview Screen (`card_preview_screen.dart`)
- Full-screen card display (InteractiveViewer for zoom/pan)
- Wrapped in `RepaintBoundary` (the actual export widget)
- Bottom bar with action buttons:
  - 💾 Save to Cloud (writes Firestore doc + uploads thumbnail)
  - 🖼️ Export PNG
  - 📄 Export PDF
  - 📤 Share Sheet
- Tap "Share Sheet" → shows `ShareBottomSheet`

### 8. Share Bottom Sheet (`share_bottom_sheet.dart`)
- Grid of share targets:
  - WhatsApp (green icon)
  - Messenger (blue/purple icon)
  - Telegram (blue icon)
  - Instagram Stories (gradient icon)
  - Save to Gallery
  - More (system share sheet)
- Each target: icon + label
- Progress indicator while exporting/sharing

### 9. Saved Cards Screen (`saved_cards_screen.dart`)
- Staggered grid of saved card thumbnails, built from a `StreamProvider` over the user's Firestore `wish_cards` collection (`GridView.builder` + `cached_network_image` for `thumbnailUrl`)
- Long press → context menu (Edit / Delete / Share)
- Empty state illustration
- Search/filter by occasion
- Offline banner if the device is offline (Firestore still serves cached data)

### 10. Settings Screen (`settings_screen.dart`)
- Account section: Google profile photo, display name, email, **Sign Out**, **Delete Account** (with a confirmation dialog explaining the cascade delete)
- Default Preferences (font, tone)
- Theme Toggle (Light / Dark / System)
- Daily AI quota usage indicator
- Clear All Saved Cards (with confirmation)
- About (version, licenses)
- "Rate App" link

---

## 🗄️ Data Models

### `WishCardModel` (Firestore, JSON-serializable — no Hive annotations)
```dart
class WishCardModel {
  final String id;              // UUID
  final String occasionId;      // e.g., 'fathers_day'
  final String recipientName;
  final String senderName;
  final String wishText;        // Final selected/edited wish
  final String templateId;      // Selected background template
  final String fontFamily;
  final double fontSize;
  final int textColor;          // Color.value (int)
  final List<String> stickerIds;// Placed sticker asset paths
  final bool showBorder;
  final String? thumbnailUrl;   // Firebase Storage download URL (was thumbnailPath)
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson();
  factory WishCardModel.fromJson(Map<String, dynamic> json, String id);
}
```

### `OccasionModel`
```dart
class OccasionModel {
  final String id;               // 'fathers_day', 'mothers_day', etc.
  final String displayName;      // 'Father's Day'
  final String emoji;            // '👨'
  final Color primaryColor;
  final Color secondaryColor;
  final String templateFolder;   // assets/images/templates/fathers_day/
  final List<String> templateIds;
  final IconData icon;
}
```

### `WishVariantModel`
```dart
class WishVariantModel {
  final String id;        // UUID for the variant
  final String text;      // AI-generated wish text
  bool isSelected;        // User selected this variant
}
```

### `AppUser` / `UserModel` (NEW)
```dart
class AppUser {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;
}
```

---

## 🧩 ViewModels

### `AuthViewModel` (NEW)
```dart
class AuthViewModel extends StateNotifier<AsyncValue<AppUser?>> {
  Future<void> signInWithGoogle();
  Future<void> signOut();
  Future<void> deleteAccount();
}
```

### `WishGeneratorViewModel`
```dart
class WishGeneratorViewModel extends StateNotifier<WishGeneratorState> {
  AsyncValue<List<WishVariantModel>> wishVariants; // loading/data/error
  WishVariantModel? selectedVariant;
  String recipientName, relationship, personalNote, tone;

  Future<void> generateWishes();        // Calls GenerateWishUsecase → Cloud Function
  Future<void> regenerateVariant(int index); // Re-gen single variant
  void selectVariant(int index);
  void editVariantText(int index, String newText);
}
```

### `CardEditorViewModel`
```dart
class CardEditorViewModel extends StateNotifier<CardEditorState> {
  String selectedTemplateId;
  String fontFamily;
  double fontSize;
  Color textColor;
  List<String> appliedStickerIds;
  bool showBorder;
  String senderName;
  List<CardEditorState> _history;  // Undo/redo stack

  void selectTemplate(String id);
  void setFont(String fontFamily);
  void setFontSize(double size);
  void setTextColor(Color color);
  void addSticker(String stickerId);
  void removeSticker(String stickerId);
  void toggleBorder();
  void undo();
  void redo();
}
```

### `PreviewViewModel`
```dart
class PreviewViewModel extends StateNotifier<PreviewState> {
  bool isExporting;
  bool isSaving;
  String? exportedFilePath;
  String? errorMessage;

  Future<void> saveCard(WishCardModel card); // Firestore write + Storage upload
  Future<File> exportAsPng(GlobalKey repaintKey, String name);
  Future<File> exportAsPdf(GlobalKey repaintKey, String name);
  Future<void> shareToWhatsApp(GlobalKey repaintKey);
  Future<void> shareToTelegram(GlobalKey repaintKey);
  Future<void> shareToMessenger(GlobalKey repaintKey);
  Future<void> openShareSheet(GlobalKey repaintKey);
}
```

### `SavedCardsViewModel`
```dart
class SavedCardsViewModel extends StateNotifier<SavedCardsState> {
  // Backed by a Stream<List<WishCardModel>> over
  // FirebaseFirestore.instance.collection('users/$uid/wish_cards')
  //   .orderBy('updatedAt', descending: true).snapshots()

  Future<void> deleteCard(String cardId); // Deletes Firestore doc + Storage thumbnail
  void filterByOccasion(String? occasionId);
}
```

---

*This document is the complete specification for the WishCraft Flutter app (Firebase edition). An AI agent should use this as the single source of truth for architecture decisions, file creation, feature implementation, and code structure. It replaces the original local-only / user-supplied-API-key prototype spec.*

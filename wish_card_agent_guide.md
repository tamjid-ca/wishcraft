# 🚀 WishCraft — Agent Quick-Start Checklist & Build Order (Firebase Edition)

## How to Use These Docs

Feed these 3 files to your AI coding agent in this order:
1. `wish_card_app_context.md` — Architecture, features, folder structure (Firebase Auth + Firestore + Storage + Cloud Functions)
2. `wish_card_implementation_reference.md` — Key file code snippets, including the Cloud Functions backend
3. `wish_card_agent_guide.md` (this file) — Step-by-step build order

> **What changed from the original prototype spec:** local Hive storage → Cloud Firestore + Firebase Storage; user-supplied Gemini API key stored on-device → Gemini called server-side from a Firebase Cloud Function; no login → Google Sign-In via Firebase Auth. This is what makes the app production-grade rather than a local demo.

---

## ✅ Build Order (Follow This Sequence)

### Phase 0: Firebase Project Setup (NEW — do this before writing any Flutter code)
- [ ] Create a Firebase project in the Firebase console
- [ ] Enable **Authentication → Google** sign-in provider
- [ ] Enable **Cloud Firestore** (production mode, choose a region)
- [ ] Enable **Firebase Storage**
- [ ] Enable **Cloud Functions** (requires the Blaze pay-as-you-go plan — Gemini calls and Functions both need it)
- [ ] Enable **App Check** (Play Integrity for Android, App Attest for iOS)
- [ ] Register the Android app (needs the package name + **SHA-1 and SHA-256 fingerprints**) and the iOS app (needs the bundle ID) in Project Settings
- [ ] Download `google-services.json` → `android/app/`
- [ ] Download `GoogleService-Info.plist` → `ios/Runner/`
- [ ] Note the Gemini API key (from Google AI Studio) — this goes into **Cloud Functions secrets**, never into the Flutter project

### Phase 1: Project Bootstrap
- [ ] `flutter create wishcraft --org com.yourname`
- [ ] Replace `pubspec.yaml` with the full dependency list from the context doc (Firebase packages included)
- [ ] `dart pub global activate flutterfire_cli` then `flutterfire configure` → generates `lib/firebase_options.dart` and links both platforms
- [ ] Run `flutter pub get`
- [ ] Create the full folder structure from the context doc, including the new `functions/` directory at the repo root
- [ ] Add `analysis_options.yaml`

### Phase 2: Core Layer
- [ ] `lib/core/errors/app_exception.dart`
- [ ] `lib/core/constants/app_colors.dart`
- [ ] `lib/core/constants/app_strings.dart`
- [ ] `lib/core/constants/app_dimensions.dart`
- [ ] `lib/core/constants/app_assets.dart`
- [ ] `lib/core/theme/app_theme.dart`
- [ ] `lib/core/theme/text_styles.dart`
- [ ] `lib/core/theme/occasion_themes.dart`
- [ ] `lib/core/utils/image_utils.dart`
- [ ] `lib/core/utils/share_utils.dart`
- [ ] `lib/core/utils/validators.dart`

### Phase 3: Firebase Backend (Cloud Functions) — build before the app depends on it
- [ ] `functions/package.json`, `functions/tsconfig.json`
- [ ] `functions/src/generateWishes.ts` (Gemini proxy + quota enforcement)
- [ ] `functions/src/deleteAccount.ts` (cascade delete)
- [ ] `functions/src/index.ts` (exports)
- [ ] `firestore.rules`
- [ ] `storage.rules`
- [ ] `firebase functions:secrets:set GEMINI_API_KEY`
- [ ] `firebase deploy --only functions,firestore:rules,storage:rules`
- [ ] Smoke-test `generateWishes` from the Firebase console or `firebase functions:shell` before wiring up the Flutter client

### Phase 4: Data Layer
- [ ] `lib/data/models/wish_card_model.dart` (plain JSON-serializable, no Hive annotations)
- [ ] `lib/data/models/occasion_model.dart`
- [ ] `lib/data/models/wish_variant_model.dart`
- [ ] `lib/data/models/user_model.dart`
- [ ] `lib/data/models/user_preferences_model.dart`
- [ ] `lib/data/datasources/local/local_cache_datasource.dart` (shared_preferences — theme + first-launch flag only)
- [ ] `lib/data/datasources/remote/firebase_auth_datasource.dart`
- [ ] `lib/data/datasources/remote/firestore_datasource.dart`
- [ ] `lib/data/datasources/remote/firebase_storage_datasource.dart`
- [ ] `lib/data/datasources/remote/gemini_functions_datasource.dart`
- [ ] `lib/data/services/gemini_service.dart`
- [ ] `lib/data/services/export_service.dart`
- [ ] `lib/data/services/share_service.dart`
- [ ] `lib/data/repositories/auth_repository.dart` (abstract)
- [ ] `lib/data/repositories/auth_repository_impl.dart`
- [ ] `lib/data/repositories/card_repository.dart` (abstract)
- [ ] `lib/data/repositories/card_repository_impl.dart`
- [ ] `lib/data/repositories/ai_repository.dart` (abstract)
- [ ] `lib/data/repositories/ai_repository_impl.dart`

### Phase 5: Domain Layer
- [ ] `lib/domain/entities/occasion.dart`
- [ ] `lib/domain/entities/wish_card.dart`
- [ ] `lib/domain/entities/wish_variant.dart`
- [ ] `lib/domain/entities/app_user.dart`
- [ ] `lib/domain/usecases/sign_in_with_google_usecase.dart`
- [ ] `lib/domain/usecases/sign_out_usecase.dart`
- [ ] `lib/domain/usecases/delete_account_usecase.dart`
- [ ] `lib/domain/usecases/generate_wish_usecase.dart`
- [ ] `lib/domain/usecases/save_card_usecase.dart`
- [ ] `lib/domain/usecases/export_card_usecase.dart`
- [ ] `lib/domain/usecases/share_card_usecase.dart`

### Phase 6: ViewModels
- [ ] `lib/presentation/viewmodels/auth_viewmodel.dart`
- [ ] `lib/presentation/viewmodels/home_viewmodel.dart`
- [ ] `lib/presentation/viewmodels/occasion_viewmodel.dart`
- [ ] `lib/presentation/viewmodels/wish_generator_viewmodel.dart`
- [ ] `lib/presentation/viewmodels/card_editor_viewmodel.dart`
- [ ] `lib/presentation/viewmodels/preview_viewmodel.dart`
- [ ] `lib/presentation/viewmodels/saved_cards_viewmodel.dart`

### Phase 7: Providers
- [ ] `lib/providers/providers.dart`

### Phase 8: Common Widgets
- [ ] `lib/presentation/widgets/common/loading_overlay.dart`
- [ ] `lib/presentation/widgets/common/error_snackbar.dart`
- [ ] `lib/presentation/widgets/common/gradient_button.dart`
- [ ] `lib/presentation/widgets/common/app_scaffold.dart`
- [ ] `lib/presentation/widgets/auth/google_sign_in_button.dart`

### Phase 9: Card Widgets
- [ ] `lib/presentation/widgets/cards/wish_card_widget.dart`
- [ ] `lib/presentation/widgets/cards/card_template_selector.dart`
- [ ] `lib/presentation/widgets/cards/saved_card_thumbnail.dart` (uses `cached_network_image` for `thumbnailUrl`)

### Phase 10: Feature Widgets
- [ ] `lib/presentation/widgets/occasion/occasion_chip.dart`
- [ ] `lib/presentation/widgets/occasion/occasion_grid.dart`
- [ ] `lib/presentation/widgets/wish/wish_variant_card.dart`
- [ ] `lib/presentation/widgets/wish/wish_variants_list.dart`
- [ ] `lib/presentation/widgets/editor/font_picker.dart`
- [ ] `lib/presentation/widgets/editor/color_palette_picker.dart`
- [ ] `lib/presentation/widgets/editor/sticker_overlay_picker.dart`
- [ ] `lib/presentation/widgets/editor/text_editor_panel.dart`
- [ ] `lib/presentation/widgets/share/share_bottom_sheet.dart`

### Phase 11: Screens
- [ ] `lib/presentation/screens/onboarding/onboarding_screen.dart`
- [ ] `lib/presentation/screens/onboarding/sign_in_screen.dart` (replaces api_key_setup_screen.dart)
- [ ] `lib/presentation/screens/home/home_screen.dart`
- [ ] `lib/presentation/screens/occasion/occasion_selection_screen.dart`
- [ ] `lib/presentation/screens/wish_generator/wish_generator_screen.dart`
- [ ] `lib/presentation/screens/card_editor/card_editor_screen.dart`
- [ ] `lib/presentation/screens/preview/card_preview_screen.dart`
- [ ] `lib/presentation/screens/saved_cards/saved_cards_screen.dart`
- [ ] `lib/presentation/screens/settings/settings_screen.dart` (Sign Out + Delete Account)

### Phase 12: App Bootstrap
- [ ] `lib/core/router/app_router.dart` (auth-aware redirect)
- [ ] `lib/app.dart`
- [ ] `lib/main.dart` (Firebase.initializeApp + App Check)

### Phase 13: Assets & Config
- [ ] Add all fonts to `assets/fonts/` and declare in `pubspec.yaml`
- [ ] Add placeholder template images to `assets/images/templates/`
- [ ] Add sticker PNGs to `assets/images/stickers/`
- [ ] Add Lottie JSON files to `assets/lottie/`
- [ ] Update `AndroidManifest.xml` with permissions
- [ ] Update `ios/Runner/Info.plist` with photo library permissions **and** the Google Sign-In `REVERSED_CLIENT_ID` URL scheme
- [ ] Add Android SHA-1/SHA-256 fingerprints to the Firebase console (debug **and** release keystores)

### Phase 14: Testing
- [ ] Unit tests for ViewModels
- [ ] Unit tests for Services and Repositories (`fake_cloud_firestore`, `firebase_auth_mocks`)
- [ ] Widget tests for `WishCardWidget` and `SignInScreen`
- [ ] Cloud Functions unit tests (`firebase-functions-test`) for `generateWishes` quota logic
- [ ] Firestore/Storage security rules tests via the Emulator Suite

### Phase 15 (Optional Stretch Goal): Guest Mode
- [ ] If the team wants a "try before you sign in" flow, add Firebase Anonymous Auth, let guests generate/preview cards locally, and prompt to sign in with Google before saving/syncing — this is **not** part of the default build order.

---

## 🔑 Agent Prompt Starters

Use these prompts with your coding agent:

### Start Building
```
Using the specification in wish_card_app_context.md and code reference in
wish_card_implementation_reference.md, create the WishCraft Flutter app.

Start with Phase 0 (Firebase Project Setup) and Phase 1 (Project Bootstrap)
from the checklist. Set up the Firebase project config, generate
firebase_options.dart via flutterfire configure, then create the full
pubspec.yaml and folder structure.
```

### Per-Phase Prompts
```
Continue building WishCraft. Phase [N] is next. Create all files listed
in the Phase [N] section of the checklist. Follow the MVVM architecture
and code patterns shown in wish_card_implementation_reference.md.
Remember: Gemini is only ever called from functions/src/generateWishes.ts —
never add a Gemini API key or HTTP call inside lib/.
```

### Backend-First Prompt (recommended before Phase 4)
```
Build the functions/ directory first: generateWishes.ts, deleteAccount.ts,
index.ts, firestore.rules, and storage.rules, following
wish_card_implementation_reference.md. Deploy and smoke-test the
generateWishes callable function before wiring up any Flutter client code
that depends on it.
```

### Fix/Debug Prompt
```
The WishCraft app has an issue: [describe issue].
Context: I'm using Flutter + Riverpod (StateNotifier) + Firebase
(Auth/Firestore/Storage/Functions) + Google Sign-In + Gemini (via Cloud
Function only). The relevant file is [filename]. Here's the error: [error].
Fix it following the architecture described in wish_card_app_context.md.
```

---

## ⚠️ Common Pitfalls to Avoid

| Issue | Solution |
|-------|----------|
| Google Sign-In fails silently / `ApiException: 10` on Android | You forgot to add the **SHA-1/SHA-256 fingerprint** (debug and release) to the Firebase console under Project Settings → Your app |
| `FirebaseAuthException: requires-recent-login` on account deletion | Firebase requires a fresh credential for sensitive actions — re-run the Google sign-in flow, then retry `user.delete()` |
| iOS Google Sign-In does nothing when tapped | Missing the `CFBundleURLSchemes` entry with the `REVERSED_CLIENT_ID` from `GoogleService-Info.plist` in `Info.plist` |
| `PERMISSION_DENIED` reading/writing Firestore | Security rules reject the request — check the doc path matches `users/{uid}/...` **and** the signed-in user's `uid` matches; also confirm rules were actually deployed (`firebase deploy --only firestore:rules`) |
| `generateWishes` callable returns `unauthenticated` even though the user is signed in | The Flutter client didn't wait for `FirebaseAuth` to finish initializing before calling the function, or App Check is blocking the request — check App Check debug tokens are registered for local development |
| Cloud Function times out or is very slow on first call | Cold starts are normal for callable functions on the free/low tier — consider `minInstances: 1` for production if latency matters, at extra cost |
| Gemini returns garbled JSON/text | Always prompt for plain text with `---WISH_SEPARATOR---` inside the Cloud Function, never ask Gemini for JSON directly |
| Gemini API key exposed in a leaked APK/IPA | This should be structurally impossible now — the key only exists in Cloud Functions secrets. If you find a Gemini key anywhere under `lib/`, `pubspec.yaml`, or an `.env` bundled into the client, that's a regression — remove it |
| `RepaintBoundary` capturing blank/white | Ensure `isComplexHint: true` on `RepaintBoundary`, add a 100–200ms delay before capture |
| Firestore offline cache shows stale data after sign-out/sign-in as a different user | Call `FirebaseFirestore.instance.clearPersistence()` (before any reads) or `terminate()` then reinitialize when switching accounts, to avoid leaking cached data between users on a shared device |
| Firebase Storage upload succeeds but `thumbnailUrl` is `null` in Firestore | You must call `getDownloadURL()` **after** `putFile()`/`putData()` completes and save that URL into the Firestore doc — the upload alone doesn't populate the field |
| Share to WhatsApp fails on iOS | Use `share_plus` system sheet — WhatsApp iOS doesn't support direct intent |
| `google_fonts` throws font not found | Only use fonts from the Google Fonts catalog; check exact name spelling |
| Stickers misalign on export | Normalize sticker positions to 0.0–1.0 ratio, multiply by actual render size on export |
| `StateNotifierProvider.family` rebuilds every time | Pass a stable `occasionId` string, avoid passing objects |
| Permission denied gallery save | Call `permission_handler` request before `GallerySaver.saveImage()` |
| PDF export produces blank page | Capture PNG first, then embed in PDF — don't try to render Flutter widget directly to PDF |
| Cloud Functions deploy fails with billing error | `onCall` functions and outbound calls to the Gemini API require the **Blaze** (pay-as-you-go) plan — the free Spark plan can't deploy functions that make external network calls |

---

## 📐 Card Dimensions Reference

| Format | Logical Size | Export Pixel Ratio | Output Pixels |
|--------|-------------|-------------------|---------------|
| Square (default) | 360×360 | 3.0× | 1080×1080 |
| Portrait | 360×640 | 3.0× | 1080×1920 |
| Gallery Thumbnail | 360×360 | 1.0× | 360×360 |
| A4 PDF | — | — | embedded square in A4 |

---

## 🎨 Font Families (All Google Fonts)

| Key | Google Fonts Name | Style |
|-----|------------------|-------|
| `playfair` | `Playfair Display` | Elegant serif |
| `dancing` | `Dancing Script` | Handwritten |
| `montserrat` | `Montserrat` | Bold modern |
| `lato` | `Lato` | Clean minimal |
| `sacramento` | `Sacramento` | Flowing cursive |
| `nunito` | `Nunito` | Friendly rounded |

---

## 🌐 Gemini API — Production Usage Notes

- **Model:** `gemini-1.5-flash` (configurable in `functions/src/generateWishes.ts`; upgrade path to `gemini-2.0-flash` without a client release since the model name lives server-side)
- **Where it's called from:** exclusively `functions/src/generateWishes.ts`, using a key stored via `firebase functions:secrets:set GEMINI_API_KEY`
- **Cost control:** the app enforces its own daily per-user quota (default **20 generations/day**, tracked in `users/{uid}/meta/quota`) independent of whatever rate limit Gemini itself applies to the API key — this protects the developer's bill from a single user or a compromised client hammering the endpoint
- **Gemini's own free-tier limits** (informational — the Cloud Function should still handle `429`s gracefully): 15 requests/min, 1M tokens/min, 1,500 requests/day on `gemini-1.5-flash`. If usage is expected to exceed this, move to a paid Gemini API tier and raise `DAILY_LIMIT` accordingly.
- **User-facing message on quota exhaustion:**
  > "You've reached today's generation limit. Please try again tomorrow."
- **User-facing message on transient Gemini failure:**
  > "Something went wrong generating wishes. Please try again."

---

*All 3 documentation files together form the complete, production-grade WishCraft build specification: Flutter client + MVVM/Riverpod, Firebase Auth (Google Sign-In), Cloud Firestore + Storage for cloud-synced cards, and a Cloud Functions backend that securely proxies Gemini.*

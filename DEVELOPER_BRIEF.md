# RuckOps — Developer Brief

**Version:** 1.0 (MVP)
**Platforms:** iOS 16+ and Android 10+ (phone only)
**Audience:** Solo dev or small team shipping v1 to both stores

---

## 1. Overview

RuckOps is a GPS workout tracker for rucking and running, built for military and serious-fitness users. The MVP records 4–12 hour workouts with adaptive battery-optimized GPS, persists every point to local storage in near-real-time for crash recovery, syncs to the cloud when online, and gates a Pro tier behind in-app purchase.

This brief is the source of truth. If something isn't here, it doesn't get built. The MVP scope (`MVP_SCOPE.md`) is locked.

---

## 2. Tech Stack

A single recommended stack — chosen for one team shipping to both stores fast, with battery-life as the #1 risk.

| Layer | Tool | Why (plain English) |
|-------|------|---------------------|
| App framework | **React Native + Expo (Bare workflow with Dev Client)** | One codebase for iOS and Android; Bare workflow lets us drop in the native modules required for multi-hour background GPS — Expo Managed cannot do this. EAS Build gives us iOS builds without owning a Mac. |
| Background GPS | **react-native-background-geolocation** *(Transistor Software)* | Purpose-built for exactly this use case. Handles iOS deferred location updates, Android FusedLocationProvider with battery-aware priority switching, foreground service, and writes points to its own SQLite store for crash recovery. Free for dev; one-time $299 production license. Solves concern #1. |
| Local database | **expo-sqlite** | Native SQLite. Used for the offline workout queue, sync state, and entitlement cache. |
| Backend / DB | **Supabase** *(free tier)* | Postgres + Auth + Realtime + Storage in one. Free tier covers thousands of users. Replaces Firebase without the vendor lock-in. |
| Auth | **Supabase Auth** | Built-in email/password; native Sign in with Apple via `expo-apple-authentication`; Google via `@react-native-google-signin/google-signin`. Tokens flow into Supabase RLS for free. |
| In-App Purchase | **react-native-iap** | Wraps Apple StoreKit and Google Play Billing. Works with both subscription products. Receipts are forwarded to a Supabase Edge Function for server-side validation. |
| Maps | **react-native-maps** | Apple Maps on iOS (default), Google Maps on Android. Free at MVP scale. Renders the route polyline and start/end markers. |
| Push notifications | **Expo Notifications** | Wraps APNs and FCM, handles tokens, server send via Expo's free push API. |
| Crash + analytics | **Sentry** *(@sentry/react-native)* | Free tier covers 5k errors/month. Captures crashes, JS errors, and native errors with stack traces. We log workout-lifecycle breadcrumbs (start, pause, resume, end, save, sync). |
| Build + deploy | **EAS Build + EAS Submit** | Cloud builds for iOS/Android, store submission, OTA updates for non-native fixes. |

**On Expo's role.** We use Expo's tooling (CLI, EAS Build, Dev Client, Notifications, expo-location for foreground use) but eject the lockdown so we can use `react-native-background-geolocation` and any other community native modules. This is the "Bare with Dev Client" pattern — best of both.

**Rejected alternatives:**
- *Expo Managed:* Cannot run a foreground service on Android or sustain background location on iOS for 4–12 hours. Disqualified.
- *Flutter:* Equivalent capability via `flutter_background_geolocation`, but the rest of the JS ecosystem (Supabase JS, react-native-iap, Sentry RN) is more mature and the team can use one language.
- *Native iOS + Android:* Best raw battery and GPS performance — but doubles the implementation timeline. Not viable for v1 with a small team.

---

## 3. File Structure

See `FILE_STRUCTURE.md` for the full tree with one-line descriptions per file. High-level shape:

```
RuckOps/
├── app/                  ← Expo / native config
├── src/
│   ├── screens/          ← 9 screens, one file each
│   ├── components/       ← Reusable UI (stat tiles, chips, map, etc.)
│   ├── services/         ← Supabase, IAP, location, sync, notifications
│   ├── stores/           ← Zustand slices (auth, workout, history, settings)
│   ├── hooks/            ← Reusable logic (useWorkoutSession, useEntitlement)
│   ├── navigation/       ← React Navigation stack + tab routers
│   ├── db/               ← expo-sqlite schema and queries
│   ├── constants/        ← Colors, copy strings (from APP_CONTENT.md), config
│   └── utils/            ← Formatters (distance, pace, duration), unit conversion
├── assets/               ← Icon, splash, fonts
└── supabase/             ← SQL migrations + Edge Functions
```

---

## 4. Architecture

### 4.1 Runtime data flow

```
┌─────────────────────────────────────────────────────────────┐
│                       RUCKOPS APP                            │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ UI layer (React Native screens + components)          │   │
│  └────────────────────┬─────────────────────────────────┘   │
│                       │                                      │
│  ┌────────────────────▼─────────────────────────────────┐   │
│  │ State layer (Zustand stores)                          │   │
│  │  - authStore  - workoutStore  - settingsStore         │   │
│  │  - historyStore  - entitlementStore                   │   │
│  └─────┬─────────────────┬──────────────────┬───────────┘   │
│        │                 │                  │                │
│  ┌─────▼─────┐     ┌─────▼──────┐    ┌──────▼─────────┐     │
│  │ Local DB  │     │ Background │    │ Sync Engine    │     │
│  │ (SQLite)  │◄────┤ Geolocation│    │ (queue → cloud)│     │
│  └─────▲─────┘     └────────────┘    └────────┬───────┘     │
│        │                                       │             │
└────────┼───────────────────────────────────────┼─────────────┘
         │                                       │
         │                                       ▼
         │                              ┌────────────────┐
         │                              │   SUPABASE     │
         │                              │ ┌────────────┐ │
         │                              │ │ Postgres   │ │
         │                              │ │ Auth       │ │
         │                              │ │ Realtime   │ │
         │                              │ │ Edge Funcs │ │
         │                              │ └────────────┘ │
         │                              └────────────────┘
         │                                       ▲
         │                              ┌────────┴────────┐
         │                              │ Apple App Store │
         │                              │ Google Play     │
         │                              │ (IAP receipts)  │
         │                              └─────────────────┘
```

### 4.2 The workout-recording loop (concern #1: battery)

This is the most important loop in the app. It must run reliably for 12 hours.

1. User taps **START** on Pre-Workout Setup.
2. App creates a new `workout` row in local SQLite: `status = 'recording'`, `started_at = now`, `pack_weight_kg`, `type`.
3. App calls `BackgroundGeolocation.start()`. The library:
   - On iOS: enables background location, sets `desiredAccuracy = navigation`, switches to deferred updates when the screen is off (every 50m / 60s, whichever first).
   - On Android: starts a foreground service with the persistent OS notification, uses `FusedLocationProviderClient` with `PRIORITY_HIGH_ACCURACY` while screen on, drops to `PRIORITY_BALANCED_POWER_ACCURACY` when screen off and the device is moving steadily.
4. Every location point fires a callback that:
   - Inserts a row into the local `workout_points` table immediately (NOT just into memory).
   - Updates running totals (distance, duration, current pace) in `workoutStore`.
   - Triggers a UI refresh on the Live Tracking screen.
5. Every 1 km / 1 mi crossed → fires a local push notification (mile-marker trigger).
6. Auto-pause: if `BackgroundGeolocation` reports the device stationary for 60s and `auto_pause = true` in settings, status flips to `auto_paused`. Distance accumulation freezes; duration timer pauses. When motion resumes, status flips back to `recording`.
7. User taps **END** → confirmation modal → SAVE or DISCARD.
   - SAVE: `status = 'completed'`, `ended_at = now`, finalize totals, sync engine queues the workout for upload.
   - DISCARD: hard delete the workout row and all its points from local DB.

### 4.3 Crash recovery (concern #3)

The app must survive an OS-level kill mid-workout. The contract:

- Every GPS point is written to SQLite *synchronously* in the location callback. Worst-case data loss is the in-flight point.
- On app launch, the auth bootstrap checks for any local workout with `status = 'recording'` or `status = 'paused'`.
- If found, the user is routed to a recovery modal (Crash Recovery copy from `APP_CONTENT.md` §Live Tracking → "Workout interrupted"):
  - **RESUME:** rejoins the session — `BackgroundGeolocation.start()` and `status = 'recording'`.
  - **SAVE:** finalizes the workout with whatever was captured up to the last point. Routes to Post-Workout Summary.
  - **DISCARD:** hard deletes.
- The resumed timer accounts for the gap: the gap between the last-recorded point and "now" is treated as paused time, not duration.

### 4.4 Offline-first sync engine (concern #4)

Every state change writes to local SQLite first. The sync engine is a background worker that:

1. Watches a `sync_queue` table containing `{entity_type, entity_id, op, payload, attempts, last_error}` rows.
2. When the device is online (via `@react-native-community/netinfo`), drains the queue in FIFO order.
3. On 200 OK from Supabase, deletes the queue row and updates `synced_at` on the entity.
4. On error, increments `attempts`, backs off (exponential, max 5 retries), then surfaces the "Sync failed" toast on Home/History.
5. Uses last-write-wins per row by `updated_at`. No CRDTs in v1 — a single user editing on one device at a time is the dominant case.

### 4.5 Cross-device sync (concern #5)

On any signed-in launch with network:
- Pull-down on Home or History triggers `pullSync()`: fetches all workouts updated server-side since the device's `last_pulled_at` and upserts them into local SQLite.
- Soft-deletes (`deleted_at IS NOT NULL`) propagate the same way.
- Realtime subscription to `workouts` keyed by `user_id` keeps a second device live without manual refresh.

---

## 5. Data Models

### 5.1 Storage shape (shared between local SQLite and Supabase Postgres)

All weights stored in **kilograms**, all distances in **meters**, all durations in **seconds**, all timestamps in **UTC ISO 8601**. Display-layer converts to user units.

#### `users`
| Field | Type | Notes |
|-------|------|-------|
| id | uuid (PK) | matches `auth.users.id` in Supabase |
| email | text | unique |
| display_name | text | from auth provider, editable in v2 |
| units | enum: `imperial` \| `metric` | default `imperial` |
| default_pack_weight_kg | numeric(5,2) | nullable until onboarding |
| body_weight_kg | numeric(5,2) | nullable |
| auto_pause_enabled | boolean | default `true` |
| notifications_enabled | boolean | mirrors OS state |
| subscription_tier | enum: `free` \| `pro` | default `free` |
| created_at | timestamptz | |
| updated_at | timestamptz | |

#### `workouts`
| Field | Type | Notes |
|-------|------|-------|
| id | uuid (PK) | client-generated |
| user_id | uuid (FK → users.id) | RLS scope key |
| type | enum: `ruck` \| `run` | |
| status | enum: `recording` \| `paused` \| `completed` \| `discarded` | |
| started_at | timestamptz | |
| ended_at | timestamptz | nullable until completed |
| duration_seconds | int | excludes paused time |
| distance_meters | numeric(10,2) | |
| avg_pace_seconds_per_km | int | derived |
| pack_weight_kg | numeric(5,2) | 0 for runs |
| elevation_gain_meters | numeric(8,2) | |
| calories | int | nullable if no body_weight |
| notes | text | max 1000 chars |
| created_at | timestamptz | |
| updated_at | timestamptz | |
| deleted_at | timestamptz | soft delete |
| synced_at | timestamptz | local only — when last upserted to cloud |

#### `workout_points`
| Field | Type | Notes |
|-------|------|-------|
| id | uuid (PK) | |
| workout_id | uuid (FK → workouts.id) | cascade delete |
| sequence | int | 0-indexed |
| latitude | numeric(9,6) | |
| longitude | numeric(9,6) | |
| altitude_meters | numeric(7,2) | nullable |
| accuracy_meters | numeric(6,2) | nullable |
| speed_mps | numeric(5,2) | nullable |
| recorded_at | timestamptz | |

For long workouts, points can total 10–40k rows. Indexed on `(workout_id, sequence)`. On the cloud side, points are written as a JSONB array on the `workouts` row to avoid millions of rows; the local DB keeps them normalized for query speed.

#### `subscriptions`
| Field | Type | Notes |
|-------|------|-------|
| id | uuid (PK) | |
| user_id | uuid (FK → users.id) | |
| platform | enum: `ios` \| `android` | |
| product_id | text | e.g. `pro_monthly` |
| original_transaction_id | text | unique per user |
| expires_at | timestamptz | |
| status | enum: `active` \| `cancelled` \| `expired` \| `grace_period` | |
| latest_receipt | text | for re-validation |
| updated_at | timestamptz | |

### 5.2 Row-level security (RLS)

Every table is RLS-locked to `auth.uid() = user_id`. No user can read or write another user's data. Edge Functions use the service role key for receipt validation only.

---

## 6. Screen-by-Screen Spec

The exact copy for every label, button, error, and success message is in `APP_CONTENT.md`. **Use those strings verbatim — do not paraphrase.** This section maps each screen to the data, services, and state it needs.

### 6.1 Welcome / Sign-In
- **Component:** `WelcomeScreen.tsx`
- **State read:** `authStore.session` (if present, redirect to Home)
- **Services called:** `auth.signInWithApple()`, `auth.signInWithGoogle()`, `auth.signInWithEmail(email, password)`
- **On success:** if `users` row missing in Supabase, route to Onboarding; else route to Home
- **Network states:** offline banner from `APP_CONTENT.md` (no-connection error)

### 6.2 Onboarding (4 steps)
- **Component:** `OnboardingNavigator.tsx` wrapping 4 step screens
- **State written:** `settingsStore.units`, `settingsStore.bodyWeightKg`, `settingsStore.defaultPackWeightKg`
- **Services called:**
  - `permissions.requestLocation('always')` — Step 4
  - `permissions.requestNotifications()` — Step 4
  - `users.upsert()` to Supabase on completion
- **Validation:** body weight 23–230 kg / 50–500 lb; pack weight 1–90 kg / 1–200 lb
- **Resume:** if interrupted, `settingsStore.onboardingStep` persists last completed step

### 6.3 Home / Dashboard
- **Component:** `HomeScreen.tsx`
- **Tabs:** Home (active), History, Profile
- **Data read:**
  - `historyStore.getMonthTotals(currentMonth)` → distance, time, weight-moved
  - `historyStore.getRecent(3)` → last 3 workouts
- **Services called:** `syncEngine.pullSync()` on pull-to-refresh
- **Empty state:** uses copy from `APP_CONTENT.md` Home § Empty State
- **GPS permission banner:** shown if `permissions.getLocationStatus() !== 'granted'`

### 6.4 Pre-Workout Setup
- **Component:** `PreWorkoutScreen.tsx`
- **State read:** `settingsStore.defaultPackWeightKg`, `settingsStore.units`
- **Services called:**
  - `locationTracker.startWarmup()` — gets a GPS lock without yet recording
  - `locationTracker.getSignalStrength()` → `STRONG | FAIR | SEARCHING | LOST`
- **On START tap:** creates a new local workout row (`status = 'recording'`), navigates to LiveTracking

### 6.5 Live Tracking
- **Component:** `LiveTrackingScreen.tsx`
- **Critical:** no tab bar visible; back-swipe disabled
- **State read:** `workoutStore.currentSession` (live distance, duration, pace, status)
- **Services called:**
  - `BackgroundGeolocation` callbacks → `workoutStore` updates
  - `notifications.scheduleMilestone(distance)` on each km/mi marker
  - On END → confirmation modal → `workoutStore.endSession('save'|'discard')`
- **OS persistent notification:** managed by `BackgroundGeolocation` + Expo Notifications
- **Lock state:** local component state; intercepts all touch events except slide-to-unlock

### 6.6 Post-Workout Summary
- **Component:** `PostWorkoutScreen.tsx`
- **State read:** `workoutStore.lastCompletedSession`
- **Services called:**
  - `workouts.computeFinalStats()` → fills `avg_pace`, `elevation_gain`, `calories`
  - `syncEngine.enqueueWorkout(workoutId)` on SAVE
  - `workouts.delete(workoutId)` (hard) on DISCARD
- **Map:** `react-native-maps` with polyline from `workout_points`

### 6.7 History
- **Component:** `HistoryScreen.tsx`
- **State read:** `historyStore.list({filter, monthOffset})`
- **Filter chips:** `ALL | RUCK | RUN`
- **Pagination:** lazy load by month section
- **Free tier paywall:** when scrolling past 30 days, render `<PaywallCard />` instead of older rows. Tap UPGRADE → Profile/Subscription
- **Pull-to-refresh:** triggers `syncEngine.pullSync()`

### 6.8 Workout Detail
- **Component:** `WorkoutDetailScreen.tsx`
- **State read:** `historyStore.getById(id)`
- **Map:** same renderer as Post-Workout Summary
- **Delete flow:** optimistic delete → 5-second undo toast → after toast dismisses, `syncEngine.enqueueDelete(id)`

### 6.9 Profile / Settings
- **Component:** `ProfileScreen.tsx`
- **State read:** `authStore.user`, `settingsStore`, `entitlementStore.tier`
- **Inline editors:** units toggle, default pack weight, body weight (numeric modal)
- **Subscription:**
  - Free: shows UPGRADE TO PRO card → opens `iap.openPurchaseSheet(productId)`
  - Pro: shows renewal date and `Manage subscription` link → deep-links to App Store / Play Store
- **Sign out:** clears auth session, clears local DB optionally (offer in v2; v1 keeps cache)

---

## 7. GPS & Background Strategy (concern #1, #2)

### iOS

- **Info.plist additions:**
  - `NSLocationAlwaysAndWhenInUseUsageDescription` — copy: "RuckOps records distance and route while you ruck. Always-on lets the GPS keep running when your phone is in your pocket and the screen is off."
  - `NSLocationWhenInUseUsageDescription` — same intent, shorter.
  - `UIBackgroundModes` → `location`
  - `NSMotionUsageDescription` — for activity-based auto-pause heuristic.
- **Library:** `react-native-background-geolocation` configured with:
  - `desiredAccuracy: DESIRED_ACCURACY_NAVIGATION` while screen on
  - `desiredAccuracy: DESIRED_ACCURACY_HIGH` deferred when screen off
  - `distanceFilter: 10` meters
  - `stopOnTerminate: false`, `startOnBoot: false` (we don't auto-resume across reboots)
  - `pausesLocationUpdatesAutomatically: false`
- **Battery target:** ≤ 15% drain per hour on a recent iPhone with screen off.

### Android

- **AndroidManifest.xml additions:**
  - `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`, `ACCESS_BACKGROUND_LOCATION`
  - `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_LOCATION` (Android 14+)
  - `POST_NOTIFICATIONS` (Android 13+)
- **Foreground service:** `react-native-background-geolocation` ships one. The persistent notification uses copy from `APP_CONTENT.md` Live Tracking → "Persistent OS notification".
- **FusedLocationProviderClient settings:**
  - `PRIORITY_HIGH_ACCURACY` while screen on
  - `PRIORITY_BALANCED_POWER_ACCURACY` when screen off + battery > 30%
  - Drops to `PRIORITY_LOW_POWER` if battery < 10% (with banner warning the user)
  - 1-second interval on, 5-second interval off
- **Battery target:** ≤ 12% drain per hour on a Pixel 7 with screen off and Doze whitelisted via foreground service.

### Mile/km marker notifications
- Local notifications scheduled via Expo Notifications — no server roundtrip.
- Title and body strings from `APP_CONTENT.md` Push Notifications → "Workout milestone".
- Throttled to one per integer marker; never duplicated on resume.

---

## 8. Auth Flow (concern #6)

### Sign in with Apple (mandatory on iOS — App Store Guideline 4.8)
- Library: `expo-apple-authentication`
- Flow: native sheet → Apple credential → exchange identity token with Supabase Auth via `signInWithIdToken({provider: 'apple', token})`.
- First-time users get a `users` row created server-side via a trigger on `auth.users` insert.

### Sign in with Google
- Library: `@react-native-google-signin/google-signin`
- iOS: configured with reversed client ID URL scheme.
- Android: configured with SHA-1 fingerprints (debug + release).
- Flow: native sheet → Google ID token → Supabase `signInWithIdToken({provider: 'google', token})`.

### Email + password
- Supabase Auth's built-in email flow.
- Reset password via Supabase's hosted page (custom-themed in v2).

### Session persistence
- Supabase JS SDK with `expo-secure-store` adapter for the session token.

---

## 9. In-App Purchase Flow (concern #7)

### Products
| Product ID | Platform | Price | Type |
|------------|----------|-------|------|
| `ruckops_pro_monthly` | iOS + Android | $4.99/mo | Auto-renewing subscription |
| `ruckops_pro_yearly` | iOS + Android | $39.99/yr | Auto-renewing subscription |

### Purchase
1. User taps UPGRADE TO PRO on Profile.
2. `iap.fetchProducts(['ruckops_pro_monthly','ruckops_pro_yearly'])` → returns localized prices.
3. User selects a plan → `iap.requestSubscription(productId)`.
4. Native sheet completes → app receives a receipt.
5. App POSTs the receipt to Supabase Edge Function `validate-receipt` (service-role-keyed).
6. Edge Function calls Apple / Google receipt verification API, parses `expires_at`, upserts `subscriptions` row, sets `users.subscription_tier = 'pro'`.
7. App updates `entitlementStore.tier`, refreshes UI.
8. `iap.finishTransaction(purchase)` to clear the StoreKit / Play Billing queue.

### Restore
- On Profile, "Already subscribed? Restore purchases." link → `iap.getAvailablePurchases()` → re-validate any active receipts via the same Edge Function.

### Server-side validation (Edge Function)
- iOS: verify against `https://buy.itunes.apple.com/verifyReceipt` (with sandbox fallback).
- Android: Google Play Developer API `purchases.subscriptions.get`.
- Renewal: a daily cron Edge Function re-validates active receipts and downgrades expired users to `free`.

---

## 10. Free vs Pro Entitlement Gating (concern #9)

### What's gated
| Feature | Free | Pro |
|---------|------|-----|
| Live tracking | ✅ unlimited | ✅ unlimited |
| Workout history | Last 30 days only | Unlimited |
| Monthly trend charts | ❌ | ✅ |
| CSV export | ❌ | ✅ |

### Where the gate lives
- **Client side (UX):** `entitlementStore.tier` decides whether to render the paywall card in History past 30 days, the trend-chart entry point, and the CSV export button. Source of truth on the device.
- **Server side (truth):** `users.subscription_tier` in Postgres. RLS policies on `workouts` queries:
  - Free users: `WHERE created_at > now() - interval '30 days'`
  - Pro users: no date filter.
- The client and server can disagree briefly (e.g. just-purchased and not yet validated). The Edge Function bumps both sides on successful validation.

---

## 11. Maps (concern #8)

- **Library:** `react-native-maps`.
- **iOS:** Apple Maps provider (default — no API key needed).
- **Android:** Google Maps provider — requires `GOOGLE_MAPS_ANDROID_API_KEY` in `AndroidManifest.xml` meta-data. Free tier (28k map loads/mo) is plenty.
- **Polyline rendering:** decode `workout_points` to a `<Polyline coordinates={…} strokeColor={brandAmber} />`. For workouts with > 5k points, downsample with Douglas-Peucker (`@turf/simplify`) to keep render fast.
- **Markers:** green pin at first point, red pin at last point.

---

## 12. Crash Reporting & Analytics (concern #10)

### Sentry
- DSN injected at build time via `EXPO_PUBLIC_SENTRY_DSN`.
- Captures: JS exceptions, native crashes (via Sentry's RN integration), unhandled promise rejections.
- Breadcrumbs logged on every workout-lifecycle event:
  - `workout_started`, `workout_paused`, `workout_resumed`, `workout_auto_paused`, `workout_ended`, `workout_saved`, `workout_discarded`, `gps_lost`, `gps_restored`, `low_battery`, `crash_recovery_shown`, `crash_recovery_resumed`.

### Product analytics (lightweight)
- Custom events posted to Supabase `events` table from the same breadcrumb hooks.
- No third-party analytics in v1 (no PostHog, no Amplitude, no Firebase Analytics) — keeps the privacy story tight, which matters for the audience.
- Schema: `(id, user_id, event_name, properties jsonb, occurred_at)`.

---

## 13. Push Notifications

All 14 triggers from `APP_CONTENT.md` § Push Notifications. Categorized:

| Class | Where it fires from | Example |
|-------|---------------------|---------|
| **Local (in-app, no server)** | Inside `BackgroundGeolocation` callback or workout state machine | Mile marker, Battery critical, GPS lost, Workout interrupted |
| **Server-pushed via Expo** | Supabase Edge Function or scheduled job | Pro renewed, Pro expiring, Pro lapsed, Weekly summary, Inactivity nudge, First-workout milestone |

Expo push tokens stored on `users.expo_push_token`, refreshed on every launch.

---

## 14. Environment Variables

The developer needs to obtain each of these and put them in `.env`. The repo ships with `.env.example`; `.env` is gitignored.

| Var | Where to find it | Required for |
|-----|------------------|--------------|
| `EXPO_PUBLIC_SUPABASE_URL` | Supabase dashboard → Settings → API → Project URL | All API calls |
| `EXPO_PUBLIC_SUPABASE_ANON_KEY` | Supabase dashboard → Settings → API → `anon` `public` key | Auth and queries |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase dashboard → Settings → API → `service_role` key | Edge Functions only — NEVER ship to client |
| `EXPO_PUBLIC_GOOGLE_WEB_CLIENT_ID` | Google Cloud Console → Credentials → OAuth Web client | Google Sign-In |
| `GOOGLE_MAPS_ANDROID_API_KEY` | Google Cloud Console → Credentials → Maps SDK key | Android map rendering |
| `EXPO_PUBLIC_SENTRY_DSN` | Sentry dashboard → Project Settings → Client Keys | Crash reporting |
| `BACKGROUND_GEOLOCATION_LICENSE_KEY` | Transistor Software dashboard (after purchasing license — required for production builds only) | Production builds |
| `APPLE_TEAM_ID` | Apple Developer → Membership | EAS iOS build |
| `EAS_PROJECT_ID` | Created on first `eas init` | Build pipeline |

---

## 15. Subscription Logic

Stated explicitly so it's unambiguous to the developer:

- **Free tier defaults to ON for every new user.** `users.subscription_tier = 'free'` at row creation.
- **Pro is granted only after server-side receipt validation.** The client never sets `subscription_tier = 'pro'` directly.
- **Grace period:** if a renewal fails (Apple's billing retry window is up to 60 days), `subscriptions.status = 'grace_period'` and the user keeps Pro access. After grace, the daily cron downgrades them.
- **Restore on a new device:** purely a `getAvailablePurchases()` call — no extra UI needed. After restore, the same Edge Function path runs.
- **Refunds and chargebacks:** `App Store Server Notifications` and `Google Real-time Developer Notifications` webhooks land on a Supabase Edge Function that downgrades the user.

---

## 16. Things NOT to Build (v2 list — copied from MVP_SCOPE.md)

The developer must not build any of these. They are explicitly out of scope for v1:

1. Apple Watch companion app
2. Wear OS / Android Wear companion app
3. Standalone smartwatch tracking (no phone needed)
4. Heart rate monitor integration (Bluetooth or watch-based)
5. Social features: friends, activity feed, leaderboards, public sharing
6. Sharing workouts to Instagram, Twitter, Facebook
7. Route planning and turn-by-turn navigation
8. Training plans and structured workouts
9. Audio coaching cues and voice prompts during workouts
10. Photos or media attached to workouts
11. Strava, Garmin, or Apple Health export and sync
12. Challenges, badges, achievements, streaks
13. Group rucks and event coordination
14. Advanced metrics (TSS, training load, weight-adjusted pace formulas)
15. Offline maps for areas without cell service

---

## 17. Build & Deploy Plan

### Local dev
1. `npm install`
2. Copy `.env.example` → `.env`, fill in values.
3. `npx expo prebuild --clean` to generate native projects.
4. `npx expo run:ios` or `npx expo run:android` (Dev Client).

### Cloud builds
- `eas build --profile development --platform all` for internal Dev Client builds.
- `eas build --profile preview --platform all` for TestFlight / Play internal testing.
- `eas build --profile production --platform all` for store submission.

### Submission
- `eas submit --platform ios` and `eas submit --platform android`.

### OTA updates (post-launch)
- `eas update --branch production` for JS-only fixes (no native changes).

### Release checklist
1. Bump version in `app.json`.
2. Update "What's New" copy from `APP_CONTENT.md`.
3. Production EAS build for both platforms.
4. TestFlight + Internal track for 48-hour smoke test.
5. Submit to App Store + Play Store.

---

## 18. Out-of-Scope Technical Choices Made For You

So the developer doesn't waste cycles re-deciding:

- **State management:** Zustand. (Not Redux Toolkit — too much ceremony for a 9-screen MVP. Not Context — it re-renders too aggressively for live-tracking.)
- **Forms:** controlled components with manual validation. (Not React Hook Form — only ~3 forms in the app.)
- **Styling:** StyleSheet + a `theme.ts` file with the colors and typography from `APP_DESIGN_BLUEPRINT.md`. (Not NativeWind — the design is too custom for utility classes to pay off.)
- **Navigation:** React Navigation (native stack + bottom tab navigator).
- **Linting:** ESLint with `expo/eslint-config-expo` + Prettier.
- **TypeScript:** yes, strict mode. (The data model is not trivial; types catch real bugs.)
- **Testing:** Jest + `@testing-library/react-native` for utilities (unit converters, pace math). Detox for one happy-path E2E (sign-in → start workout → end workout → save). Don't aim for high coverage in v1 — aim for the math being right.

---

## 19. What "Done" Means for This Brief

The Project 5 builder has everything they need when:
- Every screen in `APP_DESIGN_BLUEPRINT.md` has a one-paragraph spec section above (✅ §6).
- Every copy string ships from `APP_CONTENT.md` (referenced, not duplicated).
- Every external service has a named library, an env var, and a flow (✅ §§5, 7–11, 14).
- Every concern in the handover prompt has a specific section (✅ #1 §7, #2 §7, #3 §4.3, #4 §4.4, #5 §4.5, #6 §8, #7 §9, #8 §11, #9 §10, #10 §12).

If the developer needs to make a decision not covered here, they ask first. They do not invent features.

# RuckOps — File Structure

The exact repo layout for Project 5 to build against. Every file gets a one-line plain-English description.

```
RuckOps/
├── README.md                           ← How to clone, install, and run the app locally
├── package.json                        ← App dependencies (managed by npm install)
├── package-lock.json                   ← Locked dependency versions (auto-generated)
├── tsconfig.json                       ← TypeScript compiler settings (strict mode)
├── app.json                            ← Expo config: app name, icon, splash, plugins
├── eas.json                            ← EAS Build profiles: development, preview, production
├── babel.config.js                     ← Babel preset (expo)
├── metro.config.js                     ← Metro bundler config (default)
├── .env.example                        ← Template listing every secret key the app needs
├── .env                                ← Real secrets (gitignored, never commit)
├── .gitignore                          ← Files Git should ignore (.env, node_modules, builds)
├── .eslintrc.js                        ← ESLint rules
├── .prettierrc                         ← Prettier formatting rules
├── App.tsx                             ← Root component: providers, navigation, sentry init
│
├── assets/
│   ├── icon.png                        ← App icon source (1024×1024)
│   ├── adaptive-icon.png               ← Android adaptive icon foreground
│   ├── splash.png                      ← Splash screen image
│   ├── favicon.png                     ← Web favicon (unused in v1 but required by Expo)
│   └── fonts/
│       ├── RobotoCondensed-Bold.ttf    ← Headings and section titles
│       ├── JetBrainsMono-Bold.ttf      ← All numeric metric values
│       ├── Inter-Regular.ttf           ← Body text and form input
│       └── Inter-Medium.ttf            ← Button labels and emphasized body
│
├── src/
│   ├── screens/
│   │   ├── WelcomeScreen.tsx           ← Sign-in entry point (Apple/Google/email buttons)
│   │   ├── onboarding/
│   │   │   ├── OnboardingNavigator.tsx ← Wraps the 4 onboarding steps in a stack
│   │   │   ├── UnitsStep.tsx           ← Step 1: pick miles+lbs or km+kg
│   │   │   ├── BodyWeightStep.tsx      ← Step 2: optional body weight input
│   │   │   ├── PackWeightStep.tsx      ← Step 3: default pack weight input
│   │   │   └── PermissionsStep.tsx     ← Step 4: location and notifications prompts
│   │   ├── HomeScreen.tsx              ← Dashboard: START button, monthly totals, recent 3
│   │   ├── PreWorkoutScreen.tsx        ← Workout setup: mode toggle, pack weight, GPS check
│   │   ├── LiveTrackingScreen.tsx      ← Live workout: distance, pace, pause/end/lock
│   │   ├── PostWorkoutScreen.tsx       ← Summary: stats grid, route map, notes, save/discard
│   │   ├── HistoryScreen.tsx           ← Workout list grouped by month, filter chips
│   │   ├── WorkoutDetailScreen.tsx     ← One past workout: stats, map, notes, delete
│   │   ├── ProfileScreen.tsx           ← Settings: prefs, subscription, sign out
│   │   └── CrashRecoveryScreen.tsx     ← Modal shown if a workout was interrupted
│   │
│   ├── components/
│   │   ├── primitives/
│   │   │   ├── Button.tsx              ← Primary, secondary, destructive variants
│   │   │   ├── Card.tsx                ← Surface container with border and padding
│   │   │   ├── Toast.tsx               ← Top-aligned notification for success/error
│   │   │   ├── Modal.tsx               ← Confirmation dialog wrapper
│   │   │   ├── TextInput.tsx           ← Themed numeric and text input
│   │   │   ├── Switch.tsx              ← Themed toggle switch
│   │   │   └── EmptyState.tsx          ← Heading + body + CTA empty-state block
│   │   ├── workout/
│   │   │   ├── StatTile.tsx            ← Single label + monospace value tile
│   │   │   ├── StatGrid.tsx            ← 2×3 grid of StatTile (used post-workout + detail)
│   │   │   ├── ModeChip.tsx            ← RUCK or RUN amber/olive chip
│   │   │   ├── PackWeightStepper.tsx   ← Numeric input with ± buttons
│   │   │   ├── GpsSignalIndicator.tsx  ← Color-coded GPS strength label
│   │   │   ├── HeroMetric.tsx          ← Large monospace distance display
│   │   │   ├── LockOverlay.tsx         ← Dim overlay + slide-to-unlock for live tracking
│   │   │   └── EndWorkoutModal.tsx     ← Save/Discard confirmation
│   │   ├── history/
│   │   │   ├── WorkoutRow.tsx          ← One workout list row with type-color bar
│   │   │   ├── MonthHeader.tsx         ← Sticky uppercase month section header
│   │   │   ├── FilterChips.tsx         ← ALL / RUCK / RUN selector
│   │   │   └── PaywallCard.tsx         ← Free-tier 30-day cap upsell card
│   │   ├── map/
│   │   │   └── RouteMap.tsx            ← react-native-maps with polyline + start/end pins
│   │   ├── home/
│   │   │   ├── StartWorkoutButton.tsx  ← Massive amber CTA on the dashboard
│   │   │   └── MonthlyTotals.tsx       ← Three stat tiles for distance/time/weight
│   │   └── nav/
│   │       ├── BottomTabBar.tsx        ← Custom tab bar (Home / History / Profile)
│   │       └── HeaderBar.tsx           ← Status bar with wordmark and date
│   │
│   ├── services/
│   │   ├── supabase.ts                 ← Supabase client initialization
│   │   ├── auth.ts                     ← Apple, Google, email sign-in flows
│   │   ├── locationTracker.ts          ← react-native-background-geolocation wrapper
│   │   ├── syncEngine.ts               ← Local→cloud upload queue with retry/backoff
│   │   ├── pullSync.ts                 ← Cloud→local fetch on launch and pull-to-refresh
│   │   ├── iap.ts                      ← react-native-iap wrapper: purchase/restore
│   │   ├── notifications.ts            ← Expo push token + local notification scheduling
│   │   ├── permissions.ts              ← Location and notification permission helpers
│   │   ├── analytics.ts                ← Sentry breadcrumbs + Supabase events table writes
│   │   └── connectivity.ts             ← Network state listener (NetInfo wrapper)
│   │
│   ├── stores/
│   │   ├── authStore.ts                ← Current session, signed-in user
│   │   ├── settingsStore.ts            ← Units, body weight, default pack weight, toggles
│   │   ├── workoutStore.ts             ← In-flight workout session state
│   │   ├── historyStore.ts             ← Cached workout list with filter and pagination
│   │   └── entitlementStore.ts         ← Free vs Pro tier with renewal date
│   │
│   ├── hooks/
│   │   ├── useWorkoutSession.ts        ← Subscribes to live tracking updates
│   │   ├── useEntitlement.ts           ← Returns current tier + checks for gated features
│   │   ├── useGpsSignal.ts             ← Polls signal strength for the Pre-Workout screen
│   │   ├── useBatteryWarning.ts        ← Watches battery; fires the 10%/5% banners
│   │   ├── useCrashRecovery.ts         ← On launch, detects unsaved workouts
│   │   ├── usePullToRefresh.ts         ← Wraps pullSync with loading + error toast state
│   │   └── useFormatters.ts            ← Distance/pace/duration formatting per user units
│   │
│   ├── navigation/
│   │   ├── RootNavigator.tsx           ← Auth gate → onboarding gate → main app
│   │   ├── MainTabNavigator.tsx        ← Bottom tabs: Home, History, Profile
│   │   └── linking.ts                  ← Deep-link config (notifications → screens)
│   │
│   ├── db/
│   │   ├── schema.ts                   ← SQLite CREATE TABLE statements
│   │   ├── migrations.ts               ← Versioned migrations runner
│   │   ├── workouts.ts                 ← CRUD for workouts table
│   │   ├── workoutPoints.ts            ← Bulk insert + read for GPS points
│   │   ├── syncQueue.ts                ← Read/write the pending sync rows
│   │   └── client.ts                   ← expo-sqlite open + transaction helpers
│   │
│   ├── constants/
│   │   ├── colors.ts                   ← Brand color tokens from the design blueprint
│   │   ├── typography.ts               ← Font families, sizes, line heights
│   │   ├── strings.ts                  ← Every UI string from APP_CONTENT.md (single source)
│   │   ├── theme.ts                    ← Combined theme object passed via context
│   │   └── config.ts                   ← Feature flags and app-wide constants
│   │
│   └── utils/
│       ├── units.ts                    ← Convert kg↔lb, m↔mi/km, m/s↔min/mi
│       ├── pace.ts                     ← Compute average pace, current pace from rolling window
│       ├── duration.ts                 ← Format seconds → HH:MM:SS
│       ├── distance.ts                 ← Format meters → "5.32 mi" or "8.57 km"
│       ├── calories.ts                 ← Estimate calories from weight + distance + pack
│       ├── elevation.ts                ← Compute total elevation gain from points
│       ├── polyline.ts                 ← Simplify GPS points for fast map render
│       ├── date.ts                     ← "MAY 7 · THU" and "MAY 2026" formatters
│       └── id.ts                       ← UUID generator (uses expo-crypto)
│
├── supabase/
│   ├── migrations/
│   │   ├── 0001_init.sql               ← users, workouts, workout_points, subscriptions
│   │   ├── 0002_rls_policies.sql       ← Row-level security on every table
│   │   ├── 0003_triggers.sql           ← Auto-create users row on auth.users insert
│   │   └── 0004_events_table.sql       ← Lightweight analytics events table
│   ├── functions/
│   │   ├── validate-receipt/
│   │   │   └── index.ts                ← Apple/Google receipt verification + tier upsert
│   │   ├── revalidate-subscriptions/
│   │   │   └── index.ts                ← Daily cron: re-check active subs, downgrade expired
│   │   ├── apple-server-notifications/
│   │   │   └── index.ts                ← Webhook for Apple subscription events
│   │   ├── google-rtdn/
│   │   │   └── index.ts                ← Webhook for Google Real-time Developer Notifications
│   │   ├── send-push/
│   │   │   └── index.ts                ← Server-pushed notifications (weekly summary, lapsed)
│   │   └── _shared/
│   │       └── supabaseAdmin.ts        ← Service-role Supabase client for Edge Functions
│   └── seed.sql                        ← Empty in v1 (no seed data)
│
└── docs/
    ├── DEVELOPER_BRIEF.md              ← Carried forward — the technical spec
    ├── MVP_SCOPE.md                    ← Carried forward — what's in / out of v1
    ├── APP_DESIGN_BLUEPRINT.md         ← Carried forward — screen designs
    ├── APP_CONTENT.md                  ← Carried forward — all UI copy
    └── APP_IDEA_SUMMARY.md             ← Carried forward — concept and target user
```

---

## Notes for the Project 5 Builder

- **Single source of truth for copy:** `src/constants/strings.ts` is generated from `APP_CONTENT.md`. Screens import from there — never hardcode UI text in component files.
- **Single source of truth for colors:** `src/constants/colors.ts` mirrors the values in `APP_DESIGN_BLUEPRINT.md` § Visual Identity. Never use raw hex codes outside that file.
- **Native files are generated, not hand-edited.** After `npx expo prebuild`, the `ios/` and `android/` folders appear. Treat them as build output. Native config goes through `app.json` plugins.
- **The `supabase/` folder is the source of truth for the backend.** Apply migrations with `supabase db push` (Supabase CLI). Edge Functions deploy with `supabase functions deploy <name>`.
- **TypeScript strict mode is on.** No `any` without an explicit comment explaining why.
- **No file in `src/` should be over ~300 lines.** If a screen grows past that, split components into the matching `src/components/<area>/` folder.

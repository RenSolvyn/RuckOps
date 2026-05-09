# MVP Scope

> **This scope is LOCKED.** Projects 2–5 will treat these features as the source of truth. Anything not listed here goes into v2.

---

## Screens (build these, nothing else)

### 1. Welcome / Sign-In
- App logo and tactical branding
- Sign in with Apple, Google, or email
- Brief value prop: "Built for ruckers"
- "Get Started" path for new users

### 2. Onboarding (first launch only)
- Set preferred units (miles + lbs, or km + kg)
- Optional body weight entry (used for future calorie estimates)
- Set default pack weight (saves time on every future ruck)
- Permission prompts: location (always-on), notifications

### 3. Home / Dashboard
- Large "Start Workout" button at the top
- Last 3 workouts at a glance (date, type, distance, pack weight)
- This-month totals: total distance, total time, total weight moved
- Bottom tab nav: Home, History, Profile

### 4. Pre-Workout Setup
- Mode toggle: Ruck or Run
- If Ruck: pack weight input (defaults to saved value, editable per workout)
- GPS signal strength indicator
- Big "Start" button

### 5. Live Tracking
- Primary metric: current distance (large, glanceable)
- Secondary metrics: duration, current pace, pack weight
- Pause / Resume / End controls
- Auto-pause when stationary (toggleable in settings)
- Screen lock to prevent accidental taps from ending the workout

### 6. Post-Workout Summary
- Final stats: distance, duration, average pace, pack weight, elevation gain, calorie estimate
- Map of the route taken
- Optional notes field
- Save / Discard

### 7. History
- Chronological list of all past workouts (newest first)
- Each row: date, type, distance, duration, pack weight
- Filter by type: Ruck / Run / All
- Tap row to open Workout Detail

### 8. Workout Detail
- Full stats from that session
- Route map
- User notes
- Delete workout option

### 9. Profile / Settings
- Name, email, units preference, default pack weight
- Subscription status (Free / Pro)
- Sign out
- Privacy policy and terms links

---

## Features Included in MVP

1. Sign-in via Apple, Google, or email
2. First-launch onboarding (units + default pack weight)
3. GPS-tracked live workouts in two modes: Ruck or Run
4. Pack weight input on every ruck workout
5. Live stats display (distance, pace, duration, pack weight)
6. Pause / resume / end controls with screen lock
7. Auto-pause when the user stops moving
8. Battery-optimized GPS sampling for long-duration workouts
9. Post-workout summary screen with route map and editable notes
10. Permanent workout history saved to the cloud
11. History list with filter by workout type
12. Workout detail view with map, stats, and delete option
13. Cloud sync so workout history survives a device change
14. Free vs Pro subscription tiers

---

## Features Excluded (save for v2)

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

## Data the App Needs to Store

- **User profile:** email, name, units preference, default pack weight, optional body weight
- **Workout records:** workout ID, date/time, type (Ruck or Run), duration, distance, average pace, pack weight, GPS route coordinates, elevation gain, user notes
- **Subscription status:** Free or Pro, renewal/expiry date
- **Device settings:** notification preferences, auto-pause toggle

---

## Third-Party Services Needed

- **Authentication:** Sign in with Apple, Sign in with Google, email/password sign-in
- **Cloud database:** stores user profiles and workout history; syncs across devices
- **Map provider:** Apple Maps on iOS, Google Maps on Android (both free at MVP scale)
- **Push notifications:** APNs (iOS) and FCM (Android)
- **Payment processor:** Apple In-App Purchase on iOS, Google Play Billing on Android (required by both stores for digital subscriptions)
- **Crash reporting and basic analytics:** standard tooling so bugs and crash patterns are visible from day one

---

## Subscription / Pricing Model

### Free Tier
- Unlimited workout tracking (Ruck and Run)
- Live stats during workouts
- Post-workout summaries with route map
- Last 30 days of workout history
- Core stats: distance, pace, duration, pack weight

### Pro Tier — $4.99/month or $39.99/year
- Everything in Free
- Unlimited workout history (no 30-day cap)
- Monthly trend charts (distance over time, pack weight progression)
- CSV export of all workout data
- Early access to v2 features as they ship (smartwatch apps, advanced metrics)

**Rationale:** The free tier is generous enough that the app actually gets used and shared in the rucking community — that word-of-mouth is the entire growth strategy for a niche app. The Pro tier converts the 5–10% of power users who care about long-term progression, who are also the most likely to evangelize.

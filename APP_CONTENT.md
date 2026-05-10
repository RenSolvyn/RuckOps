# RuckOps — App Content

Every word that appears in the RuckOps MVP. Voice and tone: tactical, direct, military-coded. Short sentences. Active verbs. No fluff. No cheerleading. No emoji. Field manual, not lifestyle brand.

---

## Screen: Welcome / Sign-In

**Page Title:** RUCKOPS *(rendered as wordmark, not text title)*
**Subtitle / Descriptor:** BUILT FOR RUCKERS

### Buttons
| Button | Label | Confirm Dialog (if needed) |
|--------|-------|---------------------------|
| Auth — Apple | Continue with Apple | — |
| Auth — Google | Continue with Google | — |
| Auth — Email | Continue with email | — |
| Footer — Privacy | Privacy Policy | — |
| Footer — Terms | Terms | — |

### Labels & Field Names
- App version footer: `Version 1.0.0`

### Empty State
*Not applicable — this screen is its own entry point.*

### Error Messages
| Situation | Message Shown |
|-----------|---------------|
| No internet connection | No connection. Sign-in unavailable. |
| Authentication fails | Authentication failed. Try again. |
| Apple Sign-In cancelled | Sign-in cancelled. |
| Google Sign-In cancelled | Sign-in cancelled. |
| Email not recognized | No account found for that email. |
| Wrong password | Password incorrect. Try again. |
| Account temporarily locked | Too many attempts. Try again in a few minutes. |

### Success Messages
| Action | Confirmation Shown |
|--------|--------------------|
| Sign-in succeeds (returning user) | *Silent — routes to Home.* |
| Sign-in succeeds (first-ever) | *Silent — routes to Onboarding.* |

### Microcopy
- Email field placeholder: `Email`
- Password field placeholder: `Password`
- "Forgot password?" link text: `Forgot password?`
- Sign-up toggle text: `New here? Create an account.`

---

## Screen: Onboarding

**Page Title:** *Each step has its own headline (see below).*
**Subtitle / Descriptor:** Step indicator: `STEP X OF 4`

### Buttons
| Button | Label | Confirm Dialog (if needed) |
|--------|-------|---------------------------|
| Step 1 — Advance | NEXT | — |
| Step 2 — Skip body weight | SKIP | — |
| Step 2 — Advance | NEXT | — |
| Step 3 — Advance | NEXT | — |
| Step 4 — Allow location | ALLOW | — |
| Step 4 — Allow notifications | ALLOW | — |
| Step 4 — Final | CONTINUE TO DASHBOARD | — |
| Back navigation | *(swipe gesture only)* | — |

### Labels & Field Names

**Step 1 — Units**
- Headline: `CHOOSE YOUR UNITS`
- Card 1: `MILES + LBS`
- Card 2: `KILOMETERS + KG`
- Caption: `You can change this later in Profile.`

**Step 2 — Body Weight (Optional)**
- Headline: `BODY WEIGHT (OPTIONAL)`
- Caption: `Used for calorie estimates. Skip if you'd rather not.`
- Input label: `Body weight`
- Unit suffix: `LB` or `KG`

**Step 3 — Default Pack Weight**
- Headline: `DEFAULT PACK WEIGHT`
- Caption: `Saves time on every ruck. Adjust per workout when needed.`
- Input label: `Pack weight`
- Unit suffix: `LB` or `KG`

**Step 4 — Permissions**
- Headline: `PERMISSIONS`
- Location card title: `LOCATION (ALWAYS-ON)`
- Location explainer: `Required to record distance and route. Always-on keeps the GPS running during long rucks when your phone is in your pocket and the screen is off.`
- Notifications card title: `NOTIFICATIONS`
- Notifications explainer: `Workout alerts, sync status, and milestone markers. Optional but recommended.`

### Empty State
*Not applicable.*

### Error Messages
| Situation | Message Shown |
|-----------|---------------|
| Body weight out of range | Enter a value between 50 and 500 lb. *(or 23–230 kg)* |
| Pack weight out of range | Enter a value between 1 and 200 lb. *(or 1–90 kg)* |
| Pack weight is zero | Pack weight can't be zero. Enter a value or skip to Run mode later. |
| Location permission denied | Location is required to track workouts. Enable it later in Settings. |
| Notification permission denied | *Silent — proceeds without warning.* |
| OS permission dialog dismissed | Permission still needed. Tap ALLOW to retry. |
| App killed mid-onboarding | *Resumes from last completed step on next launch.* |

### Success Messages
| Action | Confirmation Shown |
|--------|--------------------|
| Onboarding complete | *Silent — routes to Home.* |

### Microcopy
- Body weight placeholder: `e.g. 180`
- Pack weight placeholder: `e.g. 35`

---

## Screen: Home / Dashboard

**Page Title:** *(no title — wordmark in status header)*
**Subtitle / Descriptor:** Status header right-aligns the current date, format: `THU · MAY 7`

### Buttons
| Button | Label | Confirm Dialog (if needed) |
|--------|-------|---------------------------|
| Primary CTA | START WORKOUT | — |
| Recent workout row | *(tap target — row itself)* | — |
| Tab bar — Home | HOME | — |
| Tab bar — History | HISTORY | — |
| Tab bar — Profile | PROFILE | — |
| GPS permission banner | *(tappable, deep links to OS Settings)* | — |

### Labels & Field Names
- CTA caption: `Tap to begin a ruck or run.`
- Section header 1: `THIS MONTH`
- Section header 2: `RECENT`
- Stat tile 1 label: `DISTANCE`
- Stat tile 2 label: `TIME`
- Stat tile 3 label: `WEIGHT MOVED`
- Stat tile placeholder when empty: `—`
- Recent row format: `[DATE] · [RUCK or RUN chip] · [DISTANCE] · [PACK WEIGHT, rucks only] · [DURATION]`

### Empty State
> **Heading:** No workouts logged.
> **Body:** Hit START WORKOUT to record your first ruck. Stats and history fill in from there.
> **CTA Button:** START WORKOUT

### Error Messages
| Situation | Message Shown |
|-----------|---------------|
| Sync failure (silent retry) | Last synced [time]. Retrying… |
| Sync fully failed | Sync failed. Pull down to retry. |
| Location permission missing | Location permission needed. Tap to fix. |
| GPS hardware unavailable | GPS unavailable on this device. |
| Cloud unreachable | Offline. Showing local data. |

### Success Messages
| Action | Confirmation Shown |
|--------|--------------------|
| Pull-to-refresh succeeds | Synced. |
| New workout saved (returning to Home) | Workout saved. |

### Microcopy
- Pull-to-refresh prompt: `Pull to sync`
- Pull-to-refresh active: `Syncing…`

---

## Screen: Pre-Workout Setup

**Page Title:** WORKOUT SETUP
**Subtitle / Descriptor:** *(none — title carries the screen)*

### Buttons
| Button | Label | Confirm Dialog (if needed) |
|--------|-------|---------------------------|
| Back | *(back arrow icon)* | — |
| Mode — Ruck | RUCK | — |
| Mode — Run | RUN | — |
| Pack weight decrement | – | — |
| Pack weight increment | + | — |
| Start (GPS ready) | START | — |
| Start (GPS not ready) | ACQUIRING GPS… | — |
| Start (location denied) | LOCATION DISABLED | Tap deep-links to OS Settings. |

### Labels & Field Names
- Mode toggle group label: *(none — buttons self-evident)*
- Pack weight label: `PACK WEIGHT`
- Pack weight unit suffix: `LB` or `KG`
- GPS signal label: `GPS SIGNAL`
- GPS signal states: `STRONG` / `FAIR` / `SEARCHING` / `LOST`
- Stepper increment value: `±5 LB` or `±2 KG` *(visually shown in tooltip on long-press)*

### Empty State
*Not applicable — screen is always populated from saved defaults.*

### Error Messages
| Situation | Message Shown |
|-----------|---------------|
| Location permission denied | Enable Location to begin. Open Settings. |
| GPS searching for signal | Acquiring GPS… stay outdoors for fastest fix. |
| GPS lost while on this screen | GPS signal lost. Reacquiring… |
| Pack weight set to zero in RUCK mode | Pack weight is 0. Switch to RUN? |
| Pack weight exceeds limit | Pack weight maxes at 200 lb. *(or 90 kg)* |
| Phone in airplane mode | Airplane mode is on. GPS still works — sync will resume later. |

### Success Messages
| Action | Confirmation Shown |
|--------|--------------------|
| GPS lock acquired | *Silent — Start button enables.* |

### Microcopy
- Pack weight stepper helper text: `Tap ± to adjust by 5 lb. Long-press to type.`
- Mode toggle helper *(first-time users only)*: `Run mode hides pack weight.`

---

## Screen: Live Tracking

**Page Title:** *(no title — full-bleed metric display)*
**Subtitle / Descriptor:** Mode chip top-left: `RUCK · 35 LB` or `RUN`

### Buttons
| Button | Label | Confirm Dialog (if needed) |
|--------|-------|---------------------------|
| Pause | PAUSE | — |
| Resume | RESUME | — |
| End | END | **End workout?** — Save / Discard |
| Lock | LOCK | — |
| Unlock | *(slide-to-unlock affordance)* | — |
| End modal — Save | SAVE | — |
| End modal — Discard | DISCARD | **Discard this workout?** Stats and route will be lost. **Cancel / Discard** |
| Crash recovery — Resume | RESUME | — |
| Crash recovery — Save | SAVE | — |
| Crash recovery — Discard | DISCARD | **Discard recovered workout?** Cancel / Discard |

### Labels & Field Names
- Status indicator (top-right): `RECORDING` / `PAUSED` / `AUTO-PAUSED`
- Hero metric: *(current distance — large numerals + small unit `MI` or `KM`)*
- Secondary tile 1: `DURATION`
- Secondary tile 2: `PACE`
- Secondary tile 3: `PACK`
- Pace unit suffix: `/ MI` or `/ KM`
- Slide-to-unlock copy: `SLIDE TO UNLOCK`
- Persistent OS notification title: `RuckOps — Recording`
- Persistent OS notification body: `[DISTANCE] · [DURATION] · [MODE]`
- Persistent OS notification (paused): `RuckOps — Paused`
- Persistent OS notification body (paused): `[DISTANCE] · [DURATION] · Tap to resume`

### Empty State
*Not applicable.*

### Error Messages
| Situation | Message Shown |
|-----------|---------------|
| GPS lost mid-workout | GPS LOST — reacquiring. Distance held at last reading. |
| GPS reacquired | GPS restored. Recording resumed. |
| Battery drops below 10% | BATTERY CRITICAL — consider ending workout. |
| Battery drops below 5% | BATTERY 5%. End workout to save data. |
| Phone backgrounded — recording continues | *(handled via persistent OS notification)* |
| App killed mid-workout (next launch) | Workout interrupted at [time]. Resume / Save / Discard. |
| Storage full | Storage full. End workout to free space. |

### Success Messages
| Action | Confirmation Shown |
|--------|--------------------|
| Pause engaged | *Visual: status flips to PAUSED.* |
| Resume engaged | *Visual: status flips to RECORDING.* |
| Lock engaged | *Visual: screen dims, controls disabled.* |
| Unlocked | *Visual: screen returns to full brightness.* |
| Auto-pause triggered | *Visual: status flips to AUTO-PAUSED.* |
| Auto-resume after movement | *Visual: status flips to RECORDING.* |

### Microcopy
- End modal title: `End workout?`
- End modal body: `Save your stats and route, or discard this session.`
- Discard confirmation title: `Discard this workout?`
- Discard confirmation body: `Stats and route will be lost. This can't be undone.`
- Crash recovery modal title: `Workout interrupted`
- Crash recovery modal body: `Last recorded at [time]. Resume the session, save what was captured, or discard.`
- Lock helper *(first-time only)*: `Locks the screen against accidental taps. Slide bottom edge to unlock.`

---

## Screen: Post-Workout Summary

**Page Title:** WORKOUT COMPLETE
**Subtitle / Descriptor:** Timestamp under headline: `[DAY], [MONTH] [DATE] · [START TIME]–[END TIME]`

### Buttons
| Button | Label | Confirm Dialog (if needed) |
|--------|-------|---------------------------|
| Save | SAVE | — |
| Discard | DISCARD | **Discard this workout?** Stats and route will be lost. **Cancel / Discard** |

### Labels & Field Names
- Stat tile 1: `DISTANCE`
- Stat tile 2: `DURATION`
- Stat tile 3: `AVG PACE`
- Stat tile 4: `PACK WEIGHT`
- Stat tile 5: `ELEV GAIN`
- Stat tile 6: `CALORIES`
- Notes section header: `ADD NOTES (OPTIONAL)`
- Notes input placeholder: `Trail conditions, how it felt, gear notes…`

### Empty State
*Not applicable — screen always shows just-completed workout data.*

### Error Messages
| Situation | Message Shown |
|-----------|---------------|
| Map fails to load | Map unavailable — route data saved. |
| Calorie estimate unavailable (no body weight) | — *(stat shown as `—` with hint below: `Set body weight in Profile to enable calorie estimate.`)* |
| Save fails (offline) | Saved locally. Will sync when back online. |
| Save fails (server error) | Save failed. Tap to retry. |
| Notes too long | Notes max out at 1000 characters. |
| User force-quits before saving | *(workout stays in unsaved state — recovery prompt on next launch)* |

### Success Messages
| Action | Confirmation Shown |
|--------|--------------------|
| Save succeeds (online) | Workout saved. |
| Save succeeds (offline queue) | Saved locally — will sync when online. |
| Discard confirmed | Workout discarded. |

### Microcopy
- Notes character counter (visible after 800 chars): `[X] / 1000`
- Map zoom helper *(first-time only)*: `Pinch to zoom the route.`
- Discard confirmation title: `Discard this workout?`
- Discard confirmation body: `Stats and route will be lost. This can't be undone.`

---

## Screen: History

**Page Title:** HISTORY
**Subtitle / Descriptor:** *(none)*

### Buttons
| Button | Label | Confirm Dialog (if needed) |
|--------|-------|---------------------------|
| Filter — All | ALL | — |
| Filter — Ruck | RUCK | — |
| Filter — Run | RUN | — |
| Workout row | *(tap target — row itself)* | — |
| Paywall card — Upgrade | UPGRADE | — |
| Tab bar — Home | HOME | — |
| Tab bar — History | HISTORY | — |
| Tab bar — Profile | PROFILE | — |

### Labels & Field Names
- Month section header format: `MAY 2026` *(uppercase, monospace)*
- Workout row line 1: `[MONTH] [DATE] · [DAY ABBR]` (e.g., `MAY 7 · THU`)
- Workout row line 2 (ruck): `[DISTANCE] · [DURATION] · [PACK WEIGHT]`
- Workout row line 2 (run): `[DISTANCE] · [DURATION]`
- Type chip (left edge color bar): no text label, color only — amber for ruck, olive for run
- Paywall card title: `Older workouts available with Pro.`
- Paywall card body: `Free tier shows the last 30 days. Upgrade to keep your full training log.`

### Empty State

**No workouts logged yet:**
> **Heading:** No workouts yet.
> **Body:** Start your first ruck from Home. It'll show up here when you save it.
> **CTA Button:** GO TO HOME

**Filter result empty (Ruck):**
> **Heading:** No rucks in this period.
> **Body:** Switch the filter to RUN or ALL to see the rest.
> **CTA Button:** SHOW ALL

**Filter result empty (Run):**
> **Heading:** No runs in this period.
> **Body:** Switch the filter to RUCK or ALL to see the rest.
> **CTA Button:** SHOW ALL

### Error Messages
| Situation | Message Shown |
|-----------|---------------|
| Sync failure on pull-to-refresh | Sync failed. Pull down to retry. |
| Cloud unreachable | Offline. Showing local history. |
| Workout failed to load | One workout couldn't load. Pull down to retry. |
| Free tier paywall reached (scrolling past 30 days) | *(non-error — paywall card displays inline)* |

### Success Messages
| Action | Confirmation Shown |
|--------|--------------------|
| Pull-to-refresh succeeds | Synced. |
| Filter changes | *(silent — list re-renders)* |

### Microcopy
- Pull-to-refresh prompt: `Pull to sync`
- Pull-to-refresh active: `Syncing…`
- Loading older workouts indicator: `Loading…`

---

## Screen: Workout Detail

**Page Title:** Format: `[MONTH] [DATE] · [RUCK or RUN]` (e.g., `MAY 7 · RUCK`)
**Subtitle / Descriptor:** Time range under title: `[START TIME]–[END TIME]`

### Buttons
| Button | Label | Confirm Dialog (if needed) |
|--------|-------|---------------------------|
| Back | *(back arrow icon)* | — |
| Delete | DELETE WORKOUT | **Delete this workout?** This can't be undone. **Cancel / Delete** |

### Labels & Field Names
- Stat tile 1: `DISTANCE`
- Stat tile 2: `DURATION`
- Stat tile 3: `AVG PACE`
- Stat tile 4: `PACK WEIGHT`
- Stat tile 5: `ELEV GAIN`
- Stat tile 6: `CALORIES`
- Notes section header: `NOTES`
- Notes empty value: `No notes.`

### Empty State
*Not applicable — screen always shows one stored workout.*

### Error Messages
| Situation | Message Shown |
|-----------|---------------|
| Map data missing or corrupt | Route unavailable. |
| Workout still syncing from another device | *(skeleton loaders until data arrives)* |
| Calorie estimate unavailable | — *(stat shown as `—`)* |
| Delete fails (offline) | Delete queued. Will sync when online. |
| Delete fails (server error) | Delete failed. Try again. |

### Success Messages
| Action | Confirmation Shown |
|--------|--------------------|
| Delete confirmed (optimistic) | Workout deleted. **UNDO** *(toast, 5 sec)* |
| Undo tapped within 5 seconds | Restored. |

### Microcopy
- Delete confirmation title: `Delete this workout?`
- Delete confirmation body: `Stats, route, and notes will be removed. This can't be undone.`
- Map zoom helper *(first-time only)*: `Pinch to zoom the route.`

---

## Screen: Profile / Settings

**Page Title:** PROFILE
**Subtitle / Descriptor:** *(none)*

### Buttons
| Button | Label | Confirm Dialog (if needed) |
|--------|-------|---------------------------|
| Units row | *(tap to toggle)* | — |
| Default pack weight row | *(tap to edit, opens inline editor)* | — |
| Body weight row | *(tap to edit)* | — |
| Auto-pause toggle | *(switch)* | — |
| Notifications toggle | *(switch — deep links to OS if revoked)* | — |
| Upgrade to Pro | UPGRADE TO PRO | — |
| Manage subscription (Pro users) | Manage subscription | *(deep links to App Store / Play Store)* |
| Privacy Policy | Privacy Policy | — |
| Terms of Service | Terms of Service | — |
| Sign Out | SIGN OUT | **Sign out of RuckOps?** Your data stays synced — sign back in any time. **Cancel / Sign Out** |
| Tab bar — Home | HOME | — |
| Tab bar — History | HISTORY | — |
| Tab bar — Profile | PROFILE | — |

### Labels & Field Names
- Profile header: avatar (initials), name, email
- Section header 1: `PREFERENCES`
- Section header 2: `SUBSCRIPTION`
- Section header 3: `ABOUT`
- Preference row 1: `Units` — value: `Miles + Lbs` or `Kilometers + Kg`
- Preference row 2: `Default pack weight` — value: `[X] LB` or `[X] KG`
- Preference row 3: `Body weight` — value: `[X] LB` or `[X] KG` or `Not set`
- Preference row 4: `Auto-pause` — value: toggle switch
- Preference row 5: `Notifications` — value: toggle switch
- Subscription tier — Free badge: `FREE`
- Subscription tier — Pro badge: `PRO`
- Subscription price line: `$4.99/month or $39.99/year`
- Pro renewal line: `Renews [DATE]`
- Pro cancelled line: `Pro access ends [DATE]`
- About row 1: `Privacy Policy`
- About row 2: `Terms of Service`
- About row 3: `App version` — value: `1.0.0 (build [X])`

### Empty State
- Body weight not set: `Not set` *(with caption on row: `Tap to add — enables calorie estimates.`)*

### Error Messages
| Situation | Message Shown |
|-----------|---------------|
| Subscription validation pending | Verifying… |
| IAP fails | Purchase failed. Try again. |
| IAP cancelled | *(silent — sheet dismisses)* |
| Restore purchases fails | No active subscription found on this account. |
| Sign-out fails | Sign-out failed. Try again. |
| Preference save fails | Couldn't save. Try again. |
| Offline preference change | Saved locally. Will sync when online. |
| Body weight invalid | Enter a value between 50 and 500 lb. *(or 23–230 kg)* |
| Pack weight invalid | Enter a value between 1 and 200 lb. *(or 1–90 kg)* |

### Success Messages
| Action | Confirmation Shown |
|--------|--------------------|
| Preference saved | *(silent — value updates)* |
| Pro upgrade succeeds | Welcome to Pro. Unlimited history unlocked. |
| Pro restore succeeds | Pro access restored. |
| Sign out succeeds | *Routes to Welcome / Sign-In.* |

### Microcopy
- Pack weight inline editor placeholder: `e.g. 35`
- Body weight inline editor placeholder: `e.g. 180`
- Auto-pause helper text: `Pauses the timer when you stop moving. Resumes when you start again.`
- Notifications helper text: `Workout alerts, sync status, milestones.`
- Upgrade card body: `Unlimited history. Monthly trend charts. CSV export. Early access to v2 features.`
- Restore purchases link (under Upgrade): `Already subscribed? Restore purchases.`

---

## Push Notifications

| Trigger | Title (≤50 chars) | Body (≤100 chars) |
|---------|-------------------|-------------------|
| Workout milestone — every mile/km marker | MILE [N] *(or KM [N])* | [DISTANCE] · [DURATION] · [PACE]/mi |
| Battery drops below 10% during workout | BATTERY CRITICAL | Phone under 10%. Consider ending the workout to save your data. |
| Battery drops below 5% during workout | BATTERY 5% | End the workout now to save your stats and route. |
| GPS lost for over 60 seconds during workout | GPS LOST | Signal dropped. Step into open sky or end the workout. |
| Workout interrupted by crash | WORKOUT INTERRUPTED | Open RuckOps to resume, save, or discard the unsaved session. |
| Workout saved (after offline-queue sync) | WORKOUT SYNCED | Your offline workout uploaded. History is up to date. |
| Sync complete | SYNC COMPLETE | Workout history is up to date across your devices. |
| Sync failed | SYNC FAILED | Pull down to refresh on Home or History to retry. |
| Pro renewed | PRO RENEWED | Subscription renewed. Unlimited history active. |
| Pro expiring (3 days out) | PRO EXPIRES IN 3 DAYS | Renews automatically. Manage in Profile. |
| Pro lapsed | PRO ACCESS ENDED | History limited to 30 days. Upgrade in Profile to restore. |
| Weekly summary (Mondays, 8am local) | WEEK IN REVIEW | [N] sessions · [X] mi · [Y] avg pack lb. Open to see the breakdown. |
| Inactivity nudge (14 days no workout) | NO RUCKS LOGGED | Two weeks since your last session. Step out when you're ready. |
| First-workout milestone | FIRST WORKOUT LOGGED | Your training history starts now. Open RuckOps to review it. |

---

## Onboarding Screens

### Step 1 of 4 — Units
- **Headline:** CHOOSE YOUR UNITS
- **Subheadline:** Pick your standard. You can change this later in Profile.
- **Button:** NEXT

### Step 2 of 4 — Body Weight (Optional)
- **Headline:** BODY WEIGHT (OPTIONAL)
- **Subheadline:** Used for calorie estimates. Skip if you'd rather not.
- **Button:** NEXT *(secondary: SKIP)*

### Step 3 of 4 — Default Pack Weight
- **Headline:** DEFAULT PACK WEIGHT
- **Subheadline:** Saves time on every ruck. Adjust per workout when needed.
- **Button:** NEXT

### Step 4 of 4 — Permissions
- **Headline:** PERMISSIONS
- **Subheadline:** RuckOps needs two permissions to work. Location is required. Notifications are optional.
- **Button:** CONTINUE TO DASHBOARD

---

## App Store Listing

**App Name:** `RuckOps: Ruck & Run Tracker` *(27 chars)*

**Subtitle:** `GPS tracker built for ruckers` *(29 chars)*

**Promotional Text** *(170 chars max — App Store):*
`Live GPS tracking for rucking and running. Pack weight logged on every workout. Permanent cloud history. Built for the field — not the feed.`
*(141 chars)*

**Description** *(under 4000 chars):*

```
RuckOps is a GPS workout tracker built for one job: rucking. Distance, pace, duration, pack weight — logged correctly on every session, stored permanently, and surfaced when you need them.

Other apps treat rucking as a tag. RuckOps treats it as the headline.


WHO IT'S FOR

Veterans. Active duty. Selection candidates. First responders. Anyone whose training plan calls for time under load. If you've ever finished a ruck and had to scroll through six categories to log it as "walking," this app is for you.


CORE TRACKING

— Live GPS recording with adaptive sampling for long-duration events
— Pack weight logged on every ruck — required field, not an afterthought
— Two modes: Ruck and Run
— Distance, pace, duration, elevation gain, calorie estimate
— Route map saved on every workout
— Optional notes for trail conditions, gear, and how it felt


BUILT FOR THE FIELD

— Battery-optimized for 4–12 hour events
— Auto-pause when stationary, manual pause when needed
— Screen lock prevents accidental taps from ending a session
— Persistent background tracking — phone in pocket, recording continues
— Crash recovery: if something interrupts a workout, your data isn't gone


CLEAN HISTORY

— Every workout saved permanently to the cloud
— Filter by Ruck or Run
— Tap any past session for full stats, route map, and notes
— Cross-device sync — change phones without losing your training log


FREE TIER

— Unlimited workout tracking
— Last 30 days of history
— All core stats and route maps


PRO — $4.99/MONTH OR $39.99/YEAR

— Unlimited history
— Monthly trend charts (distance over time, pack weight progression)
— CSV export of every workout
— Early access to v2 features as they ship


WHAT'S NOT HERE

We left things out on purpose. No social feed. No badges. No streaks. No gamification. The app respects your time and focuses on tracking the work. Smartwatch support, heart-rate integration, and Strava export are scheduled for v2.


REQUIREMENTS

— iOS 16 or later (Android 10 or later)
— Always-on location permission for accurate distance and route capture
— Cell signal recommended for sync — workouts queue locally when offline


PRIVACY

Your workout data belongs to you. We don't sell it. We don't share it. We don't post it anywhere without your direct action. Read the full privacy policy in the app.


QUESTIONS OR FEEDBACK

Email [email protected]. We read every message.
```
*(approx. 1,950 chars)*

**Keywords** *(≤100 chars total, comma-separated, no spaces after commas — App Store rule):*
`rucking,ruck,march,gps,tracker,workout,fitness,military,army,run,training,hiking,pace`
*(86 chars)*

**What's New (v1.0):**
```
v1.0 — Initial release.

— Live GPS tracking for Ruck and Run modes
— Pack weight logged on every ruck workout
— Permanent cloud-synced workout history
— Filter history by workout type
— Battery-optimized for 4–12 hour events
— Free tier and Pro subscription

Send feedback to [email protected]. We read everything.
```

---

## Google Play Listing *(deltas from App Store)*

**App Title** *(≤30 chars):* `RuckOps: Ruck & Run Tracker` *(27 chars)*

**Short Description** *(≤80 chars — Google Play):*
`GPS workout tracker for rucking and running. Log pack weight on every ruck.`
*(75 chars)*

**Full Description:** *(reuse the App Store long description above — Google Play allows up to 4000 chars and the same copy works)*

**Tags / Categories:**
- Primary category: Health & Fitness
- Tags: `rucking`, `gps tracker`, `workout tracker`, `military fitness`, `ruck march`, `hiking`, `running`

---

## Global Strings Reference

These strings appear across multiple screens. Centralized here for consistency.

| Key | String |
|-----|--------|
| App name | RuckOps |
| Tagline | BUILT FOR RUCKERS |
| Mode — Ruck | RUCK |
| Mode — Run | RUN |
| Tier — Free | FREE |
| Tier — Pro | PRO |
| Cancel button | CANCEL |
| Confirm destructive | DELETE *(or DISCARD or SIGN OUT depending on action)* |
| Loading state | Loading… |
| Syncing state | Syncing… |
| Saved state | Saved. |
| Generic error | Something went wrong. Try again. |
| Generic offline | Offline. Changes will sync when you reconnect. |
| Date format short | MAY 7 · THU |
| Date format long | THU, MAY 7, 2026 |
| Time format | 14:32 *(24-hour, military-coded)* |

---

# RuckOps — App Design Blueprint

A complete screen-by-screen design plan, user flow, and visual identity for the RuckOps MVP. Plain English only — no code, no Figma references.

**Visual direction (locked from Project 1):** Tactical, dark, military-coded, high-contrast, data-dense. Night-ops aesthetic. The interface should feel like an instrument, not a consumer fitness app.

---

## Screen 1: Welcome / Sign-In

**Purpose:** Get a new or returning user authenticated and into the app in as few taps as possible.

**Layout:**
- Top third: Large RuckOps wordmark over a dark background with a faint topographic contour pattern. Tagline below in small caps amber: "BUILT FOR RUCKERS."
- Middle: Three sign-in buttons stacked vertically — "Continue with Apple," "Continue with Google," "Continue with email."
- Bottom: Small dim text links — "Privacy Policy · Terms" — with the app version underneath.

**Key Elements:**
- App wordmark and tagline strip
- Three authentication buttons (Apple, Google, email)
- Footer legal links and version number

**User Actions:**
- Tap any auth provider to start that sign-in flow
- Tap "Continue with email" to open an email/password sign-in or sign-up form
- Tap legal links to open an in-app web view

**Edge Cases:**
- No internet: an inline banner appears above the buttons reading "No connection — sign-in unavailable"
- Auth fails: a red toast at the top reads "Authentication failed. Try again."
- Returning signed-in user: this screen is skipped entirely; the app launches straight into Home

---

## Screen 2: Onboarding

**Purpose:** Capture the minimum settings needed to personalize the first workout, and request the OS permissions the app cannot function without.

**Layout:** A four-step paginated flow, one decision per page, with a step indicator (4 dots) along the top.
- **Step 1 — Units.** Headline: "CHOOSE YOUR UNITS." Two large tap-target cards side by side: "MILES + LBS" and "KILOMETERS + KG." One is selected. "Next" button at the bottom.
- **Step 2 — Body weight (optional).** Headline: "BODY WEIGHT (OPTIONAL)." Numeric input with the unit suffix from Step 1. Caption: "Used for calorie estimates. Skip if you'd rather not." Two buttons: "Skip" (text) and "Next" (filled amber).
- **Step 3 — Default pack weight.** Headline: "DEFAULT PACK WEIGHT." Large numeric input with unit. Caption: "Saves time on every ruck. You can change it per workout." "Next" button.
- **Step 4 — Permissions.** Headline: "PERMISSIONS." Two stacked cards, each with an icon, title, explainer, and "Allow" button: "LOCATION (Always-On)" with a brief explainer about why always-on is required for long rucks, and "NOTIFICATIONS." Final button at the bottom: "Continue to Dashboard."

**Key Elements:**
- 4-dot step progress indicator
- Selectable unit cards
- Numeric input fields for body weight and pack weight
- Skip / Next / Continue buttons
- Permission request cards with rationale copy

**User Actions:**
- Tap a unit card to select it
- Type body weight or skip
- Type default pack weight
- Tap "Allow" to trigger the OS permission dialog
- Tap Next, Skip, or Continue to advance
- Swipe back to revisit a previous step

**Edge Cases:**
- Location denied: a dim warning appears — "Location is required to track workouts. Enable later in Settings." — and onboarding still completes
- Notifications denied: silent; no warning, just proceeds
- App force-quit mid-onboarding: resumes from the last completed step on next launch
- Invalid numeric entry (0 or > 500): inline error message, "Next" stays disabled until valid

---

## Screen 3: Home / Dashboard

**Purpose:** Get the user into a workout in one tap and surface recent activity at a glance.

**Layout:**
- Top: Status bar — small RuckOps mark on the left, current date on the right.
- Hero block: Massive amber "START WORKOUT" button — full-width, roughly 25% of screen height — with a subtle chevron icon. A small caption underneath reads "Tap to begin a ruck or run."
- This-month panel: Section header "THIS MONTH." Three monospace stat tiles in a row: total distance, total time, total weight moved (distance × pack weight). Each tile shows label + value.
- Recent panel: Section header "RECENT." A list of the last 3 workouts as compact rows — each shows date, type chip (RUCK/RUN), distance, pack weight, duration. Tappable.
- Bottom: Persistent tab bar — Home (active, amber), History, Profile.

**Key Elements:**
- Status header with date
- Primary START WORKOUT call-to-action
- Three monthly stat tiles
- Recent workouts list (up to 3 rows)
- Bottom tab bar

**User Actions:**
- Tap START WORKOUT → opens Pre-Workout Setup
- Tap any recent workout row → opens Workout Detail
- Tap History or Profile in the tab bar to switch sections
- Pull down to refresh — re-syncs from the cloud

**Edge Cases:**
- First launch / no workouts yet: the recent list is replaced with a quiet hint — "No workouts yet. Hit START to record your first ruck." Monthly tiles show "—" placeholders.
- Sync failure: a small line under the tiles reads "Last synced [time]. Retrying..."
- GPS not authorized: an amber banner above START WORKOUT reads "Location permission needed — tap to fix."

---

## Screen 4: Pre-Workout Setup

**Purpose:** Confirm workout type and pack weight, verify GPS, then arm the tracker for launch.

**Layout:**
- Top: Back arrow on the left, screen title "WORKOUT SETUP" centered.
- Mode toggle: Two large segmented buttons across the full width — "RUCK" (default selected) and "RUN." Selected state has an amber fill; unselected has an amber outline.
- Pack weight input (visible only when RUCK is selected): A large numeric input pre-filled with the saved default. Minus and plus stepper buttons flank the input for quick ±5 lb / ±2 kg adjustments. Unit suffix is shown.
- GPS signal panel: A row with a satellite icon and a label — "GPS SIGNAL: STRONG / FAIR / SEARCHING" — color-coded (green / amber / red). Updates live.
- Bottom: Massive "START" button, full width, sticky to the bottom edge. Disabled (grayed) until GPS has a usable fix.

**Key Elements:**
- Back navigation
- Ruck/Run segmented control
- Pack weight numeric input with stepper buttons
- GPS signal indicator with color status
- Sticky Start button

**User Actions:**
- Toggle between Ruck and Run
- Tap stepper or type to adjust pack weight
- Tap Start (enabled only when GPS is ready) → opens Live Tracking
- Tap Back to return to Home

**Edge Cases:**
- GPS signal not yet acquired: Start button stays disabled and reads "ACQUIRING GPS..." with animated dots
- Location permission denied entirely: Start button disabled, banner reads "Enable Location to begin. Open Settings."
- User selects RUN: pack weight section collapses cleanly out of view (no zero-weight ruck case)
- User edits pack weight to 0 while in RUCK mode: a non-blocking inline hint reads "Pack weight 0 — switch to RUN?"

---

## Screen 5: Live Tracking

**Purpose:** Display the in-progress workout with glanceable metrics and prevent accidental termination during long, fatigued sessions.

**Layout:** Full-bleed dark canvas optimized for low-light reading.
- Top strip: A mode chip on the left ("RUCK · 35 LB" or "RUN") and a small status indicator on the right ("RECORDING," "PAUSED," or "AUTO-PAUSED").
- Hero metric: Current distance in massive monospace amber numerals filling the upper third of the screen. Unit ("MI" or "KM") small below.
- Secondary row: Three tiles across — DURATION (HH:MM:SS), CURRENT PACE (per mile or km), PACK WEIGHT. Smaller monospace numerals.
- Middle (optional, austere): A thin live elevation strip — kept minimal so it doesn't compete with the hero number.
- Bottom controls: Three large buttons — PAUSE (amber outline), END (red outline), and LOCK (padlock icon).
- When LOCK is engaged: the screen dims slightly, all other controls become unresponsive, and a slide-to-unlock affordance appears at the bottom edge.

**Key Elements:**
- Mode + pack weight chip
- Hero distance display
- Secondary metric tiles (duration, pace, pack weight)
- Pause / End / Lock buttons
- Slide-to-unlock affordance (appears when locked)

**User Actions:**
- Tap Pause → workout pauses; button changes to "RESUME"
- Tap Resume → workout continues
- Tap End → confirmation modal: "End workout? Save / Discard"
- Tap Lock → lock state engaged
- Swipe to unlock from the bottom edge
- Auto-pause kicks in automatically when stationary (if enabled in settings); the chip switches to "AUTO-PAUSED"

**Edge Cases:**
- GPS signal lost mid-workout: a banner reads "GPS LOST — attempting reacquire." Distance freezes at last known reading; no false drift recorded.
- Phone backgrounded: tracking continues uninterrupted; a persistent OS notification displays current distance and duration.
- Battery very low (under 10%): a non-blocking banner reads "BATTERY CRITICAL — consider ending workout."
- App crashes or is killed mid-workout: on relaunch, a recovery prompt appears — "Workout interrupted at [time]. Resume / Save / Discard."
- User taps End by accident: the confirmation modal prevents data loss.

---

## Screen 6: Post-Workout Summary

**Purpose:** Show the completed workout's stats and route, capture optional notes, then commit it to history.

**Layout:**
- Top: Headline "WORKOUT COMPLETE" with the date and time stamp directly underneath.
- Hero stats grid: Six cells in two rows of three — Distance, Duration, Avg Pace, Pack Weight, Elevation Gain, Calorie Estimate. Monospace numerals; small-caps labels.
- Map block: Full-width route map below the stats — a green pin at the start, a red pin at the end, and a polyline showing the route taken.
- Notes field: Section header "ADD NOTES (OPTIONAL)" with a multi-line text input. Placeholder text: "Trail conditions, how it felt, gear notes..."
- Bottom: Two buttons side by side — "SAVE" (amber fill, primary) and "DISCARD" (red text, secondary).

**Key Elements:**
- Header with timestamp
- Six-tile stat grid
- Map with route polyline and start/end markers
- Notes textarea
- Save and Discard buttons

**User Actions:**
- Pinch and pan the map to inspect the route
- Type into the notes field
- Tap Save → uploads to cloud, returns to Home
- Tap Discard → confirmation modal, then returns to Home

**Edge Cases:**
- Map fails to load: the map area shows "Map unavailable — route data saved."
- Calorie estimate unavailable (no body weight set): the cell shows "—" with a subtle hint "Set body weight in Profile to enable."
- Save fails (offline): the workout is queued locally; a banner reads "Saved locally — will sync when online."
- User backgrounds the app on this screen: the screen state is preserved exactly when the user returns.

---

## Screen 7: History

**Purpose:** Let the user browse all past workouts and filter by type.

**Layout:**
- Top: Screen title "HISTORY." Filter chip row directly below: "ALL" / "RUCK" / "RUN." The active chip has an amber fill.
- Body: A chronological list, newest first. Each row is a card with:
  - A thin colored bar on the left edge — amber for ruck, olive-green for run
  - Top line: date and day of week (e.g., "May 7 · Thu")
  - Bottom line: distance · duration · pack weight (pack weight only shown for rucks)
  - A small chevron on the right indicating the row is tappable
- Workouts are grouped under month section headers: "MAY 2026," "APRIL 2026," and so on.
- Bottom: Persistent tab bar (History tab active).

**Key Elements:**
- Filter chips (All / Ruck / Run)
- Month section headers
- Workout list rows with type-color bar
- Bottom tab bar

**User Actions:**
- Tap a filter chip → the list re-filters in place
- Tap any workout row → opens Workout Detail
- Scroll down to load older workouts
- Pull down to refresh — re-syncs from the cloud

**Edge Cases:**
- Empty (no workouts at all): a centered icon with the message "No workouts yet. Start your first ruck from Home."
- Free tier 30-day cap reached: when scrolling past 30 days, a locked card appears — "Older workouts available with Pro" — with an "Upgrade" button
- Filter result empty: "No [Ruck/Run] workouts in this period."
- Sync failure: pull-to-refresh shows an error toast.

---

## Screen 8: Workout Detail

**Purpose:** Show one past workout in full detail with map, stats, notes, and a delete option.

**Layout:**
- Top: Back arrow on the left, workout title centered (date + type chip).
- Stats grid: The same six-tile layout as the Post-Workout Summary — Distance, Duration, Avg Pace, Pack Weight, Elevation Gain, Calorie Estimate.
- Map block: The full route map with start and end markers and the polyline.
- Notes block: Displays the user's saved notes. If none were saved, shows muted text "No notes."
- Bottom action: "DELETE WORKOUT" — red text button, requires confirmation.

**Key Elements:**
- Back navigation and workout title
- Six-tile stat grid
- Route map
- Notes display block
- Delete button

**User Actions:**
- Tap Back → returns to History (or to Home if the user entered from the dashboard)
- Pinch and pan the map
- Tap Delete → confirmation modal "Delete this workout? This can't be undone."
- (No editing in MVP — this screen is view + delete only)

**Edge Cases:**
- Workout deleted: optimistic removal from the list, with an undo toast for 5 seconds before the delete commits to the cloud
- Map data missing or corrupt: stats still render normally; the map area shows "Route unavailable."
- Workout still syncing from another device: skeleton loaders fill the stat tiles until data arrives.

---

## Screen 9: Profile / Settings

**Purpose:** Manage the user's account, training preferences, and subscription status.

**Layout:**
- Top: Screen title "PROFILE."
- Profile block: An avatar circle with the user's initials (no photo upload in MVP), name, and email below.
- Section "PREFERENCES":
  - Units (Miles+Lbs / Km+Kg) — tap to toggle
  - Default pack weight — numeric, tap to edit
  - Body weight — numeric, tap to edit
  - Auto-pause — toggle switch
  - Notifications — toggle switch (deep links to OS settings if needed)
- Section "SUBSCRIPTION":
  - Tier badge: "FREE" or "PRO"
  - If Free: an "UPGRADE TO PRO" button showing $4.99/mo or $39.99/yr
  - If Pro: renewal date and "Manage subscription" link (deep-links to App Store or Play Store)
- Section "ABOUT":
  - Privacy Policy link
  - Terms of Service link
  - App version
- At the bottom: SIGN OUT button (red text).
- Bottom: Persistent tab bar (Profile tab active).

**Key Elements:**
- Profile header (avatar, name, email)
- Preferences list with toggles and editable fields
- Subscription block with upgrade CTA or status
- About links
- Sign out button
- Bottom tab bar

**User Actions:**
- Tap any preference row → inline edit modal or toggle
- Tap Upgrade to Pro → opens the IAP purchase sheet (Apple or Google)
- Tap Manage Subscription → deep links out of the app
- Tap Privacy or Terms → opens an in-app web view
- Tap Sign Out → confirmation modal, then returns to Welcome / Sign-In

**Edge Cases:**
- Subscription validation pending: the badge area shows "Verifying..."
- IAP fails or is cancelled: silently dismisses; user remains on Free tier
- User edits preferences while offline: changes save locally and sync on reconnect
- Sign-out failure: a toast reads "Sign-out failed. Try again."

---

## User Flow

```
[Launch]
   │
   ├─ (signed in?)
   │     YES ─→ [Home]
   │     NO  ─→ [Welcome / Sign-In]

[Welcome / Sign-In]
   ├─ (auth success, first-ever sign-in?) ─→ [Onboarding]
   └─ (auth success, returning user?)     ─→ [Home]

[Onboarding] ─→ [Home]

[Home]
   ├─ Tap START WORKOUT      ─→ [Pre-Workout Setup]
   ├─ Tap recent workout row ─→ [Workout Detail] ─→ back to [Home]
   ├─ Tab: History           ─→ [History]
   └─ Tab: Profile           ─→ [Profile / Settings]

[Pre-Workout Setup]
   ├─ Tap START (GPS ready) ─→ [Live Tracking]
   └─ Tap Back              ─→ [Home]

[Live Tracking]
   ├─ Tap End → "Save"    ─→ [Post-Workout Summary]
   └─ Tap End → "Discard" ─→ confirm ─→ [Home]

[Post-Workout Summary]
   ├─ Tap Save    ─→ [Home]   (workout now appears in History)
   └─ Tap Discard ─→ confirm ─→ [Home]

[History]
   ├─ Tap workout row ─→ [Workout Detail]
   ├─ Tab: Home       ─→ [Home]
   └─ Tab: Profile    ─→ [Profile / Settings]

[Workout Detail]
   ├─ Tap Back   ─→ [History] (or [Home] if entered from there)
   └─ Tap Delete ─→ confirm ─→ back to previous screen

[Profile / Settings]
   ├─ Tap Sign Out ─→ confirm ─→ [Welcome / Sign-In]
   ├─ Tap Upgrade  ─→ [IAP sheet] ─→ back to [Profile]
   ├─ Tab: Home    ─→ [Home]
   └─ Tab: History ─→ [History]

ERROR / EDGE PATHS
- GPS denied at Pre-Workout Setup → blocks Start until granted in OS Settings
- Sign-in failure on Welcome → stays on Welcome with error toast
- Workout interrupted by crash → next launch shows recovery prompt before [Home]
- Offline → all screens function with cached data; saves queue for later sync
```

---

## Visual Identity

### Colors

- **Primary — #F4811F (tactical amber).** Start Workout CTA, all primary buttons, active tab icons, key numeric metrics, brand accents.
- **Secondary — #4A5D23 (olive drab).** Ruck type chips, secondary highlights, success states that don't warrant alarm-bell red.
- **Background — #0D0F0D (deep tactical black).** Full-screen background. Maximizes contrast and reduces battery drain on OLED screens during long workouts.
- **Surface — #1A1D1A (near-black gray).** Cards, tiles, and elevated panels. Sits visibly on the background without raising overall brightness.
- **Text — #E8E8E8 (off-white)** for primary text; **#8B8F89 (muted gray)** for secondary labels and hints.
- **Alert — #DC2626 (warning red).** End Workout, Delete, Sign Out confirmations, and critical banners (low battery, GPS lost).

### Typography

- **Headings & Numerics:** Roboto Condensed Bold for screen titles and section headers; JetBrains Mono Bold for all live and historical metric values (distance, pace, duration, weight).
- **Body:** Inter Regular for descriptions, captions, list rows, and form input.
- **Why:** Condensed sans-serif headings echo military stenciled typography without becoming a costume. Monospace numerals lock columns of stats into a clean grid that's readable in motion. Inter body keeps long-form text legible during low-light, fatigued reading.

### Design Principles

- **Glanceable in motion.** Every primary metric is sized and positioned to be readable in a single glance from a moving body in low light. Hero numbers dominate; chrome stays out of the way.
- **Tactical hierarchy.** The most important data on each screen gets the largest, brightest treatment. Secondary data is intentionally smaller and dimmer. No equal-weight grids that force the eye to hunt.
- **Earned interface.** No civilian gloss, no playful animations, no streaks-and-stars. The app respects the user's discipline and time. Interface elements look like instruments, not toys.

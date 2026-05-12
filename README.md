# RuckOps

**🔗 Live demo: [khurang-r.github.io/RuckOps](https://khurang-r.github.io/RuckOps/)**

A GPS workout tracker for rucking and running. Built for the military and serious fitness community — track workouts in real time, log pack weight, and build a long-term progress history.

> **Status:** project planning docs (Project 4 output) plus a working **web MVP** that runs on GitHub Pages. The native mobile build (React Native + Expo + Supabase) described in the planning docs is the v2 target.
>
> If you forked this repo, your live URL is `https://<your-username>.github.io/RuckOps/` once Pages is enabled.

## Live web MVP

Once GitHub Pages is enabled on this repo, the app is live at:
**https://khurang-r.github.io/RuckOps/**

The web MVP gets the core workout flow working in any modern browser:

- Foreground GPS tracking (Geolocation API)
- Live distance, duration, pace, and pack weight
- Pause / resume / lock controls, auto-pause when stationary
- Post-workout summary with a route map (Leaflet + OpenStreetMap)
- Workout history with type filter (Ruck / Run / All)
- Workout detail with delete
- Profile settings (units, default pack weight, body weight, auto-pause)
- CSV export of all workouts
- PWA shell — installable to home screen, works offline-first for the app shell

### How to enable GitHub Pages

1. Go to **Settings → Pages** in the GitHub UI.
2. Under "Build and deployment," set **Source** to **GitHub Actions**.
3. Push to `main` (or click Run workflow on the *Deploy to GitHub Pages* action). The workflow at `.github/workflows/pages.yml` will publish the site automatically.
4. Wait ~1–2 minutes; the URL above goes live.

Alternative if you want zero CI: set **Source** to **Deploy from a branch**, branch `main`, folder `/ (root)`. The `.nojekyll` file at the root keeps GitHub from running Jekyll over the assets.

### Running locally

No build step. Any static server works:

```bash
# Python
python3 -m http.server 8000
# or Node
npx serve .
```

Then open `http://localhost:8000`. Note that geolocation in browsers requires HTTPS *or* localhost — `file://` won't work.

## What's in v1.7

This release closes the feedback loop. The system now reads the delta between prescribed and actual training (P18), decides on prescription modifications (P19), and applies them via the C-ADAPT composition. The home WOD card surfaces every adaptation explicitly — no silent edits.

- **F-ADAPT-PLAN — daily adaptive prescription (Tier 2).** Today's plan prescription is now read through C-ADAPT before it's rendered. The system pulls your last 14 days of completion deltas (pace vs prescribed zone, duration vs prescribed minutes), combines with your current Banister Form score, and decides one of: continue (no change), ease intensity one rung, or reduce duration. The decision rule:
  - Pace consistently +15 sec/mi slower than prescribed AND Form 0.5σ below your norm → ease intensity (tempo → moderate, hard → moderate, etc.)
  - Pace strongly slower (+30 sec/mi alone) → ease intensity regardless of Form
  - Median completion < 85% of prescribed duration → reduce prescribed duration to match reality, bounded at 65%
  - Insufficient signal (< 3 sessions or no Form baseline) → plan as-is
- **One-way easing invariant.** Adaptation NEVER escalates intensity. Faster-than-prescribed pace plus healthy Form produces "continue" — the plan's hard work is the stimulus structure; the system can offer to ease it, not amplify it. This is a hard invariant in the C-ADAPT composition rule, structurally tested.
- **No compounding.** Each day's decision reads current state fresh. There's no accumulated "adaptation budget" or integral term that could drift unbounded over a multi-week plan. Adaptation per day is bounded and stateless across days.
- **Rest days are immutable to adaptation.** F-ADAPT-PLAN can soften work; only F-PLAN-OVERRIDE v2 (the harder veto rule from v1.5) can convert work to rest. Rest → work is never possible. The plan's rest pattern is the injury-prevention mechanism.
- **Explicit provenance on every adaptation.** When today's prescription has been modified, the WOD card subtitle shows what changed: "PLAN — Week 6/12, Day 3/7 · Your tempo: 6:57/mi · eased from tempo". The label itself shows "(eased to moderate)". You always see what the system did.
- **Settings toggle.** Profile → ADAPTIVE PRESCRIPTION. Default ON. Disable to always see the raw plan prescription regardless of recent training.

### How the layers stack now (per-day prescription pipeline)
1. **PlanState.today()** produces the raw scheduled workout from the plan template.
2. **F-ADAPT-PLAN (this release)** may ease intensity or reduce duration based on Form trend + completion deltas.
3. **F-PLAN-OVERRIDE v2 (v1.5)** may convert hard work to full rest when Form drops sharply.
4. **F-PACE-ZONES (v1.4)** appends your personalized pace target to the WOD card.

A workout eased by ADAPT can still be vetoed by OVERRIDE on the same day. The hierarchy is intentional: ADAPT (soft adjustment) < OVERRIDE (hard veto). If Form is mildly depressed, you get an easier workout. If Form is severely depressed, you get a rest day. The user always sees which rule fired and why.

### What v1.7 deliberately did NOT do
- **HR-driven adaptation.** HR is too lagged and individual-variable for per-session prescription modification. Pace is the anchor; HR remains supplementary.
- **Coaching text generation.** The provenance reason field is short and structural ("pace median +25s/mi over 5 sessions, Form -1.2σ"), not prose advice. No LLM-style hallucinated coaching tips.
- **Auto-extending plans when "feeling good."** Faster-than-prescribed pace produces "continue", not amplification. The plan's structure was committed to; ad-hoc extensions break it.
- **Confidence intervals on individual outcome predictions.** We can't honestly produce them. The decision is a heuristic with explicit thresholds; we don't dress it up with bogus uncertainty quantification.
- **Adapting based on a single workout.** Three-session minimum for stable signal. One bad workout doesn't trigger anything.

### The feedback loop, now closed
Prescription (F-PLAN) → execution (LiveWorkout) → load measurement (P14 sRPE / FFF) → Form score → P18 delta → P19 decision → adapted prescription (F-ADAPT-PLAN) → next day. Every arrow in that chain is a registered primitive or composition with its own tier ceiling and structural invariants. v1.8 onwards becomes content (more templates, more populations) rather than architecture.

### Phased roadmap (sealed at v1.7)
- **v1.8:** Template expansion — 10K-specific run template (currently routes through half-marathon), marathon template (Pfitzinger 18/55 or similar), beginner ruck template (4-week 6-mile preparation).
- **v1.9:** Per-user Banister coefficient calibration. After 90+ days of training history, fit τ_fitness and τ_fatigue to the individual rather than using population defaults (42/7). Tier ceiling moves from T2 to T1 for users with calibrated coefficients.
- **Beyond:** HR-zone-aware pace targeting (only if HR strap paired); multi-event chained plans (5K → 10K → half progression).

## What's in v1.6

This release lands the long-promised plan generator: P15 PlanGenerator plus the C-COMPOSE-PLAN composition rule. The generator is template-adaptive, not pure-generative — every output plan traces to one of the hand-authored published templates (Cooper, Knapik, Pfitzinger). This is the design choice that distinguishes a defensible generator from a cargo-cult one: we don't reinvent periodization, we adapt published structures to user fitness and event timing.

- **F-PLAN-GENERATE — personalized plan synthesis from templates (Tier 2).** New "+ GENERATE PERSONALIZED PLAN" entry on the plans sheet. You pick mode (run/ruck), event distance (5K / 10K / half marathon for runs; 6mi / 12mi for rucks), and weeks until your event. The generator selects the closest matching hand-authored template using an asymmetric log-ratio metric (training UP from a shorter template is penalized more than training DOWN; a 10K target gets the half-marathon template's structure adapted shorter, not the c25k beginner walk-run plan stretched out). It then scales the week count within ±25% of the template's natural length by inserting consolidation weeks or removing build weeks, and scales workout durations by your current VDOT or pack weight (clamped to [0.6, 1.4] of template defaults). Every generated plan carries provenance metadata showing which template anchored it and what scaling was applied.
- **Honest refusal paths.** Outside the supported envelope, the generator refuses with a specific reason rather than producing a bad plan. "Closest template is 12 weeks; your 4-week target is outside the ±25% scaling window. Pick 9-15 weeks, or use a hand-authored plan." No silent failures.
- **Persistence with documented degradation.** Generated plans serialize to localStorage under `ruckops.genPlans` and rehydrate at boot so PlanState can resolve their id. If localStorage gets cleared or corrupted, the generated plan record is lost — this is a Tier 3 degradation (recoverable: regenerate with the same parameters) documented honestly in the registry, not a hidden gap.

### What v1.6 deliberately did NOT do (and what we learned)

Two industry myths got refuted by contact with the hand-authored templates during validation:

1. **The "10% weekly volume increase" rule** is folklore, not periodization. Knapik's published 8-week ruck plan has a 43% W1→W2 jump as the user moves from light-pack acclimation to standard pack. Pfitzinger has 20-25% phase transitions. Enforcing 10% would reject the exact templates we depend on. The validation now only catches catastrophic (>50%) jumps that would indicate a scaling bug, not legitimate phase transitions. This is documented in the registry under "Not enforced (and why we don't)."

2. **The "final week taper" rule** is template-specific, not universal. Cooper's c25k W12 IS the 5K event, not a taper week. Knapik's W8 IS the 12-mile test. The generator preserves whatever taper shape the underlying template has; it doesn't enforce a separate rule on top. A generated 5K plan looks different from a generated half-marathon plan because the templates are different.

Both lessons are now first-class entries in the COMPOSITION_REGISTRY.md "Not enforced" section. This is the FORGE discipline working as intended: structural invariants must survive contact with the templates they validate.

### Phased roadmap (sealed at v1.6)
- **v1.7:** C-ADAPT composition — daily plan modification based on Form score + actual completion delta (prescribed pace vs observed pace). Closes the feedback loop: prescription → execution → load → Form → next prescription.
- **v1.8:** More templates (10K, marathon for run; ultra-ruck 20mi+, walking events for ruck). Each new template gets its own validation cycle against the existing P15 contract.
- **Beyond:** HR-zone-aware pace targeting (only if HR strap paired); per-user Banister coefficient calibration; multi-event chained plans (5K → 10K → half progression).

## What's in v1.5

This release lands two new primitives (P14, P17) plus the F-WORKOUT-METRO composition that wires the metronome to the prescribed workout intensity. F-FFF replaces ACWR on the home readiness card when sufficient training history exists; F-PLAN-OVERRIDE upgrades to Form-aware decisions with ACWR fallback for new users.

- **F-FFF — Form / Fitness / Fatigue scoring (Tier 2).** Banister's training-load model (1991) computes a moving fitness score (τ = 42 days) and fatigue score (τ = 7 days) from your session history (sRPE = duration × RPE per Foster 2001). Form = fitness − 2.0 × fatigue per Busso (2003). The readiness card on the home screen now shows Form relative to your own median (1σ bands → FRESH / OPTIMAL / ELEVATED / HIGH RISK). The model is only used when you have ≥14 days of training history; before that, the v1 ACWR-based readiness path is preserved for backward compatibility.
- **F-PLAN-OVERRIDE v2 — Form-aware plan override.** The plan engine's "today's hard workout should become rest" decision now uses Form score when available. Override fires when Form drops more than 1σ below your personal median AND the prescribed workout is moderate/tempo/hard/test. For users with <14 days of history, falls back to the v1 ACWR > 1.5 rule. Easy days and rest days are never overridden — the plan's own rest pattern is the injury-prevention mechanism.
- **F-WORKOUT-METRO — prescription-driven metronome.** When you start a workout prescribed by your active plan, the metronome now auto-selects the appropriate initial cadence target based on the prescription's intensity tag. Easy run → 170 spm floor. Tempo → 178. Intervals → 182. Ruck → pack-weight-scaled. Interval workouts get an additional phase-aware behavior: the cadence target shifts up to the prescription floor during the work block, and eases back to the easy floor during the recovery jog. The shift fires from the same phase-change event that triggers voice cues, so target and announcement stay in lockstep. The pre-workout screen also shows your full personalized pace zones (E / M / T / I / R for run mode, easy/standard/tempo for ruck mode) as soon as you've completed the calibration trial.

### What v1.5 explicitly does NOT claim
- That Form score predicts injury for an individual. Banister's coefficients are population-level (τ_fitness=42d, τ_fatigue=7d, k=2.0); individual fits would shift them, and we don't measure individual fits. The model is *applied* correctly; the question of whether 42 / 7 are the right time constants *for you* is empirical and unmeasured here. The decision rule uses your own median Form as the anchor, not absolute Form numbers, which makes the *relative* signal more robust than the *absolute* one.
- That race-time prediction from fitness scores is reliable. The relationship between Banister fitness and race performance is messy at the individual level. We don't expose it.
- That phase-aware cadence cueing improves running economy or injury risk. The literature supports population-level effects of +5% cadence on biomechanics; v1.5 just makes the cue follow the workout structure instead of staying static. Whether that helps any individual is unmeasured by this app.
- A "recovery countdown" timer. Banister's model says nothing about *when* you should next train hard. Form trends matter; specific countdown numbers would be theater.

### Phased roadmap (sealed at v1.5)
- **v1.6:** P15 PlanGenerator — procedural plan generation given (event distance, weeks available, current VDOT, days/week). Hand-authored plans become templates the generator picks from.
- **v1.7:** C-ADAPT composition — day-to-day plan modification based on actual completion + Form score.
- **Beyond:** HR-zone-aware pace targeting (only if HR strap paired); per-user Banister coefficient calibration when enough history exists.

## What's in v1.4

This release adds three new primitives (P13, P13b, P16) and one new composition rule (C-ENTRAIN), wired into two new product features. Per [Composition Registry](COMPOSITION_REGISTRY.md) discipline, each primitive earned its tier through validation tests before its first use site.

- **F-PACE-ZONES — personalized pace targets (run T1, ruck T2).** When you complete the 1-mile calibration trial, plan-day cards now show your individual target pace alongside each prescribed workout (e.g., "EASY RUN 30 MIN · Your easy: 9:42/mi"). Run-mode paces come from the Daniels VDOT system (P13, Tier 1 — verified against 10 reference VDOT values from Daniels 2014). Ruck paces come from the Knapik / Army FM 21-18 standard pace with personal variance from your past ruck history (P13b, Tier 2). A registry invariant explicitly forbids cross-mapping: running zones never appear for a ruck workout and vice versa.
- **F-METRONOME — adaptive stride-cadence cueing (Tier 2).** New ♩ button in the live-workout header toggles an audio metronome. Beat tempo adapts to your observed cadence from the motion tracker (P2): target = max(your observed cadence × 1.05, the pace-appropriate floor). Hard-capped at observed × 1.10 to honor the form-cue literature (Heiderscheit et al. 2011) — the +5% bump is what's well-supported; pushing harder isn't. Mode bounds enforced (run: 150-200 spm, walk/ruck: 100-130 spm). Adaptation rate-limited to once per 60 seconds to match the MotionTracker's convergence window (registry C-ENTRAIN invariant). Pack-weight scales the ruck cadence default (light pack → 120, standard → 115, heavy → 110).

### What v1.4 explicitly does NOT claim
- That cadence cueing prevents injury or improves performance in any individual. The literature supports population-level effects on biomechanics; individual outcomes are unmeasured by this app.
- "180 spm is the right cadence." It is not. The "180 always" target originated from Daniels' anecdotal observation of elite runners at 1984 Olympics; subsequent research (Hunter & Smith 2007, de Ruiter 2013) shows optimal cadence is highly individual. The app uses adaptive targets, not magic numbers.
- That ruck VDOT zones exist. They don't. Ruck training has its own pace anchors per Knapik / Army FM 21-18; the registry's run/ruck differentiation invariant prevents the app from silently treating them as the same.
- HR-zone-based metronome. Heart rate lags 30+ seconds behind effort; it cannot drive beat-by-beat cadence cues. Refused at the composition rule level.

### Phased roadmap (declared at v1.4)
- **v1.5 (next):** P14 FormFitnessFatigue (Banister model) — replaces the current 7d/28d ACWR with exponentially-weighted fitness and fatigue scores.
- **v1.6:** P15 PlanGenerator — procedural plan generation given (event distance, weeks available, current VDOT, days/week). Hand-authored plans become templates the generator picks from.
- **v1.7:** C-ADAPT composition — day-to-day plan modification based on actual completion + Form score.

## What's in v1.3

This release introduces three changes, each governed by the [Composition Registry](COMPOSITION_REGISTRY.md). Tier labels are honest about what's measured vs. what's claimed.

- **F-DIAG — workout diagnostics export (Tier 1).** Post-workout, tap "EXPORT DIAGNOSTICS" to download a JSON file with the workout record plus filter statistics, tracking-mode transitions, conformal-coverage scores, and sensor-health flags. Useful for debugging cross-device behavior. The export schema is documented in the registry under F-DIAG.
- **F-ADAPT-UI — adaptive baseline (UI-infrastructure, validated by visual checks).** Live-screen tile grid uses CSS container queries to adapt from iPhone SE width (forces 2-up) to tablet (allows up to 6-up). Sub-stat values use `clamp()` fluid type. The GPS-lost and PDR-active pulses respect `prefers-reduced-motion`. UI quality lives outside the registry's tier system; visual regression is the validation.
- **F-PLAN — coaching plans (Tier 2).** Three plans shipped: Couch-to-5K (12 weeks, Cooper progression), 12-Mile Ruck Prep (8 weeks, Knapik / U.S. Army FM 21-18), and Half Marathon (12 weeks, Pfitzinger 12/47). Each cites its source. When a plan is active, the home-screen WOD card shows today's prescribed workout. Each plan-day advances exactly once when the user saves a workout. The `PlanState` engine (P12) is round-trip-serialized so progress persists across sessions.
- **F-PLAN-OVERRIDE — ACWR-aware schedule modification (Tier 2).** If ACWR > 1.5 (Gabbett 2016 injury threshold) AND a plan prescribes hard work, the home screen shows a rest-override instead. Easy days and rest days are never overridden. Tier 2 because both inputs (F-PLAN, ACWR) are Tier 2; the composition cannot exceed its weakest link.

### What v1.3 explicitly does NOT claim
- That coaching plans improve user race times, prevent injury, or replace human coaching. Plan content is evidence-cited; the *outcomes* claim is out of scope.
- That tracking is now SOTA-equal to Garmin or Strava in the field. Field measurement against ground truth is unmeasured (v1.4+ work).
- That conformal-coverage 95% holds outside i.i.d. synthetic data. Synthetic tests demonstrate the algorithm; in-session distribution shift would degrade coverage in ways that aren't yet quantified.

The full audit of past claims and their honest tier classifications is in [COMPOSITION_REGISTRY.md §5](COMPOSITION_REGISTRY.md).

### Honest gaps in the web MVP

These are deliberate, scope-locked. They live in the v2 native build, not here.

- **No background GPS.** The browser kills the tab when it's hidden, so workouts only record while the tab is in the foreground. The pre-workout screen says this explicitly. The Wake Lock API is used during workouts to keep the screen on.
- **No accounts, no cloud sync, no cross-device.** All data lives in `localStorage` on this device. The Profile screen has a CSV export so users can move data manually.
- **No Apple/Google sign-in.** Removed from the welcome screen.
- **No in-app purchases or subscription tiers.** The web MVP is single-tier.
- **No push notifications.** Service worker is registered but only handles caching.
- **No 4–12 hour battery test.** Web GPS isn't optimized for ultra-long sessions; the planning docs call out `react-native-background-geolocation` as the right answer for that, which is a v2 native task.
- **Map tiles need internet.** OpenStreetMap tiles are cached as you view them but not pre-fetched.

These are tracked as v2 deliverables in `MVP_SCOPE.md`.

## Files in this repo

### Web MVP (new in this fork)

| File | Purpose |
|---|---|
| `index.html` | App shell with all screen templates |
| `app.js` | Single-file ES module: routing, state machine, GPS, persistence |
| `styles.css` | Tactical dark theme — colors and typography from the design blueprint |
| `manifest.webmanifest` | PWA manifest |
| `sw.js` | Service worker (cache-first shell + tile cache) |
| `icon-192.png`, `icon-512.png`, `icon-512-maskable.png` | PWA icons |
| `.nojekyll` | Disables Jekyll on GitHub Pages |
| `.github/workflows/pages.yml` | Deploys to Pages on every push to `main` |

### Original planning documents (unchanged)

| File | Purpose |
|---|---|
| `APP_IDEA_SUMMARY.md` | Validated concept (Project 1) |
| `MVP_SCOPE.md` | Locked MVP scope (Project 1) |
| `APP_DESIGN_BLUEPRINT.md` | Screen-by-screen design (Project 2) |
| `APP_CONTENT.md` | Final copy that ships in the binary (Project 3) |
| `DEVELOPER_BRIEF.md` | Full technical spec for the native build (Project 4) |
| `FILE_STRUCTURE.md` | Native repo layout (Project 4) |
| `HANDOVER_PROMPT.md` | Prompt for Project 5 (MVP Builder) |
| `github/PUSH_COMMAND.txt` | Original push command |
| `github/REPO_SETUP.md` | Original repo setup notes |

## Tech stack at a glance

| Layer | Web MVP (this fork) | v2 Native (planned) |
|---|---|---|
| App | Vanilla JS + ES modules, no build step | React Native + Expo (Bare workflow) |
| GPS | `navigator.geolocation.watchPosition` (foreground only) | `react-native-background-geolocation` |
| Local DB | `localStorage` | `expo-sqlite` |
| Backend | None — local only | Supabase (Postgres + Auth + Edge Functions) |
| Maps | Leaflet + OpenStreetMap | `react-native-maps` |
| Auth | None — single-user device | Supabase Auth (Apple, Google, email) |
| IAP | None | `react-native-iap` |
| Crash + analytics | None | Sentry |
| Build pipeline | GitHub Pages deploy action | EAS Build + EAS Submit |

The full justification for the v2 native choices is in `DEVELOPER_BRIEF.md` §2.

## What the web MVP looks like

The visual identity matches the design blueprint:

- Tactical amber `#F4811F` for primary CTAs, hero metrics, brand accents
- Olive drab `#4A5D23` for run-mode highlights
- Deep tactical black `#0D0F0D` background
- Roboto Condensed Bold for titles, JetBrains Mono Bold for numerics, Inter for body
- Glanceable hero metrics, monospace stats, no civilian gloss

## Browser support

- iOS Safari 14+ — works, with the foreground-only caveat
- Android Chrome — works
- Desktop Chrome / Firefox / Edge — works (geolocation is desktop-IP-based, useful only for testing the UI)
- Wake Lock API: supported on Android Chrome and recent iOS Safari; falls back gracefully where not

## License

MIT (or whatever the original repo elects).

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

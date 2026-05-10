# RuckOps — Project 4 Output

Developer brief and GitHub setup for **RuckOps**, a GPS workout tracker for rucking and running.

## Files in this package

- `APP_IDEA_SUMMARY.md` — Validated concept (carried forward from Project 1)
- `MVP_SCOPE.md` — Locked MVP scope (carried forward from Project 1)
- `APP_DESIGN_BLUEPRINT.md` — Screen-by-screen design (carried forward from Project 2)
- `APP_CONTENT.md` — Every word that ships in the binary (carried forward from Project 3)
- `DEVELOPER_BRIEF.md` — **New this project.** Full technical spec
- `FILE_STRUCTURE.md` — **New this project.** Repo layout with one-line file descriptions
- `HANDOVER_PROMPT.md` — Ready-to-paste prompt for Project 5 (MVP Builder)
- `github/PUSH_COMMAND.txt` — One-line terminal command to push everything to GitHub
- `github/REPO_SETUP.md` — Step-by-step guide to creating the empty GitHub repo

## What's in the developer brief

- **Tech stack** — Single recommended stack with justification (React Native + Expo Bare + Supabase, with `react-native-background-geolocation` for the multi-hour GPS requirement)
- **Architecture** — Runtime data flow, the workout-recording loop, crash recovery contract, offline-first sync engine, cross-device sync
- **Data models** — `users`, `workouts`, `workout_points`, `subscriptions` — schema for both local SQLite and Supabase Postgres
- **Screen specs** — Each of the 9 screens mapped to its data, services, and state
- **GPS strategy** — Specific iOS deferred location updates and Android FusedLocationProvider configuration
- **Auth flow** — Apple, Google, email via Supabase Auth
- **IAP flow** — Apple StoreKit + Google Play Billing with server-side receipt validation via Supabase Edge Functions
- **Free vs Pro gating** — Where the gate lives client-side and server-side
- **Environment variables** — Every secret with plain-English instructions for where to find it
- **Build & deploy plan** — Local dev, EAS Build profiles, store submission, OTA updates

## Tech stack at a glance

| Layer | Tool |
|-------|------|
| App framework | React Native + Expo (Bare workflow with Dev Client) |
| Background GPS | react-native-background-geolocation |
| Local DB | expo-sqlite |
| Backend | Supabase (Postgres + Auth + Edge Functions) |
| IAP | react-native-iap |
| Maps | react-native-maps |
| Push | Expo Notifications |
| Crash + analytics | Sentry |
| Build pipeline | EAS Build + EAS Submit |

The full justification for each choice is in `DEVELOPER_BRIEF.md` §2.

## What's next

1. **Create the GitHub repo first** — see `github/REPO_SETUP.md` for the step-by-step. The repo URL needs to be `https://github.com/khurang-r/RuckOps` to match the push command.
2. **Run the command in `github/PUSH_COMMAND.txt`** from your Ubuntu terminal. It will unzip this package, init a Git repo, commit everything, and push to GitHub.
3. **Open a new chat for Project 5: MVP Builder.** Upload `RuckOps-Project4.zip` and paste the contents of `HANDOVER_PROMPT.md`. The Project 5 builder will generate the actual codebase.

## Important

The MVP scope is still locked. The developer brief does not introduce new features beyond what is in `MVP_SCOPE.md` — it only specifies *how* to build them. Project 5 (MVP Builder) will turn the brief and file structure into working code.

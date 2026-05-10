# Handover Prompt for Project 5: MVP Builder

Open a new chat for **Project 5: MVP Builder**, upload `RuckOps-Project4.zip`, and paste the prompt below.

---

I've completed Project 4 (Developer Brief). The full validated concept, locked MVP scope, complete design blueprint, all in-app copy, and the technical specification are in the attached ZIP.

**App name:** RuckOps
**Platform:** iOS 16+ and Android 10+ (phone only)
**Tech stack (locked in Project 4):** React Native + Expo (Bare workflow with Dev Client) + Supabase + react-native-background-geolocation + react-native-iap + Sentry. Justification for each is in `DEVELOPER_BRIEF.md` §2.

**GitHub repo:** https://github.com/khurang-r/RuckOps (already pushed with the Project 3 + Project 4 docs).

**Reference all six documents in the ZIP:**
- `APP_IDEA_SUMMARY.md` — concept and target user
- `MVP_SCOPE.md` — what's in and out (LOCKED — do not add features)
- `APP_DESIGN_BLUEPRINT.md` — screen layouts and visual identity
- `APP_CONTENT.md` — every UI string (use verbatim, do not paraphrase)
- `DEVELOPER_BRIEF.md` — full technical spec including data model, GPS strategy, auth, IAP, sync, gating
- `FILE_STRUCTURE.md` — exact repo layout with one-line description per file

**What I need from Project 5:**

A complete, runnable codebase ZIP that matches `FILE_STRUCTURE.md` exactly. Specifically:
1. Every file in `FILE_STRUCTURE.md` exists with working code
2. All UI copy comes from `src/constants/strings.ts` (sourced from `APP_CONTENT.md`)
3. All colors come from `src/constants/colors.ts` (sourced from `APP_DESIGN_BLUEPRINT.md` § Visual Identity)
4. `package.json` lists all dependencies from `DEVELOPER_BRIEF.md` §2
5. `.env.example` lists all environment variables from `DEVELOPER_BRIEF.md` §14
6. `supabase/migrations/` contains the SQL for the data model in `DEVELOPER_BRIEF.md` §5
7. `supabase/functions/` contains the Edge Functions for receipt validation, subscription revalidation, and webhooks
8. A `README.md` that walks through clone → install → env setup → first run on iOS and Android

**Critical correctness checks:**
- The crash-recovery flow (`DEVELOPER_BRIEF.md` §4.3) must work — every GPS point persists synchronously to SQLite before the workout state advances
- The free vs Pro gate (§10) must be enforced both client-side (UX) and server-side (RLS)
- The IAP flow (§9) must call the `validate-receipt` Edge Function — the client must never set `subscription_tier = 'pro'` directly
- The background GPS configuration (§7) must use the exact priority/accuracy values specified per platform

**Don't add new screens, features, or v2 items.** The MVP scope is locked.

After generating the codebase, push it to the existing GitHub repo (`https://github.com/khurang-r/RuckOps`) on a feature branch like `feature/project-5-mvp-build`, so I can review the diff before merging to `main`.

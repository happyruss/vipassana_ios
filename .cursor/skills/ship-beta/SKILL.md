---
name: ship-beta
description: >-
  Ship Vipassana beta builds to TestFlight and Play internal testing.
  Auto-bumps build numbers, uploads one or both platforms, commits bumps
  and tags master on success. Use when the user says "ship beta", "/ship-beta",
  "ship beta vipassana", "ship beta android/ios" for Vipassana, or asks to
  upload a Vipassana beta build.
disable-model-invocation: true
---

# Ship Beta (Vipassana)

Upload **Vipassana Insight** to TestFlight and **Vipassana by Guided Meditation** to Play **internal testing**. Store listing copy is out of scope — binary upload only.

Ship from **`vipassana_ios`** (parent checkout with `AudioAssets/`), not the nested clone without audio.

## When to use

- User says **ship beta**, **/ship-beta**, or **ship beta vipassana**
- User wants **only Android** or **only iOS**

## Prerequisites

| Platform | Credentials |
|----------|-------------|
| iOS | `~/.appstoreconnect/AuthKey_<KEY_ID>.p8` + `APP_STORE_CONNECT_ISSUER_ID` |
| Android | `keystore.properties` + `~/.playstore/service-account.json` with **Vipassana** app access in Play Console → Users and permissions |

Repos as siblings of `meditation-treks`. Default branch **`master`**. Clean working tree on each repo you ship.

**Play:** Grant `play-upload@meditation-treks.iam.gserviceaccount.com` access to `com.guidedmeditationtreks.vipassana` (not the retired API Access page).

## Workflow

```
Ship Beta Progress:
- [ ] Step 1: Run orchestrator (bump + upload + commit)
- [ ] Step 2: Report build / upload status
```

### Step 1: Run orchestrator

From `meditation-treks` repo root:

```bash
./scripts/ship-beta-vipassana.sh            # both
./scripts/ship-beta-vipassana.sh android    # Play internal only
./scripts/ship-beta-vipassana.sh ios        # TestFlight only

# Same as above:
./scripts/ship-beta.sh vipassana
./scripts/ship-beta.sh vipassana android
./scripts/ship-beta.sh vipassana ios
```

Bumps build numbers on shipped platforms, uploads, then commits and tags `beta/vipassana-<versionName>-<build>` on success.

**Bump only:** `./scripts/bump-beta-build-vipassana.sh [android|ios|both]`

**Re-upload without rebuild:**

```bash
cd vipassana_android && bundle exec fastlane upload_release
cd vipassana_ios && bundle exec fastlane distribute_beta
```

### Step 2: Report

- New build number and platforms shipped
- TestFlight / Play internal success or failure
- Deploy tag name and commit SHAs

Do **not** run `submit_release` or `fastlane release` unless the user explicitly asks for production.

Privacy policy: https://meditationtreks.com/privacy-policy/

# Handoff — Word Unlocked (Bible Widget App)

## Update 2026-09-28 — every finding from the 2026-09-27 audit is fixed

The audit (7 high, 14 medium, 22 low; private report
https://claude.ai/artifact/LpkyYd96PZpsEx3W6AAuwo) is fixed in one batch. Verified with
Xcode 27.0 and the iOS 27.0 simulator SDK: 104 tests in 10 suites pass (the two live API
tests skip by design), and the Debug simulator build and the unsigned Release device build
both have 0 warnings.

**Licensing and privacy**
- **No more URL cache.** Both live services use `LiveAPISession.shared`, an ephemeral
  session with `urlCache = nil`, so no Recovery Version text, ESV download or API key
  reaches `Library/Caches/…/Cache.db`. The app clears the old shared cache at every launch,
  and deletes any Recovery Version rows that debug builds before this one copied into its
  database. Checked after a live Recovery Version request: `Cache.db` held 0 rows.
- **The keys left Info.plist.** The app target's first build phase, "Embed API Keys",
  writes the three values from the gitignored `Config/Secrets.xcconfig` into
  `$(DERIVED_FILE_DIR)/LiveAPIKeys.swift`, XOR-masked so neither the ESV key nor the LSM
  token is a plain string in the binary (checked: 0 matches in the built .app; the LSM app
  ID is just the bundle id). The project references that file with
  `sourceTree = DERIVED_FILE_DIR` — Xcode does not compile a script's output on its own.
  An empty or `YOUR_…` value means not configured, and the translation stays hidden.
  **Rotation plan:** if a key is revoked or its quota abused, issue a new one at
  api.esv.org or with LSM, put it in `Secrets.xcconfig`, rebuild and ship; watch both
  providers' usage pages after launch.
- **ESV's 48 hours can't be skipped.** The time is recorded before the request goes out
  and rolled back only when the request never left the device (offline, DNS, TLS,
  certificate or ATS failures). The download runs in its own task, so leaving Today
  mid-download no longer throws it away.
- **Every verse is labelled with its own translation** (`Verse.translationCode`), so ESV
  text never shows as KJV, and a favorite keeps the translation it was saved in.
- Privacy wording in the app, on the three pages and in the listing now says what reaches
  Crossway and LSM (IP address, app and OS version, the verses asked for). The listing no
  longer says Recovery Version text is "used by permission".

**What people see**
- Daily Verse draws from the 665 curated verses in a shuffled order (matched by book,
  chapter and verse in the other translations), keeping the testament filters.
- Memorization shows its steps on Today and the widget: whole verse, blanks, first
  letters, reference only, review — one step per local calendar day.
- Five tabs (Translations moved into Settings), onboarding keeps Next visible, the active
  mode's settings open, mode sheets save and close, Search reads "Psalm 23", "1 Kings 2",
  "Jude 3" and ranges, Favorites has Edit, reorder, Share and Remove.
- Widget: Segmented takes turns every 20 minutes within a verse's slot, Reference Only
  shows the reference, Chapter's Show Progress adds "Verse 3 of 36", tapping a widget
  opens Today, references are written out ("1 Kings 2:2"), and a timeline built before
  first unlock is retried after 15 minutes instead of at midnight.
- New "Automatic" theme follows Light and Dark Mode and is the default; three accents
  were darkened to pass 4.5:1.
- Favorites decode one by one and are rewritten only when a migration changed them; old
  Recovery Version favorites become the KJV text of the same verse.
- Seed scripts verify TLS and pin their sources by commit or SHA-256;
  `fetch_esv_seed.py` is deleted. The current BSB source differs from the shipped seed
  only at 2 Timothy 1:15 ("province" vs "Province"); the database was not regenerated.

**Correction — the contact address is privacy@rippre.com.** Item 5 below used to say
help@rippre.com is used everywhere. It isn't: the owner confirmed privacy@rippre.com on
2026-09-12, and the 2026-09-14 history rewrite changed only the commit author email to
help@rippre.com. The app and all three hosted pages publish privacy@rippre.com.

The nine 6.9" screenshots in `marketing/screenshots/6.9/` were retaken from a fresh
install on a dedicated iPhone 17 Pro Max simulator ("WordUnlocked Shots", iOS 27.0,
status bar set to 9:41), so they show the five tabs and the new Today.

**Still the owner's:** Apple signing and the App Store Connect record.

## Update 2026-09-22 — where the to-do list actually stands

Nothing is in flight. `main` = `origin/main` = `b5ef1ce`, working tree clean; 72/72 tests
and a 0-warning Release build as of the 2026-09-14 batch, and no code has changed since.

- **GitHub secret scanning and push protection are ON.** Enabled 2026-09-22 via
  `gh api -X PATCH repos/burntsteam/word-unlocked`; confirm any time with
  `gh api repos/burntsteam/word-unlocked --jq .security_and_analysis`. The backfill scan
  of the whole history reported **0 alerts**
  (`gh api repos/burntsteam/word-unlocked/secret-scanning/alerts`). Push protection now
  blocks a push carrying a recognised provider secret; if it ever fires, rewrite the
  commit instead of taking the bypass.
- **It does not cover this repo's two secrets.** GitHub refuses to enable
  `secret_scanning_non_provider_patterns` (generic patterns) and
  `secret_scanning_validity_checks` — the PATCH returns 200 and leaves both `disabled`,
  because they need GitHub Advanced Security. Neither the ESV API key nor the LSM token
  matches a known provider pattern, so **GitHub would not catch either one**. Keep running
  the local scan before every push:

  ```bash
  cd "/Users/yg/Repositories/Bible Widget App"
  KEY=$(grep -E '^ESV_API_KEY' WordUnlocked/Config/Secrets.xcconfig | sed 's/.*= *//')
  git log -p origin/main..HEAD | grep -c "$KEY"   # expect 0
  git grep -q -F "$KEY" HEAD && echo LEAK || echo clean
  ```
  (Repeat for `LSM_TOKEN`. `WordUnlocked/Config/Secrets.xcconfig` is gitignored and
  untracked — verified again on 2026-09-22.)

**Only the owner can finish these:**

1. **Apple signing** — 0 valid codesigning identities in the keychain, no
   `DEVELOPMENT_TEAM` on either target. Archiving is impossible until it's set.
2. **The App Store Connect record** — every piece of text is pre-written in
   `marketing/app-store-listing.md`, and the privacy/support URLs are live on Pages.

**Optional, owner's call:**

- Add help@rippre.com to GitHub → Settings → Emails so the rewritten commits link to the
  account.
- Ask GitHub Support to purge the pre-rewrite SHAs — the old commits (with the personal
  address) stay fetchable by SHA until GitHub garbage-collects them.
- Written LSM permission, if the Recovery Version should ever reach the Lock Screen; today
  its terms forbid storing the text, so the widget falls back to KJV.

**Knowledge graph (graphify) as of 2026-09-22, HEAD `47818a0`:**

- Rebuilt at `--scope all`: 735 nodes, 65 communities, **every community named** (87
  curated names in `community_labels.json`) and **730 of 734 nodes described**
  (`node_descriptions.json` went 0 → 730). Both sidecars are tracked, so a rebuild
  restores them. The 19 description batches had sat unanswered since the graph was
  first built; `/Users/yg/Repositories/scripts/graphify-describe-nodes.py` answered
  them with the local model (`OPENAI_BASE_URL=http://localhost:11434/v1
  DESCRIBE_MODEL=qwen3.6:35b-a3b`, ~10 min, no API cost), then
  `graphify update . --scope all …` ingested them. Recipe and gotchas: engram
  `01m35jdk86gaqfqqtdgr68mgxa`.
- **graphify 0.17.1's `query` and `explain` never print node descriptions** and have no
  flag for it. The text is on `graph.json` nodes and in the sidecar only. Don't expect
  richer CLI output because the nodes are described.
- Ingesting descriptions re-clusters and leaves a few communities bare; run
  `scripts/graphify-label-communities.py` (same ollama env, `LABEL_MODEL=`) after, then
  `graphify-sync-report.py` last. Never `graphify label`.
- The tree will show `GRAPH_REPORT.md` and `community_labels.json` modified a few
  seconds after *any* commit, including the one that absorbs them. That loop cannot
  converge; it's the post-commit hook. Check that no curated name was dropped, then
  either commit it or leave it.

## Update 2026-09-14

Signing and the App Store Connect record stay with the owner for later (secret scanning was
turned on afterwards, on 2026-09-22). Done this session:

- **The commit email is help@rippre.com.** All 37 commits were rewritten and force-pushed:
  author, committer, and the old address inside HANDOFF.md and docs/*.html. Trees and
  messages were verified identical apart from that address, and this repo's `user.email` is
  now help@rippre.com. Commit SHAs quoted further down this file are pre-rewrite. The old
  commits may stay reachable on GitHub by SHA until GitHub garbage-collects them; GitHub
  Support can purge them if that matters.
- **Weekly Theme is now Weekly Plan:** seven verses a week, one a day, from a theme, a
  chapter, a book, or the user's own list (added from search or favorites). Repeat keeps the
  same seven every week; turning it off moves on seven verses a week and starts over at the
  end. The raw value is still `weeklyTheme`. Chapter and book sources read in book, chapter
  and verse order, because verse ids are not in reading order.
- **ESV keeps as many verses on the phone as Crossway allows:** up to 500, and never more
  than half of any book, counting ESV favorites. They are the verses the current settings
  show next, so the Lock Screen widget now shows ESV offline; before, it repeated the last
  verse fetched. **Each install downloads at most once every 48 hours**, in one request of up
  to 300 verses (the API refuses request lines over 4,094 bytes). Being offline doesn't
  start the 48-hour wait. A verse not downloaded yet shows in KJV, labelled KJV, with a note
  saying when the next download can happen.
- **The Recovery Version is no longer stored at all.** LSM's terms of use forbid storing any
  RV text for offline use, and the app used to keep the last verse for the widget. RV now
  loads into memory while reading and shows LSM's attribution beside the verse; the widget,
  wallpaper export and RV favorites use KJV. "Used by permission" is gone from RV copy,
  since LSM's terms forbid implying a relationship. The 48-hour rule applies to ESV only:
  RV can't be stored, so it has to load whenever it's shown.
- **Fetching is tested:** stubbed-network tests for both services, plus two live tests that
  call the real APIs when run with `TEST_RUNNER_LIVE_API_TESTS=1`. ESV returned John 3:16
  and Psalm 23:1, and RV returned John 3:16 with LSM's attribution. 72/72 tests pass, and
  the Release build has 0 warnings.
- The in-app privacy, Translations and Licenses text, the docs pages and the listing
  describe the new storage. The privacy policy is dated September 14, 2026.
- Checked in the simulator: 299 ESV verses downloaded in one request (John 5:4 is left out,
  since the ESV omits it), RV text with LSM's attribution, and Weekly Plan's book and
  My Verses sources through Start This Week. The 6.9" screenshots 03-onboarding-modes,
  07-modes and 08-translations were retaken from a fresh install to show Weekly Plan and
  the new RV label.

## Update 2026-09-12

Done this session: **repo made public** (user's choice, history secret-scanned clean),
**GitHub Pages live** — https://burntsteam.github.io/word-unlocked/ (+ privacy.html,
support.html — put these two in App Store Connect), **contact email aligned to
privacy@rippre.com everywhere** (docs edited to match the app; user confirmed they keep
that mailbox), **nine 6.9" screenshots** at `marketing/screenshots/6.9/` (1320×2868,
committed).

**ESV is ON.** The key is in the gitignored `Secrets.xcconfig` (verified with a live
api.esv.org request; never commit it — the repo is public). Listing, docs and the
Translations screenshot now say seven translations; the listing banner says how to flip
back. `ESVBibleService` takes its key via `init(apiKey:)`: unit tests run inside the app
(TEST_HOST), so the old "no key" tests broke once the key existed and would have hit the
network. Tests 41/41 green with the key.

Still blocked on user: Apple signing (item 1) and ASC record creation (item 6). Items 2
(ESV key), 3 (screenshots), 4 (Pages) and 5 (email) below are done.

### Hardening pass (2026-09-12, later)

Verified: 47/47 tests, Release device build with 0 warnings, and in the simulator —
Search and Memorization with ESV selected, the Topic list, the Weekly Theme preview, and
the Lock Screen widget gallery rendering the verse. Fixed:

- **Privacy manifests were never bundled.** The files existed but the project didn't
  reference them, which blocks the App Store Connect upload. Both targets ship one now,
  with the App Group reason 1C8F.1 added.
- **Lock Screen widget views had no `containerBackground`**, so iOS 17+ showed "Please
  adopt containerBackground API" instead of the verse.
- **The widget loaded a whole translation per timeline entry** (~22 MB each; the extension
  gets ~30 MB). Verse choice is now one SQL-backed `VerseSelectionService` shared by app
  and widget. That also fixed Exclude Long always showing Gen 1:1, the app and widget
  disagreeing, ESV/RV never rotating (and their Search/Memorization being empty), the
  built-in verse saving as Gen 1:1, and widget days changing at reload time, not midnight.
- **Topics were hard-coded**: 10 of 26 had no verses, anxiety/fear/grief (named in the App
  Store copy) weren't offered, and non-KJV translations had no topic verses at all. Topic
  and Weekly Theme now list the database's topics and match verses across translations.
  Weekly Theme shows a topic's first seven verses, one per day, matching its preview.
- **Live fetches**: a cancelled fetch showed a red error, a new verse's fetch could be
  dropped, cached verses were re-fetched (every install shares one API key), and 429
  said "check your connection".
- Memorization search stalled on every keystroke; the widget could create an empty
  database before the app's first launch.

### Mode settings implemented (2026-09-13)

Every mode setting now changes what the app and the Lock Screen show, through the shared
verse picker, and each has a test:
- **Rotation speed** (Topic, Chapter, Favorites: daily / 12h / 6h) and **Daily Verse's
  update interval** (daily / 8h): the verse advances at fixed hours counted from midnight,
  and the widget schedules an entry at each boundary.
- **Chapter end behaviour**: reading starts at verse 1 whenever a new passage is set; then
  Repeat starts the chapter again, Next Chapter reads on (Revelation wraps to Genesis), and
  Stop stays on the last verse.
- **Weekly auto-repeat**: on keeps the theme; off moves to the next theme (alphabetical)
  each week after "Start This Week".
- **Favorites shuffle** plays each pass in a new but reproducible order, every favorite
  once per pass. **Favorites exclude-long** filters favorites only, instead of switching
  the app-wide long-verse strategy as it used to.
- **Days now turn over at local midnight.** `Calendar.ordinality(of: .day, in: .era)` rolls
  over at midnight UTC (5 PM in California), so the daily verse used to change in the late
  afternoon. Slots now count local calendar days.

Still the owner's call:
- ~~**GitHub secret scanning and push protection are off**~~ — both enabled 2026-09-22;
  see the update at the top of this file for what they do and don't catch.
- ~~**Every commit's author email is the owner's personal address**~~ — rewritten to
  help@rippre.com and force-pushed on 2026-09-14.

Written 2026-09-01, end of the migration-audit + ship-readiness session. Everything
below is committed and pushed: `main` = `d078d61`, in sync with
`origin/main` (https://github.com/burntsteam/word-unlocked.git), working tree clean.

## Where things stand

The iCloud → new-machine migration audit came back **clean** (git fsck, worktree vs
HEAD, no `.icloud` stubs/dataless files/conflicted copies, 50 MB SQLite seed passes
`PRAGMA integrity_check`, all seed JSONs parse). Both targets build on Xcode 26.6 /
iOS 26.5 SDK, and the audit's findings were then all fixed, committed as the batch
`6c96c57..d078d61`.

### Shipped this session (all verified, all pushed)

- **App icon** — 1024×1024 opaque, open-book-on-navy, generated by
  `scripts/generate-app-icon.swift` (CoreGraphics; no ImageMagick/Pillow on this Mac).
  Wired via `ASSETCATALOG_COMPILER_APPICON_NAME` on the app target only; confirmed
  present inside the built .app.
- **ESV gated off** — `ESV_API_KEY` is missing from `WordUnlocked/Config/Secrets.xcconfig`
  (gitignored, unrecoverable from git — it holds only `LSM_APP_ID`/`LSM_TOKEN`).
  `ESVBibleService.isConfigured` now hides the ESV row when the key is empty, so the
  app ships SIX translations (KJV/WEB/BSB/ASV/LSV offline + Recovery Version live).
  Adding the key later re-enables ESV with no code change.
- **Onboarding fixes** (found by driving the simulator): the translation step was
  hardcoded to KJV-only — now data-driven from `TranslationService.availableOffline`,
  all five render; page dots were an `.overlay` floating over scrolling content — now
  `.safeAreaInset`.
- **Tests** — new `WordUnlockedTests` target + shared scheme, 41 swift-testing cases,
  `xcodebuild test` green (~0.015 s). ESV eviction rule extracted to pure
  `ESVBibleService.applyingStore(_:to:)` (`store(_:)` is private again) after the
  original tests were found writing 500 junk verses into the real App Group store the
  widget reads. `VerseSelectionService.pick`/`stableIndex` widened to internal (pure).
- **Hosted pages** — `docs/` (index/privacy/support + `.nojekyll`), self-contained
  HTML, no external requests, claims verified against code. Written for GitHub Pages
  (enable: repo Settings → Pages → main branch `/docs`).
- **Listing corrections** in `marketing/app-store-listing.md` — the big ones:
  - "Revised Version" → **Recovery Version** (© Living Stream Ministry, api.lsm.org);
    the old name was a different public-domain 1885 translation. Legally significant.
  - Keyword string was **102 chars vs Apple's 100 limit** (file claimed ~99) → now 90.
  - RV "rolling cache" overclaim fixed (RV caches exactly ONE verse; ESV caches 500).
  - All counts now describe the six-translation build; a banner at the top says
    exactly what to flip back if the ESV key is added before submission.
- **`ITSAppUsesNonExemptEncryption = false`** in Info.plist (HTTPS-only → exempt).
- **Hygiene** — committed `.pyc` removed + `__pycache__`/`*.pyc` ignored tree-wide;
  empty `WordUnlocked/WordUnlocked/Paywall/` dir removed (no StoreKit anywhere — app
  is free, no IAP); `**/.graphify/cache/` ignored (see gotchas).
- **Graphify** — graph rebuilt (was 3 commits stale), `stale:false`, all 7 curated
  community names survived (verified by name against HEAD~1), sidecars
  `community_labels.json` + `node_descriptions.json` both tracked.

## The original to-do list (written 2026-09-01) — items 2-5 are done

Kept for the detail in it; see the 2026-09-22 update above for what is still open.

1. **Apple signing** — keychain has **0 valid codesigning identities** and no
   `DEVELOPMENT_TEAM` in the project. Sign into Xcode → Settings → Accounts on this
   Mac, pick the team (9 different team IDs exist across old projects — user must
   choose), then set the team on both targets. Archiving is impossible until then.
2. ~~**ESV API key**~~ — DONE 2026-09-12; the key is in the gitignored `Secrets.xcconfig`.
   Original note:
   **ESV API key** — decision made: get it LATER from api.esv.org (requires an
   account; Claude cannot create one). When it arrives: append
   `ESV_API_KEY = <key>` to `WordUnlocked/Config/Secrets.xcconfig`, then follow the
   banner at the top of `marketing/app-store-listing.md` (Six→Seven, restore ESV
   bullet + `esv` keyword) and the HTML comments at the top of each `docs/*.html`.
3. ~~**App Store screenshots at 6.9"**~~ — DONE; nine 1320x2868 shots are committed at
   `marketing/screenshots/6.9/`. Original note:
   **App Store screenshots at 6.9"** — Apple requires 1320×2868 (iPhone 17 Pro Max).
   Working captures from the walkthrough exist at
   `/private/tmp/claude-501/-Users-yg-Repositories-Bible-Widget-App/5c5a4907-0f56-4a02-bdeb-84307309dc63/scratchpad/shots/`
   (scratchpad = may be gone after reboot) but they are **6.3"** (iPhone 17 Pro,
   1206×2622) — wrong upload size. The Pro Max simulator takes headless screenshots
   fine but **taps need the user to approve device access once** in the simulator
   panel ("Let Claude use it"). Approve that, then a session can re-drive the same
   walkthrough on the Pro Max: fresh install → onboarding (Next×5/Get Started) →
   Today / Translations / Modes / Search (+ theme picker page during onboarding).
   Captions to overlay are in the listing file.
4. ~~**GitHub Pages**~~ — DONE; live at https://burntsteam.github.io/word-unlocked/.
   Original note:
   **GitHub Pages** — enable it (Settings → Pages → main, `/docs`), then put the
   resulting privacy/support URLs into App Store Connect.
5. ~~**Decide `privacy@rippre.com`**~~ — DONE; the contact address is privacy@rippre.com,
   confirmed by the owner on 2026-09-12. Only the commit author email became
   help@rippre.com (2026-09-14). Original note:
   **Decide `privacy@rippre.com`** — the in-app policy (SettingsView.swift:232) still
   shows it; the hosted pages used a personal address. Align once the user decides
   whether they own/keep the rippre.com mailbox.
6. **App Store Connect setup** (still open) — everything text-side is pre-written in
   `marketing/app-store-listing.md` (name/subtitle/promo/description/keywords/
   what's-new/captions, all measured under their char limits).

## Gotchas discovered (save future-you the debugging)

- **graphify hooks fight `.gitattributes`**: hook-rebuild re-adds
  `graphify-out/graph.json merge=graphify-json` on every run. It was removed once as
  vestigial and came back — the tool owns that file; leave the line alone.
- **graphify writes `.graphify/cache/` relative to CWD** — running from a subdir
  litters `WordUnlocked/.graphify/` etc. Now ignored via `**/.graphify/cache/`, but
  expect strays to appear; they are pure derived cache, safe to `rm -rf`.
- **GRAPH_REPORT.md and community_labels.json re-dirty themselves asynchronously after
  every commit**, including the commit that absorbs them — normal churn per CLAUDE.md;
  commit opportunistically (after a dropped-name check) or ignore it.
- The graphify **restore/guard scripts live one level up** at
  `/Users/yg/Repositories/scripts/` (not in this repo). The pre-commit label guard IS
  installed here and finds them by walking up. (An earlier session note claiming the
  guard was missing was wrong.)
- **The label sidecar's real data is under `.labels`** — counting top-level JSON keys
  of `community_labels.json` gives 2. Each entry is `{"name", "members"}`; a curated
  name is anything not matching `Community \d+`. (Was 7 names in 60 communities on
  2026-09-01; 87 names, 65 communities, all named, as of 2026-09-22.)
- **zsh eats `$c:Word...`** — `:W` parses as a parameter modifier; use `${c}:path`
  when scripting `git show`.
- macOS has **no `timeout` command**; don't wrap network git calls with it.
- Simulator point spaces used for taps: iPhone 17 Pro = 402×874, Pro Max = 440×956.
  Tab bar y≈839 (17 Pro); tabs at x≈62/127/201/275/340.
- ~~DEBUG-only dead path in `RVBibleService.fetch`~~ — removed 2026-09-28; nothing reads
  the local `seed_verses_rv_testing.json` now. The file went to the Trash that day and
  was restored 2026-10-06 at the user's request. It is RV text, so it stays local-only:
  gitignored (`.gitignore:3`), not in the Xcode project, never bundled into the app.
- **A failing `xcodebuild test` then sits for up to 10 minutes** running
  `simctl diagnose`. Pass `-collect-test-diagnostics never` to get the result at once.
- **A Run Script's output is not compiled automatically**, even a `.swift` file listed
  under Output Files: the target also needs a file reference to it (here
  `sourceTree = DERIVED_FILE_DIR`) in its Sources phase.

## How to verify the world is still green

```bash
cd "/Users/yg/Repositories/Bible Widget App/WordUnlocked"
xcodebuild test -project WordUnlocked.xcodeproj -scheme WordUnlocked \
  -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17 Pro Max' \
  -collect-test-diagnostics never
```
Expect: `Test run with 104 tests in 10 suites passed` + `** TEST SUCCEEDED **` (the two
live API tests are skipped unless `TEST_RUNNER_LIVE_API_TESTS=1` is set).
Widget: same command with `-scheme WordUnlockedWidget` and `build` → BUILD SUCCEEDED.

## Fastest path to "submitted"

signing (user) → 6.9" screenshots (one approval + re-run walkthrough) → enable
Pages + URLs into ASC → paste listing copy → archive & upload. ESV can join in a
1.0.1 without blocking any of it.

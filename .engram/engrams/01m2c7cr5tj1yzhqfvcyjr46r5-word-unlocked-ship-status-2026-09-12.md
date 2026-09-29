---
id: 01m2c7cr5tj1yzhqfvcyjr46r5
title: Word Unlocked ship status 2026-09-12
type: decision
tags:
  - word-unlocked
  - ship
  - app-store
scope: project
created: 2026-09-13T01:51:29.977Z
updated: 2026-09-29T23:44:04.732Z
author: HeiroGlyphics
---
- Repo is public, and GitHub Pages is live at burntsteam.github.io/word-unlocked. The privacy and support URLs are recorded in marketing/app-store-listing.md.
- The published contact address is privacy@rippre.com: the app's privacy policy, docs/*.html and the listing. The owner confirmed it on 2026-09-12. Only commit metadata uses help@rippre.com, since the 2026-09-14 history rewrite. (This engram used to say help@rippre.com was used everywhere; corrected 2026-09-28.)
- 6.9-inch screenshots are committed at marketing/screenshots/6.9 (retaken 2026-09-28 for the five-tab layout, on a dedicated "WordUnlocked Shots" iPhone 17 Pro Max simulator).
- ESV was enabled 2026-09-12. The key lives only in the gitignored Config/Secrets.xcconfig; the repo is public, so never commit it.

2026-09-14 history rewrite: the owner asked for commit metadata to use help@rippre.com.
- All 37 commits were rewritten with git filter-branch: author and committer email, plus the old address inside HANDOFF.md and docs/*.html blobs. The result was force-pushed. Trees and messages were verified identical apart from that address, and two remapped short SHAs in one message.
- The repo-local user.email is help@rippre.com.
- The pre-rewrite commits may stay fetchable on GitHub by SHA until GitHub garbage-collects them or Support purges them.

2026-09-14 licensing pass: ESV is stored up to Crossway's limit (500 verses, never more than half a book) and downloads at most once every 48 hours; the Recovery Version is never stored, because LSM's terms forbid it.

2026-09-22: GitHub secret scanning and push protection are ON, history backfill 0 alerts — but generic-pattern scanning needs Advanced Security, so GitHub cannot see the ESV key or the LSM token. See 01m35dg60qnxvecf4ftpqchqpz. The local leak scan is still the real guard and is written into HANDOFF.md.

2026-09-28: every finding of the 2026-09-27 audit (01m3hpvk) is fixed; 104 tests in 10 suites, Debug and Release 0 warnings on Xcode 27.0. HANDOFF.md's top section has the details.

Remaining user-only items (everything else is done):
- Xcode signing (0 identities, no DEVELOPMENT_TEAM) — blocks archiving
- App Store Connect record (all copy pre-written in marketing/app-store-listing.md)

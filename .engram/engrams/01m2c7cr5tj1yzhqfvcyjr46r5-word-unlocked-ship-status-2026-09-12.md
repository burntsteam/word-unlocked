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
updated: 2026-09-14T22:39:54.039Z
author: HeiroGlyphics
---
- Repo is public, and GitHub Pages is live at burntsteam.github.io/word-unlocked. The privacy and support URLs are recorded in marketing/app-store-listing.md.
- The contact email is privacy@rippre.com everywhere (the owner keeps that mailbox).
- 6.9-inch screenshots are committed at marketing/screenshots/6.9.
- ESV was enabled 2026-09-12. The key lives only in the gitignored Config/Secrets.xcconfig; the repo is public, so never commit it.

2026-09-14 history rewrite: the owner asked for commit metadata to use help@rippre.com.
- All 37 commits were rewritten with git filter-branch: author and committer email, plus the old address inside HANDOFF.md and docs/*.html blobs. The result was force-pushed. Trees and messages were verified identical apart from that address, and two remapped short SHAs in one message.
- The repo-local user.email is help@rippre.com.
- The pre-rewrite commits may stay fetchable on GitHub by SHA until GitHub garbage-collects them or Support purges them.

Remaining user-only items:
- Xcode signing (0 identities)
- App Store Connect record
- GitHub secret scanning and push protection

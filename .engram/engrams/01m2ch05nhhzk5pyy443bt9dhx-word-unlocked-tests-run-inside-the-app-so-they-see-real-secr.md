---
id: 01m2ch05nhhzk5pyy443bt9dhx
title: >-
  Word Unlocked tests run inside the app, so they see real Secrets.xcconfig
  values
type: decision
tags:
  - word-unlocked
  - testing
  - gotcha
  - esv
  - secrets
scope: project
created: 2026-09-13T04:39:23.568Z
updated: 2026-09-13T04:39:23.568Z
author: HeiroGlyphics
---
WordUnlockedTests has TEST_HOST=WordUnlocked.app, so Bundle.main in a unit test is the app bundle whose Info.plist carries ESV_API_KEY/LSM_TOKEN from the gitignored Config/Secrets.xcconfig. Tests that assumed 'no key' broke the moment the ESV key was added (2026-09-12) and would have made live api.esv.org calls that persist into the widget's App Group cache. Decision: ESVBibleService takes its key via init(apiKey:) (shared reads Info.plist; static isConfigured delegates to shared) and tests build keyless instances. Never assert on the bundle's secrets in tests; the repo is public and contributors build without keys.

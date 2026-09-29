---
id: 01m2ch05nhhzk5pyy443bt9dhx
title: Word Unlocked tests run inside the app, so they see the real API keys
type: decision
tags:
  - word-unlocked
  - testing
  - gotcha
  - esv
  - secrets
scope: project
created: 2026-09-13T04:39:23.568Z
updated: 2026-09-28T07:25:55.608Z
author: HeiroGlyphics
---
WordUnlockedTests has TEST_HOST=WordUnlocked.app, so a unit test runs in the app module and can reach the real keys. Since 2026-09-28 the keys are no longer in Info.plist: the "Embed API Keys" build phase writes them from the gitignored Config/Secrets.xcconfig into a generated, masked LiveAPIKeys.swift, which the live tests read (LiveAPIKeys.esvAPIKey, .lsmAppID, .lsmToken).

Tests that assumed "no key" broke the moment the ESV key was added (2026-09-12) and would have made live api.esv.org calls that persist into the widget's App Group store. Decision: ESVBibleService and RVBibleService take their keys through init (shared reads LiveAPIKeys; static isConfigured delegates to shared), and tests build their own instances with test credentials and StubURLProtocol. Never assert on the real keys in tests; the repo is public and contributors build without keys, which leaves them empty and the live translations hidden.

---
id: 01m3hpvk1ewvqp04knc583vftr
title: >-
  Word Unlocked audit 2026-09-27: all 43 findings fixed 2026-09-28; URLCache
  stored RV text
type: issue
tags:
  - word-unlocked
  - audit
  - url-cache
  - recovery-version
  - esv
  - licensing
  - ux
  - gotcha
  - testing
scope: project
created: 2026-09-27T15:13:38.861Z
updated: 2026-09-28T07:25:55.871Z
author: HeiroGlyphics
---
Full code + live UI/UX audit on 2026-09-27 (report: https://claude.ai/artifact/LpkyYd96PZpsEx3W6AAuwo, private to the owner): 7 high, 14 medium, 22 low. All fixed on 2026-09-28; HANDOFF.md's top section lists what changed.

Gotcha worth keeping: URLSession.shared's URLCache writes responses to Library/Caches/com.rippre.wordunlocked/Cache.db. Before the fix that stored Recovery Version text (LSM forbids it), every 300-verse ESV download under a new URL (can exceed Crossway's 500-verse cap over time), and the ESV key inside the cached request. Both live services now use LiveAPISession.shared (ephemeral, urlCache = nil), and the app clears URLCache.shared at launch. Verified 2026-09-28 after a live RV request: Cache.db had 0 rows and nothing under Library mentioned either API.

The owner decision the audit raised is settled: the contact address is privacy@rippre.com (see 01m2c7cr).

Testing technique: the simulator panel needs a one-time device-access approval before taps work. Without it, a throwaway XcodeGen UI-test bundle in the scratchpad can drive the installed app through XCUIApplication(bundleIdentifier: "com.rippre.wordunlocked"), with no change to the repo. Onboarding's ScrollViews ignore fast swipes, so use press(forDuration:thenDragTo:withVelocity: .slow). With .searchable, Search's keyboard covers the tab bar: tap the "Close" button before switching tabs. Home Screen widgets land on the page that was long-pressed, and pressing Home returns to a different page, so swipe to find them. widgetURL reaches onOpenURL with no URL scheme registered.

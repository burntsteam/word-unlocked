---
id: 01m2cjfn7zpp4xncetkcgg970e
title: >-
  Word Unlocked pbxproj is hand-maintained: files on disk are not bundled until
  wired into a build phase
type: issue
tags:
  - word-unlocked
  - xcode
  - pbxproj
  - privacy-manifest
  - app-store
  - gotcha
scope: project
created: 2026-09-13T05:05:19.614Z
updated: 2026-09-13T05:05:19.614Z
author: HeiroGlyphics
---
The project uses classic groups with synthetic object IDs (no file-system synchronized groups), so a file on disk is not part of a target until it has a PBXFileReference, a group child, a PBXBuildFile and a Sources/Resources phase entry. PrivacyInfo.xcprivacy sat on disk for both the app and the widget but was never bundled; found 2026-09-12 by inspecting the Release .app, and it would have blocked the App Store Connect upload. After adding any resource, verify the built bundle: PrivacyInfo.xcprivacy must exist in WordUnlocked.app and in PlugIns/WordUnlockedWidget.appex. The App Group UserDefaults suite needs required-reason 1C8F.1, not only CA92.1.

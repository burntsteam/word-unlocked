---
id: 01m2cnabcsr0nn7v89971zqpgx
title: "Word Unlocked verse selection: one database-backed selector for app and widget"
type: decision
tags:
  - word-unlocked
  - widget
  - verse-selection
  - sqlite
  - memory
  - hardening
scope: project
created: 2026-09-13T05:54:51.416Z
updated: 2026-09-13T05:54:51.416Z
author: HeiroGlyphics
---
Decided 2026-09-12 during the pre-release hardening pass. VerseSelectionService is compiled into both the app and the widget extension and is the only place a verse is chosen; WidgetTimelineService only builds entries. Daily selection runs in SQL (COUNT then LIMIT 1 OFFSET) because loading a translation costs ~22MB and the extension budget is ~30MB: never reintroduce an allVerses-style load. topic_verses stores KJV verse ids, so other translations join on book/chapter/verse. Topic and Weekly Theme lists come from the topics table (the old hard-coded lists had 10 topics with no verses and hid anxiety/fear/grief). Weekly Theme shows the topic's first seven verses, one per day of the week, matching its 7-day preview. ESV and RV rotate through the KJV reference set (referenceTranslationCode). Exclude Long filters before picking. Widget entries after the first start at midnight; accessory widget views need containerBackground. Still saved but read by nothing (owner decision pending): topic/chapter/favorites rotation speed, chapter end behaviour, daily update interval, weekly auto-repeat, favorites shuffle and favorites exclude-long.

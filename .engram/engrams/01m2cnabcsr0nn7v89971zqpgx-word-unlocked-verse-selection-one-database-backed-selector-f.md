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
updated: 2026-09-13T07:58:05.942Z
author: HeiroGlyphics
---
Decided 2026-09-12 in the hardening pass; extended 2026-09-13 when the mode settings were implemented. VerseSelectionService is compiled into both the app and the widget extension and is the only place a verse is chosen; WidgetTimelineService only schedules entries at VerseSelectionService.slotStartDates. Daily selection runs in SQL (COUNT then LIMIT 1 OFFSET) because loading a translation costs ~22MB and the extension budget is ~30MB: never reintroduce an allVerses-style load. topic_verses stores KJV verse ids, so other translations join on book/chapter/verse, and the Topic and Weekly Theme lists come from the topics table. A rotation slot is a block of RotationInterval.hours counted from local midnight. Any mode setting saved straight to App Group defaults must be listed in modeSettingKeys, or Today's selectionStamp will not notice it change. Chapter mode is anchored at chapterStartDate and Weekly Theme at weeklyStartDate; only SettingsStore.startPlan writes them (mode, passage or theme change, or Start This Week). Chapter end: repeat, stop, or nextChapter (reads on via chapterVerseCounts; Revelation wraps to Genesis). Weekly auto-repeat off advances one topic, alphabetically, per week. Favorites shuffle is a SplitMix64 Fisher-Yates order per pass; favorites exclude-long filters favorites only. ESV and RV rotate through the KJV reference set. Accessory widget views need containerBackground.

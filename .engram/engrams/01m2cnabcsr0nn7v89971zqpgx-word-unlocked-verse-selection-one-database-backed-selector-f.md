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
updated: 2026-09-14T22:39:53.902Z
author: HeiroGlyphics
---
Decided 2026-09-12 in the hardening pass; extended 2026-09-13 (mode settings) and 2026-09-14 (Weekly Plan, planning ahead for live translations).

VerseSelectionService is compiled into both the app and the widget extension, and it is the only place a verse is chosen. WidgetTimelineService only schedules entries at VerseSelectionService.slotStartDates.

Selection over a large set runs in SQL (COUNT, then LIMIT 1 OFFSET, in filteredRecord). Loading a translation costs ~22MB and the extension budget is ~30MB, so never reintroduce an allVerses-style load.

Verse ids are NOT in reading order (John 3:16 is id 212). Anything that walks a chapter or book in order must pass inReadingOrder: true, which sorts by book_id, chapter, verse.

topic_verses stores KJV verse ids, so other translations join on book/chapter/verse. Topic lists come from the topics table.

A rotation slot is a block of RotationInterval.hours counted from local midnight. Any mode setting saved straight to App Group defaults must be listed in modeSettingKeys, or Today's selectionStamp will not notice it change.

Chapter mode is anchored at chapterStartDate. Weekly Plan is anchored at weeklyStartDate; its enum case and raw value are still weeklyTheme. Only SettingsStore.startPlan writes these two dates, and it reloads widget timelines.

Weekly Plan's source is a WeeklyPlan:
- theme: the shared topicSlug
- chapter or book: weeklyBookId / weeklyChapter
- your own list: weeklyCustomVerseIds

Day d of week w shows verse (autoRepeat ? d : 7w + d) mod count, so it either repeats its first seven verses or moves on seven a week and wraps. The old rule, "auto-repeat off moves to the next theme alphabetically", is gone.

Other modes:
- Chapter end: repeat, stop, or nextChapter (reads on via chapterVerseCounts; Revelation wraps to Genesis).
- Favorites shuffle is a SplitMix64 Fisher-Yates order per pass; favorites exclude-long filters favorites only.
- ESV and RV rotate through the KJV reference set. upcomingRecords lists the verses ahead that a live translation downloads.

Accessory widget views need containerBackground.

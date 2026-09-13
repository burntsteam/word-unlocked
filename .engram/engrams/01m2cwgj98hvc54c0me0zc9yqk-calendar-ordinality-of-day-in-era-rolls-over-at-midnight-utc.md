---
id: 01m2cwgj98hvc54c0me0zc9yqk
title: >-
  Calendar.ordinality(of: .day, in: .era) rolls over at midnight UTC, not local
  midnight
type: issue
tags:
  - swift
  - foundation
  - calendar
  - timezone
  - gotcha
  - word-unlocked
scope: project
created: 2026-09-13T08:00:35.111Z
updated: 2026-09-13T08:00:35.111Z
author: HeiroGlyphics
---
Verified 2026-09-13 on macOS and the iOS 26 simulator in America/Los_Angeles: the era day ordinal changes between 16:59 and 17:01 local time, i.e. at 00:00 UTC. Word Unlocked's daily verse had been changing at 5 PM because of it. ordinality(of: .day, in: .weekOfYear) and dateInterval(of: .weekOfYear, for:) are local-correct. To number local days, count days between local midnights: calendar.dateComponents([.day], from: calendar.startOfDay(for: epoch), to: calendar.startOfDay(for: date)).day (VerseSelectionService.dayNumber).

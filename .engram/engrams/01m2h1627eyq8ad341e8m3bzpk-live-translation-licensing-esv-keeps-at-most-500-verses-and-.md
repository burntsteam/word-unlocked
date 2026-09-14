---
id: 01m2h1627eyq8ad341e8m3bzpk
title: >-
  Live translation licensing: ESV keeps at most 500 verses and downloads every
  48h; RV is never stored
type: decision
tags:
  - word-unlocked
  - esv
  - recovery-version
  - licensing
  - api
  - rate-limit
  - widget
  - gotcha
scope: project
created: 2026-09-14T22:39:11.597Z
updated: 2026-09-14T22:39:11.597Z
author: HeiroGlyphics
---
Checked 2026-09-14 against both providers' published terms.

Crossway (api.esv.org): users may not copy or download more than 500 ESV verses or more than half of any book, and an API key gets 5,000 requests a day (1,000 an hour, 60 a minute). Every install shares our key. So ESVBibleService keeps at most 500 verses on the device. ESVBibleService.Allowance counts ESV favorites first, and allows half of each book using KJV verse counts. The verses come from VerseSelectionService.upcomingRecords, which lists what the current settings show next. Each install downloads at most once per 48 hours (the owner's rule), in ONE request of at most 300 comma-separated BBCCCVVV ids. The API rejects a request line over 4,094 bytes: 480 ids failed with a 400. The last-download time is recorded when a response arrives, or when the request may have reached the server. It is not recorded for failures before sending (offline), so being offline doesn't start the wait.

ESV API quirks:
- Ids separated by ';' return nothing; use ','.
- A verse the ESV omits (Matt 17:21) comes back widened to 17:20-22, and is skipped.
- Psalm titles and acrostic letters come before the '[n]' verse marker. Verse numbers stay on, and text before the first marker is dropped.

LSM (api.lsm.org Terms of Use):
- "you may not store any amount of the text of the Holy Bible Recovery Version for offline use."
- The response's copyright attribution must be shown with the verse.
- No public statement may imply a relationship beyond using the API, so RV copy never says "used by permission".

RVBibleService therefore holds verses in memory only, and the widget, wallpapers and RV favorites use KJV. LSM allows at most 50 verses per request.

The 48-hour rule deliberately applies only to ESV, where the concern is the shared key. RV has to fetch whenever it is shown, because it cannot be stored.

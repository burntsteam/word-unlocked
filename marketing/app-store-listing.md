# Word Unlocked — App Store Listing

> **Copy below describes the app as it currently builds: SEVEN translations.**
> `ESV_API_KEY` is set in `Config/Secrets.xcconfig` (verified live against api.esv.org on
> 2026-09-12). If the key is ever removed, `ESVBibleService.isConfigured` hides ESV at
> runtime: switch every "Seven" to "Six", drop the ESV bullet under **Live** and its
> caching sentence, and use the no-`esv` keyword string in the Keywords section.
> Shipping copy that advertises ESV while the app hides it is a metadata mismatch and a
> rejection risk.

**URLs for App Store Connect** (Pages live as of 2026-09-12):
- Privacy Policy URL: `https://burntsteam.github.io/word-unlocked/privacy.html`
- Support URL: `https://burntsteam.github.io/word-unlocked/support.html`
- Screenshots (6.9", 1320×2868): `marketing/screenshots/6.9/`

Copy blocks below map to fields in App Store Connect. Character limits are noted
so nothing gets truncated. Everything here reflects the app as built:
5 full **offline** Bibles (KJV, WEB, BSB, ASV, LSV) plus 2 live translations fetched on demand —
ESV (Crossway) and the Recovery Version (Living Stream Ministry), a Lock Screen widget, verse modes, topics, memorization, favorites, themes, and Set as
Wallpaper — no account, no tracking, core experience works completely offline.

---

## App Name  (max 30 chars)
`Word Unlocked: Bible Widget`  *(27)*

**Alternates**
- `Word Unlocked — Bible Verses` *(28)*
- `Word Unlocked: Verse Widget` *(27)*

## Subtitle  (max 30 chars)
`Scripture on your Lock Screen`  *(29)*

**Alternates**
- `Daily Bible verses, offline` *(27)*
- `Bible verses, private & free` *(28)*

## Promotional Text  (max 170 chars — editable anytime, no review)
`Keep a verse in front of you all day. Put Scripture on your Lock Screen, read KJV or WEB completely offline, or choose from 7 translations — no account needed.` *(159)*

---

## Description  (max 4000 chars)

Put God's Word where you'll actually see it — right on your Lock Screen.

Word Unlocked turns the screen you check a hundred times a day into a quiet
moment with Scripture. Add the widget, choose how your verses rotate, and let a
word of hope, peace, or strength meet you every time you pick up your phone.

No account. No sign-up. No internet required. Just Scripture.

WHY YOU'LL LOVE IT
• Lock Screen & Home Screen widgets — a verse you see without opening anything
• A fresh verse every day, or rotate by topic, weekly plan, or chapter
• Seven translations — five completely offline, two live
• KJV and WEB are built in and work 100% offline, no signal needed
• Private by design — no accounts, no tracking, no ads

CHOOSE YOUR TRANSLATION
Read in the voice that fits you, and switch anytime:

**Fully Offline (no internet needed)**
• King James Version (KJV) — 31,102 verses
• World English Bible (WEB) — 31,095 verses
• Berean Standard Bible (BSB) — 31,086 verses, clear and modern
• American Standard Version (ASV) — 31,086 verses
• Literal Standard Version (LSV) — 31,104 verses, word-for-word

**Live (from the web when you choose)**
• English Standard Version (ESV) — © Crossway, used by permission
• Recovery Version (RV) — © Living Stream Ministry
ESV keeps up to 500 of the verses you'll see next on your phone, so the widget works
offline. The Recovery Version loads while you read and isn't stored on your phone.

VERSES THAT MEET THE MOMENT
Pick the rhythm that fits your walk:
• Daily Verse — a new passage each day
• Topics — go straight to anxiety, fear, strength, faith, hope, peace,
  forgiveness, grief, patience, gratitude, and more
• Weekly Plan — seven verses a week from a theme, chapter, book, or your own list
• Chapter — walk through a book, verse by verse
• Memorization — focus on the verses you're committing to heart
• Favorites — save the ones that stay with you

MAKE IT YOURS
• Clean, readable themes that look right on any wallpaper
• Set as Wallpaper — turn a verse into a Lock Screen background that stays clear
  of the clock
• Long verses are handled gracefully, so text never spills off the widget

PRIVATE AND OFFLINE, THE WAY IT SHOULD BE
Your reading is yours. Word Unlocked doesn't ask you to make an account, doesn't
track you, and doesn't need a connection to show you Scripture. Everything you
need is already on your phone.

Add the widget today and keep a verse in front of you — wherever the day takes
you.

— Public domain and openly licensed translations included. LSV © Covenant Press
(CC BY-SA). ESV text © Crossway and Recovery Version text © Living Stream
Ministry, both used by permission.

---

## Keywords  (max 100 chars, comma-separated, no spaces after commas)
`verse,daily,devotional,christian,kjv,esv,offline,faith,prayer,jesus,god,psalm,gospel,study`
*(90 chars — measured, under the 100 limit)*

The previous string was **102 chars and would have been rejected**. "bible", "widget",
"lock screen" and "scripture" were dropped because Apple already indexes the app name
and subtitle — repeating them there wasted budget rather than adding reach.

**If ESV ships without an API key, use this instead** (drops the `esv` term so the
metadata does not advertise a dead translation):
`verse,daily,devotional,christian,kjv,offline,faith,prayer,jesus,god,psalm,gospel,study,hope` *(91 chars)*

---

## What's New  (release notes)

**Version 1.0**
Welcome to Word Unlocked! Keep Scripture on your Lock Screen, all day.
• Lock Screen and Home Screen widgets
• Seven translations: five fully offline (KJV, WEB, BSB, ASV, LSV) plus ESV and the
  Recovery Version via live fetch
• Rotate verses by day, topic, weekly plan, or chapter
• Memorization mode and Favorites
• Set as Wallpaper
• No account, no tracking — KJV and WEB work completely offline

---

## Screenshot Captions  (short lines to overlay on screenshots)
1. `Scripture on your Lock Screen`
2. `A new verse, every single day`
3. `Seven translations — KJV and WEB fully offline`
4. `Find a verse for how you feel`
5. `Read by topic, theme, or chapter`
6. `Set a verse as your wallpaper`
7. `No account. No tracking. Core experience offline.`

---

## Support / Notes for submission
- Primary category: Reference (secondary: Lifestyle)
- Age rating: 4+
- Contains no user accounts, no data collection → App Privacy: "Data Not Collected"
- The five offline translations (KJV, WEB, BSB, ASV, LSV) are always available.
- ESV (api.esv.org, Crossway) and the Recovery Version (api.lsm.org, Living
  Stream Ministry) require API keys in Config/Secrets.xcconfig. If either is not
  enabled at launch, remove it from the translation lists above and update counts
  accordingly ("Seven" → "Six"/"Five", etc.). The app falls back gracefully when
  a live translation's key is missing.
- AS OF 2026-09-12: `LSM_APP_ID`, `LSM_TOKEN` and `ESV_API_KEY` are all set; the ESV
  key was verified with a live request to api.esv.org. All seven translations ship.
- Licensing limits the app enforces (verified against both providers' terms 2026-09-14):
  ESV keeps at most 500 verses on a device and never more than half of any book, and each
  install downloads at most once every 48 hours (the key allows 5,000 requests a day).
  LSM forbids storing any Recovery Version text, so RV is held in memory while reading,
  shows LSM's attribution beside the verse, and the widget and wallpapers use KJV.

**Future additions (not in v1.0):**
- NIV, NKJV, NLT: These require per-publisher approval on the YouVersion Platform
  dashboard (Thomas Nelson/HarperCollins controls NIV/NKJV, Tyndale controls NLT).
  Request enablement once your app is live, then wire as live translations.

---
id: 01m35dg60qnxvecf4ftpqchqpz
title: >-
  word-unlocked: GitHub secret scanning is on, but it cannot see this repo's two
  secrets (2026-09-22)
type: decision
tags:
  - github
  - secret-scanning
  - push-protection
  - ghas
  - secrets
  - gotcha
scope: project
created: 2026-09-22T20:39:14.710Z
updated: 2026-09-22T20:39:14.710Z
author: HeiroGlyphics
---
Enabled on burntsteam/word-unlocked with
`gh api -X PATCH repos/burntsteam/word-unlocked` (secret_scanning +
secret_scanning_push_protection). The history backfill found 0 alerts.

The gotcha: `secret_scanning_non_provider_patterns` (generic patterns) and
`secret_scanning_validity_checks` cannot be turned on. The PATCH returns 200
and silently leaves both `disabled` — they need GitHub Advanced Security.
Neither the ESV API key nor the LSM token matches a known provider pattern,
so GitHub would not catch either one being committed. The local leak scan
(grep the pending diff and `git grep -F ... HEAD` for both values out of the
gitignored WordUnlocked/Config/Secrets.xcconfig) remains the only real guard
before a push.

Push protection does now block pushes carrying a recognised provider secret;
if it ever fires, rewrite the commit rather than taking the bypass.

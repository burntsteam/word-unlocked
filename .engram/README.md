# Project Engram

This directory holds **shared agent memory** for this project, managed by the
`engram` CLI ([engram](https://www.npmjs.com/package/engram)).

## Why this exists
Agents — local coding assistants (Pi, Claude Code, Cursor), code-review bots,
and CI — read these notes so the whole team shares the same context:
architectural decisions, gotchas, replaced packages, conventions, and "why did
we do X?" Because these are plain Markdown files committed to git, **every
teammate and every cloud session sees them automatically.**

Even without the `engram` CLI installed, any agent can read the files in
`engrams/` directly — that is by design.

## How agents use it
At the start of a session an agent runs:

    engram context

…to get a digest, and searches when it needs specifics:

    engram search "auth"

When an agent learns something durable, it records it:

    engram add --title "..." --type decision "the rationale..."

## File format
Each file in `engrams/` is Markdown with YAML frontmatter:

```markdown
---
id: "01jb3x1q2v7k9m4t8z0c2d5e6h"   # collision-resistant ULID; legacy stores use 0001-style
title: Replaced libfoo with libbar
type: decision        # decision | fact | preference | note | issue | context
tags: [deps, auth]
scope: project
created: 2025-01-15T10:30:00.000Z
updated: 2025-01-15T10:30:00.000Z
author: ""
pinned: true          # optional
---
<markdown body>
```

## Tracking
This project's memory is **tracked in git** — it is shared with the whole team and with cloud sessions. Commit changes to `.engram/` like any other code.

Edit by hand if you like — they are just files — but never invent an id:
`engram add` mints a globally-unique one (timestamp + randomness), so several
sessions, machines, or merged branches can record concurrently with only a
negligible chance of colliding on id. Ids sort lexicographically by creation
time (millisecond precision). If you ever do hit duplicates (hand-written or
legacy `0001`-style), `engram dedupe` repairs them.

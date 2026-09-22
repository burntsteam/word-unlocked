---
id: 01m35jdk86gaqfqqtdgr68mgxa
title: >-
  graphify descriptions: the local describer fills them, but query/explain don't
  print them (2026-09-22)
type: decision
tags:
  - graphify
  - descriptions
  - ollama
  - cli
  - gotcha
scope: project
created: 2026-09-22T22:05:12.837Z
updated: 2026-09-22T22:05:12.837Z
author: HeiroGlyphics
---
Word Unlocked sat at 0/734 nodes described with 19 unanswered
`.graphify/description-instructions/batch-*.md` files, because
`--description-mode assistant` only writes prompts and waits.

What works (~10 min for 734 nodes, no API cost):

    ollama serve
    OPENAI_BASE_URL=http://localhost:11434/v1 DESCRIBE_MODEL=qwen3.6:35b-a3b \
      python3 /Users/yg/Repositories/scripts/graphify-describe-nodes.py "<repo>"
    graphify update . --scope all --description-mode assistant --label-mode assistant
    then restore-descriptions, restore-labels, sync-report (sync last)

Result here: 730/734 described, sidecar 0 -> 730.

Two gotchas:
- graphify 0.17.1's `query` and `explain` do NOT print node descriptions, and
  neither has a flag for it. The text lives on graph.json nodes and in
  .graphify/node_descriptions.json, so it helps anything reading those files,
  not the CLI output. Don't promise a richer `query` after describing.
- Ingesting the answers re-clusters, which left 7 of 65 communities bare, so
  graphify-label-communities.py has to run again afterwards. Expect the
  describe -> update -> label -> sync order, not describe alone.

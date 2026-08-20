# Graph Report - .  (2026-08-20)

## Corpus Check
- label mode - file stats not available

## Summary
- 54 nodes · 100 edges · 7 communities detected
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output
- Edge kinds: calls: 45 · contains: 42 · MODIFIES: 7 · ON_BRANCH: 3 · PARENT_OF: 2 · rationale_for: 1


## Graph Freshness
- Built from Git commit: `606b9f4`
- Compare this hash to `git rev-parse HEAD` before trusting freshness-sensitive graph output.
## God Nodes (most connected - your core abstractions)
1. `derived()` - 6 edges
2. `derived()` - 6 edges
3. `derived()` - 6 edges
4. `derived()` - 6 edges
5. `derived()` - 6 edges
6. `words()` - 4 edges
7. `words()` - 4 edges
8. `main()` - 4 edges
9. `words()` - 4 edges
10. `words()` - 4 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Communities

### Community 0 - "LSV import pipeline"
Cohesion: 0.42
Nodes (9): clean_inline(), derived(), excerpt(), fetch(), fit_category(), main(), parse_usfm(), segments() (+1 more)

### Community 1 - "ASV import pipeline"
Cohesion: 0.54
Nodes (7): clean(), derived(), excerpt(), fit_category(), main(), segments(), words()

### Community 2 - "KJV import pipeline"
Cohesion: 0.54
Nodes (7): derived(), excerpt(), fetch_json(), fit_category(), main(), segments(), words()

### Community 3 - "Web seed fetcher"
Cohesion: 0.54
Nodes (7): clean(), derived(), excerpt(), fit_category(), main(), segments(), words()

### Community 4 - "iOS app build tools"
Cohesion: 0.43
Nodes (6): main, 1524b07 Update App Store listing: add RV as live translation, emphasize KJV/WEB offline, 606b9f4 Add future translation roadmap to submission notes, 676cef0 Initial commit: Word Unlocked — iOS scripture Lock Screen widget, load(), main()

### Community 5 - "BSB import pipeline"
Cohesion: 0.62
Nodes (6): derived(), excerpt(), fit_category(), main(), segments(), words()

### Community 6 - "ESV API fetcher"
Cohesion: 0.53
Nodes (5): fetch_text(), load_json(), main(), Return the ESV text for a single-verse reference, or raise on hard failure., resolve_api_key()

## Knowledge Gaps
- **1 isolated node(s):** `Return the ESV text for a single-verse reference, or raise on hard failure.`
  These have ≤1 connection - possible missing edges or undocumented components.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What connects `Return the ESV text for a single-verse reference, or raise on hard failure.` to the rest of the system?**
  _1 weakly-connected nodes found - possible documentation gaps or missing edges._
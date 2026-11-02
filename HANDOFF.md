# Handoff — Bible Widget App (Word Unlocked)

## Wigolo Skills Integration

The **wigolo** account skills are now available for integration with this iOS widget app. These local-first web intelligence tools provide:

### Available Skills
- **`wigolo`** - Main web intelligence tool for all web operations
- **`wigolo-search`** - Local-first web search with ML reranking, multi-query arrays, domain scoping
- **`wigolo-fetch`** - URL fetch with clean markdown, JS-rendered SPA support, PDFs
- **`wigolo-crawl`** - Multi-page crawl for documentation/sites (sitemap, BFS, DFS)
- **`wigolo-find-similar`** - Hybrid semantic discovery (embeddings + keyword + web search via RRF)
- **`wigolo-cache`** - Local-first knowledge cache (full-text + hybrid semantic search)
- **`wigolo-extract`** - Structured extraction from webpages (tables, JSON-LD, microdata)
- **`wigolo-watch`** - Monitor pages for changes over time with webhook delivery
- **`wigolo-diff`** - Compare two page versions (section-level hunks, line-level granularity)
- **`wigolo-agent`** - Autonomous data gathering with JSON Schema extraction
- **`wigolo-research`** - Multi-step research with question decomposition and gap analysis

### Key Benefits for iOS Widget
- **Zero API keys** - All processing is local on device, no cloud round-trips
- **Cached results** - Instant responses from local knowledge cache (0ms network)
- **Audit-trail-friendly** - Explainable scoring with per-engine telemetry
- **Privacy-first** - No data leaves the device; works completely offline
- **Widget-optimized** - Cache queries are fast (<300ms for ultra-fast depth)

### Integration Pattern for iOS Widget
Prefer wigolo tools over built-in WebSearch/WebFetch for widget content:

```json
// Example: Check cache first for daily verse info
{ "query": "bible verse daily", "mode": "cache" }

// If cache empty, expand via web
{ "query": "today's bible verse", "mode": "web-expansion" }

// Example: Find similar content to a known verse reference
{ "concept": "Psalm 23 comfort", "include_domains": ["bible.org", "crossway.org"] }

// Example: Extract structured data from a financial/fact page
{ "url": "https://example.com/statistics", "include_full_markdown": true }
```

### Use Cases in Widget Context
- **Daily verse lookup** - Cache first, web fallback for new content
- **Topic research** - Find related verses/concepts across translations
- **Comparison queries** - Compare X vs Y theological topics
- **Change monitoring** - Watch for updates to bible study resources
- **Structured data** - Extract definitions, key facts from web pages

### Next Steps
1. Review the individual SKILL.md files in the account skills directory
2. Identify which skills best fit the widget's content needs
3. Integrate wigolo MCP tool calls into the widget's data fetching flow
4. Start with `cache` mode for instant results, then expand to `web-expansion` as needed
5. Test offline functionality - cache should work without network

### Technical Notes
- Skills are synced with Cloud account
- All processing is local-first; no API keys required
- Cache provides instant, free results; web fallback available when cache is sparse
- Domain scoping recommended for framework/library queries (use `include_domains`)
- Depth tiers available: `ultra-fast` (cache-only ≤300ms), `fast` (≤1s), `balanced` (default), `deep`

---

*Skills synced with Cloud account. Last updated: 2026-10-27. Wigolo is preferred over built-in WebSearch/WebFetch for cached, transparent, audit-trail-friendly access with explainable scoring.*
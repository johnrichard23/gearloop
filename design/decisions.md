# UI/UX decisions

One entry per decision: what, why, and when. Newest first.

## 2026-10-01 — Teal palette replaces Ocean & Coral
- **Decision:** Brand palette is teal (`#1F6F63` primary) with a sage accent (`#6FA897`).
- **Why:** The earlier ocean-blue primary looked too close to a well-known social network's blue.
- **Consequences:** `app_colors.dart`, `CLAUDE.md` and `CONSTITUTION.md` were updated to the
  teal palette the same day; Figma and code now match. Price text styles use primary, and text on
  an accent fill uses `kColorOnAccent`.

## 2026-10-01 — Prices use primary, not accent
- **Decision:** Price text uses `color/primary`.
- **Why:** The sage accent is about 2.7:1 against white — below the 4.5:1 text minimum. A dark
  `color/on-accent` is provided for text placed on an accent fill.

## 2026-10-01 — Design system built in Figma before Flutter widgets
- **Decision:** Tokens and components are designed first (`Design System` page), then built in
  Flutter (Phase 0), then screens are designed and built phase by phase.
- **Why:** Gives each Flutter widget a spec and keeps screens consistent.

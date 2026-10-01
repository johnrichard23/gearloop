# UI/UX decisions

One entry per decision: what, why, and when. Newest first.

## 2026-10-01 — Inspiration, never imitation
- **Decision:** We study existing apps for patterns and principles, but never copy a layout,
  asset, copy or look. The rule is `CONSTITUTION.md` §14.
- **Why:** Rentra needs its own identity, and copying invites confusion and copyright risk.
- **Consequences:** Reference screens are not named in the repo; each influenced screen is checked
  against the "change it" test. The login redesign followed this: a minimal flat screen, but with
  Rentra's own headline treatment, pill fields and copy.

## 2026-10-01 — Earthy palette (forest green, cream, gold) replaces teal
- **Decision:** Brand palette is a deep forest green (`#2A5251`) on warm cream (`#F3EFEA`) with a
  gold accent (`#C8A26C`) and sand surfaces, taken from a reference the owner loved.
- **Why:** It reads warmer and calmer than cool teal, closer to the PRD's "borrowing from a trusted
  neighbor" feel (warmth, confidence, simplicity).
- **Consequences:** `app_colors.dart`, `CLAUDE.md`, `CONSTITUTION.md` and `design/tokens.md` were
  updated. The Figma variables are **not yet updated** (Figma tool limit) and still show teal.
  Gold fails as text and under white text (about 2.4:1), so text on gold uses `kColorOnAccent`.
  Success and warning were darkened to pass 4.5:1 on cream.

## 2026-10-01 — Teal palette replaces Ocean & Coral (superseded by the earthy palette above)
- **Decision:** Brand palette is teal (`#1F6F63` primary) with a sage accent (`#6FA897`).
- **Why:** The earlier ocean-blue primary looked too close to a well-known social network's blue.
- **Consequences:** `app_colors.dart`, `CLAUDE.md` and `CONSTITUTION.md` were updated to the
  teal palette the same day; Figma and code now match. Price text styles use primary, and text on
  an accent fill uses `kColorOnAccent`.

## 2026-10-01 — Prices use primary, not accent
- **Decision:** Price text uses `color/primary`.
- **Why:** The accent (sage then, gold now) is far below 4.5:1 for text against light surfaces — below the 4.5:1 text minimum. A dark
  `color/on-accent` is provided for text placed on an accent fill.

## 2026-10-01 — Design system built in Figma before Flutter widgets
- **Decision:** Tokens and components are designed first (`Design System` page), then built in
  Flutter (Phase 0), then screens are designed and built phase by phase.
- **Why:** Gives each Flutter widget a spec and keeps screens consistent.

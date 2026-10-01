# Rentra — Design (UI/UX)

Specs and decisions behind the Rentra interface. This folder is documentation only: nothing
here is compiled, and nothing under `lib/` depends on it.

**Figma file:** "Rentra — UI/UX Prototype" (ask the owner for access). Pages: `Rentra Screens`
(screen frames) and `Design System` (tokens and components).

## How the pieces fit

| Source | Role |
|---|---|
| `PRD.md` → *Screen Inventory & Design Tracker* | The checklist: every screen, its phase, and whether it is designed / built |
| `CONSTITUTION.md` §13 | The UI/UX rules every screen must follow |
| `design/tokens.md` | Figma token ↔ Dart constant mapping |
| `design/components.md` | Figma component ↔ Flutter widget mapping |
| `design/screens/` | Per-screen specs, one file per development phase |
| `design/flows/` | End-to-end user flows (booking, payment, cancellation) |
| `design/decisions.md` | UI/UX decisions and the reason behind each |

## Workflow

1. Design the screen in Figma using only Design System components and variables.
2. Write or update its spec in `design/screens/` (frames, states, widgets used, data, edge cases).
3. Mark **Figma** ✅ in the PRD tracker.
4. Build it in Flutter with `AppColors`, `AppTextStyles`, `AppSpacing` and the shared widgets.
5. Mark **Code** ✅ in the PRD tracker.

Work proceeds phase by phase (0 UI foundation → 4 compliance and polish); see the PRD tracker.

## Screen spec template

Copy this into `design/screens/phase-N-*.md` for each screen:

```
### <#> <Screen name>
- **Figma frame:** <page / frame name>
- **Phase:** <0–4>
- **Purpose:** one sentence
- **States:** loading · content · empty · error · offline (+ any per-status variants)
- **Components used:** <shared widgets>
- **Data:** <entity / repository / provider>
- **Primary action:** <the one Accent/Primary CTA>
- **Edge cases:** <collisions, permissions, failures>
- **Copy:** <key strings; all live in AppStrings>

# Design tokens — Figma ↔ Dart

Source of truth for look and feel is the Figma `Design System` page. Dart constants live in
`lib/core/constants/`. Naming: Figma `color/primary` ↔ Dart `AppColors.kColorPrimary`.

> **Palette status:** `app_colors.dart` was moved to the teal palette below on 2026-10-01. Names
> and hex values match Figma.

## Colors (collection: Rentra Colors)

| Figma variable | Hex | Dart constant | Use |
|---|---|---|---|
| `color/primary` | `#1F6F63` | `kColorPrimary` | Brand, primary buttons, links, prices |
| `color/primary-light` | `#2A8576` | `kColorPrimaryLight` | Active/hover, info badge |
| `color/primary-faded` | `#E4F1EE` | `kColorPrimaryFaded` | Tinted backgrounds, chips, info banner |
| `color/accent` | `#6FA897` | `kColorAccent` | Highlights (not for text on white) |
| `color/accent-light` | `#E8F3EF` | `kColorAccentLight` | Accent-tinted backgrounds |
| `color/background` | `#F7FAF9` | `kColorBackground` | App background |
| `color/surface` | `#FFFFFF` | `kColorSurface` | Cards, sheets |
| `color/surface-variant` | `#F1F5F4` | `kColorSurfaceVariant` | Secondary surfaces, disabled fields |
| `color/text` | `#1A1A2E` | `kColorTextPrimary` | Headings, body emphasis |
| `color/text-muted` | `#6B7280` | `kColorTextSecondary` | Descriptions, metadata |
| `color/text-hint` | `#9CA3AF` | `kColorTextHint` | Placeholders, disabled text |
| `color/success` / `-light` | `#16A34A` / `#DCFCE7` | `kColorSuccess` / `kColorSuccessLight` | Completed, verified |
| `color/warning` / `-light` | `#D97706` / `#FEF3C7` | `kColorWarning` / `kColorWarningLight` | Pending, deposit |
| `color/error` / `-light` | `#C0392B` / `#FDECEA` | `kColorError` / `kColorErrorLight` | Failure, destructive |
| `color/border` | `#E5E7EB` | `kColorBorder` | Default borders |
| `color/border-strong` | `#D1D5DB` | `kColorBorderDark` | Emphasized borders, disabled outline |

**On-colors and aliases** (`kColorOnPrimary` and `kColorOnAccent` are in `AppColors`; the two aliases are added with the Toast and Skeleton widgets):

| Figma variable | Value | Use |
|---|---|---|
| `color/on-primary` | `#FFFFFF` | Text/icons on primary, error, toast |
| `color/on-accent` | `#0B2F29` | Text on accent fill (white fails contrast, ~2.7:1) |
| `color/inverse-surface` | alias of `color/text` | Toast background |
| `color/skeleton` | alias of `color/border` | Skeleton placeholder fill |

## Spacing (collection: Rentra Spacing)

`spacing/2, 4, 8, 12, 16, 20, 24, 32, 40, 48, 64` ↔ `AppSpacing.kSpacing2 … kSpacing64`.

## Radius (collection: Rentra Radius)

| Figma | px | Dart |
|---|---|---|
| `radius/sm` | 6 | `kRadiusSmall` |
| `radius/md` | 10 | `kRadiusMedium` |
| `radius/lg` | 16 | `kRadiusLarge` |
| `radius/xl` | 24 | `kRadiusXLarge` |
| `radius/full` | 999 | `kRadiusCircular` |

## Typography (font: Inter)

| Figma text style | Spec | Dart style | Match |
|---|---|---|---|
| `Heading/H1` | Bold 28 | `kTextHeading1` | ✅ |
| `Heading/H2` | Semi Bold 22 | `kTextHeading2` | weight differs (code w700) |
| `Heading/H3` | Semi Bold 18 | `kTextHeading3` | ✅ |
| `Heading/H4` | Semi Bold 16 | `kTextHeading4` | ✅ |
| `Body/Regular` | Regular 15 | `kTextBodyLarge` (16) / `kTextBodyMedium` (14) | size differs — decide |
| `Body/Medium` | Medium 15 | — | add |
| `Caption` | Regular 13 | `kTextBodySmall` (12) / `kTextCaption` (11) | size differs — decide |
| `Label` | Medium 12, +0.5 tracking | `kTextLabel` | ✅ |
| `Button` | Semi Bold 15 | `kTextButton` | ✅ |
| `Price/Large` | Bold 20 | `kTextPrice` | ✅ (color: primary in Figma, accent in code) |
| `Price/Small` | Semi Bold 14 | `kTextPriceSmall` | ✅ (color: primary in Figma) |

Open mismatches (Body, Caption, Heading/H2 weight, price color) are resolved when the code palette
and type scale are updated; log the outcome in `decisions.md`.

## Effects

`Shadow/Elevated` — drop shadow, y 4, blur 16, `#1A1A2E` at 12%. Used on dialogs and sheets.

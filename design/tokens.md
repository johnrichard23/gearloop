# Design tokens — Figma ↔ Dart

Source of truth for look and feel is the Figma `Design System` page. Dart constants live in
`lib/core/constants/`. Naming: Figma `color/primary` ↔ Dart `AppColors.kColorPrimary`.

> **Palette status:** `app_colors.dart` uses the earthy palette below (forest green, cream, gold),
> adopted 2026-10-01. **The Figma `Rentra Colors` variables still hold the earlier teal values** and
> must be updated to match; names are unchanged.

## Colors (collection: Rentra Colors)

| Figma variable | Hex | Dart constant | Use |
|---|---|---|---|
| `color/primary` | `#2A5251` | `kColorPrimary` | Brand, primary buttons, links, prices |
| `color/primary-light` | `#3D6B68` | `kColorPrimaryLight` | Active/hover, info badge |
| `color/primary-faded` | `#E4E9E3` | `kColorPrimaryFaded` | Tinted backgrounds, chips, info banner |
| `color/accent` | `#C8A26C` | `kColorAccent` | Highlights, main-action fill (not for text) |
| `color/accent-light` | `#F3E9D8` | `kColorAccentLight` | Accent-tinted backgrounds |
| `color/background` | `#F3EFEA` | `kColorBackground` | App background |
| `color/surface` | `#FBF9F5` | `kColorSurface` | Cards, sheets |
| `color/surface-variant` | `#ECE5DA` | `kColorSurfaceVariant` | Secondary surfaces, disabled fields |
| `color/text` | `#1F2D2B` | `kColorTextPrimary` | Headings, body emphasis |
| `color/text-muted` | `#5E6A66` | `kColorTextSecondary` | Descriptions, metadata |
| `color/text-hint` | `#7C8680` | `kColorTextHint` | Placeholders, disabled text |
| `color/success` / `-light` | `#2E7A47` / `#E3F0E5` | `kColorSuccess` / `kColorSuccessLight` | Completed, verified |
| `color/warning` / `-light` | `#A65E0C` / `#F8E9CF` | `kColorWarning` / `kColorWarningLight` | Pending, deposit |
| `color/error` / `-light` | `#B54A3A` / `#F6E0DB` | `kColorError` / `kColorErrorLight` | Failure, destructive |
| `color/border` | `#E2DBCF` | `kColorBorder` | Default borders |
| `color/border-strong` | `#CFC6B8` | `kColorBorderDark` | Emphasized borders, disabled outline |

**On-colors and aliases** (`kColorOnPrimary` and `kColorOnAccent` are in `AppColors`; the two aliases are added with the Toast and Skeleton widgets):

| Figma variable | Value | Use |
|---|---|---|
| `color/on-primary` | `#FFFFFF` | Text/icons on primary, error, toast |
| `color/on-accent` | `#1E3A39` | Text on gold fill (white fails contrast, ~2.4:1) |
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

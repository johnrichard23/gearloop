---
name: rentra-ui-styleguide
description: Rentra's UI styleguide for Flutter. Use it whenever building, restyling or reviewing any Rentra UI element: buttons, text fields, chips, tabs, bottom navigation bars, settings and list screens, alerts and banners, cards, sheets, dialogs, icons, spacing, radius, elevation, shadows, typography, color proportions or layout composition, including their states (default, pressed, disabled, focus, selected, error, loading). Use it to pick the right token and component recipe so screens stay consistent, even if the user does not mention the styleguide.
---

# Rentra UI styleguide

This is how Rentra's tokens and components fit together, so any screen looks like the same product. The
values live in code; this skill tells you which token to reach for and how each component behaves.

**Sources of truth (read them, do not copy values into your head):**
- Colors: `lib/core/constants/app_colors.dart` (`AppColors.kColor…`)
- Spacing, radius, icon sizes: `lib/core/constants/app_spacing.dart` (`AppSpacing.kSpacing…`, `kRadius…`, `kIcon…`)
- Type: `lib/core/constants/app_text_styles.dart` (`AppTextStyles.kText…`)
- Shared widgets: `lib/core/widgets/` and `design/components.md`; token rationale in `design/tokens.md`

Hardcoded hex values, font sizes and spacing numbers are not allowed (`CONSTITUTION.md` §3, §13). If a
token you need does not exist, say so and propose it; changing shared tokens needs a spec.

## Tokens by role

**Color roles** (pick by meaning, not by look):
- Brand and primary action: `kColorPrimary`; pressed or active: `kColorPrimaryLight`; tinted background
  (chips, info): `kColorPrimaryFaded`.
- Gold accent: `kColorAccent`, for fills and icons only (the Post button, highlights), never for text on
  cream. Text on gold is `kColorOnAccent`; text on primary is `kColorOnPrimary`.
- Surfaces: page `kColorBackground`; cards and sheets `kColorSurface`; secondary surfaces and disabled
  fields `kColorSurfaceVariant`.
- Text: `kColorTextPrimary`, `kColorTextSecondary`, `kColorTextHint` (placeholder and disabled).
- Status: success, warning, error each have a strong color and a `…Light` background.
- Borders: `kColorBorder` by default, `kColorBorderDark` for emphasis and disabled outlines.
- One accent hue, one grey family. Do not add colors to a screen to make it "pop".

**Spacing** (only these steps): 2, 4, 8, 12, 16, 20, 24, 32, 40, 48, 64. Typical use: 4 icon-to-label,
8 compact, 12 chip padding and small insets, 16 default screen and card padding, 20 within a screen, 24
between stacked sections, 32 large breaks, 48 sheets and modals, 64 page breathing room.

**Radius:** small 6 (tags), medium 10 (inputs, buttons), large 16 (cards, sheets, thumbnails), x-large 24
(modals, featured cards), circular (pills, avatars, round buttons). One radius family per screen:
pill-shaped screens (auth, Home, Browse controls) use pills throughout.

**Type roles:** `kTextDisplay` onboarding and launch only; `kTextHeading1` screen titles;
`kTextHeading2` section headers; `kTextHeading3` card and modal titles; `kTextHeading4` subsections;
`kTextBodyLarge`/`Medium`/`Small` for text; `kTextLabel` form labels and chips; `kTextCaption`
footnotes; `kTextButton` buttons; `kTextPrice`/`kTextPriceSmall` prices (primary color). Use one display
size per screen and never `TextStyle(fontSize: …)` in a screen.

**Elevation:** Rentra mostly uses a tonal surface plus a `kColorBorder` outline, not shadows. Three
levels: flat (outline only, cards in lists), raised (floating controls such as the tab bar: blur about
24, y 8, text-color at 10%), overlay (sheets, dialogs: blur about 16, y 4, text-color at 12%). There are
no elevation tokens in code yet; shadows are written inline in a few widgets. When you need one, reuse
those numbers and flag it so an `AppElevation` token can be added later.

## Component recipes and states

Always cover: default, pressed, disabled, focus (where it applies), selected, error, loading, empty.

- **Button.** Use `AppButton`. Primary is filled `kColorPrimary` with `kColorOnPrimary` text; secondary
  is `isOutlined`; tertiary is a plain `TextButton` in primary color. Pressed uses `kColorPrimaryLight`;
  disabled uses `isEnabled: false` (dimmed, no tap); loading uses `isLoading`. One primary button per
  screen. Height at least 48. The gold button is for the single main action (Post) only.
- **Text field.** Label above in `kTextLabel`; fill `kColorSurface`; border `kColorBorder`; focused
  border `kColorPrimary` (this is the focus ring); error border `kColorError` with the message below in
  error color; hint in `kColorTextHint`. Reuse `AuthPillField` (pill) or `AppTextField`.
- **Chips.** Selected or active: `kColorPrimary` fill, `kColorOnPrimary` text, a close icon when it can be
  cleared (`ActiveFilterChip`). Unselected choice: `kColorSurface` fill with `kColorBorderDark` outline
  (`CategoryChoiceChip`). Status chips use the status `…Light` fill with the status color text (Pending is
  warning, Confirmed is success, Cancelled is error). Tags use `kColorPrimaryFaded`. Padding 12 and 8,
  circular radius.
- **Tabs.** Text tabs with a 2px underline on the selected one: selected text in `kColorPrimary` bold,
  others in `kColorTextSecondary`. No filled boxes. Keep to three or four tabs.
- **Alerts and banners.** Success, warning and error: status `…Light` background, a 1px border of the
  status color at about 30%, a leading icon, short message. Info: `kColorPrimaryFaded` with a primary
  icon (there is no separate info color, and do not add one without a spec). Toasts follow
  `design/tokens.md`.
- **Cards.** `kColorSurface`, radius 16, 1px `kColorBorder`, padding 16. Image on top with the card's top
  radius, title in `kTextHeading3` or `Heading4`, at most one primary action. See `ListingCard`.
- **Sheets and dialogs.** Large top radius, drag handle on bottom sheets, overlay elevation, one clear
  primary action. A crowded sheet becomes its own screen (`CONSTITUTION.md` §16.2).
- **Lists and empty or error states.** Use `EmptyStateWidget`, `ErrorStateWidget` and `LoadingSkeleton`
  so every screen has loading, empty and error handled.
- **Icons.** Sizes 16, 20, 24 or 32 from `AppSpacing`; one family per screen; icon-only buttons need a
  semantic label.

## More detail, loaded when needed
- `references/navigation-and-lists.md`: bottom navigation sizing, and the grouped settings or list
  pattern (profile and settings screens).
- `references/typography-and-composition.md`: good versus bad type hierarchy, the 60-30-10 color split,
  negative space, grid, focal point and rhythm.
Read the matching file whenever you build a bottom bar, a settings or profile list, or when a screen's
text sizes or overall balance feel off.

## Before you hand over UI
- [ ] No raw colors, font sizes or spacing numbers; everything from tokens.
- [ ] Spacing and radius come from the scales; one radius family per screen.
- [ ] Text uses `AppTextStyles`; one display size.
- [ ] Interactive targets at least 48dp; icon buttons labelled for screen readers.
- [ ] All states considered (default, pressed, disabled, focus, selected, error, loading, empty).
- [ ] Shared widgets reused or extended, not copied.
- [ ] One accent used with purpose; no decoration without a job.
- [ ] Derived from our own tokens, not copied from a reference (`CONSTITUTION.md` §14).

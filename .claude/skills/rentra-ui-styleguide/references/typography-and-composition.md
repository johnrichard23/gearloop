# Typography and composition

## Good versus bad type (from a typography comparison)
The "bad" card in the reference had: headline 26, sub-headline 11, body 12, buttons 18, and the primary
and secondary buttons shouted louder than the content. The "good" one had: headline 24, sub-headline 16,
body 14, buttons 16, both buttons equal. The lessons:

1. **Set a clear hierarchy.** Each level is visibly different from the next, in a sensible order:
   headline, then sub-headline, then body. A sub-headline must not be smaller than the body text under it.
2. **Balance button text.** Primary and secondary buttons use the same size (`kTextButton`, 15). A button
   label is never larger than the headline and never the loudest text on the card.
3. **Keep it readable.** Body text is at least 14 (`kTextBodyMedium`); anything the user must read
   (prices, dates, errors, labels they act on) is not 11 or 12. `kTextCaption` is for timestamps and
   fine print only. Text meets 4.5:1 contrast; `kColorTextHint` is for placeholders, not for content.
4. **Use consistent scaling.** Only the steps in `AppTextStyles`. No one-off sizes, and no more than one
   display-size heading on a screen.

Rentra's rough ladder: 22 (section or card headline), 16 (sub-headline or body large), 14 (body), 15
(buttons), 12 (labels, metadata), 11 (fine print).

## Color proportions: 60-30-10
- **60% neutral:** warm cream `kColorBackground` and `kColorSurface`. Most of any screen is calm space.
- **30% brand:** forest green `kColorPrimary` for headlines, buttons, active states, prices.
- **10% accent:** gold `kColorAccent` for the one main action and small highlights. If gold appears on
  more than a couple of things, it has stopped meaning anything.
Check a screen by squinting: mostly cream, some green, a touch of gold.

## Composition
- **Negative space is a feature.** Generous space around groups makes a screen feel calm and easier to
  scan. Do not fill space just because it is there.
- **Establish hierarchy with size, color and contrast,** in that order, before reaching for more
  elements. The most important thing on the screen is the largest or highest contrast.
- **One focal point per screen.** The eye should land on one thing first (the search, the price, the
  primary button).
- **Use a grid.** 16 side margins, content aligned to the same left edge, the spacing scale for every gap
  (an 8-point rhythm). Misalignment is the quickest way to look unfinished.
- **Create rhythm.** Repeat the same spacing between sibling items and sections so the eye can move down
  the page; vary it only to mark a new group (Proximity).
- **Be consistent.** The same element looks the same everywhere (identical cards, chips, buttons). Reuse
  the shared widgets.
- **Golden ratio and rule of thirds** are optional aids for hero images and illustrations, not for
  forms and lists.
- **Prefer a lean, flat look:** tonal surfaces and thin borders over heavy shadows or gradients.

## Design for mobile first
Rentra is a phone app first (the web dashboard comes later).
- One main column, one primary action, content reachable with a thumb; important controls in the lower
  half of the screen.
- Respect safe areas and the floating bottom bar (scrolling screens pad their end).
- Check a small phone (about 360 by 640) and text at 2x; layouts that break there get a vertical
  fallback, not a smaller font.
- When a screen is later shown on a wide web layout, center it in a narrow column and reuse the same
  tokens and copy (`PRD.md` web note).

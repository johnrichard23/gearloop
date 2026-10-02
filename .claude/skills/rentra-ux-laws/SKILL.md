---
name: rentra-ux-laws
description: Apply nine UX laws (Hick's, Fitts's, Jakob's, Miller's, Tesler's, Aesthetic-Usability, Peak-End, Doherty Threshold, Proximity) plus everyday usability rules when designing, building or reviewing any Rentra screen, flow, form, filter, list, empty or loading state, confirmation, or microcopy. Use it before building UI and whenever a screen feels cluttered, scattered, confusing, slow, or has too many options or poorly grouped content, even if the user never mentions UX laws.
---

# Rentra UX laws

These nine laws explain why a screen feels easy or hard. Use them as a quick design pass before you
build, and as a review pass after. They serve the rules already in `CONSTITUTION.md` (§13 UI/UX, §16.2
one job per screen): a screen has one job and as few elements as that job needs.

## How to use

1. **Design pass.** Before writing UI, say what the screen's one job is, then walk the laws below and
   note which ones apply. Most screens touch three or four, not all nine.
2. **Review pass.** For an existing screen, answer the "ask yourself" line for each law that applies.
3. **Report** only the laws that matter, in this shape:

| Law | Verdict | Fix |
|---|---|---|
| Hick's | Too many chips on Browse | Move categories into a filters sheet |

Say what you changed and why, in plain words. Skip laws that do not apply instead of padding the list.

## The nine laws

### 1. Hick's Law: more choices, longer decisions
People slow down as the number of options grows. Reduce and guide.
- One primary action per screen; secondary actions look quieter.
- Prefer a sheet or its own screen to a long row of chips or toggles (the category filter lives in a
  sheet, not ten visible chips).
- Reveal detail progressively: show the summary, tap for the rest.
- In a flow, ask one decision per step.
- *Ask yourself:* if I removed half of what is on this screen, would the job still get done?

### 2. Fitts's Law: bigger and closer is easier to hit
Time to reach a target depends on its size and distance.
- Tap targets are at least 48dp, with at least 8dp between neighbours.
- Put the primary action where the thumb rests (bottom bar, bottom sheet), not in a top corner.
- Keep destructive actions away from the primary one and ask to confirm.
- *Ask yourself:* can this be hit one-handed on a small phone without a mis-tap?

### 3. Jakob's Law: people expect your app to work like the others they use
Familiar patterns cost nothing to learn. Do not reinvent them.
- Use standard patterns: tab bar, bottom sheet, month calendar grid, heart to favourite, search field,
  back arrow top-left.
- Reuse our shared components (`AppButton`, `AuthPillField`, `EmptyStateWidget`, …) so the same thing
  looks and behaves the same everywhere in Rentra.
- Be original in look and voice (`CONSTITUTION.md` §14), conventional in behaviour.
- *Ask yourself:* would a first-time renter guess what this does without a label?

### 4. Miller's Law: working memory is small
People hold only a handful of items at once (the classic figure is about seven, plus or minus two; treat
it as "keep it small", not a hard limit).
- Chunk: group related fields into one step; keep lists to a few groups.
- Do not make people remember something across screens: show the chosen dates on the next step.
- Keep labels short and parallel.
- *Ask yourself:* does the user have to remember anything from a previous screen to continue?

### 5. Tesler's Law: complexity never disappears, it moves
Every feature has a cost; the question is who pays it.
- Move work from the renter to the system: smart defaults (default city), derived values (the price
  breakdown), the server deciding availability, not the renter comparing dates.
- Hide advanced options behind a quiet entry point; never delete the complexity people need.
- Prefer one clear path over a screen of switches.
- *Ask yourself:* what is the user being asked to work out that the app could work out?

### 6. Aesthetic-Usability Effect: attractive feels easier and more trustworthy
Polish raises perceived usability and trust, which matters in a marketplace where strangers lend gear.
- Use tokens only (colors, spacing, radius, type); consistent spacing and alignment are visible polish.
- Show trust cues clearly: verified badge, ratings, host name.
- Beauty does not rescue a confusing flow. Fix the flow first, then polish.
- *Ask yourself:* does anything look off-grid, off-palette, or unfinished?

### 7. Peak-End Rule: people remember the high point and the ending
The most intense moment and the last moment shape the memory of the whole experience.
- Find the peak (spotting the right gear, the host saying yes) and the end (request sent, booking
  accepted, gear returned). Make those screens warm, specific and clear about what happens next.
- Never end a flow on a bare error. Pair every failure with a way forward ("These days were just taken.
  Pick other days").
- Confirmations say what happened, to whom, and what to expect, in Rentra's neighbour-to-neighbour voice.
- *Ask yourself:* how will the user feel in the last five seconds of this flow?

### 8. Doherty Threshold: respond within about 400ms
When the system answers in under roughly 400ms, people stay in flow; slower and attention drifts.
- Acknowledge every tap immediately (pressed state, spinner on the button).
- Show a skeleton within about 100ms for anything that loads; use optimistic updates where safe.
- Anything over about a second shows progress, not a frozen screen. Do heavy work (maps, big images)
  after the transition, as the listing detail map does.
- *Ask yourself:* is there a moment where the screen does nothing visible after a tap?

### 9. Law of Proximity: things placed close together are read as related
Space tells people what belongs together. Related items sit close; unrelated groups are clearly apart.
- Spacing inside a group is smaller than spacing between groups: use 4 to 12 inside a group and 24 to 32
  between groups (the `AppSpacing` scale), so the gaps themselves explain the structure.
- Put related content in one container: on a listing, the title, rating and price are one group; the
  dates are another; the host is another; the actions are another. Do not let a rating float away from
  the thing it rates.
- Group actions together with the primary above or beside the secondary, and keep a destructive action
  apart from them.
- Fix a "scattered" feeling with grouping and spacing before adding dividers, borders or color.
- *Ask yourself:* if I blur the screen, can I still see which items belong together?

## When laws conflict
- Hick (fewer options) can fight Tesler (hide complexity but keep it reachable): prefer the smaller screen
  and a clear way to the rest.
- Jakob (familiar) can fight Aesthetic-Usability (distinctive look): keep the behaviour familiar and put
  the personality in tokens, type and copy.
- If still unsure, choose the option with fewer elements on screen.

## Everyday usability rules
Smaller rules of thumb from a general UI-rules sheet. Use them alongside the laws.
- **Don't make people think.** Labels say what will happen; one obvious next step.
- **Be predictable.** The same action looks and behaves the same everywhere; no surprise modals.
- **Disclose progressively.** Show what is needed now, tuck the rest behind a clear entry point.
- **Give contextual hints at the moment of need,** short and dismissible (for example next to the
  deposit, not in a separate help page).
- **Reduce meaningfully.** Remove before you add; a feature that cannot justify its space leaves.
- **Design for empathy.** Ask what this renter or host is worried about (trust, cost, getting the gear
  back) and answer that on the screen.
- **Be inclusive.** Strong contrast, targets of 48dp or more, text that survives 2x scaling, never color
  alone to carry meaning.
Not adopted for now: gamification, social features and analytics-driven personalisation. Rentra is a
rental marketplace, not a social app (`PRD.md`), and the product is deliberately minimal.

## Test with real people
Laws and checklists get you most of the way; real renters finish the job. Test early and often, in small
rounds, before polishing.
- Five people from the target market (Sorsogon and Bicol renters and hosts) find most of the problems.
- Give a task, not a tour: "Find a camera for this weekend and send a request." Watch without explaining.
- Note where they hesitate, mis-tap, backtrack or ask what something means. Each of those is a screen to
  simplify, not a user to instruct.
- Fix the biggest problem, then test again. When analytics exist, watch drop-off points the same way.
- Treat a prototype or a build on a real phone as test material; it does not need to be finished.

## Where the laws came from
They are well-known design heuristics (Hick, Fitts, Jakob Nielsen, Miller, Tesler, Kahneman's peak-end
finding, Doherty, and the Gestalt principle of proximity). Treat them as prompts for judgement, not rules of nature, and confirm real behaviour
by watching real renters once the app has them.

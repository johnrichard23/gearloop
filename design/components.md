# Components — Figma ↔ Flutter

Figma components live on the `Design System` page. Rules: use shared widgets before raw controls;
extend a shared widget with a variant parameter instead of forking it (CONSTITUTION §13.2).

| Figma component | Variants | Flutter widget | Status |
|---|---|---|---|
| Button | Type: Primary · Secondary · Text · Destructive × State: Default · Loading · Disabled | `core/widgets/app_button.dart` (`AppButton`) | Exists; add Text and Destructive types |
| Text Field | State: Default · Focused · Error · Disabled | `core/widgets/app_text_field.dart` (`AppTextField`) | Exists; verify focused/error/disabled |
| Empty State | — | `core/widgets/empty_state_widget.dart` | Exists |
| Error State | Type: Error · Offline | `core/widgets/error_state_widget.dart` | Exists; add Offline type |
| Toast | Type: Success · Error · Info | — | To build (Phase 0) |
| Info Banner | Type: Info · Warning · Error · Success | — | To build (Phase 0) |
| Confirm Dialog | Type: Default · Destructive | — | To build (Phase 0) |
| Listing Card | — | `features/listings/presentation/widgets/listing_card.dart` | Exists; align to Figma |
| Skeleton Card | — | `core/widgets/loading_skeleton.dart` (`LoadingSkeleton`) | Exists as a block; add card shape + shimmer |

## Behavior notes

- **Button:** one Primary per screen. Loading and Disabled block re-taps (prevents double-submit
  on booking and payment actions). Destructive is for irreversible actions only.
- **Text Field:** persistent label above the field; error message sits directly under it;
  validate on blur/submit, not every keystroke.
- **Error State:** plain-language message plus Retry; Offline adds an "Open settings" shortcut.
  Never show raw exception text.
- **Toast:** auto-dismiss ~3 s; a new toast replaces the current one; dismissible by swipe or close.
- **Info Banner:** persistent inline context (deposit rules, cancellation terms), always paired
  with an icon glyph — never color alone.
- **Confirm Dialog:** only for choices or irreversible actions; the destructive option is never the
  default focus and the safe option is listed first.
- **Listing Card:** price in `color/primary`; photo loads through the shared image widget (to build).
- **Variant copy:** in Figma, the Offline, Destructive and non-default Text Field variants carry
  their own fixed text (their text is not wired to the shared component property).

## Not yet designed

Tab bar states, bottom-sheet header, shared remote-image widget, status badge, star rating, chat
bubble. Add rows here as they are designed.

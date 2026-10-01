# Rentra — Project Documentation
> Version 1.0 | July 2026
> Tracks current feature status and known gaps. Updated per the Documentation Maintenance
> Protocol in CONSTITUTION.md §12 after each feature or significant bug fix.

---

## Current Feature Status

| Feature | Status |
|---|---|
| Auth (login/register/forgot password) | UI scaffolded; email/social sign-in not fully wired to Supabase Auth |
| Browse / Discovery, Listing Detail, Create Listing | Live on Supabase |
| Bookings (request/detail/my-bookings) | Live on Supabase |
| Messaging/Chat | UI + data layer built; not yet Realtime-wired |
| Reviews | UI + domain built |
| Profile | UI built |
| Maps (Google Maps Flutter) | Merged — listing location display |
| Image upload (Supabase Storage) | Merged |
| Payments | UI-only stub; no PayMongo/Stripe integration |
| Notifications | Static UI only; no FCM push or Realtime feed |
| Next.js web dashboard | Not started |
| Sumsub ID verification | Deferred to Phase 2 |
| Supabase Edge Functions | Not present in repo |
| Admin panel | Deferred to Phase 2 |

---

## Known Gaps

### Known UI Issues

**Browse screen — List/Map segmented control unequal width on web:** The selected segment
takes up more horizontal space than the unselected segment, making the two halves appear
unequal. Root cause: Flutter's `SegmentedButton` adds a checkmark to the selected segment by
default, increasing its width. `showSelectedIcon: false` and `expandedInsets: EdgeInsets.zero`
were both applied but did not fully resolve the issue in the web renderer. Deferred to UI
polish phase — the toggle is functionally correct (switching between List and Map views works
properly), only the visual sizing is off.

---

*Last updated: July 2026 | Version 1.0*

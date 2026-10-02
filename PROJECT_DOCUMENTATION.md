# Rentra — Project Documentation
> Version 1.1 | October 2026
> Tracks current feature status and known gaps. Updated per the Documentation Maintenance
> Protocol in CONSTITUTION.md §12 after each feature or significant bug fix.

---

## Current Feature Status

| Feature | Status |
|---|---|
| Splash + onboarding | Built; onboarding shows on first launch only |
| Auth (log in / create account / reset password) | Flat minimal screens built (redesigned October 2026 against the UX laws and styleguide: 48dp tap targets, grouped spacing, three-field sign-up, "Check your email" done state on reset); email sign-in and sign-up use Supabase Auth; Apple/Google/Facebook show "not available yet" |
| Guest mode | Built; guests browse, and Post, Bookings and Profile prompt "Log in or sign up". Account-only routes redirect to Log in and return to the listing after sign-in |
| Session handling | Supabase session restored on launch; `isSignedInProvider` follows login and logout live; Log out signs out of Supabase |
| Bottom navigation | Real Liquid Glass tab bar on iOS 26+; Flutter-drawn floating pill on older iOS and Android; gold Post button in the centre |
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

- **Dates filter on Browse needs backend work.** The date range screen (`/dates`) and the filters
  sheet row are built, but the dates do not yet filter results. Doing so needs Supabase to return the
  days each listing is already booked for a date range (for example a function that lists booked days
  per listing). The calendar already has the hooks for it: `DayAvailability`, `onMonthChanged` and
  `isLoading`. A listing's minimum rental days is not enforced yet either; that belongs in the
  booking screen, which will reuse the same calendar.
- **Social sign-in:** Apple, Google and Facebook buttons return "not available yet"; the Google and
  Facebook glyphs are code-drawn approximations to replace with official assets.
- **Terms and Privacy links** on Create account are "coming soon" placeholders (needs `url_launcher`
  and real URLs).
- **Reset password** is UI only: no reset use case exists, so the "Check your email" state appears
  but no email is sent. Wire it to Supabase `resetPasswordForEmail` before launch.
- **Sign-up password rules:** the only check is non-empty; "Confirm password" was removed because
  the show/hide toggle covers it. Add a minimum length once the Supabase setting is confirmed.
- **Logo** is a temporary two-ring placeholder.
- **Figma** still has the old teal variables and "GearLoop" file title; update to the earthy palette
  when the file is writable.
- **Native tab bar (iOS 26+):** powered by the `cupertino_native_better` plugin. Unselected icons
  follow the system colour (not themeable), and the gold Post button is a Flutter overlay on the middle
  slot, so it is tuned by hand. iOS 17 and Android use the Flutter pill instead.
- **Listing detail map:** created after the page transition because the Maps SDK can stall the first
  time a map is built; not yet profiled on device.
- **After login the user lands on Home**, except when a guest was redirected from an account-only
  screen, which resumes the listing or screen they were on.
- **Signing:** the Apple team and bundle ID used for device builds are local Xcode settings and are
  not committed; `com.example.rentra` is still the placeholder bundle ID in the repo.

### Known UI Issues

**Browse screen — List/Map segmented control unequal width on web:** The selected segment
takes up more horizontal space than the unselected segment, making the two halves appear
unequal. Root cause: Flutter's `SegmentedButton` adds a checkmark to the selected segment by
default, increasing its width. `showSelectedIcon: false` and `expandedInsets: EdgeInsets.zero`
were both applied but did not fully resolve the issue in the web renderer. Deferred to UI
polish phase — the toggle is functionally correct (switching between List and Map views works
properly), only the visual sizing is off.

---

*Last updated: October 2026 | Version 1.1*

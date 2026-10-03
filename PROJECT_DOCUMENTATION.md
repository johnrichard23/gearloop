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
| Search | Built; tapping the search field on Home or Browse opens a full-screen search (`/search`) with the keyboard up. Empty: last 3 searches (saved on the device only, `shared_preferences`) and "Popular near you" categories ranked from the loaded listings as scrolling icon chips, and "Recently viewed" (last 3 opened listings, device only). Sections with nothing to show are hidden. Typing: matching categories and listing titles. Picking one filters Browse; Browse's field shows the active query with a clear button |
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
- **Favourites:** the heart on listing cards is UI only. It toggles on screen but saves nothing
  and resets when the card rebuilds. Build favourites (table, RLS, repository, saved list) soon.
- **New categories (Fashion, Adventure, Utility):** added to the shared category list and shown in
  Home's scrolling category row; hosts can pick them when listing. Vehicles and motorbikes (Adventure,
  Utility) carry insurance, licence and damage-deposit questions that are not designed yet.
  Supabase `gear_listings.category` is plain text with no constraint (checked), so the new values work.
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

### Open Questions (to evaluate while polishing)

**Product / UX decisions**
1. **Host name on listing cards:** left off for now (the rating, review count and verified tick carry
   trust). Revisit after testing with renters.
2. **"Rented 23 times" trust line:** needs a completed-booking count per listing from Supabase. Skipped
   so the card stays short.
3. **Do renters start with search or categories?** Assumed, not researched. Test with about five
   renters in Sorsogon ("find a camera for this weekend").
4. **Home sections:** keep the 2x2 "Near you" grid until Home has two or more sections, then switch
   them to horizontal rows. Where does the removed "Top rated hosts" row go (Browse, Home, or cut)?
5. **Category photos instead of icons:** revisit once real, consistent photography exists.
6. **Naming:** "Tools" (matches existing data) vs "Power tools" (PRD wording).

**Needs backend or design work**
7. Favourites (heart is UI only): table, RLS, repository, saved list.
8. Reset password is UI only; wire to Supabase `resetPasswordForEmail`.
9. Sign-up has no minimum password length; confirm the Supabase setting and add a hint.
10. Vehicles (Adventure, Utility): insurance, driver's licence and damage-deposit rules are undesigned.
11. Location picker is a hard-coded city; notification dot is always shown.

**Verify on device**
12. Run the redesigned auth, Home and listing card in the simulator, including a 320dp phone and 2x
    text size (category labels, card price and rating row).
13. Photo fade strength (0.35 in `PhotoTopScrim`) on very bright and very dark photos; add an
    `AppElevation` token to replace the inline chip shadow.

**Search polish**
14. Slight delay when tapping back on the full-screen search with the keyboard open. Tried: stop Home, Browse
    and the tab shell resizing for the keyboard, a 180ms exit, close keyboard and screen together. Not
    confirmed fixed; test in `flutter run --profile`, and if it persists delay the autofocus by a frame.

**Search polish (cont.)**
15. "Popular near you" is ranked from loaded listings (reviews, then listing count), not from what people
    actually search. True trending searches need search logging (a Supabase table, RLS, privacy wording).

16. Debounce: suggestions are computed locally from loaded listings, so no debounce yet. When search
    moves to the server (Supabase full-text or PostGIS), add a 300ms debounce, a stale-response guard,
    a 2-character minimum, and keep local suggestions visible while the server ones load.

17. **Same-day rentals and unseen requests:** a renter wants gear this afternoon and the host does not see
    the request. Today the host has 24 hours to respond (BKG-06), notifications are static UI with no push,
    and nothing expires ignored requests, so a pending request blocks the dates and the renter waits with no
    way to plan. Effects: lost rental and commission, a bad first impression for the renter, a missed or
    stale request for the host, and off-platform deals. Options to decide: a same-day flag with a 1 to 2
    hour window, push then SMS or email fallback, automatic expiry with a "try similar gear" next step,
    host response rate and availability hours, Instant Book for trusted hosts, requests to several hosts at
    once. Start with real alerts and automatic expiry. See also `ARCHITECTURE.md` section 9.3 item 3.

**Housekeeping**
18. Failing tests not from this work: `test/widget_test.dart` (template, `MyApp` missing) and
    `create_booking_request_test.dart`.
19. The Home redesign, listing card, heart, categories and search are committed on `feature/home-redesign`;
    the branch still needs pushing and a pull request into `develop`.

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

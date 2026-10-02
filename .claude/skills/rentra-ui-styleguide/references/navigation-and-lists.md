# Navigation and list patterns

## Bottom navigation bar sizing
Guidelines taken from a navbar sizing reference, expressed for Rentra. The real values live in the
widgets; use these as the target when you build or adjust a bar.

| Part | Guideline |
|---|---|
| Slots | Equal-width, filling the screen width (five slots: Home, Browse, Post, Bookings, Profile) |
| Icon | 24 (`AppSpacing.kIconLarge`) |
| Label | 12, centered under the icon (`kTextLabel`, not the 11 caption) |
| Active indicator | 2px mark, plus the filled icon and `kColorPrimary` text |
| Center action | Round button about 52, inside a 72 touch area; centered in its slot |
| Alignment | Icon and label centered in each slot |

Notes for Rentra:
- Active tint is `kColorPrimary`; inactive is `kColorTextSecondary`.
- The Post button is the gold `kColorAccent` circle with `kColorOnAccent` icon.
- On iOS 26 and later the native Liquid Glass bar sizes its own icons and labels, so these numbers apply
  to the Flutter-drawn bar (`FloatingTabBar`) and to the gold overlay. At the time of writing the
  Flutter bar uses an 11 caption label and a 60 center circle; adjust only with approval.
- Keep the label under every icon; a bar that hides labels makes people guess (Don't make users think).

## Grouped settings and profile lists
Pattern from a settings before/after: do not show one long flat list. Group it.

1. **Header card first:** avatar, name, email (and one quiet action to edit).
2. **Sections with a small label** above each group, in `kTextLabel` and `kColorTextSecondary`, for
   example Account, Preferences, Support.
3. **Each section is one card:** `kColorSurface`, radius 16, 1px `kColorBorder`, rows separated by
   hairline dividers (`kColorBorder`) inset from the icon.
4. **Row anatomy:** leading icon (20), label (`kTextBodyLarge`), then, when useful, the current value in
   `kTextBodyMedium` secondary text (Language: English), then a chevron. Row height at least 48.
5. **Page background is `kColorBackground`** so the cards read as separate groups (Proximity).
6. **Order by how often it is used,** at most about five rows per group.
7. **Destructive or account-ending actions (Log out, Delete account)** sit on their own at the bottom,
   in `kColorError`, never inside a normal group.

For Rentra's Profile this suggests: Account (Edit profile, Password and security, Notifications),
Support (Help and support), then Log out; add Preferences only when there is a real preference to show.

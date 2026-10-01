# Rentra — Constitution
> The master doctrine governing all AI-assisted development in this project.
> Every Cursor interaction must operate within these rules.

---

## 1. Project Identity

**App Name:** Rentra
**Tagline:** Rent gear. Share value.
**Platform:** Cross-platform mobile app (iOS + Android) via Flutter + Web dashboard via Next.js
**Market:** Philippines — Bicol/Sorsogon region first, then SEA
**Category:** Peer-to-peer equipment rental marketplace
**Business Model:** 10–15% commission per booking + optional damage insurance upsell

**What Rentra is:**
A marketplace where gear owners (hosts) list underutilized equipment — cameras, drones, lenses, camping gear, musical instruments, sports equipment — and renters book them by the day with damage protection built in.

**What Rentra is NOT:**
- A property rental platform
- A skills or services platform
- A social media app
- A one-sided eCommerce store

---

## 2. Tech Stack (Non-Negotiable)

| Layer | Technology | Notes |
|---|---|---|
| Mobile | Flutter 3.44+ (Dart 3.3+) | Single codebase for iOS + Android |
| Web | Next.js 14+ (TypeScript) | Host dashboard + marketing site |
| Web Styling | Tailwind CSS | Utility-first, no CSS-in-JS |
| Web Hosting | Vercel | Auto-deploy from GitHub |
| Backend / DB | Supabase (PostgreSQL) | All-in-one BaaS |
| Auth | Supabase Auth | Apple Sign In + Google + Email |
| File Storage | Supabase Storage | Gear photos, ID documents |
| Realtime | Supabase Realtime | In-app host-renter chat |
| Payments (PH) | PayMongo | GCash, Maya, local cards |
| Payments (Global) | Stripe | International cards, commission splits |
| Push Notifications | Firebase Cloud Messaging (FCM) | Both iOS + Android |
| Email | Resend | Transactional emails |
| Maps (Mobile) | Google Maps Flutter | Location browsing, radius search |
| Maps (Web) | Mapbox | Listing location display |
| ID Verification | Sumsub | Host/renter trust layer |
| Search | Supabase Full-Text + PostGIS | Gear search + geo radius |
| State Management | Riverpod | Flutter state management |
| Navigation | GoRouter | Flutter routing |
| Architecture | Clean Architecture (feature-first) | See ARCHITECTURE.md |

**Never suggest alternatives to this stack without being explicitly asked.**

---

## 3. Flutter Code Standards

### Official Color Palette — Theme 2: Ocean & Coral
- Primary:    #1A5FA8 (Ocean Blue)
- Accent:     #E8523A (Coral)
- Background: #FFF9F8 (Cool warm white)
- Text:       #1A1A2E (Near black)
- Success:    #1B6B45 (Forest green)
- Warning:    #F5A623 (Amber)
- Error:      #C0392B (Red)

### Architecture
- Use **Clean Architecture** with **feature-first folder structure**
- Every feature folder contains: `data/`, `domain/`, `presentation/`
- No business logic in widgets — ever
- Repositories handle all Supabase calls
- Use cases contain all business rules

### State Management
- **Riverpod** only — no Provider, no Bloc, no GetX
- Use `AsyncNotifierProvider` for async data
- Use `StateNotifierProvider` for mutable state
- Never use `setState` outside of purely local UI state

### Naming Conventions
- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables and functions: `camelCase`
- Constants: `kConstantName`
- Private members: `_privateVariable`

### Widget Rules
- Prefer `const` constructors always
- Extract widgets when they exceed 50 lines
- Never nest more than 3 levels of anonymous widget builders
- All text must use `AppTextStyles` — no hardcoded font sizes
- All colors must use `AppColors` — no hardcoded hex values
- All spacing must use `AppSpacing` constants

### Container Color/Decoration Rule
Never set both `color` and `decoration` on the same Container simultaneously — Flutter throws a hard assertion error since `color` is shorthand for `decoration: BoxDecoration(color: ...)`. Put the color INSIDE the BoxDecoration whenever other decoration properties (border, borderRadius, boxShadow, gradient) are also needed:

```dart
decoration: BoxDecoration(
  color: kColorSurface,
  borderRadius: ...,
)
```

Additionally: `clipBehavior` (other than the default `Clip.none`) REQUIRES a `decoration` to be present — Flutter has nothing to clip against otherwise. If a Container needs `clipBehavior: Clip.antiAlias` (e.g., to round corners on a child), it must always have a `decoration` set too, even if that decoration is just a plain color:

```dart
Container(
  decoration: const BoxDecoration(
    color: Colors.white,
  ),
  clipBehavior: Clip.antiAlias,
  child: ...,
)
```

Never set clipBehavior without an accompanying decoration.

### Dart Rules
- Null safety is mandatory — no `!` force-unwrap without a comment explaining why
- Prefer `final` over `var` always
- Use `sealed classes` for result types (Success/Failure)
- All async functions must handle errors explicitly — no silent catches

---

## 4. Next.js / Web Code Standards

- TypeScript strict mode always — no `any` types
- Use App Router (not Pages Router)
- Server Components by default — use `'use client'` only when necessary
- All API calls go through `/app/api/` route handlers
- Never expose Supabase service key on the client side
- Use `zod` for all form and API validation
- Tailwind only — no inline styles, no CSS modules unless absolutely necessary

---

## 5. Database Standards (Supabase / PostgreSQL)

- All table names: `snake_case`, plural (e.g., `gear_listings`, `bookings`)
- All column names: `snake_case`
- Every table must have: `id` (uuid), `created_at` (timestamptz), `updated_at` (timestamptz)
- Use Row Level Security (RLS) on every table — no exceptions
- Never write raw SQL in application code — use Supabase client methods or stored procedures
- All foreign keys must have explicit `ON DELETE` rules defined
- Use database functions for complex operations (e.g., booking status transitions)

---

## 6. Security Rules (Non-Negotiable)

- Never hardcode API keys, secrets, or credentials in code
- All secrets go in `.env.local` (web) or `--dart-define` (Flutter)
- `.env` files are always in `.gitignore`
- Supabase RLS policies are the last line of defense — write them defensively
- All user inputs must be validated before any database operation
- Payment webhooks must verify Stripe/PayMongo signatures before processing
- File uploads must validate type and size before sending to Supabase Storage

---

## 7. AI Behavior Rules (Cursor-Specific)

### Before writing any code, the AI must:
1. Read the relevant files in the current feature folder
2. Check for existing patterns to reuse before creating new ones
3. Confirm it understands what is being asked before proceeding

### The AI must always:
- Follow Clean Architecture — never put Supabase calls directly in widgets
- Write code that matches the existing style of the file being edited
- Add meaningful comments for complex business logic
- Generate the smallest possible diff — change only what was asked
- Use existing `AppColors`, `AppTextStyles`, `AppSpacing` constants
- Write null-safe Dart — no force-unwraps without justification

### The AI must never:
- Install new packages without being asked
- Change the folder structure without being asked
- Refactor unrelated code in the same PR/change
- Use deprecated Flutter APIs
- Write `dynamic` types in Dart
- Write `any` types in TypeScript
- Add TODO comments and leave them unresolved
- Suggest Firebase as an alternative to Supabase

### When the AI is unsure:
- Ask one specific clarifying question — do not assume
- Show the user what it found in the codebase before proceeding
- Never hallucinate function names or package APIs — check docs first

---

## 8. Git Conventions

- Branch naming: `feature/`, `fix/`, `chore/`, `hotfix/`
- Commit messages: `feat:`, `fix:`, `chore:`, `refactor:`, `docs:`
- Example: `feat: add gear listing photo upload`
- Never commit directly to `main`
- One feature = one branch = one pull request

---

## 9. Core Business Logic Rules

These are the rules the AI must understand to generate correct business logic:

**Booking States:**
`pending` → `accepted` → `active` → `completed` → `reviewed`
or: `pending` → `declined`
or: `active` → `disputed`

**Payment Flow:**
1. Renter pays → funds held by Stripe/PayMongo
2. Host accepts booking
3. Gear handed over → booking becomes `active`
4. Gear returned + confirmed by both → booking becomes `completed`
5. Platform fee deducted → host payout released (T+1 business day)

**Trust Rules:**
- Hosts must be ID-verified (Sumsub) before listing gear
- Renters must have a verified phone number before booking
- Reviews are only unlocked after a booking reaches `completed` status
- A user cannot review themselves

**Geo Rules:**
- All listings must have a `lat/lng` coordinate stored in PostGIS format
- Default search radius: 25km
- Maximum search radius: 100km

---

## 10. Definition of Done

A feature is only complete when:
- [ ] Works on both Android emulator and Chrome (web)
- [ ] Follows Clean Architecture folder structure
- [ ] Has RLS policies written for any new Supabase tables
- [ ] No hardcoded colors, fonts, or spacing values
- [ ] Error states are handled (empty state, loading state, error state)
- [ ] No `print()` statements left in code
- [ ] No unused imports

---

## 11. Testing Standards

### What to Test
- Every Use Case in the domain layer must have a unit test
- Every Repository implementation must have a unit test with mocked data sources
- Every Riverpod Provider must have a widget test or unit test
- Critical business logic must have edge case tests:
  - Booking price calculation
  - Booking status transitions
  - Commission calculation (12%)
  - Date availability validation

### What NOT to Test (yet)
- Pure UI widgets with no logic
- Screens (integration tests come later)
- Third-party SDK behavior (Supabase, Stripe)

### Testing Libraries
- flutter_test (built into Flutter SDK)
- mocktail (for mocking dependencies)
- riverpod (has built-in ProviderContainer for testing)

### Test File Location
Mirror the lib/ structure inside test/:

```
lib/features/auth/domain/usecases/sign_in_with_email.dart
test/features/auth/domain/usecases/sign_in_with_email_test.dart
```

### Test Naming Convention
- File: `[feature]_test.dart`
- Test group: describe what is being tested

```dart
group('SignInWithEmail', () { ... });
```

- Test case: describe the scenario

```dart
test('returns UserEntity when credentials are valid', () { ... });
test('returns Failure when email is empty', () { ... });
```

### Definition of Done (Updated)
A feature is only complete when:
- [ ] Works on Android emulator and Chrome
- [ ] Follows Clean Architecture structure
- [ ] RLS policies written for new tables
- [ ] No hardcoded colors, fonts, spacing
- [ ] Error, loading, empty states handled
- [ ] No print() statements in code
- [ ] No unused imports
- [ ] Unit tests written for all use cases
- [ ] Unit tests written for all repositories
- [ ] All tests pass with flutter test

### Running Tests

```bash
flutter test
```

(runs all tests)

```bash
flutter test test/features/auth/
```

(runs tests for one feature)

```bash
flutter test --coverage
```

(generates coverage report)

---

## 12. Documentation Maintenance Protocol

After completing any feature or fixing any significant bug, update these docs before considering the work fully done:

- PROJECT_DOCUMENTATION.md → update the "Current Feature Status" table and "Known Gaps" section if either changed
- DEVELOPMENT_JOURNEY.md and DEVELOPMENT_JOURNEY_INTERVIEW.md → add a new entry under "Specific Engineering Decisions I Can Defend" if the work involved a real bug, trade-off, or architectural decision worth being able to explain later
- PRD.md → add to "What Rentra is NOT building" if a feature was deliberately deferred rather than built
- PRD.md → "Screen Inventory & Design Tracker": mark **Figma** ✅ when a screen is designed and **Code** ✅ when it is built
- design/ → keep in step with UI work:
  - `tokens.md` when a color, type, spacing or radius token is added or changed (Figma name ↔ Dart name)
  - `components.md` when a shared component is added, changed or implemented in Flutter
  - `screens/phase-N-*.md` when a screen is designed (use the template in `design/README.md`)
  - `flows/` when a multi-screen flow is defined or changed
  - `decisions.md` when a UI/UX decision is made, with the reason

When asked to build or fix something, after the implementation is verified working, proactively ask whether the relevant docs should be updated to reflect what changed, rather than waiting to be asked.

---

## 13. UI/UX Principles

Product feel to protect: **warmth, confidence, simplicity**. These principles govern how
screens look and behave; they extend (never replace) the token rules in §3.

### 13.1 Design tokens are the single source of truth
- Colors → `AppColors`, type → `AppTextStyles`, spacing/radius/icons → `AppSpacing`. No literals.
- Use one shared scale per concern: a fixed type ramp (display → title → body → caption, each
  with a regular and an emphasized weight) and the spacing scale. Do not invent one-off sizes.
- Pick **one** corner radius per element family and reuse it: inputs and buttons share a radius;
  cards share a larger radius; pills/avatars use the circular radius.
- Color carries meaning, not decoration: Primary for brand and navigation, Accent (Coral) for the
  one main action per screen, Error only for destructive/failed states, Success/Warning for
  status. Never use Accent for two competing actions on one screen.
- When a design tint has no matching token, add a named token to `AppColors` — do not inline a hex.

### 13.2 One component per job — extend, don't fork
- Reach for a shared widget in `core/widgets/` before building a raw control. Add a variant
  parameter to the shared widget rather than copying it into a feature.
- Buttons come in a small fixed set of roles: **primary** (one per screen), **secondary/outlined**,
  **text**, **destructive**. The role picks the colors; call sites rarely override them.
- A disabled or loading button automatically renders its muted style and blocks re-taps
  (prevents double-submit on booking and payment actions).
- Shared widgets to maintain: button, text field, empty state, error state, skeleton, toast,
  inline info banner, confirmation dialog, modal/sheet header, remote image.

### 13.3 Every screen has four states
Loading, content, empty, error — all designed, none left blank.
- **Loading:** skeleton placeholders shaped like the final content (with a subtle shimmer), not a
  centered spinner, for lists and detail pages. Spinners only inside buttons or brief inline actions.
- **Empty:** a friendly title, one sentence explaining why, and a single next-step action
  ("Browse gear", "List your first item"). Never a bare "No data".
- **Error:** plain-language message plus **Retry**. Offline is its own state: say the connection
  is the problem, offer Retry and a shortcut to device settings. Never show raw exception text.
- **Refresh:** any list backed by remote data supports pull-to-refresh.

### 13.4 Forms
- Every field has a persistent visible **label** above it (not placeholder-only) plus a hint
  placeholder.
- Field states are visually distinct: idle, focused (stronger border), error (error border + message
  directly under the field), read-only/locked (muted fill).
- Validate on blur/submit, not on every keystroke; show the error at the field, not in a dialog.
- Set the right keyboard type, autofill hint, and capitalization per field; password fields get
  a show/hide toggle; the keyboard dismisses on scroll or tap outside.
- The primary action stays reachable above the keyboard (pin it in a bottom inset that adjusts
  to the keyboard) and is disabled until the form is valid.

### 13.5 Feedback and messaging
- **Toast/snackbar** for lightweight confirmations ("Listing saved"): one shared widget, auto
  dismisses in ~3 seconds, replaces the previous one, and can be dismissed by swipe or close.
- **Inline banner** for persistent context on a screen (deposit rules, cancellation terms), tinted
  by meaning (info/warning/error) with an icon — never color alone.
- **Dialog** only for decisions that need a choice or are irreversible (cancel booking, delete
  listing). Destructive option uses the destructive style and is never the default focus.
- Success confirmations for high-stakes flows (booking sent, payment done) get a dedicated
  confirmation screen with the next step, not just a toast.

### 13.6 Navigation and layout
- Bottom navigation for the 4–5 top-level destinations; deeper flows push onto the stack with a
  consistent back affordance. Modal sheets use a close button and a titled header.
- Multi-step flows (create listing, checkout) show progress, keep entered data when going back,
  and confirm before discarding.
- Screen padding follows `kSpacing16`/`kSpacing20` horizontally; sections separate with
  `kSpacing24`+. Content stays inside safe areas and scrolls rather than clipping on small phones.
- Primary call-to-action on detail pages (e.g. "Request to book" with the price) is pinned at the
  bottom, not buried in the scroll.
- Content hierarchy: one clear title, secondary info in muted text, price and key facts scannable
  at a glance. Use badges/tags for category and status.

### 13.7 Media
- Remote images go through one shared image widget with a placeholder, error fallback, and
  fade-in — no raw `Image.network` in screens.
- Listing photos use a swipeable carousel with a page indicator and tap-to-zoom.
- Avatars fall back to initials when there is no photo.

### 13.8 Accessibility and touch
- Minimum tap target 48×48; interactive icons get a `Semantics` label / tooltip.
- Text scales with the system font size; layouts must not overflow at large text.
- Contrast: body text ≥ 4.5:1 against its background; never rely on color alone for status.
- Respect the platform's back gesture; do not trap the user in a flow.
- Light haptic feedback on key confirmations (booking sent, review submitted) is welcome but
  optional; never on every tap.

### 13.9 Copy and tone
- Friendly, plain, second person ("Your booking request was sent"). No jargon, no blame in errors
  ("We couldn't load your bookings. Try again.").
- Buttons say what they do ("Request to book", "Save changes"), not "OK" or "Submit".
- Prices always use the shared currency formatter (₱, no decimals unless needed).
- All user-facing strings live in `AppStrings`.

### 13.10 UI Definition of Done (adds to §10)
- [ ] Loading skeleton, empty, error, and offline states implemented
- [ ] Lists have pull-to-refresh where data is remote
- [ ] Forms show labels, field-level errors, and a keyboard-safe primary action
- [ ] Only shared widgets used for buttons, fields, empty/error states, toasts
- [ ] Tap targets ≥ 48px and interactive icons have semantic labels
- [ ] Layout checked on a small phone and at large text size

---

*Last updated: September 2026 | Version 1.1*
*Treat this document as infrastructure. Update it intentionally, not casually.*

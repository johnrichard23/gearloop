# CLAUDE.md — Rentra

> Condensed, Claude-Code-optimized doctrine for this repo. Full detail lives in
> `CONSTITUTION.md`, `PRD.md`, `ARCHITECTURE.md`, `SYSTEM_REQUIREMENTS.md` — read those
> for context this file compresses away. This file is read every session; keep changes
> intentional, not casual.

---

## 1. What Rentra Is

Rentra is a peer-to-peer equipment rental marketplace for the Philippines (Bicol/Sorsogon
first, then SEA): gear owners (hosts) list underutilized equipment — cameras, drones, audio,
camping, instruments — and renters book it by the day with a deposit and reviews as the trust
layer. It is rental only (not sales, not delivery, not a social app); revenue is a 12% platform
commission per booking. Product feel to protect: **warmth, confidence, simplicity** — borrowing
from a trusted neighbor, not a corporation.

---

## 2. Tech Stack (Non-Negotiable)

| Layer | Technology |
|---|---|
| Mobile | Flutter 3.44+ (Dart 3.3+), single codebase iOS + Android |
| Web | Next.js 14+ (TypeScript, App Router) — **not yet started**, see §7 |
| Web styling | Tailwind CSS only |
| Web hosting | Vercel |
| Backend/DB | Supabase (PostgreSQL) — no custom API server |
| Auth | Supabase Auth (Apple + Google + Email) |
| Storage | Supabase Storage |
| Realtime | Supabase Realtime (chat) |
| Payments PH | PayMongo (GCash, Maya, local cards) |
| Payments global | Stripe (intl cards, commission splits) — Phase 2 |
| Push | Firebase Cloud Messaging — not yet integrated |
| Email | Resend |
| Maps mobile | Google Maps Flutter |
| Maps web | Mapbox |
| ID verification | Sumsub — Phase 2 (manual admin verification in MVP) |
| Search | Supabase Full-Text + PostGIS (geo radius) |
| State mgmt | Riverpod only |
| Navigation | GoRouter |
| Architecture | Clean Architecture, feature-first |

**Never suggest an alternative to this stack unless explicitly asked** (e.g. never propose
Firebase in place of Supabase, Bloc/GetX in place of Riverpod, Pages Router in place of App
Router).

---

## 3. Flutter Code Standards

**Architecture**
- Clean Architecture, feature-first: every `lib/features/<feature>/` has `data/`, `domain/`,
  `presentation/`.
- No business logic in widgets. Repositories own all Supabase calls. Use cases own all
  business rules.
- `core/` holds cross-feature shared code: `constants/` (`app_colors.dart`,
  `app_text_styles.dart`, `app_spacing.dart`, `app_strings.dart`), `errors/` (sealed
  `Success`/`Failure`), `network/` (Supabase singleton), `router/`, `utils/`, `widgets/`.

**State management (Riverpod only — no Provider, Bloc, GetX)**
- `AsyncNotifierProvider` for async data.
- `StateNotifierProvider` for mutable state.
- `setState` only for purely local, non-shared UI state.

**Naming**
- Files `snake_case.dart`, classes `PascalCase`, vars/functions `camelCase`, constants
  `kConstantName`, private members `_privateVariable`.

**Widgets**
- Prefer `const` constructors always.
- Extract a widget once it exceeds 50 lines.
- Never nest more than 3 levels of anonymous widget builders.
- Text → `AppTextStyles`, colors → `AppColors`, spacing → `AppSpacing`. No hardcoded
  hex/font-size/spacing values, ever.

**Dart rules**
- Null safety mandatory; no `!` force-unwrap without a comment explaining why.
- `final` over `var` always.
- Sealed classes for result types (Success/Failure).
- Async functions must handle errors explicitly — no silent catches, no bare `dynamic`.

**Official palette (earthy)** — must be wired through `AppColors`, never
inlined:
| Token | Hex | Use |
|---|---|---|
| Primary | `#2A5251` | Deep forest green |
| Accent | `#C8A26C` | Gold (fills/icons only, not text; dark text on top) |
| Background | `#F3EFEA` | Warm cream |
| Text | `#1F2D2B` | Deep green-black |
| Success | `#2E7A47` | Green |
| Warning | `#A65E0C` | Amber |
| Error | `#B54A3A` | Terracotta |

**Database (Supabase/Postgres)**
- Tables `snake_case` plural; columns `snake_case`; every table has `id` (uuid),
  `created_at`, `updated_at` (timestamptz).
- RLS enabled on every table, no exceptions.
- No raw SQL in app code — Supabase client methods or stored procedures only.
- Explicit `ON DELETE` on every foreign key.

**AI behavior rules**
- Before writing code: read the relevant feature folder, check for existing patterns to
  reuse, confirm the ask if unsure (ask one specific question, don't assume).
- Generate the smallest possible diff. Never refactor unrelated code in the same change.
- Never install new packages, or change folder structure, without being asked.
- Never use deprecated Flutter APIs, `dynamic` in Dart, or `any` in TypeScript.
- Never leave unresolved TODOs. Never hallucinate function/package APIs — check docs first.
- SOLID is a must on every change (see `CONSTITUTION.md` §16.1). One job per screen: if a screen is
  crowded, add a screen or sheet instead of more controls (§16.2). Dates follow §16.3.
- Before designing or building UI, consult the reference skills listed in `CONSTITUTION.md` §15
  (currently `/anthropic-skills:flutter-app-design-skill`, `/anthropic-skills:canvas-design`,
  `/anthropic-skills:swiftui-app-design-skill`), and Rentra's own `/rentra-ux-laws` and
  `/rentra-ui-styleguide` (in `.claude/skills/`), and say which you used.
- Take inspiration from existing apps and projects, never copy them: no copied layouts, assets or
  copy, and never name a reference product in repo files. See `CONSTITUTION.md` §14.

**Web (Next.js) rules**
- TypeScript strict mode, no `any`. App Router. Server Components by default —
  `'use client'` only when necessary.
- All API calls through `/app/api/` route handlers. Never expose the Supabase service key
  client-side. `zod` for all form/API validation.

**Git**
- Branches: `feature/`, `fix/`, `chore/`, `hotfix/`. Commits: `feat:`, `fix:`, `chore:`,
  `refactor:`, `docs:`. Never commit directly to `main`. One feature = one branch = one PR.

---

## 4. Security Rules (Non-Negotiable)

- Never hardcode API keys, secrets, or credentials. Secrets live in `.env.local` (web) or
  `--dart-define` (Flutter); `.env*` is always git-ignored.
- Supabase RLS policies are the last line of defense — write them defensively, on every
  table.
- Validate all user input before any DB operation.
- Verify Stripe/PayMongo webhook signatures before processing — never trust an unverified
  payment webhook.
- Validate file type and size (max 10MB, images only) before upload to Supabase Storage.
- Payment data never touches Rentra servers directly — handled entirely by Stripe/PayMongo.
- JWT expires 1hr, refresh token 7 days. No plaintext tokens in local storage. Rate-limit
  auth endpoints (max 5 attempts).

---

## 5. Container Color/Decoration Rule

Never set both `color` and `decoration` on the same `Container` — Flutter throws a hard
assertion error (`color` is shorthand for `decoration: BoxDecoration(color: ...)`). Put color
**inside** `BoxDecoration` whenever other decoration props (border, borderRadius, boxShadow,
gradient) are needed:

```dart
decoration: BoxDecoration(
  color: kColorSurface,
  borderRadius: ...,
)
```

`clipBehavior` other than `Clip.none` **requires** a `decoration` (Flutter has nothing to
clip against otherwise). Never set `clipBehavior` without one:

```dart
Container(
  decoration: const BoxDecoration(color: Colors.white),
  clipBehavior: Clip.antiAlias,
  child: ...,
)
```

---

## 6. Definition of Done

- [ ] Works on Android emulator and Chrome (web)
- [ ] Follows Clean Architecture feature-first structure
- [ ] RLS policies written for any new Supabase tables
- [ ] No hardcoded colors, fonts, or spacing values
- [ ] Loading, empty, and error states all handled
- [ ] No `print()` statements
- [ ] No unused imports
- [ ] Unit tests written for new use cases and repositories (mocktail for mocks)
- [ ] `flutter test` passes

Test files mirror `lib/` under `test/` (e.g.
`lib/features/auth/domain/usecases/sign_in_with_email.dart` →
`test/features/auth/domain/usecases/sign_in_with_email_test.dart`). Don't write tests yet for
pure UI widgets, full screens, or third-party SDK behavior.

After finishing a feature or fixing a significant bug, proactively ask whether
`PROJECT_DOCUMENTATION.md`, `DEVELOPMENT_JOURNEY*.md`, or `PRD.md` ("What Rentra is NOT
building") should be updated — don't wait to be asked.

---

## 7. Current Feature Status

**Built (mobile, dummy or Supabase-backed as noted):**
- Splash and onboarding; auth screens (log in / create account / reset password) — email
  sign-in and sign-up on Supabase Auth; Apple/Google/Facebook return "not available yet"
- Guest mode — guests browse; Post, Bookings, Profile show a login prompt; account-only routes
  redirect to Log in and return to the listing after sign-in (`isSignedInProvider`, `PendingRoute`)
- Bottom bar — real Liquid Glass on iOS 26+, Flutter floating pill elsewhere (`AdaptiveTabBar`)
- Browse/Discovery, Listing Detail, Create Listing — **live on Supabase** (`gear_listings`
  data flows through)
- Bookings (request/detail/my-bookings) — **live on Supabase**
- Messaging/Chat (inbox + chat screen) — UI built, data layer present but not yet Realtime-wired
- Reviews (write review, star rating, review card) — UI + domain built
- Profile screens — UI built
- Maps integration (Google Maps Flutter) — merged, listing location display
- Image upload to Supabase Storage — merged
- Unit tests — present for early use cases (see `test/`)

**Not yet built:**
- Payments — **UI-only stub** (`checkout_screen.dart`); no PayMongo/Stripe SDK integration,
  no `data`/`domain` layers yet
- Notifications — **static UI only** (`notification_center_screen.dart` with a domain
  entity); no FCM push, no Supabase Realtime subscription feeding it — top Phase 2 priority
  per PRD
- Next.js web dashboard (`rentra-web/`) — does not exist in this repo yet
- Sumsub ID verification — deferred to Phase 2 (manual admin verification in MVP)
- Stripe (international cards) — deferred to Phase 2
- Supabase Edge Functions (`on-booking-accepted`, payout release, webhook handlers, review
  double-blind release) — not present in repo; booking/payment state transitions are not yet
  automated server-side
- Admin panel — deferred to Phase 2 (use Supabase Studio directly for now)
- Damage deposit hold/release automation, weekly/monthly discount rates, referral system,
  in-app language toggle — deferred to Phase 2

When touching payments, notifications, or admin flows: assume you are building the first
real implementation, not extending an existing one — check with the user before assuming
prior wiring exists.

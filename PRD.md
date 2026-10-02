# Rentra — Product Requirements Document (PRD)
> Version 1.0 | May 2026
> This document describes what Rentra is, what it does, and why each piece matters.
> This is the north star. When a feature decision gets confusing during development,
> come back here and ask: does this serve the renter's trust, the host's confidence,
> or the simplicity of the exchange? If yes — build it. If no — cut it.

---

## The Problem

In the Philippines — particularly outside Metro Manila — people who need specialized
equipment for a day or a weekend face an impossible choice: buy gear they can't afford
and will rarely use, or simply not do the thing they want to do.

A photographer needs a specific lens for one shoot. A band needs a sound system for
one gig. A group of friends wants camping gear for one trip. A content creator needs
a drone for one project. Buying any of these outright costs tens of thousands of pesos
for something that will sit in a corner 90% of the time.

At the same time, there are people in those same communities who already own that gear
— and it's sitting idle.

**The gap is trust and discovery.** People don't know who has what. And even when they
do, there's no safe, structured way to hand over a ₱30,000 camera to a stranger and
expect to get it back in good condition.

---

## The Solution

Rentra is a **community marketplace for gear rental** — a platform where anyone can
list equipment they own for others to rent, and anyone can find and borrow the gear
they need, nearby, for the exact days they need it.

It is not a store. It is not a delivery service. It is a **trust layer** between people
who have things and people who need things — with the discovery, scheduling,
communication, and payment all handled in one place.

---

## Who It's For

### The Gear Owner (Host)

Someone who owns equipment they're not using every day. A freelance photographer with
lenses collecting dust. A musician with instruments between gigs. An outdoor enthusiast
with camping gear used twice a year. A small events company with lights and sound
equipment sitting in storage.

They want to earn from what they already own, without the hassle of managing it
informally — no chasing people for payment, no uncertainty about whether the gear
comes back, no awkward conversations with friends who borrowed something and returned
it damaged.

### The Gear Renter

Someone who needs equipment for a specific purpose on specific dates. A student working
on a film project. A couple wanting professional photos at their own wedding. A group
planning a camping trip. A freelancer who just landed a job that requires tools they
don't own yet.

They want access to quality gear without the commitment of ownership — at a fair price,
from someone nearby, with the confidence that the transaction is protected.

### Both Can Be the Same Person

Rentra is designed so that anyone can be both a host and a renter. The photographer
who rents out their old lens on weekends might also rent a drone from someone else for
a project. This dual participation is what builds a healthy marketplace community.

---

## Core Features — What the App Does

---

### 1. Gear Discovery

**What it does:**
When someone opens Rentra, they see available gear around them — organized by
category, sortable by distance and price, filterable by availability dates. They can
search for specific items by name. They can browse by category. Every listing shows
photos, a daily price, the host's rating, and how far away the gear is.

**Why it matters:**
The entire value of Rentra starts here. If renters can't quickly find what they need,
nothing else matters. Discovery needs to feel as natural as scrolling through a feed —
not filling out a form. The map and location layer is critical because gear rental is
fundamentally a local activity. Nobody ships a camera body across provinces for a
weekend shoot.

---

### 2. Gear Listing

**What it does:**
Any verified user can become a host by creating a listing for a piece of gear. They add
photos, a description, a daily rental price, a security deposit amount, the pickup
location, and a calendar showing when it's available. They can pause or unpause
listings, update pricing, and block out dates when they need their gear back.

**Why it matters:**
Supply is the hardest side of any marketplace to build. Rentra needs to make listing
gear so simple that a non-technical person — a musician, a camper, a hobbyist
photographer — can do it in under 5 minutes. The more listings exist, the more useful
Rentra becomes for renters. The more renters come, the more valuable listing becomes
for hosts. This flywheel only spins if creating a listing is frictionless.

---

### 3. Booking

**What it does:**
When a renter finds gear they want, they select their dates, see a full price breakdown
including the daily rate, platform fee, and deposit, and send a booking request. The
host then has 24 hours to accept or decline. If accepted, payment is processed and both
parties receive confirmation. If declined or ignored, the renter is notified and not
charged.

**Why it matters:**
The booking flow is the moment of truth — where browsing becomes a transaction. It
needs to feel safe for both sides. Renters need confidence that they won't be charged
until a real person has agreed to lend them the gear. Hosts need control — they're not
a vending machine, they're choosing who handles their property. The 24-hour acceptance
window respects the host's agency while keeping the experience responsive for renters.

---

### 4. Payments

**What it does:**
Renters pay through the app using GCash, Maya, or a credit/debit card. The money is
held securely and not released to the host until the rental is complete and the gear is
returned. The platform takes a small commission from each transaction. The host receives
the remainder directly to their account after a successful rental.

**Why it matters:**
Money is where trust breaks down in informal gear lending. Rentra removes the
awkwardness of cash transactions, the risk of non-payment, and the uncertainty of
whether the gear will be returned. By holding payment until completion — and only
releasing it after both parties confirm the rental ended well — Rentra gives both
sides a financial safety net. The host knows they'll be paid. The renter knows they
have recourse if something goes wrong.

---

### 5. Messaging

**What it does:**
Once a booking request is submitted, the renter and host can message each other directly
inside the app. They coordinate pickup details, ask questions about the gear, confirm
the handover time, and handle the return. All communication stays inside Rentra.

**Why it matters:**
Gear rental is personal. Unlike buying a product from a store, renting gear involves
meeting another person, handling something valuable, and building enough mutual trust
to make the exchange comfortable. Messaging inside the app serves two purposes: it
makes the practical coordination easy, and it keeps all communication on the platform
— which protects both parties and gives Rentra visibility into disputes if they arise.

---

### 6. Trust & Verification

**What it does:**
Every user has a profile showing their name, photo, member-since date, and overall
rating. Hosts who complete identity verification get a verified badge on their profile.
After every completed rental, both the renter and the host leave a star rating and
written review of each other. These reviews are visible to future users when deciding
whether to list to or rent from someone.

**Why it matters:**
This is the single most important feature in Rentra — and the least visible. Every
other feature only works if both parties trust each other enough to go through with the
transaction. The verification badge tells a renter: this is a real person with a
verified ID, not a scam account. The review system tells a host: this renter has a
track record of returning gear in good condition. Without this layer, Rentra is just
a classifieds board. With it, Rentra is a community where reputation has real value.

---

### 7. Booking Management

**What it does:**
Both renters and hosts have a dashboard showing all their bookings — past, current, and
upcoming. Each booking shows its current status, the gear involved, the dates, the
amount, and a link to the message thread. Hosts can confirm when gear has been handed
over. Renters can confirm when gear has been returned. Either party can flag a problem
if something goes wrong.

**Why it matters:**
After the booking is confirmed, the experience doesn't end — it's just beginning. The
handover, the rental period, and the return all need to be tracked. When both parties
can see the status of a booking in real time and take the next action from their phone,
the rental process feels organized and professional rather than informal and risky.

---

### 8. Notifications

**What it does:**
Both renters and hosts receive push notifications and emails at every important moment
— when a booking request arrives, when it's accepted or declined, when a message comes
in, when a rental is about to start, when a payment is received, when a review comes in.

**Why it matters:**
A marketplace lives or dies by response time. A host who doesn't see a booking request
for 18 hours creates a bad experience for the renter. A renter who doesn't know their
booking was accepted can't plan their pickup. Notifications keep both sides moving
through the process in near real-time — which makes the whole marketplace feel alive
and responsive.

---

## The Experience We're Designing For

Rentra should feel like borrowing from a trusted neighbor — not renting from a
corporation. The entire product should communicate:

- **Warmth** — this is a community of people helping each other
- **Confidence** — your gear is safe, your money is protected, your transaction is real
- **Simplicity** — finding and booking gear should take minutes, not an afternoon

Every screen, every notification, every piece of copy in Rentra should serve one of
those three feelings.

---

## What Success Looks Like (Phase 1)

Rentra succeeds in its first phase when:

- A musician in Sorsogon can find and rent a speaker system for a weekend event
  without leaving the app
- A photographer in Legazpi can list their idle lens and earn ₱500 on a Saturday
  they weren't shooting anyway
- Both of them rate each other 5 stars and come back the following month
- Word spreads in the creative and outdoor communities of Bicol because the experience
  felt safe, fair, and genuinely useful

That's the product. Not the technology behind it — the human experience it creates.

---

## What Rentra Is NOT Building (Phase 1)

To stay focused, Rentra is deliberately not building these in Phase 1:

- **Delivery or shipping** — all rentals are pickup/return in person
- **Subscription rentals** — all bookings are date-based, not recurring
- **Gear sales** — this is rental only, not a buy-and-sell platform
- **Corporate/business accounts** — individual users only at first
- **Insurance partnerships** — deposit protection handles this in Phase 1
- **Multiple cities simultaneously** — Bicol region first, then expand
- **Real-time push/in-app notifications for new messages and booking events** — the Notification Center UI exists with static data, and chat/booking data is fully real via Supabase, but there is currently no mechanism that alerts a user when a new message or booking status change occurs while they're not actively viewing that screen. Users must manually navigate into a booking to discover new activity. This requires either Supabase Realtime subscriptions feeding into the Notification Center, or Firebase Cloud Messaging push notifications (or both), and is the top priority for Phase 2.

---

## Gear Categories (Phase 1)

- Cameras & Lenses
- Drones & Aerial
- Audio & Sound Equipment
- Lighting Equipment
- Camping & Outdoor Gear
- Sports & Fitness Equipment
- Musical Instruments
- Event & Party Equipment
- Power Tools
- Other

---

## User Roles

| Role | Description |
|---|---|
| **Guest** | Can browse and search listings but cannot book |
| **Renter** | Authenticated user who books gear from hosts |
| **Host** | Authenticated user who lists gear for rent |
| **Dual User** | A single account that is both renter and host |
| **Admin** | Platform operator who manages disputes and verifications |

---

## Booking Status Flow

```
[Renter submits request]
        ↓
    PENDING
        ↓
   Host responds
   within 24hrs
    ↙        ↘
ACCEPTED    DECLINED
    ↓            ↓
Payment      Renter
captured    notified,
            no charge
    ↓
 ACTIVE
(gear handed over)
    ↓
COMPLETED
(gear returned)
    ↓
Both parties
leave reviews
```

---

## Target Market

**Primary:** Bicol Region, Philippines (Sorsogon, Legazpi, Naga, Iriga, Albay)
**Secondary:** Rest of Philippines (Phase 2)
**Tertiary:** Southeast Asia (Phase 3)

**Primary users:**
- Freelance photographers and videographers
- Musicians and event organizers
- Outdoor enthusiasts and trail runners
- Students in media, film, and creative courses
- Small event companies and production outfits

---

## Screen Inventory & Design Tracker

The complete list of screens Rentra needs, used to track design and build coverage. Many screens
have several states (loading, empty, error, and per-status variants), so the real frame count is
roughly 120.

**Columns:** *Phase* follows the development plan (0 UI foundation · 1 Payments & booking core ·
2 Notifications & trust · 3 Discovery & retention · 4 Compliance & polish). *Figma* = designed in
the Rentra Figma file. *Code* = a Flutter screen exists (UI scaffolded unless noted otherwise
in §7 of `CLAUDE.md`). Update the ✅ marks as work lands.

### 1. Entry & Auth
| # | Screen | Phase | Figma | Code |
|---|---|---|---|---|
| 1 | Splash | 4 | ✅ | ✅ |
| 2 | Onboarding carousel | 4 | ✅ | ✅ |
| 3 | Log in | 4 | ✅ | ✅ |
| 4 | Sign up | 4 | | ✅ |
| 5 | Forgot password + "Email sent" confirmation | 4 | | ✅ |
| 6 | Verify email (waiting + link-expired states) | 4 | | |
| 7 | Account setup (name, photo, phone verification) | 4 | | |

> **Web note (Next.js dashboard):** the web app's Entry & Auth screens (log in, sign up, forgot
> password) must look like their mobile counterparts: a flat cream page, a large display headline
> with one highlighted word and a hand-drawn underline, pill-shaped fields and buttons, and the
> secondary link ("New to Rentra? Sign up") pinned at the bottom. On wide screens, centre the form
> in a narrow column. Mobile is designed and built first; the web version reuses its tokens and
> copy. The web app is not started yet (`CLAUDE.md` §7).

> **Guest mode (built):** a guest can browse but not act. Log in and Create account both offer
> "Browse as guest". Post, Bookings and Profile show a "Log in or sign up" prompt, and the Profile tab
> reads "Log in". Opening any account-only screen (booking request, chat, create listing, reviews,
> notifications, edit profile) sends a guest to Log in, then returns them to the listing they were
> viewing after they sign in. This covers #23; it is a redirect to Log in, not a separate screen.

### 2. Browse & Discovery
| # | Screen | Phase | Figma | Code |
|---|---|---|---|---|
| 8 | Home / Browse | 3 | ✅ | ✅ |
| 9 | Search: recent searches and suggestions | 3 | | |
| 10 | Search results with filter chips | 3 | | |
| 11 | Filters sheet (category, price, dates, distance, condition) | 3 | | |
| 12 | Date picker sheet | 3 | | |
| 13 | Map results view | 3 | | |
| 14 | Favorites | 3 | | |
| 15 | Location picker | 3 | | ✅ |
| 16 | Browse states: loading skeleton, empty, no results, offline, error | 0 | | |

### 3. Listing & Booking (Renter)
| # | Screen | Phase | Figma | Code |
|---|---|---|---|---|
| 17 | Listing detail + photo viewer (swipe and zoom) | 1 | ✅ | ✅ |
| 18 | Host profile (public) with reviews | 2 | | |
| 19 | Reviews list | 2 | | |
| 20 | Cancellation policy sheet | 1 | | |
| 21 | Booking request (dates, pickup time, notes) | 1 | | ✅ |
| 22 | Booking summary | 1 | ✅ | |
| 23 | Sign-in prompt for guests who try to book | 1 | | ✅ |
| 24 | Booking collision popup (dates no longer available) | 1 | | |
| 25 | Request sent confirmation | 1 | | |
| 26 | My bookings (upcoming, active, past tabs) | 1 | | ✅ |
| 27 | Booking detail, per status: pending, accepted, active, completed, declined, cancelled, disputed | 1 | | ✅ |
| 28 | Cancel booking: reason + refund preview, confirm dialog, result | 1 | | |
| 29 | Reschedule request: pick new dates, confirm | 1 | | |
| 30 | Booking receipt + add to calendar | 1 | | |

### 4. Payments
| # | Screen | Phase | Figma | Code |
|---|---|---|---|---|
| 31 | Choose payment method (GCash, Maya, card) | 1 | | |
| 32 | Checkout with deposit and fee breakdown | 1 | | ✅ (UI stub) |
| 33 | Add card | 1 | | |
| 34 | Payment processing / redirect | 1 | | |
| 35 | Payment success | 1 | | |
| 36 | Payment failed with retry | 1 | | |
| 37 | Payment timed out / abandoned | 1 | | |
| 38 | Billing history + payment detail | 3 | | |

### 5. Messaging
| # | Screen | Phase | Figma | Code |
|---|---|---|---|---|
| 39 | Inbox (with empty and loading states) | 2 | | ✅ |
| 40 | Chat (typing indicator, failed-send, image message) | 2 | | ✅ |

### 6. Notifications
| # | Screen | Phase | Figma | Code |
|---|---|---|---|---|
| 41 | Notification center (unread, empty, error states) | 2 | | ✅ (static UI) |
| 42 | Push permission pre-prompt (shown before the system dialog) | 2 | | |
| 43 | Push permission denied, with "Open settings" nudge | 2 | | |
| 44 | Notification preferences | 2 | | |
| 45 | Push notification designs (lock-screen and banner): request received, accepted, declined, payment confirmed, pickup reminder, return reminder, cancelled, new message | 2 | | |
| 46 | Unread dot on tab bar + in-app toast | 2 | | |

### 7. Host
| # | Screen | Phase | Figma | Code |
|---|---|---|---|---|
| 47 | My listings (with empty state) | 1 | | ✅ |
| 48 | Create listing, multi-step: photos, details, price and deposit, location, availability, cancellation policy, review and publish | 1 | | ✅ |
| 49 | Edit listing + pause / delete confirm | 1 | | |
| 50 | Incoming booking request: accept or decline, with decline reason | 1 | | |
| 51 | Host booking detail with handover/return checklist | 1 | | |
| 52 | Earnings and payout history | 3 | | |
| 53 | Host verification: ID upload, pending, approved, rejected | 2 | | |

### 8. Reviews & Trust
| # | Screen | Phase | Figma | Code |
|---|---|---|---|---|
| 54 | Write review with star rating | 2 | | ✅ |
| 55 | Review submitted confirmation | 2 | | |
| 56 | Report issue / dispute flow: type, photos, submit | 2 | | |

### 9. Profile & Account
| # | Screen | Phase | Figma | Code |
|---|---|---|---|---|
| 57 | Profile | 4 | | ✅ |
| 58 | Edit profile | 4 | | ✅ |
| 59 | Phone verification (code entry) | 4 | | |
| 60 | Login & security: change email and password | 4 | | |
| 61 | Delete account: warning, then final confirm | 4 | | |
| 62 | Help & support, legal pages | 4 | | |

### 10. System States
| # | Screen | Phase | Figma | Code |
|---|---|---|---|---|
| 63 | No internet (full screen) | 0 | | |
| 64 | Generic error with retry | 0 | | |
| 65 | Session expired, sign in again | 4 | | |
| 66 | Maintenance / force-update | 4 | | |
| 67 | Permission denied: location, photos | 4 | | |

### 11. Shared Overlays
| # | Screen | Phase | Figma | Code |
|---|---|---|---|---|
| 68 | Confirm dialogs: destructive, discard changes | 0 | ✅ (component) | |
| 69 | Toast set in use (success, error, info) | 0 | ✅ (component) | |
| 70 | Bottom-sheet pattern with header | 0 | | |
| 71 | Tab bar (default, selected, unread-dot states) | 0 | | ✅ (no unread dot yet) |

**Design order:** Phase 1 core (17–38) → Phase 2 (39–46, 54–56) → Host (47–53) → System states and
overlays (63–71) → Phases 3–4 (search, filters, map, favorites, profile, account deletion).

---

*Last updated: October 2026 | Version 1.2*
*Owner: Chard — Founder, Rentra*

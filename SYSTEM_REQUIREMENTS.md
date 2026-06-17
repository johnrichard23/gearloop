# GearLoop — System Requirements Document
> Version 1.0 | May 2026
> This document defines what GearLoop must do (functional) and how it must perform (non-functional).

---

## 1. Executive Summary

GearLoop is a peer-to-peer equipment rental marketplace targeting the Philippine market, starting in the Bicol/Sorsogon region. It connects gear owners (hosts) with people who need equipment temporarily (renters), facilitating the entire transaction — discovery, booking, payment, and trust — through a mobile app (iOS + Android) and a web dashboard.

---

## 2. User Roles

| Role | Description |
|---|---|
| **Guest** | Unauthenticated user — can browse listings but cannot book |
| **Renter** | Authenticated user who books gear from hosts |
| **Host** | Authenticated user who lists gear for rent |
| **Dual User** | A single account can be both renter and host |
| **Admin** | Platform operator — manages disputes, verifications, payouts |

---

## 3. Functional Requirements

---

### 3.1 Authentication & Onboarding

| ID | Requirement |
|---|---|
| AUTH-01 | Users can register with email and password |
| AUTH-02 | Users can sign in with Apple (iOS required by App Store) |
| AUTH-03 | Users can sign in with Google |
| AUTH-04 | Email verification is required before first booking or listing |
| AUTH-05 | Phone number verification (OTP) required before first booking |
| AUTH-06 | Password reset via email link |
| AUTH-07 | Session persists across app restarts |
| AUTH-08 | Hosts must complete ID verification (Sumsub) before their first listing goes live |

---

### 3.2 Gear Listings (Host)

| ID | Requirement |
|---|---|
| LST-01 | Host can create a gear listing with: title, description, category, photos (max 10), price per day, deposit amount, pickup location |
| LST-02 | Host can set availability via a calendar (block/unblock dates) |
| LST-03 | Host can pause a listing (hide from search without deleting) |
| LST-04 | Host can edit all listing details except category after first booking |
| LST-05 | Host can delete a listing (only if no active bookings) |
| LST-06 | Listing photos are stored in Supabase Storage, max 10MB per photo |
| LST-07 | Listing location is stored as PostGIS point (lat/lng) |
| LST-08 | Host sets minimum rental duration (default: 1 day) |
| LST-09 | Host can set a weekly or monthly discount rate |
| LST-10 | Listing goes live only after host is ID-verified |

**Gear Categories (V1):**
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

### 3.3 Search & Discovery (Renter)

| ID | Requirement |
|---|---|
| SRC-01 | Renter can browse all listings sorted by distance (nearest first) |
| SRC-02 | Renter can search by keyword (gear name, description) |
| SRC-03 | Renter can filter by: category, price range, availability dates, distance radius |
| SRC-04 | Renter can view listing detail: photos, description, host profile, reviews, location map |
| SRC-05 | Renter can save listings to a favorites list |
| SRC-06 | Default search radius is 25km, expandable to 100km |
| SRC-07 | Search results show listings within the selected radius of the user's current location |
| SRC-08 | Guest users can browse and search but see a prompt to sign in before booking |

---

### 3.4 Booking Flow (Renter)

| ID | Requirement |
|---|---|
| BKG-01 | Renter selects start and end date from listing's available calendar |
| BKG-02 | App calculates total price: (daily rate × days) + deposit |
| BKG-03 | Renter sees itemized price breakdown before confirming |
| BKG-04 | Renter submits booking request (does not charge card yet) |
| BKG-05 | Host receives push notification of new booking request |
| BKG-06 | Host has 24 hours to accept or decline |
| BKG-07 | If accepted: renter receives push notification, payment is captured |
| BKG-08 | If declined or expired: renter is notified, no charge made |
| BKG-09 | Booking confirmation shows: dates, total price, host contact, pickup location |
| BKG-10 | Renter can cancel a booking before host accepts — no charge |
| BKG-11 | Cancellation policy after acceptance: defined per listing by host (flexible/moderate/strict) |

---

### 3.5 Booking Management

| ID | Requirement |
|---|---|
| MGT-01 | Both host and renter have a bookings dashboard showing all past and upcoming bookings |
| MGT-02 | Booking statuses are visible: pending, accepted, active, completed, declined, disputed |
| MGT-03 | Host can mark gear as "handed over" to transition booking to `active` |
| MGT-04 | Renter can confirm gear return to transition booking to `completed` |
| MGT-05 | Both parties can open a dispute on an active booking |
| MGT-06 | Admin can view and resolve disputes |

---

### 3.6 Payments

| ID | Requirement |
|---|---|
| PAY-01 | Renter pays via GCash, Maya, local credit/debit card (PayMongo) |
| PAY-02 | Renter pays via international credit card (Stripe) |
| PAY-03 | Payment is held (not released to host) until booking is `completed` |
| PAY-04 | Platform deducts 12% commission from total before releasing to host |
| PAY-05 | Host receives payout within 1–2 business days after booking `completed` |
| PAY-06 | Deposit is held separately and released after successful gear return |
| PAY-07 | If damage is reported, admin holds deposit pending dispute resolution |
| PAY-08 | Renter receives full refund if host declines or booking expires |
| PAY-09 | Payment receipts are emailed to renter and host via Resend |
| PAY-10 | Host sets up payout bank account during onboarding |

---

### 3.7 Messaging

| ID | Requirement |
|---|---|
| MSG-01 | Renter and host can message each other within a booking thread |
| MSG-02 | Messaging is only available after a booking request is submitted |
| MSG-03 | Messages are real-time via Supabase Realtime |
| MSG-04 | Both parties receive push notifications for new messages |
| MSG-05 | Message history is preserved for the lifetime of the booking |
| MSG-06 | No external contact sharing (phone numbers, social media) in chat — platform keeps communication on-platform |

---

### 3.8 Reviews & Trust

| ID | Requirement |
|---|---|
| REV-01 | After a booking is `completed`, both renter and host can leave a review |
| REV-02 | Review window: 14 days after completion |
| REV-03 | Reviews are double-blind — neither party sees the other's review until both submit or the window expires |
| REV-04 | Rating: 1–5 stars + written comment |
| REV-05 | Host's overall rating is displayed on their profile and listings |
| REV-06 | Renter's rating is visible to hosts before accepting bookings |
| REV-07 | Users cannot review themselves |
| REV-08 | Admin can remove reviews that violate community guidelines |

---

### 3.9 Notifications

| ID | Requirement |
|---|---|
| NTF-01 | Push notifications (FCM) for: new booking request, booking accepted/declined, new message, booking reminder (24hr before), payment received, review received |
| NTF-02 | Email notifications (Resend) for: booking confirmation, payment receipt, payout confirmation |
| NTF-03 | In-app notification center showing all recent activity |
| NTF-04 | Users can manage notification preferences in settings |

---

### 3.10 User Profiles

| ID | Requirement |
|---|---|
| PRF-01 | Profile shows: name, photo, member since, overall rating, number of reviews, listings (if host) |
| PRF-02 | Verified badges: Email ✓, Phone ✓, ID ✓ |
| PRF-03 | Host profile shows all active listings |
| PRF-04 | User can edit their own profile (name, photo, bio) |
| PRF-05 | User can view their own reviews received |

---

### 3.11 Admin Panel (Web)

| ID | Requirement |
|---|---|
| ADM-01 | Admin can view all users, listings, bookings, and transactions |
| ADM-02 | Admin can approve or reject ID verifications |
| ADM-03 | Admin can suspend or ban users |
| ADM-04 | Admin can resolve disputes and trigger refunds |
| ADM-05 | Admin can view platform revenue dashboard (total GMV, platform fees, payouts) |
| ADM-06 | Admin can remove listings that violate community guidelines |

---

## 4. Non-Functional Requirements

---

### 4.1 Performance

| ID | Requirement |
|---|---|
| PER-01 | App cold start: < 3 seconds on mid-range Android (e.g., Samsung A-series) |
| PER-02 | Search results load: < 2 seconds |
| PER-03 | Listing detail page load: < 1.5 seconds |
| PER-04 | Chat messages delivered: < 500ms (Supabase Realtime) |
| PER-05 | Photo uploads: progress indicator shown, max 10MB per image |

---

### 4.2 Security

| ID | Requirement |
|---|---|
| SEC-01 | All API communication over HTTPS/TLS 1.3 |
| SEC-02 | Supabase Row Level Security (RLS) enforced on every table |
| SEC-03 | JWT tokens expire after 1 hour, refresh tokens after 7 days |
| SEC-04 | No sensitive data stored on device (no plaintext tokens in local storage) |
| SEC-05 | Payment data never touches GearLoop servers — handled entirely by Stripe/PayMongo |
| SEC-06 | File uploads validated for type (images only) and size (max 10MB) |
| SEC-07 | Rate limiting on auth endpoints (max 5 attempts before lockout) |

---

### 4.3 Scalability

| ID | Requirement |
|---|---|
| SCA-01 | Architecture must support horizontal scaling without code changes |
| SCA-02 | Database queries must use indexes on all foreign keys and search fields |
| SCA-03 | PostGIS spatial index on all listing location columns |
| SCA-04 | Image CDN via Supabase Storage (built-in) |
| SCA-05 | Supabase Edge Functions used for all webhook processing (stateless) |

---

### 4.4 Availability

| ID | Requirement |
|---|---|
| AVL-01 | Target uptime: 99.5% (Supabase Pro SLA) |
| AVL-02 | Graceful degradation: app shows cached data if network is unavailable |
| AVL-03 | Payment processing failures must show clear error messages and never double-charge |

---

### 4.5 Usability

| ID | Requirement |
|---|---|
| USE-01 | App supports both English and Filipino (Tagalog) — language toggle in settings |
| USE-02 | Minimum touch target size: 44×44pt (Apple HIG standard) |
| USE-03 | All loading states must show a skeleton or spinner — no blank screens |
| USE-04 | All error states must show a human-readable message and a retry action |
| USE-05 | Empty states must show an illustration and a clear call-to-action |
| USE-06 | App must function on Android API Level 26 (Android 8.0) and above |
| USE-07 | App must function on iOS 15 and above |

---

## 5. MVP Scope (Phase 1)

The following features constitute the Minimum Viable Product for the Bicol/Sorsogon launch:

**In MVP:**
- Auth (email + Apple + Google)
- Gear listing creation (photos, description, price, location, calendar)
- Browse and search (keyword + category + location radius)
- Booking request and acceptance flow
- In-app messaging (per booking)
- Payments via PayMongo (GCash + local cards)
- Push notifications (FCM)
- Reviews (post-completion)
- Basic host and renter profiles
- Android + iOS mobile app

**Deferred to Phase 2:**
- Stripe (international cards)
- Sumsub ID verification (manual admin verification in MVP)
- Damage deposit hold/release automation
- Weekly/monthly discount rates
- Admin web panel (use Supabase Studio in MVP)
- Web host dashboard (Next.js)
- Referral system
- In-app language toggle

---

*Last updated: May 2026 | Version 1.0*

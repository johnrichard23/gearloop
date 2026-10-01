# Rentra — Architecture Design Document
> Version 1.0 | May 2026
> This document defines the system architecture, folder structure, data models, and technical decisions for Rentra.

---

## 1. System Overview

Rentra follows a **client-server architecture** with two client surfaces (Flutter mobile app + Next.js web) sharing a single Supabase backend. There is no custom API server — Supabase acts as the entire backend layer via its PostgREST API, Realtime, Storage, Auth, and Edge Functions.

```
┌─────────────────────┐    ┌─────────────────────┐
│   Flutter Mobile    │    │   Next.js Web App   │
│  (iOS + Android)    │    │  (Host Dashboard +  │
│                     │    │   Marketing Site)   │
└──────────┬──────────┘    └──────────┬──────────┘
           │                          │
           │        HTTPS / WSS       │
           └──────────┬───────────────┘
                      │
           ┌──────────▼──────────────┐
           │       SUPABASE          │
           │  ┌────────────────────┐ │
           │  │  PostgreSQL + RLS  │ │
           │  │  PostGIS (geo)     │ │
           │  ├────────────────────┤ │
           │  │  Supabase Auth     │ │
           │  ├────────────────────┤ │
           │  │  Supabase Storage  │ │
           │  ├────────────────────┤ │
           │  │  Supabase Realtime │ │
           │  ├────────────────────┤ │
           │  │  Edge Functions    │ │
           │  └────────────────────┘ │
           └──────────┬──────────────┘
                      │
        ┌─────────────┼─────────────┐
        │             │             │
┌───────▼───┐  ┌──────▼──────┐  ┌──▼──────────┐
│  PayMongo │  │   Stripe    │  │   Sumsub    │
│  (GCash,  │  │  (Intl. CC, │  │    (ID      │
│  Maya, PH │  │  commission │  │  verify)    │
│   cards)  │  │   splits)   │  └─────────────┘
└───────────┘  └─────────────┘
        │
┌───────▼───────────────────────┐
│  Firebase Cloud Messaging     │
│  (Push notifications iOS/Android) │
└───────────────────────────────┘
        │
┌───────▼───────────────────────┐
│  Resend (Transactional Email) │
└───────────────────────────────┘
```

---

## 2. Flutter App Architecture

### Pattern: Clean Architecture (Feature-First)

Rentra follows Clean Architecture with a feature-first folder organization. Each feature is a self-contained vertical slice with its own data, domain, and presentation layers.

### Folder Structure

```
lib/
├── main.dart                        # App entry point
├── app.dart                         # MaterialApp + GoRouter setup
│
├── core/                            # Shared across all features
│   ├── constants/
│   │   ├── app_colors.dart          # All color tokens
│   │   ├── app_text_styles.dart     # All typography
│   │   ├── app_spacing.dart         # All spacing values
│   │   └── app_strings.dart         # Localization strings
│   ├── errors/
│   │   ├── failures.dart            # Sealed class: Success / Failure
│   │   └── exceptions.dart          # Custom exceptions
│   ├── network/
│   │   └── supabase_client.dart     # Supabase singleton
│   ├── router/
│   │   └── app_router.dart          # GoRouter route definitions
│   ├── utils/
│   │   ├── date_utils.dart
│   │   └── currency_utils.dart
│   └── widgets/                     # Shared UI components
│       ├── app_button.dart
│       ├── app_text_field.dart
│       ├── loading_skeleton.dart
│       ├── error_state_widget.dart
│       └── empty_state_widget.dart
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart       # Abstract interface
│   │   │   └── usecases/
│   │   │       ├── sign_in_with_email.dart
│   │   │       ├── sign_in_with_apple.dart
│   │   │       ├── sign_in_with_google.dart
│   │   │       └── sign_out.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── auth_provider.dart
│   │       ├── screens/
│   │       │   ├── login_screen.dart
│   │       │   ├── register_screen.dart
│   │       │   └── forgot_password_screen.dart
│   │       └── widgets/
│   │           └── social_sign_in_button.dart
│   │
│   ├── listings/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── listings_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── listing_model.dart
│   │   │   └── repositories/
│   │   │       └── listings_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── listing_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── listings_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_listings_by_location.dart
│   │   │       ├── get_listing_detail.dart
│   │   │       ├── create_listing.dart
│   │   │       ├── update_listing.dart
│   │   │       └── delete_listing.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── listings_provider.dart
│   │       │   └── listing_detail_provider.dart
│   │       ├── screens/
│   │       │   ├── browse_screen.dart
│   │       │   ├── listing_detail_screen.dart
│   │       │   ├── create_listing_screen.dart
│   │       │   └── my_listings_screen.dart
│   │       └── widgets/
│   │           ├── listing_card.dart
│   │           ├── listing_photo_carousel.dart
│   │           ├── category_filter_chips.dart
│   │           └── price_range_slider.dart
│   │
│   ├── bookings/
│   │   ├── data/
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       ├── create_booking_request.dart
│   │   │       ├── accept_booking.dart
│   │   │       ├── decline_booking.dart
│   │   │       ├── complete_booking.dart
│   │   │       └── cancel_booking.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── booking_request_screen.dart
│   │       │   ├── booking_detail_screen.dart
│   │       │   └── my_bookings_screen.dart
│   │       └── widgets/
│   │           ├── booking_status_badge.dart
│   │           └── booking_price_summary.dart
│   │
│   ├── messaging/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── inbox_screen.dart
│   │       │   └── chat_screen.dart
│   │       └── widgets/
│   │           ├── message_bubble.dart
│   │           └── chat_input_bar.dart
│   │
│   ├── payments/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       └── screens/
│   │           └── checkout_screen.dart
│   │
│   ├── reviews/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── write_review_screen.dart
│   │       └── widgets/
│   │           ├── star_rating_widget.dart
│   │           └── review_card.dart
│   │
│   └── profile/
│       ├── data/
│       ├── domain/
│       └── presentation/
│           ├── screens/
│           │   ├── profile_screen.dart
│           │   └── edit_profile_screen.dart
│           └── widgets/
│               └── verified_badge.dart
│
└── bootstrap/
    └── dependency_injection.dart    # Riverpod overrides + Supabase init
```

---

## 3. Database Schema

### Tables

#### `users` (extends Supabase auth.users)
```sql
id              uuid PRIMARY KEY REFERENCES auth.users(id)
full_name       text NOT NULL
avatar_url      text
phone           text UNIQUE
bio             text
is_host         boolean DEFAULT false
is_id_verified  boolean DEFAULT false
rating_avg      numeric(3,2) DEFAULT 0.00
rating_count    integer DEFAULT 0
created_at      timestamptz DEFAULT now()
updated_at      timestamptz DEFAULT now()
```

#### `gear_listings`
```sql
id              uuid PRIMARY KEY DEFAULT gen_random_uuid()
host_id         uuid REFERENCES users(id) ON DELETE CASCADE
title           text NOT NULL
description     text NOT NULL
category        text NOT NULL
price_per_day   numeric(10,2) NOT NULL
deposit_amount  numeric(10,2) DEFAULT 0
min_rental_days integer DEFAULT 1
location        geography(POINT, 4326) NOT NULL   -- PostGIS
location_label  text NOT NULL                      -- "Legazpi City, Albay"
is_active       boolean DEFAULT true
is_paused       boolean DEFAULT false
created_at      timestamptz DEFAULT now()
updated_at      timestamptz DEFAULT now()
```

#### `listing_photos`
```sql
id              uuid PRIMARY KEY DEFAULT gen_random_uuid()
listing_id      uuid REFERENCES gear_listings(id) ON DELETE CASCADE
storage_path    text NOT NULL
display_order   integer NOT NULL
created_at      timestamptz DEFAULT now()
```

#### `listing_availability`
```sql
id              uuid PRIMARY KEY DEFAULT gen_random_uuid()
listing_id      uuid REFERENCES gear_listings(id) ON DELETE CASCADE
blocked_date    date NOT NULL
reason          text    -- 'booked' | 'host_blocked'
created_at      timestamptz DEFAULT now()
UNIQUE(listing_id, blocked_date)
```

#### `bookings`
```sql
id              uuid PRIMARY KEY DEFAULT gen_random_uuid()
listing_id      uuid REFERENCES gear_listings(id) ON DELETE RESTRICT
renter_id       uuid REFERENCES users(id) ON DELETE RESTRICT
host_id         uuid REFERENCES users(id) ON DELETE RESTRICT
start_date      date NOT NULL
end_date        date NOT NULL
total_days      integer NOT NULL
daily_rate      numeric(10,2) NOT NULL
subtotal        numeric(10,2) NOT NULL
platform_fee    numeric(10,2) NOT NULL
deposit_amount  numeric(10,2) NOT NULL
total_amount    numeric(10,2) NOT NULL
status          text NOT NULL DEFAULT 'pending'
  -- pending | accepted | active | completed | declined | cancelled | disputed
payment_intent_id  text        -- Stripe/PayMongo reference
payment_status     text        -- unpaid | held | released | refunded
notes           text
created_at      timestamptz DEFAULT now()
updated_at      timestamptz DEFAULT now()
```

#### `messages`
```sql
id              uuid PRIMARY KEY DEFAULT gen_random_uuid()
booking_id      uuid REFERENCES bookings(id) ON DELETE CASCADE
sender_id       uuid REFERENCES users(id) ON DELETE RESTRICT
content         text NOT NULL
is_read         boolean DEFAULT false
created_at      timestamptz DEFAULT now()
```

#### `reviews`
```sql
id              uuid PRIMARY KEY DEFAULT gen_random_uuid()
booking_id      uuid REFERENCES bookings(id) ON DELETE RESTRICT
reviewer_id     uuid REFERENCES users(id) ON DELETE RESTRICT
reviewee_id     uuid REFERENCES users(id) ON DELETE RESTRICT
rating          integer NOT NULL CHECK (rating BETWEEN 1 AND 5)
comment         text
is_visible      boolean DEFAULT false   -- revealed after double-blind window
created_at      timestamptz DEFAULT now()
UNIQUE(booking_id, reviewer_id)
```

#### `payouts`
```sql
id              uuid PRIMARY KEY DEFAULT gen_random_uuid()
booking_id      uuid REFERENCES bookings(id) ON DELETE RESTRICT
host_id         uuid REFERENCES users(id) ON DELETE RESTRICT
gross_amount    numeric(10,2) NOT NULL
platform_fee    numeric(10,2) NOT NULL
net_amount      numeric(10,2) NOT NULL
status          text DEFAULT 'pending'    -- pending | processing | paid | failed
payout_ref      text    -- Stripe/PayMongo payout reference
paid_at         timestamptz
created_at      timestamptz DEFAULT now()
```

---

## 4. Row Level Security (RLS) Policies

Every table has RLS enabled. Core policies:

**gear_listings:**
- Anyone can SELECT active, non-paused listings
- Only the host (owner) can INSERT, UPDATE, DELETE their own listings

**bookings:**
- Renter can SELECT their own bookings
- Host can SELECT bookings for their listings
- Only renters can INSERT new bookings
- Host can UPDATE status (accept/decline)
- Both parties can UPDATE status for completion

**messages:**
- Only participants of the booking (renter + host) can SELECT and INSERT messages

**reviews:**
- Anyone can SELECT visible reviews
- Only the reviewer can INSERT their own review
- Reviews become visible only after double-blind window closes (handled via Edge Function)

---

## 5. Edge Functions

Serverless functions in Supabase for logic that can't live in the client:

| Function | Trigger | Purpose |
|---|---|---|
| `on-booking-accepted` | Booking status → accepted | Capture payment, send confirmation email, block listing dates |
| `on-booking-completed` | Booking status → completed | Release payout, unlock review window |
| `on-booking-declined` | Booking status → declined | Release payment hold, notify renter |
| `release-reviews` | Cron (daily) | Make reviews visible after 14-day window or both submitted |
| `stripe-webhook` | Stripe webhook | Handle payment events, update booking payment_status |
| `paymongo-webhook` | PayMongo webhook | Handle PH payment events |
| `send-booking-reminder` | Cron (daily) | Push notification 24hr before booking start |

---

## 6. Next.js Web App Structure

```
rentra-web/
├── app/
│   ├── (marketing)/             # Public marketing pages
│   │   ├── page.tsx             # Landing page
│   │   ├── how-it-works/
│   │   └── become-a-host/
│   ├── (auth)/
│   │   ├── login/
│   │   └── register/
│   ├── (dashboard)/             # Authenticated host dashboard
│   │   ├── listings/
│   │   │   ├── page.tsx         # All listings
│   │   │   ├── new/             # Create listing
│   │   │   └── [id]/            # Edit listing
│   │   ├── bookings/
│   │   ├── earnings/
│   │   └── profile/
│   └── api/
│       ├── stripe/
│       │   └── webhook/
│       └── paymongo/
│           └── webhook/
├── components/
│   ├── ui/                      # Base components (Button, Input, etc.)
│   ├── listings/
│   └── dashboard/
├── lib/
│   ├── supabase/
│   │   ├── client.ts            # Browser client
│   │   └── server.ts            # Server client
│   └── utils/
├── types/
│   └── database.types.ts        # Auto-generated from Supabase
└── middleware.ts                 # Auth protection for dashboard routes
```

---

## 7. Key Technical Decisions

### Why Supabase over Firebase
PostgreSQL is relational. A marketplace with bookings linking to listings linking to users linking to reviews is fundamentally relational data. Trying to model that in Firestore leads to complex denormalization and eventual consistency nightmares. Supabase gives SQL, joins, transactions, and PostGIS for geo — all in one.

### Why GoRouter over Navigator 2.0
GoRouter is the Flutter team's recommended routing solution. It handles deep linking (required for booking confirmation links in emails), URL-based navigation for web builds, and nested navigation cleanly. Navigator 2.0 raw API is too verbose for a solo developer.

### Why Riverpod over Bloc
For a solo developer, Riverpod's boilerplate-to-power ratio is better than Bloc. Bloc requires events, states, and blocs for every feature — that's 3 files per state unit. Riverpod requires one provider. Both are architecturally sound; Riverpod is faster to ship.

### Why PayMongo + Stripe (both)
PayMongo handles the Philippine market — GCash and Maya are the dominant payment methods in Bicol/Sorsogon, and a local payment provider has better acceptance rates for PH-issued cards. Stripe handles international cards and is the standard for commission splits and marketplace payouts globally. Both will run simultaneously from MVP.

### Why FCM for push notifications
Apple Push Notification Service (APNs) handles iOS only. Google FCM acts as a unified layer that routes to APNs for iOS and to FCM directly for Android — one integration, both platforms. The Flutter Firebase Messaging package handles this out of the box.

---

## 8. Development Environment

```
IDE:              Cursor (AI-first VS Code fork)
Flutter SDK:      3.44.0 (stable)
Dart:             3.3+
Android Studio:   For Android SDK + AVD emulator only
Node.js:          20 LTS (for Next.js)
Package Manager:  pnpm (web), pub (Flutter)
Version Control:  Git + GitHub
CI/CD:            GitHub Actions → Vercel (web), GitHub Actions → manual (mobile)
```

---

*Last updated: May 2026 | Version 1.0*

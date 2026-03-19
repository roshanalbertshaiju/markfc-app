# MarkFC (MIFC) — Firebase Studio Master Context Prompt

Paste this at the start of every Firebase Studio session.

---

## Project Overview

You are working on **MarkFC (MIFC)** — a premium Flutter sports club app for a football club. The app is nearly complete. Your job is to help finalize Firebase integration and replace mock data with real Firestore streams.

## Tech Stack

- **Flutter** with **Dart SDK ^3.11.0**
- **State Management:** Flutter Riverpod ^3.3.1
- **Routing:** GoRouter ^17.1.0
- **Backend:** Firebase (Auth, Firestore, Storage, Messaging)
- **Architecture:** Feature-First / Domain-Driven Design (DDD)

## Project Structure

```
lib/
├── core/           # Global themes, routing, shared providers
├── features/       # One folder per domain
│   ├── home/
│   ├── fixtures/
│   ├── news/
│   ├── players/
│   ├── store/
│   └── ...
└── shared/         # Reusable UI components, base models
```

## Firebase Project

- **Project ID:** `markifootballclub`
- **firebase_options.dart** has been generated via `flutterfire configure`
- **Firestore Database** is live at nam5

## Firestore Collections (already exist in DB)

| Collection  | Purpose                        | Access         |
|-------------|--------------------------------|----------------|
| `fixtures`  | Match schedule & results       | Public read    |
| `results`   | Historical match results       | Public read    |
| `players`   | Squad info & stats             | Public read    |
| `news`      | Club news articles             | Public read    |
| `hero-sec`  | Homepage hero carousel data    | Public read    |
| `video`     | MIFC TV content                | Public read    |
| `faqs`      | Frequently asked questions     | Public read    |
| `shop`      | Merchandise products           | Public read    |
| `users`     | User profiles (auth-linked)    | Owner or Admin |
| `orders`    | Purchase orders                | Owner or Admin |
| `form`      | Fan/contact form submissions   | Auth write     |
| `admin`     | Admin user records             | Admin only     |

## Admin Detection

Admins are identified by `admin == "true"` field in their `users/{uid}` document.

## Design System

- **Primary:** Navy Blue `#162460`
- **Secondary:** Crimson `#9D1C1E`
- **Base:** Black `#0A0A0A`
- **Accents:** Prestige Gold `#E2C48D`, Palladium Silver `#D1D1D1`
- **Fonts:** Outfit (headings), Inter (body)

## Current Status

- [x] UI complete across all feature modules
- [x] Riverpod state management wired up
- [x] Firebase project created and flutterfire configured
- [ ] `main.dart` Firebase initialization (placeholder exists)
- [ ] Mock data replaced with Firestore streams
- [ ] Firestore security rules deployed
- [ ] Firebase Storage rules deployed
- [ ] Store cart & checkout flow

## Your Role

When given a task, refer to the skill files in `.skills/` for step-by-step instructions on how to approach each category of work. Always follow Riverpod patterns — use `StreamProvider` or `FutureProvider` for Firestore data, never `setState` or raw `FutureBuilder` outside of providers.

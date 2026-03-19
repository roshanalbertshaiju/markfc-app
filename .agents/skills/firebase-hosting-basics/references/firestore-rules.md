---
name: firestore-rules
description: "Use this skill when writing, updating, or deploying Firestore security rules or Firebase Storage rules for the MIFC app."
---

# Firestore & Storage Rules Skill

## Overview

Rules live in two files at the project root:
- `firestore.rules` — controls Firestore read/write access
- `storage.rules` — controls Firebase Storage access

Deploy with: `firebase deploy --only firestore:rules,storage`

---

## firestore.rules (Full MIFC Ruleset)

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // ── Helpers ──────────────────────────────────────────
    function isLoggedIn() {
      return request.auth != null;
    }

    function isAdmin() {
      return isLoggedIn() &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.admin == "true";
    }

    function isOwner(userId) {
      return isLoggedIn() && request.auth.uid == userId;
    }

    // ── Public Collections (read by anyone) ──────────────
    match /fixtures/{doc} {
      allow read: if true;
      allow write: if isAdmin();
    }

    match /results/{doc} {
      allow read: if true;
      allow write: if isAdmin();
    }

    match /players/{doc} {
      allow read: if true;
      allow write: if isAdmin();
    }

    match /news/{doc} {
      allow read: if true;
      allow write: if isAdmin();
    }

    match /hero-sec/{doc} {
      allow read: if true;
      allow write: if isAdmin();
    }

    match /video/{doc} {
      allow read: if true;
      allow write: if isAdmin();
    }

    match /faqs/{doc} {
      allow read: if true;
      allow write: if isAdmin();
    }

    match /shop/{doc} {
      allow read: if true;
      allow write: if isAdmin();
    }

    // ── Users ─────────────────────────────────────────────
    match /users/{userId} {
      allow read: if isOwner(userId) || isAdmin();
      allow create: if isLoggedIn() && request.auth.uid == userId;
      allow update: if isOwner(userId) || isAdmin();
      allow delete: if isAdmin();
    }

    // ── Orders ────────────────────────────────────────────
    match /orders/{orderId} {
      allow read: if isLoggedIn() &&
        (resource.data.userId == request.auth.uid || isAdmin());
      allow create: if isLoggedIn();
      allow update, delete: if isAdmin();
    }

    // ── Form Submissions ──────────────────────────────────
    match /form/{doc} {
      allow create: if isLoggedIn();
      allow read, update, delete: if isAdmin();
    }

    // ── Admin Collection ──────────────────────────────────
    match /admin/{doc} {
      allow read, write: if isAdmin();
    }
  }
}
```

---

## storage.rules

```js
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {

    // Player images — public read
    match /players/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null &&
        firestore.get(/databases/(default)/documents/users/$(request.auth.uid)).data.admin == "true";
    }

    // News images — public read
    match /news/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null &&
        firestore.get(/databases/(default)/documents/users/$(request.auth.uid)).data.admin == "true";
    }

    // Shop images — public read
    match /shop/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null &&
        firestore.get(/databases/(default)/documents/users/$(request.auth.uid)).data.admin == "true";
    }

    // User profile images — only the user
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Deny everything else
    match /{allPaths=**} {
      allow read, write: if false;
    }
  }
}
```

---

## Deploying Rules

```bash
# Deploy both rules
firebase deploy --only firestore:rules,storage

# Deploy only Firestore rules
firebase deploy --only firestore:rules

# Deploy only Storage rules
firebase deploy --only storage
```

## Testing Rules (Firebase Emulator)

```bash
firebase emulators:start --only firestore
```

Then use the Firebase console Rules Playground to simulate reads/writes before deploying.

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| `get()` call fails in rules | Make sure the `users` document exists for that UID |
| Admin check always false | Confirm `admin` field is string `"true"` not boolean `true` |
| Rules not updating | Run `firebase deploy --only firestore:rules` explicitly |

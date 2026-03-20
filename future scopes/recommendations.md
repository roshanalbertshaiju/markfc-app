# Future Scopes & Recommendations

These are high-impact enhancements identified during the initial development and connectivity fixes.

### 1. In-App Admin Suite
* **Goal:** Enable management of news, match results, and products without technical access.
* **Logic:** Use the existing `isAdmin()` logic in [firestore.rules](file:///c:/code/markfc/firestore.rules) to gate access.
* **Component:** A separate route (e.g., `/admin`) with forms for data input.

### 2. Live Match Push Notifications
* **Goal:** Increase user engagement during match days.
* **Implementation:** Leverage the successfully registered SHA-1 fingerprint to use **Firebase Cloud Messaging (FCM)**.
* **Feature:** Real-time goal alerts and full-time score updates.

### 3. Offline Capabilities
* **Goal:** Improve UX in low-connectivity environments (like stadiums).
* **Implementation:** Use Firestore's local persistence and build a "retry" queue for user actions like voting or ticket requests.

### 4. User Engagement & Gamification
* **Features:**
    * **Predictor:** Predict match scores to earn "Loyalty Points".
    * **Elite Logic:** Gate premium content based on the `memberStatus` field in the user profile.

### 5. Media Optimization
* **Goal:** Faster loading for news and video content.
* **Implementation:** Migrate from external image URLs to **Firebase Storage** with image-resizing extensions to keep the app feeling "Elite" and snappy.

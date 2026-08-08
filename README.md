# FlutFest - Advanced UI Kit for Event Management

FlutFest is a modern Flutter UI Kit for event management apps, now updated with advanced features like local notifications and full responsiveness.

It is designed for developers or designers who want to start their project quickly without building everything from scratch.

---

## 🚀 Features

* **Modern & Professional Design** – Clean, attractive UI tailored for event apps.
* **Smart Notifications** – Integrated local notifications for event reminders.
* **Functional Home Screen** – Displays and filters events (Upcoming, Expired, Favorites).
* **Responsive Layout** – Optimized for Mobile and Web.
* **State Management** – Uses GetX for fast and reliable state updates.
* **Cross-Platform** – Enhanced compatibility for Android, iOS, and Web.
* **Dark Mode Support** – Fully dynamic theming.

---

## 📄 Pages included:

1. **Splash Screen** - Optimized launch experience.
2. **Welcome Screen** - Smooth entry with permission handling.
3. **Register & Login** - Complete authentication UI.
4. **Home Screen** - Categorized event lists with AdMob integration.
5. **Event Details** - Rich display of event info and location.
6. **Create/Edit Event** - Full form with image picking and date selection.
7. **Notifications & Settings** - Functional user preference screens.
8. **Privacy Policy** - Ready-to-use web page for store compliance.

---

## 📂 Folder Structure

```
flutfest/
├── .github/workflows/
│   └── deploy.yml            # Auto-deployment to GitHub Pages
├── assets/
│   ├── icons/
│   └── images/
│       └── events/           # Categorized event assets
├── lib/
│   ├── core/
│   │   ├── bindings/         # GetX Dependency injection
│   │   ├── helpers/          # SnackBar, Event, and Date helpers
│   │   ├── services/         # Notification & AI services
│   │   ├── utils/            # Shared constants and dummy data
│   │   └── widgets/          # Platform-specific widgets (AdMob/Images)
│   ├── logic/
│   │   ├── controllers/      # Business logic (Event, User, Settings)
│   │   └── models/           # Data models (Event, ViewModels)
│   ├── views/
│   │   ├── home/             # Home tabs and event components
│   │   ├── events/           # Create, Edit, and My Events screens
│   │   ├── details/          # Event detail screens
│   │   ├── settings/         # App settings and themes
│   │   └── welcome/          # Onboarding and login flow
│   ├── widgets/              # Reusable UI components (Buttons, Fields)
│   ├── theme.dart            # Main theme configuration
│   ├── main.dart             # App entry point with secure init
│   └── routes.dart           # Named route management
├── web/
│   ├── index.html
│   └── privacy_policy.html   # Privacy policy for Google Play
├── pubspec.yaml              # Project dependencies & versioning
└── README.md
```

---

## 📦 How to Use

1. Download and extract the project files.
2. Open the project in your preferred IDE (VS Code or Android Studio).
3. Run:

   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

---

## 🎨 Customization

You can easily modify:

* **Colors**: via `lib/theme.dart`
* **Fonts**: using Google Fonts
* **Logic**: controllers are located in `lib/logic/controllers/`
* **Layout**: widgets are modular for easy rearrangement

---

## 📨 Contact & Support

For inquiries or support, contact:
`flutpulse@proton.me`

---

FlutFest – Start your event app quickly with a clean, customizable UI.

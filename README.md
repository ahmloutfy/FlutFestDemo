# FlutFest - Basic UI Kit for Event Management

FlutFest is a modern Flutter UI Kit for event management apps.

It is designed for developers or designers who want to start their project quickly without building everything from scratch.

It includes essential ready-to-use screens and reusable components that you can easily expand later.

---

## 🚀 Features

* Modern & Professional Design – Clean, attractive UI tailored for event apps.
* Functional Home Screen – Displays events in an engaging way.
* Reusable Widgets – Organized and easy to integrate.
* Responsive Layout – Works seamlessly across all devices.
* State Management with GetX – Lightweight and fast.
* Dark Mode Support – Ready to customize.

---

## 📄 Pages included:

1. Splash Screen
2. Welcome Screen
3. Register Screen
4. Login Screen
5. Forgot Password Screen
6. Home Screen

Not included in the Basic version (icons visible but not functional):

* Settings
* Notifications
* Search
* Create New Event

> Note: These icons or placeholders are present in the UI but are not functional, giving you flexibility to implement them your way.

---

## 📂 Folder Structure

```
flutfest/
├── assets/
│   ├── icons/
│   │   └── social_media/
│   └── images/
├── lib/
│   ├── core/
│   │   └── helpers/
│   │       └── snack_bar_helper.dart
│   ├── logic/
│   │   ├── controllers/
│   │   │   ├── event_controller.dart
│   │   │   └── favorite_controller.dart
│   │   └── models/
│   │       └── event_model.dart
│   ├── theme.dart
│   ├── main.dart
│   ├── routes.dart
│   ├── views/
│   │   ├── forgot_password/
│   │   │   └── forgot_password_screen.dart
│   │   ├── home/
│   │   │   ├── screens/
│   │   │   │   ├── home_screen.dart
│   │   │   │   └── home_tab_screen.dart
│   │   │   └── widgets/
│   │   │       ├── event_card.dart
│   │   │       ├── event_categories.dart
│   │   │       └── event_image.dart
│   │   ├── login/
│   │   │   └── login_screen.dart
│   │   ├── register/
│   │   │   └── register_screen.dart
│   │   └── welcome/
│   │       └── welcome_screen.dart
│   └── widgets/
│       ├── buttons/
│       │   └── primary_button.dart
│       └── custom_appbar.dart
├── pubspec.yaml
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
4. Connect to your backend or add your app logic.

> ⚠️ This UI kit does not include full backend integration or advanced event management features, but it provides a solid, scalable UI foundation.

---

## 🎨 Customization

You can easily modify:

* Colors – via `theme.dart`
* Fonts – using Google Fonts
* Screens content in `views/`
* Layout – widgets are modular for easy rearrangement

#### Example: Change primary color

```dart
// In theme.dart
static const Color primarySeedColor = Color(0xFF2196F3); // Change to your brand color
```

---

## 📨 Contact & Support

For inquiries or support, contact:
`flutpulse@proton.me`

---

FlutFest – Start your event app quickly with a clean, customizable UI.
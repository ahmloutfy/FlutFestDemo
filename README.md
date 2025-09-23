# FlutFest - Basic UI Kit for Event Management

FlutFest is a modern Flutter UI Kit for event management apps.

It is designed for developers or designers who want to start their project quickly without building everything from scratch.

It includes essential ready-to-use screens and reusable components that you can easily expand later.

---

## 👀 Live Preview

[![Live Preview](https://img.shields.io/badge/Live%20Preview-Click%20Here-blue?style=for-the-badge)](https://ahmloutfy.github.io/FlutFestDemo/)

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

## 📸 Screenshots

<p align="center">
  <img src="screenshots/1-%20Splash%20-%20Dark.jpg" width="45%"/>
  <img src="screenshots/1-%20Splash%20-%20Light.jpg" width="45%"/>
</p>

<p align="center">
  <img src="screenshots/2-%20Welcome%20-%20Dark.jpg" width="45%"/>
  <img src="screenshots/2-%20Welcome%20-%20Light.jpg" width="45%"/>
</p>

<p align="center">
  <img src="screenshots/3-%20Register%20-%20Dark.jpg" width="45%"/>
  <img src="screenshots/3-%20Register%20-%20Light.jpg" width="45%"/>
</p>

<p align="center">
  <img src="screenshots/4-%20Login%20-%20Dark.jpg" width="45%"/>
  <img src="screenshots/4-%20Login%20-%20Light.jpg" width="45%"/>
</p>

<p align="center">
  <img src="screenshots/5-%20Forgot%20password%20-%20Dark.jpg" width="45%"/>
  <img src="screenshots/5-%20Forgot%20password%20-%20Light.jpg" width="45%"/>
</p>

<p align="center">
  <img src="screenshots/6-%20Home%20-%20Dark.jpg" width="45%"/>
  <img src="screenshots/6-%20Home%20-%20Light.jpg" width="45%"/>
</p>

---

## 💳 Get FlutFest
You can download the Basic UI Kit here:

👉 [Buy on Gumroad]([https://gumroad.com/your-link](https://flutpulse.gumroad.com/l/FlutFest/))

---

## 📂 Folder Structure

```
📦 FlutFest
┣ 📂 assets
┃ ┣ 🖼️ images/
┃ ┗ 🔊 fonts/
┣ 📂 lib
┃ ┣ 📂 controllers
┃ ┃ ┣ 🧩 event_controller.dart
┃ ┃ ┗ 🧩 favorite_controller.dart
┃ ┣ 📂 models
┃ ┃ ┗ 📄 event_model.dart
┃ ┣ 📂 screens
┃ ┃ ┣ 🏠 home_screen.dart
┃ ┃ ┣ 🏠 home_tab_screen.dart
┃ ┃ ┣ 👋 welcome_screen.dart
┃ ┃ ┣ 🔐 login_screen.dart
┃ ┃ ┗ 📝 register_screen.dart
┃ ┣ 📂 widgets
┃ ┃ ┣ 🎴 event_card.dart
┃ ┃ ┣ 🗂️ events_categories.dart
┃ ┃ ┣ 🖼️ event_image.dart
┃ ┃ ┗ 🧭 custom_appbar.dart
┃ ┣ 🎨 theme.dart
┃ ┣ 🍭 snack_bar_helper.dart
┃ ┣ 🛣️ routes.dart
┃ ┗ 🚀 main.dart
┣ 📂 test
┃ ┗ 🧪 widget_test.dart
┣ 📄 pubspec.yaml
┣ 📄 README.md
┗ 📄 .gitignore

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

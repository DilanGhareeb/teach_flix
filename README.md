# 📚 TeachFlix

**TeachFlix** is a Flutter-based educational app featuring clean architecture, Firebase authentication, user profile management, multi-language support (English & Kurdish), and a responsive UI powered by Bloc and Riverpod.

---

## ✨ Features

- 🔐 **Firebase Authentication**

  - Register / Login with email and password
  - Profile avatar selection
  - Gender and name capture during registration

- 🧑‍💻 **Firestore User Profiles**

  - Stores user profile data in Firestore after registration
  - Reuses data on login and app startup

- 🧭 **Clean Architecture**

  - Separated `presentation`, `domain`, `data`, and `core` layers
  - Bloc for state management
  - UseCases, Entities, DTOs

- 🌍 **Multilingual Support**

  - Supports English (`en`) and Kurdish (`ckb`) using ARB files
  - Localized error handling and UI elements

- 🎨 **Modern UI**
  - `AppTheme` for consistent theming
  - Bottom navigation bar using `salomon_bottom_bar`
  - RTL/LTR support with dynamic locale switching

---

## 🚀 Getting Started

### 🔧 Prerequisites

- Flutter 3.13+
- Dart 3+
- Firebase project (iOS + Android setup)
- `flutterfire_cli` configured

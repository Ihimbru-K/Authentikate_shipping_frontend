````markdown
# Authentikate Mobile – NAHPI-Bamenda Biometric Exam Attendance System

## Overview

**Authentikate Mobile** is a Flutter-based mobile application designed to manage biometric attendance for the **National Higher Polytechnic Institute (NAHPI)** at the **University of Bamenda (UBa)**. It provides a user-friendly mobile interface for admin login, secure student enrollment, attendance tracking via biometric authentication, and report generation. The mobile app interfaces seamlessly with a FastAPI backend server.

---

## Table of Contents

- [Features](#features)
- [Technologies](#technologies)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [API Endpoints](#api-endpoints)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- Admin signup and login with JWT token management.
- Student enrollment with department & level selection, fingerprint template, and photo upload.
- Real-time fetching of departments, levels, and courses.
- Attendance tracking and session management.
- CSV report generation for attendance and errors.
- Clean, responsive UI with customizable themes.

---

## Technologies

- **Framework:** Flutter
- **Programming Language:** Dart
- **State Management:** Provider
- **HTTP Requests:** `http` package
- **File Handling:** `file_picker`, `path_provider`
- **Storage:** `shared_preferences`
- **UI Scaling:** `flutter_screenutil`
- **Dependencies:** Managed via `pubspec.yaml`

---

## Installation

### Prerequisites

- Flutter SDK (`3.6.2` or later)
- Dart SDK
- Android/iOS emulator or physical test device
- Stable internet connection for API requests

### Steps

**1. Clone the Repository**

```bash
git clone https://github.com/Ihimbru-K/authentikate_mobile.git
cd authentikate_mobile
````

**2. Install Dependencies**

```bash
flutter pub get
```

**3. Set Up Environment**

Update `constants.dart` or a `.env` (if used) with the correct backend base URL. See [Configuration](#configuration).

**4. Run the Application**

```bash
flutter run
```

---

## Configuration

**API Base URL**

Set in `constants.dart`:

```dart
static const String apiBaseUrl = 'http://10.239.170.89:8000';
```

> ✅ Example alternatives (for local testing):
>
> * `http://localhost:8000`
> * `http://192.168.1.119:8000`
> * `http://10.0.2.2:8000` (Android Emulator)

**Custom Colors**

Defined in `constants.dart`:

```dart
primaryColor: UBa Blue (#003087)
accentColor: NAHPI Gold (#FFD700)
successColor: NAHPI Green (#228B22)
errorColor: Red (#DC3545)
backgroundColor: White (#FFFFFF)
```

**Assets**

* `assets/images/uba_logo.png`

---

## Usage

### Start the App

Run on an emulator or connected physical device:

```bash
flutter run
```

### Login & Signup

Use the **login** or **signup** screen to authenticate with the backend. JWT tokens are securely stored for subsequent requests.

### Navigation

Main sections are accessible via the bottom navigation bar:

* **Home**
* **Register**
* **Attendance**
* **Reports**

---

## API Endpoints

The app interacts with the following FastAPI backend endpoints (`apiBaseUrl`):

| Endpoint       | Method | Description                        |
| -------------- | ------ | ---------------------------------- |
| `/departments` | GET    | Fetch list of departments          |
| `/levels`      | GET    | Fetch list of levels               |
| `/courses`     | GET    | Fetch list of courses              |
| `/sessions`    | GET    | Fetch active sessions for an admin |
| `/auth/signup` | POST   | Register a new admin               |
| `/auth/login`  | POST   | Login and receive JWT token        |

### Example Request: Fetch Departments

```bash
curl -X GET "http://10.239.170.89:8000/departments" \
  -H "Authorization: Bearer <your_token>"
```

---

## Contributing

1. Fork the repository

```bash
git checkout -b feature/new-feature
```

2. Commit your changes

```bash
git commit -m "Add new feature"
```

3. Push to your branch

```bash
git push origin feature/new-feature
```

4. Open a Pull Request

---

## License

No license file was provided; assume **MIT** unless otherwise specified.


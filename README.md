# Flutter Chat App

## Overview
This is a real-time chat application built using **Flutter**, **Firebase**, and **Riverpod** for state management. The app supports **one-to-one messaging** with a smooth and responsive UI.

## Features
- **One-to-One Chat** – Send and receive messages in real-time.
- **Firebase Authentication** – Secure login with email/password.
- **Cloud Firestore** – Real-time database for storing messages and user data.
- **Riverpod for State Management** – Efficient and scalable app state handling.
- **User Profile** – Display user info with profile pictures.
- **Message Unread Identifier** – Know when messages are read.

## Tech Stack
- **Flutter** (Dart)
- **Firebase Authentication**
- **Cloud Firestore**
- **Riverpod** for state management
- **Dart & Provider/Riverpod**

## Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/Syed722528/chat_messaging_app.git
   cd chatapp
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Set up Firebase:
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/).
   - Enable Firestore, Authentication, and Cloud Messaging.
   - Download and place `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) in their respective folders.
4. Run the app:
   ```sh
   flutter run
   ```

## Folder Structure
```
lib/
│-- main.dart  # Entry point
│-- controllers/  # Riverpod
│-- pages/  # UI Screens
│-- services/  # Firebase interactions
│-- utils/  # Colors and minor ui changes helper
│-- widgest/  # UI screens
```

## Sample Video
Check out the sample demo video:
<video src="[Demo Video](https://github.com/Syed722528/chat_app.git/sample/chatapp.mp4)" controls width="600"></video>
## Future Improvements
- Group Chats
- Voice & Video Calls
- End-to-End Encryption
- Status Updates (like WhatsApp)

## Contributions
Feel free to fork and contribute via pull requests!

## License
This project is licensed under the MIT License.


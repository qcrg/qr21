# Rocket.Chat Dart/Flutter SDK (`rocketchat_sdk`)

[![Pub Version](https://img.shields.io/pub/v/rocketchat_sdk?logo=dart)](https://pub.dev/packages/rocketchat_sdk)
[![Code Quality](https://img.shields.io/badge/code_style-very_good_analysis-blue.svg?logo=dart)](https://pub.dev/packages/very_good_analysis)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A robust, enterprise-grade, fully modular Dart/Flutter SDK for integrating Rocket.Chat REST APIs into your applications. 

Designed with modern practices, utilizing **Dio** for network operations, **Freezed** and **json_serializable** for strictly-typed immutable data objects, and fully validated under strict **Very Good Analysis** rules.

---

## Features

- 🏗️ **Modular API Architecture**: U endpoints are clean, segregated, and easy to navigate (`client.auth`, `client.dm`, `client.channels`, `client.users`).
- 🔐 **Dynamic Authentication & Credentials**: Authenticate once, and credentials (`X-Auth-Token` & `X-User-Id` headers) are dynamically managed and injected into subsequent requests automatically.
- 📦 **Immutable Data Models**: Fully integrated with `Freezed` for compile-safe, immutable data objects like `RocketChatUser`, `DmRoom`, `ChannelRoom`, and `RocketChatMessage`.
- 🛡️ **Highly Strict Code Quality**: Developed under strictly-typed analysis rules (`strict-casts`, `strict-inference`) using `very_good_analysis` guidelines to prevent runtime anomalies.
- ⚡ **Asynchronous Operations**: Fully non-blocking async network calls.

---

## Getting Started

### Installation

Add `rocketchat_sdk` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  rocketchat_sdk: ^0.1.0
```

Or run:

```bash
dart pub add rocketchat_sdk
```

---

## Core Modules & API Coverage

The SDK exposes 4 high-level modular API sub-categories from `RocketChatClient`:

| Module | Property | Key Endpoints Covered | Description |
| :--- | :--- | :--- | :--- |
| **Auth** | `client.auth` | `login`, `logout`, `me` | Handles session authentication & fetches user profiles |
| **Direct Messages** | `client.dm` | `list`, `messages` | Lists DM conversations and retrieves message histories |
| **Channels** | `client.channels` | `list`, `create`, `join`, `leave`, `history`, `info` | Public channel management & history fetches |
| **Users** | `client.users` | `list`, `info`, `create`, `delete` | Member administration & profile retrieval |

---

## Usage Guide

### 1. Initialization and Dynamic Login

```dart
import 'package:rocketchat_sdk/rocketchat_sdk.dart';

void main() async {
  // Initialize without a token (anonymous / pre-login state)
  final client = RocketChatClient(baseUrl: 'https://chat.yourcompany.com');

  try {
    // Log in. X-Auth-Token and X-User-Id are automatically managed on success!
    final loginData = await client.auth.login(
      username: 'apiadmin',
      password: 'secure_password_123',
    );
    print('Logged in successfully! User ID: ${loginData.userId}');

    // Fetch details of currently logged in user
    final profile = await client.auth.me();
    print('Hello, ${profile.name} (@${profile.username})!');
  } catch (e) {
    print('Error: $e');
  }
}
```

### 2. Listing Direct Messages & Conversational Messages

```dart
// Fetch last 10 direct message chats
final dms = await client.dm.list(count: 10);

if (dms.isNotEmpty) {
  final chatRoom = dms.first;
  print('Conversation with: ${chatRoom.usernames.join(", ")}');

  // Fetch last 20 messages inside the DM room
  final messages = await client.dm.messages(
    roomId: chatRoom.id,
    count: 20,
  );

  for (final message in messages.reversed) {
    print('[${message.sender.username}]: ${message.msg}');
  }
}
```

### 3. Public Channels Management & Message History

```dart
// List public channels
final channels = await client.channels.list(count: 5);

for (final channel in channels) {
  print('#${channel.name} (Active users: ${channel.usersCount})');
}

// Join a channel and view message history
final roomId = 'GENERAL';
final success = await client.channels.join(roomId: roomId);

if (success) {
  final history = await client.channels.history(roomId: roomId, count: 10);
  for (final msg in history) {
    print('[${msg.sender.username}]: ${msg.msg}');
  }

  // Leave the channel
  await client.channels.leave(roomId: roomId);
}
```

### 4. Admin User Administration

```dart
// Create a new user (requires administrator privileges)
final newUser = await client.users.create(
  email: 'john.doe@example.com',
  name: 'John Doe',
  username: 'johndoe',
  password: 'user_password_123',
);

print('Created new member: ${newUser.name} (@${newUser.username})');

// Delete a user
await client.users.delete(userId: newUser.id);
print('Deleted user successfully.');
```

---

## Data Models (DTOs)

The package utilizes modern, compile-safe, immutable classes built with `Freezed`:
- `RocketChatUser`: Details about user accounts.
- `DmRoom`: Model representing a direct message room conversation.
- `ChannelRoom`: Model representing a public/private group/channel room.
- `RocketChatMessage`: Model representing a message transaction.
- `RocketChatLoginData`: Model housing login token and user identifier details.

---

## Static Quality Standards

This SDK strictly passes **`very_good_analysis`** validation checks with:
*   `0 errors`, `0 warnings`
*   Compulsory strict-casts (`strict-casts: true`)
*   Compulsory strict-inference (`strict-inference: true`)

To run quality checks yourself:
```bash
dart analyze
```

To run unit tests:
```bash
dart test
```

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

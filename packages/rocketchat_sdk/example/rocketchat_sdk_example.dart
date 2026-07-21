// ignore_for_file: avoid_print, avoid_catches_without_on_clauses
import 'package:rocketchat_sdk/rocketchat_sdk.dart';

void main() async {
  // 1. Initialize the Rocket.Chat client with your server's base URL and built-in logging enabled.
  // You don't need authentication credentials at this stage.
  final client = RocketChatClient(
    baseUrl: 'https://chat.example.com',
    enableLogging: true, // New in 0.2.0: Client logging support!
  );

  print('🚀 Rocket.Chat SDK Client initialized at: ${client.baseUrl}');

  try {
    // 2. Perform a secure login request using username and password.
    // Auth headers (X-Auth-Token & X-User-Id) will be dynamically managed
    // and injected into subsequent network requests automatically upon success!
    print('\n🔑 Logging in...');
    final loginData = await client.auth.login(
      username: 'apiadmin',
      password: 'password123',
    );

    print('✅ Login successful!');
    print('   User ID: ${loginData.userId}');
    print('   Token:   ${loginData.authToken.substring(0, 10)}...');

    // 3. Get the authenticated user's own profile details
    print('\n👤 Fetching own profile details...');
    final myself = await client.auth.me();
    print('✅ Profile loaded: ${myself.name} (@${myself.username})');

    // 4. Fetch the authenticated user's avatar URL (New in 0.2.0!)
    print('\n🖼️ Fetching user avatar...');
    final avatarUrl = await client.users.getAvatar(userId: myself.id);
    print('✅ Avatar URL: $avatarUrl');

    // 5. Fetch active room subscriptions (New in 0.2.0!)
    print('\n📋 Fetching subscriptions...');
    final subscriptions = await client.subscriptions.get();
    print('✅ Subscriptions loaded: ${subscriptions.length} found.');
    for (final sub in subscriptions.take(5)) {
      print('   • Room ID: ${sub.rid}, Name: ${sub.name} (Type: ${sub.t})');
    }

    // 6. List all public channels in the workspace
    print('\n💬 Fetching public channels...');
    final channels = await client.channels.list(count: 10);
    print('✅ Channels list loaded:');
    for (final room in channels) {
      print('   • #${room.name} (ID: ${room.id}, Messages: ${room.msgs})');
    }

    // 7. List the user's active direct message (DM) rooms
    print('\n✉️ Fetching direct message rooms...');
    final dms = await client.dm.list(count: 10);
    print('✅ Direct message rooms loaded:');
    for (final room in dms) {
      print('   • Chat with ${room.usernames.join(", ")} (ID: ${room.id})');
    }

    if (dms.isNotEmpty) {
      final activeRoom = dms.first;
      // 8. Fetch the message history inside the first active DM room
      print('\n📝 Fetching messages inside DM room: ${activeRoom.id}...');
      final messages = await client.dm.messages(
        roomId: activeRoom.id,
        count: 5,
      );

      print('✅ Last ${messages.length} messages:');
      for (final message in messages.reversed) {
        print('   [${message.sender.username}]: ${message.msg}');
      }

      // 9. Send a new direct message (New in 0.2.0!)
      print('\n📤 Sending a new message to DM room: ${activeRoom.id}...');
      final sentMessage = await client.dm.sendMessage(
        roomId: activeRoom.id,
        text: 'Hello from Rocket.Chat Dart SDK v0.2.0! 🚀',
      );
      print('✅ Message sent successfully! Msg ID: ${sentMessage.id}');
      print('   Content: "${sentMessage.msg}" at ${sentMessage.ts}');

      // 10. Mark room subscription as read (New in 0.2.0!)
      print('\n📖 Marking subscription as read for room: ${activeRoom.id}...');
      final isRead = await client.subscriptions.read(roomId: activeRoom.id);
      if (isRead) {
        print('✅ Subscription successfully marked as read!');
      }
    }

    // 11. Join and explore a channel
    if (channels.isNotEmpty) {
      final channelToJoin = channels.first;
      print('\n🤝 Joining channel #${channelToJoin.name}...');
      final joined = await client.channels.join(roomId: channelToJoin.id);
      if (joined) {
        print('✅ Successfully joined #${channelToJoin.name}!');

        // Fetch channel history
        print('📝 Fetching history of #${channelToJoin.name}...');
        final history = await client.channels.history(
          roomId: channelToJoin.id,
          count: 5,
        );
        for (final message in history.reversed) {
          print('   [${message.sender.username}]: ${message.msg}');
        }

        // Leave the channel
        print('🚪 Leaving channel #${channelToJoin.name}...');
        await client.channels.leave(roomId: channelToJoin.id);
        print('✅ Left #${channelToJoin.name}.');
      }
    }

    // 12. User Management: List all workspace users (requires appropriate permissions)
    print('\n👥 Fetching all workspace users...');
    final allUsers = await client.users.list(count: 5);
    print('✅ User list loaded:');
    for (final user in allUsers) {
      print('   • @${user.username} (${user.name ?? "No Name"})');
    }

    // 13. Logout securely
    print('\n🔌 Logging out...');
    final loggedOut = await client.auth.logout();
    if (loggedOut) {
      print('✅ Logout successful! Auth headers cleared.');
    }
  } catch (e) {
    print('❌ An error occurred: $e');
  }
}

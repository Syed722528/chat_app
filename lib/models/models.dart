// Model to display Chat Item on HomePage
class ChatItem {
  final String displayName;
  final String lastMessage;
  final String time;
  final int unreadCount;
  const ChatItem({
    required this.displayName,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
  });
}

// Model for Message Sent

class SendMessage {
  final String message;
  final MessageType messageType;
  final String userId;
  final String receiverId;
  final DateTime sendDateAnTime;

  const SendMessage(
    this.message,
    this.userId,
    this.receiverId,
    this.sendDateAnTime,
    this.messageType,
  );
}

enum MessageType { text, image, video, file }

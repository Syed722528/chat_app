import 'package:chat_app/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final fireStore = FirebaseFirestore.instance;

  // Stream to get all the users except the current user and the users that have been chatted with
  Stream<List<Map<String, dynamic>>> getUsersStream(
    String currentUserId,
  ) async* {
    Set<String> chattedIds = await getChattedUserIds(currentUserId);
    yield* fireStore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data())
          .where(
            (user) =>
                user['uid'] != currentUserId &&
                !chattedIds.contains(user['uid']),
          )
          .toList();
    });
  }

  // Stream to get all the recents chat / All the users that current has chatted with
  Stream<List<Map<String, dynamic>>> getRecentChats(String uid) {
    return fireStore
        .collection('chatRooms')
        .where('users', arrayContains: uid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => doc.data()).toList();
        })
        .handleError((error) {
          print('Error fetching users');
        });
  }

  // Stream to get all the user ids which current user has chatted with
  getChattedUserIds(String uid) async {
    final snapshot =
        await fireStore
            .collection('chatRooms')
            .where('users', arrayContains: uid)
            .get();

    Set<String> chattedUserIds = {};

    for (var doc in snapshot.docs) {
      List<dynamic> users = doc.data()['users'];
      chattedUserIds.addAll(users.map((e) => e.toString()));
    }

    chattedUserIds.remove(uid);
    return chattedUserIds;
  }

  // This function creates a chat room between two users
  Future<String?> createChatRoom(String uid1, String uid2) async {
    try {
      List<String> sortedUIDS = [uid1, uid2]..sort();
      String chatRoomId = sortedUIDS.join("_");

      await fireStore.collection('chatRooms').doc(chatRoomId).set({
        'users': sortedUIDS,
        'createdAt': FieldValue.serverTimestamp(),
        'chatRoomId': chatRoomId,
        'latestMessage': '',
        'unreadCount': {uid1: 0, uid2: 0},
      });

      return chatRoomId;
    } catch (e) {
      print('Error creating chat room: $e');
      return null;
    }
  }

  Future<void> deleteChatRoom(String chatRoomId) async {
    try {
      final chatRoomRef = fireStore.collection('chatRooms').doc(chatRoomId);
      final messageRef = chatRoomRef.collection('messages');
      final messageSnapshot = await messageRef.get();

      final batch = fireStore.batch();

      for (var doc in messageSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      await chatRoomRef.delete();
    } catch (e) {
      throw Exception('Failed to delete chat room: ${e.toString()}');
    }
  }

  // This function is resposible for sending message and also updated the latest message in the chatroom
  // Future<void> sendMessage(
  //   String message,
  //   MessageType type,
  //   String chatRoomid,
  //   String senderId,
  //   String recepientId,
  // ) async {
  //   try {
  //     await fireStore
  //         .collection('chatRooms')
  //         .doc(chatRoomid)
  //         .collection('messages')
  //         .add({
  //           'senderId': senderId,
  //           'text': message,
  //           'timeStamp': FieldValue.serverTimestamp(),
  //         });
  //     await fireStore.collection('chatRooms').doc(chatRoomid).update({
  //       'latestMessage': message,
  //     });
  //   } catch (e) {
  //     print('Error sending message: $e');
  //   }
  // }

  Future<void> sendMessage(
    String message,
    MessageType type,
    String chatRoomId,
    String senderId,
    String recepientId,
  ) async {
    try {
      final chatRoomRef = fireStore.collection('chatRooms').doc(chatRoomId);

      await fireStore.runTransaction((transaction) async {
        final messageRef = chatRoomRef.collection('messages').doc();
        transaction.set(messageRef, {
          'senderId': senderId,
          'text': message,
          'timeStamp': FieldValue.serverTimestamp(),
          'read': false,
        });
        transaction.update(chatRoomRef, {
          'latestMessage': message,
          'unreadCount.$recepientId': FieldValue.increment(1),
        });
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  // This function is responsible for getting all the message from a chat room
  Stream<List<Map<String, dynamic>>> getMessages(String chatRoomId) {
    return fireStore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => doc.data()).toList();
        })
        .handleError((error) {
          print('Error fetching messages: $error');
        });
  }

  Future<void> markMessagesAsRead(String chatRoomId, String userId) async {
    final chatRoomRef = fireStore.collection('chatRooms').doc(chatRoomId);
    final messagesRef = chatRoomRef.collection('messages');

    try {
      await fireStore.runTransaction((transaction) async {
        // Get the latest chatRoom data to avoid overwriting
        final chatRoomSnapshot = await transaction.get(chatRoomRef);
        final chatRoomData = chatRoomSnapshot.data() as Map<String, dynamic>;

        // Fetch unread messages in the transaction
        final unreadMessages =
            await messagesRef
                .where(
                  'senderId',
                  isNotEqualTo: userId,
                ) // Get messages received by user
                .where('read', isEqualTo: false)
                .get();

        if (unreadMessages.docs.isEmpty) return; // No unread messages, exit

        // Mark each unread message as read
        for (var doc in unreadMessages.docs) {
          transaction.update(doc.reference, {'read': true});
        }

        // Preserve other user's unread count
        Map<String, dynamic> updatedUnreadCount = Map.from(
          chatRoomData['unreadCount'],
        );
        updatedUnreadCount[userId] = 0; // Reset only the current user's count

        // Update chatRoom with modified unread count map
        transaction.update(chatRoomRef, {'unreadCount': updatedUnreadCount});
      });
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }
}

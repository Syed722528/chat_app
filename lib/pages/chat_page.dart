import 'package:chat_app/models/models.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class ChatPage extends StatelessWidget {
  final String chatRoomId;
  final Map<String, dynamic> recepientData;
  ChatPage({super.key, required this.chatRoomId, required this.recepientData});

  final chatService = ChatService();

  final currentUser = FirebaseAuth.instance.currentUser;

  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.veryLightBlue,
      appBar: AppBar(
        backgroundColor: AppColors.lightBlue,
        title: Text(recepientData['userName']),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.call))],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),

          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: chatService.getMessages(chatRoomId),

                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: const CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error getting chats'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No recent chats'));
                    }
                    return ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,

                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        final message = snapshot.data![index];
                        return Align(
                          alignment:
                              message['senderId'] == currentUser!.uid
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.normalBlue,
                            ),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            child: Text(
                              message['text'],
                              style: TextStyle(color: AppColors.whiteColor),
                              softWrap: true,
                              textWidthBasis: TextWidthBasis.parent,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.lightBlue,
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          style: ButtonStyle(
                            foregroundColor: WidgetStatePropertyAll(
                              AppColors.darkBlue,
                            ),
                          ),
                          onPressed: () {
                            chatService.sendMessage(
                              messageController.text,
                              MessageType.text,
                              chatRoomId,
                              FirebaseAuth.instance.currentUser!.uid,
                              recepientData['uid'],
                            );
                            messageController.clear();
                          },
                          icon: Icon(Icons.send),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

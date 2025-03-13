import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/user_controller.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.veryLightBlue,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.lightBlue,
        title: Text('Search users by Name'),
        titleTextStyle: TextStyle(fontSize: 20, color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [UserSearchBar(), Expanded(child: ChatItemList())],
          ),
        ),
      ),
    );
  }
}

class UserSearchBar extends ConsumerWidget {
  const UserSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 50,
      child: TextField(
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).state = value;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          filled: true,
          hintText: 'Search chats',
          fillColor: AppColors.veryLightBlue,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.normalBlue),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.darkBlue),
          ),
        ),
      ),
    );
  }
}

class ChatItemList extends ConsumerWidget {
  final chatService = ChatService();
  final ScrollController? controller;
  final double? maxHeight;

  ChatItemList({super.key, this.controller, this.maxHeight});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
    return StreamBuilder(
      stream: chatService.getUsersStream(
        ref.watch(firebaseAuthProvider).currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              height: 40,
              child: const CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError) {
          return Text('Error fetching users');
        }
        if (!snapshot.hasData && snapshot.data == null) {
          return Text('No users found');
        }
        final users =
            snapshot.data!
                .where(
                  (user) =>
                      user['userName'].toLowerCase().contains(searchQuery),
                )
                .toList();

        return Container(
          constraints: BoxConstraints(maxHeight: maxHeight ?? double.infinity),
          child: ListView.builder(
            // controller: controller,
            shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return GestureDetector(
                onTap: () async {
                  final chatRoomid = await chatService.createChatRoom(
                    ref.watch(firebaseAuthProvider).currentUser!.uid,
                    user['uid'],
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ChatPage(
                            recepientData: user,
                            chatRoomId: chatRoomid!,
                          ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.veryLightBlue, AppColors.lightBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),

                  margin: EdgeInsets.symmetric(vertical: 2),
                  child: ListTile(
                    style: ListTileStyle.list,
                    contentPadding: EdgeInsets.all(10),
                    tileColor: AppColors.veryLightBlue,
                    leading: CircleAvatar(
                      radius: 35,
                      backgroundColor: AppColors.lightBlue,
                    ),
                    title: Text(user['userName']),
                    subtitle: Text(user['email']),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

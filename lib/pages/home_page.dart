import 'package:chat_app/controllers/auth_controller.dart';
import 'package:chat_app/controllers/user_controller.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/search_page.dart';
import 'package:chat_app/utils/provider.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/app_colors.dart';

class HomePage extends ConsumerWidget {
  final editUserName = TextEditingController();
  final bool hasStatus = false;
  HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: _buildAppBar(context, ref),
      drawer: _buildDrawer(context, ref),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.veryLightBlue,
        foregroundColor: AppColors.darkBlue,
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchPage()),
            ),

        // onPressed: () {
        //   showDialog(
        //     context: context,
        //     builder:
        //         (context) => AlertDialog(
        //           backgroundColor: AppColors.whiteColor,
        //           scrollable: false,
        //           content: SizedBox(
        //             height: double.maxFinite,
        //             width: double.maxFinite,
        //             child: Column(
        //               mainAxisSize: MainAxisSize.min,
        //               children: [
        //                 UserSearchBar(),
        //                 Expanded(child: ChatItemList()),
        //               ],
        //             ),
        //           ),
        //           title: Text(
        //             'Search by Username or Email',
        //             style: TextStyle(color: AppColors.darkBlue),
        //           ),
        //           actions: [
        //             TextButton(
        //               style: ButtonStyle(
        //                 backgroundColor: WidgetStatePropertyAll(
        //                   AppColors.normalBlue,
        //                 ),
        //                 foregroundColor: WidgetStatePropertyAll(
        //                   AppColors.veryLightBlue,
        //                 ),
        //               ),
        //               onPressed: () => Navigator.pop(context),
        //               child: Text('Ok'),
        //             ),
        //           ],
        //         ),
        //   );
        // },
        child: Icon(Icons.chat_bubble),
      ),
    );
  }

  Padding _buildBody() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [StatusBar(hasStatus: hasStatus), Divider(), RecentChats()],
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context, WidgetRef ref) {
    return Drawer(
      elevation: 2,
      backgroundColor: AppColors.veryLightBlue,
      width: MediaQuery.of(context).size.width * 0.60,
      child: Column(
        children: [
          DrawerHeader(
            child: Icon(
              Icons.miscellaneous_services_rounded,
              size: 40,
              color: AppColors.normalBlue,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.person, color: AppColors.normalBlue),
                    ),
                    Text('Profile'),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.person, color: AppColors.normalBlue),
              ),
              Text('Settings'),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  ref.read(signOutProvider.notifier).signOut();
                },
                icon: Icon(Icons.logout_outlined, color: AppColors.normalBlue),
              ),
              Text('Log out'),
            ],
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, WidgetRef ref) {
    final currentUserName =
        ref.watch(userProvider).value?.displayName ?? 'User';
    return AppBar(
      centerTitle: true,
      backgroundColor: AppColors.veryLightBlue,
      title: Consumer(
        builder: (context, ref, child) {
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      backgroundColor: AppColors.lightBlue,

                      content: TextField(
                        controller: editUserName,
                        decoration: InputDecoration(
                          fillColor: AppColors.veryLightBlue,
                          filled: true,
                          hintText: currentUserName,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      title: Text('Edit name'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            FirestoreService.updateCurrentUserName(
                              editUserName.text,
                            );
                            FirebaseAuth.instance.currentUser!
                                .updateDisplayName(editUserName.text);

                            Navigator.pop(context);
                          },
                          child: Text('Save'),
                        ),
                      ],
                    ),
              );
            },
            child: Text(currentUserName),
          );
        },
      ),
      actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
    );
  }
}

class RecentChats extends ConsumerWidget {
  final chatService = ChatService();

  RecentChats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Chats',
          style: TextStyle(color: AppColors.darkBlue, fontSize: 30),
        ),
        StreamBuilder(
          stream: chatService.getRecentChats(
            ref.watch(firebaseAuthProvider).currentUser!.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error fetching users');
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No recent chats'));
            }
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final chatRoom = snapshot.data![index];
                List users = chatRoom['users'] ?? [];
                final userId = users.firstWhere(
                  (id) =>
                      id != ref.watch(firebaseAuthProvider).currentUser!.uid,
                  orElse: () => null,
                );

                return FutureBuilder<DocumentSnapshot>(
                  future:
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const ListTile(
                        title: Text("Loading..."),
                        subtitle: Text("Loading..."),
                      );
                    }
                    if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                      return const Center(child: Text("User not found"));
                    }

                    final user =
                        userSnapshot.data!.data() as Map<String, dynamic>;

                    return GestureDetector(
                      onTap: () async {
                        try {
                          await chatService.markMessagesAsRead(
                            chatRoom['chatRoomId'],
                            ref.watch(firebaseAuthProvider).currentUser!.uid,
                          );
                        } catch (e) {
                          print(e.toString());
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ChatPage(
                                  recepientData:
                                      user, // Now it's properly loaded
                                  chatRoomId: chatRoom['chatRoomId'],
                                ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 2),
                        child: Dismissible(
                          direction: DismissDirection.endToStart,
                          key: Key(chatRoom['chatRoomId']),
                          onDismissed: (direction) {
                            chatService.deleteChatRoom(chatRoom['chatRoomId']);
                          },
                          background: Container(
                            color: AppColors.normalBlue,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(Icons.archive, color: Colors.white),
                          ),
                          child: ListTile(
                            hoverColor: AppColors.normalBlue,
                            contentPadding: EdgeInsets.all(10),
                            tileColor: AppColors.veryLightBlue,
                            leading: CircleAvatar(
                              radius: 35,
                              backgroundColor: AppColors.lightBlue,
                            ),
                            title: Text(user['userName']),
                            subtitle: Text(chatRoom['latestMessage']),
                            trailing: CircleAvatar(
                              backgroundColor: AppColors.normalBlue,
                              radius: 12,
                              child: Text(
                                chatRoom['unreadCount'][ref
                                        .watch(firebaseAuthProvider)
                                        .currentUser!
                                        .uid]
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class StatusBar extends StatelessWidget {
  StatusBar({super.key, required this.hasStatus});

  final List<String> statusMockImages = [
    'assets/photo1.jpeg',
    'assets/photo2.jpg',
    'assets/photo3.jpg',
    'assets/photo4.jpg',
  ];

  final bool hasStatus;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.20,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: statusMockImages.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              padding: EdgeInsets.all(4),
              width: MediaQuery.of(context).size.width * 0.20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey, width: 3),
              ),

              child:
                  hasStatus
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          fit: BoxFit.cover,
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTX9izQJS0uruCvLF5qiXSf9BxDHEDTP2s-Hw&s',
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return CircularProgressIndicator();
                          },
                          errorBuilder:
                              (context, error, stackTrace) => Icon(Icons.error),
                        ),
                      )
                      : Icon(Icons.add),
            );
          }
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 6),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.darkBlue, width: 3),
            ),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                width: MediaQuery.of(context).size.width * 0.20,

                fit: BoxFit.cover,
                statusMockImages[index],
                // loadingBuilder: (context, child, loadingProgress) {
                //   if (loadingProgress == null) return child;
                //   return CircularProgressIndicator();
                // },
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              ),
            ),
          );
        },
      ),
    );
  }
}

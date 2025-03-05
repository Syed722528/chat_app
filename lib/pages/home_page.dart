import 'package:flutter/material.dart';

import '../models/models.dart';
import '../provider.dart';
import '../utils/app_colors.dart';

class HomePage extends StatelessWidget {
  final bool hasStatus = false;
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.veryLightBlue,
        title: Text('Conversations'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.chat_bubble_outline)),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.lightBlue,
        width: MediaQuery.of(context).size.width * 0.60,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: [
              StatusBar(hasStatus: hasStatus),
              Divider(),
              SearchBar(),
              SearchResults(),
              ChatItemList(
                chats: [
                  ChatItem(
                    message: 'Hello',
                    name: 'Hassan',
                    time: '11:02 am',
                    unreadCount: 3,
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

class ChatItemList extends StatelessWidget {
  final List<ChatItem> chats;
  const ChatItemList({super.key, required this.chats});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: chats.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final chat = chats[index];
        return Container(
          margin: EdgeInsets.symmetric(vertical: 2),

          child: ListTile(
            hoverColor: AppColors.normalBlue,
            contentPadding: EdgeInsets.all(10),
            tileColor: AppColors.veryLightBlue,
            leading: CircleAvatar(
              radius: 35,
              backgroundColor: AppColors.lightBlue,
            ),
            title: Text(chat.name),
            subtitle: Text(chat.message),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(chat.time),
                CircleAvatar(
                  backgroundColor: AppColors.normalBlue,
                  radius: 8,
                  child: Text(
                    '1',
                    style: TextStyle(fontSize: 8, color: AppColors.whiteColor),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final query = _controller.text;

      setState(() {
        if (query.isEmpty) {
          searchResults = [];
        } else {
          searchResults =
              data
                  .where(
                    (item) => item.toLowerCase().contains(query.toLowerCase()),
                  )
                  .toList();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.08,
      child: TextField(
        controller: _controller,
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

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return searchResults.isNotEmpty
        ? ListView.builder(
          shrinkWrap: true,
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(searchResults[index]));
          },
        )
        : SizedBox.shrink();
  }
}

class StatusBar extends StatelessWidget {
  const StatusBar({super.key, required this.hasStatus});

  final bool hasStatus;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.20,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
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
              child: Image.network(
                width: MediaQuery.of(context).size.width * 0.15,

                fit: BoxFit.cover,
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTX9izQJS0uruCvLF5qiXSf9BxDHEDTP2s-Hw&s',
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return CircularProgressIndicator();
                },
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              ),
            ),
          );
        },
      ),
    );
  }
}

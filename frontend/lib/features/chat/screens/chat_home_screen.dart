import 'package:flutter/material.dart';
import 'package:signova/features/chat/service/chat_service.dart';
import 'package:signova/features/chat/screens/chat_screen.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  final TextEditingController searchController = TextEditingController();

  List sessions = [];
  List users = [];
  bool isLoading = false;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    loadSessions();
  }

  Future<void> loadSessions() async {
    setState(() => isLoading = true);

    try {
      final response = await ChatService().getSessions();
      sessions = response.data['data']['sessions'] ?? [];
    } catch (e) {
      debugPrint("Load sessions error: $e");
    }

    setState(() => isLoading = false);
  }

  Future<void> searchUsers() async {
    if (searchController.text.trim().isEmpty) return;

    setState(() {
      isSearching = true;
      users = [];
    });

    try {
      final response = await ChatService().searchUsers(
        searchController.text.trim(),
      );

      users = response.data['data']['results'] ?? [];
    } catch (e) {
      debugPrint("Search users error: $e");
    }

    setState(() => isSearching = false);
  }

  Future<void> startChat(String username) async {
    try {
      final response = await ChatService().startChat(username);

      final sessionId = response.data['data']['session_id'];

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            sessionId: sessionId,
            receiverUsername: username,
            isReceiverDeaf: false,
          ),
        ),
      ).then((_) {
        loadSessions();
      });
    } catch (e) {
      debugPrint("Start chat error: $e");
    }
  }

  void openSession(Map session) {
    final peer = session['peer'];
    final sessionId = session['session_id'];
    final username = peer?['username'] ?? 'Unknown';
    final isReceiverDeaf = peer?['isDeaf'] == true;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          sessionId: sessionId,
          receiverUsername: username,
          isReceiverDeaf: isReceiverDeaf,
        ),
      ),
    ).then((_) {
      loadSessions();
    });
  }
  String getLastMessageText(Map session) {
    final last = session['last_message'];

    if (last == null) return "No messages yet";

    final type = last['type'];
    final content = last['content'] ?? "";

    if (type == "image") return "📷 Image";
    if (type == "audio") return "🎧 Audio";
    if (type == "video") return "🎥 Video";

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: "Search username",
                    ),
                  ),
                ),
                IconButton(
                  onPressed: searchUsers,
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          ),

          if (isSearching) const CircularProgressIndicator(),

          if (users.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user['avatar'] != null
                          ? NetworkImage(user['avatar'])
                          : null,
                      child: user['avatar'] == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(user['username']),
                    subtitle: Text(user['phone'] ?? ''),
                    onTap: () {
                      startChat(user['username']);
                    },
                  );
                },
              ),
            )
          else
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                onRefresh: loadSessions,
                child: ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    final peer = session['peer'];
                    final username = peer?['username'] ?? 'Unknown';
                    final avatar = peer?['avatar'];

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                        avatar != null ? NetworkImage(avatar) : null,
                        child: avatar == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(username),
                      subtitle: Text(
                        getLastMessageText(session),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        openSession(session);
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
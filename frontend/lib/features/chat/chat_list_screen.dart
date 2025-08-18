import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../services/api_service.dart';
import '../../services/models.dart';
import 'chat_screen.dart';
import '../../core/widgets/asset_media.dart';
import '../../core/app_router.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ApiService _api = const ApiService();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppInsets.s16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Поиск чатов',
                prefixIcon: Icon(Icons.search),
                filled: true,
              ),
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
            ),
          ),
          const _SectionTitle('Фиксированный разговор'),
          FutureBuilder<List<ChatSummary>>(
            future: _api.getPinnedChats(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                );
              }
              final pinned = snapshot.data!;
              return SizedBox(
                height: 96,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: AppInsets.s16),
                  scrollDirection: Axis.horizontal,
                  itemCount: pinned.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => _PinnedChatItem(item: pinned[i]),
                ),
              );
            },
          ),
          const _SectionTitle('Все чаты'),
          Expanded(
            child: FutureBuilder<List<ChatSummary>>(
              future: _api.getChats(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var chats = snapshot.data!;
                if (_query.isNotEmpty) {
                  chats = chats.where((c) => c.name.toLowerCase().contains(_query)).toList();
                }
                return ListView.separated(
                  itemCount: chats.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.white10),
                  itemBuilder: (_, i) => _ChatTile(item: chats[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppInsets.s16, 8, AppInsets.s16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: const TextStyle(fontSize: 14, color: AppColors.secondaryText)),
      ),
    );
  }
}

class _PinnedChatItem extends StatelessWidget {
  final ChatSummary item;
  const _PinnedChatItem({required this.item});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(radius: 28, backgroundColor: Colors.transparent,
          child: assetImage(item.avatarAsset, width: 56, height: 56, circle: true),
        ),
        const SizedBox(height: 6),
        SizedBox(width: 80, child: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}

class _ChatTile extends StatelessWidget {
  final ChatSummary item;
  const _ChatTile({required this.item});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: Colors.transparent,
        child: assetImage(item.avatarAsset, width: 40, height: 40, circle: true),
      ),
      title: Text(item.name),
      subtitle: Text(item.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.secondaryText)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(item.time, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
          if (item.unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accentBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('${item.unreadCount}', style: const TextStyle(fontSize: 12)),
            ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          fadeRoute(ChatScreen.placeholderFromSummary(item: item)),
        );
      },
    );
  }
}



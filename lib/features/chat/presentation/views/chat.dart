import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nopin_creative/core/constants/assets.dart';
import 'package:nopin_creative/core/constants/colors.dart';
import 'package:nopin_creative/core/shared/responsive/responsive_layout.dart';
import 'package:nopin_creative/features/chat/data/models/chat.dart';
import 'package:nopin_creative/features/chat/presentation/views/messages.dart';
import 'package:nopin_creative/features/home/data/models/property.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Chat> _filteredChats = [];

  @override
  void initState() {
    super.initState();
    _filteredChats = List.from(dummyChats);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterChats(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredChats = List.from(dummyChats);
      } else {
        _filteredChats = dummyChats
            .where((chat) =>
                chat.users[0].toLowerCase().contains(query.toLowerCase()) ||
                chat.fromProperty.title
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                chat.messages.last.body
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('pt_BR_short', timeago.PtBrShortMessages());
    final isTablet = ResponsiveLayout.isTablet(context);
    final accentColor = AppColors.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 1.0,
        backgroundColor: Colors.white,
        title: _isSearching
            ? _buildSearchField()
            : Text(
                "Mensagens",
                style: GoogleFonts.poppins(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? CupertinoIcons.xmark : CupertinoIcons.search,
              color: Colors.black87,
              size: isTablet ? 24 : 22,
            ),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  _filterChats('');
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          if (!_isSearching)
            IconButton(
              icon: Icon(
                CupertinoIcons.ellipsis_vertical,
                color: Colors.black87,
                size: isTablet ? 24 : 22,
              ),
              onPressed: () {
                // Show chat options menu
              },
            ),
        ],
      ),
      body: _filteredChats.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                final chat = _filteredChats[index];
                final lastMessageTime = chat.messages.last.time;
                final isLastMessageMine = chat.messages.last.from == "user_1";

                return ChatListItem(
                  chat: chat,
                  isLastMessageMine: isLastMessageMine,
                  lastMessageTime: lastMessageTime,
                  accentColor: accentColor,
                  isTablet: isTablet,
                );
              },
              itemCount: _filteredChats.length,
            ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      style: TextStyle(color: Colors.black87, fontSize: 16),
      decoration: InputDecoration(
        hintText: 'Pesquisar conversas...',
        hintStyle: TextStyle(color: Colors.black54),
        border: InputBorder.none,
      ),
      onChanged: _filterChats,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.chat_bubble_2,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            _isSearching
                ? "Nenhuma conversa encontrada"
                : "Suas mensagens aparecerão aqui",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isSearching
                ? "Tente outro termo de pesquisa"
                : "Comece uma conversa ao visualizar uma propriedade",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ChatListItem extends StatelessWidget {
  final Chat chat;
  final bool isLastMessageMine;
  final DateTime lastMessageTime;
  final Color accentColor;
  final bool isTablet;

  const ChatListItem({
    super.key,
    required this.chat,
    required this.isLastMessageMine,
    required this.lastMessageTime,
    required this.accentColor,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(
      lastMessageTime.year,
      lastMessageTime.month,
      lastMessageTime.day,
    );

    String timeText;
    if (messageDate == today) {
      // Format as time only if today
      timeText =
          '${lastMessageTime.hour}:${lastMessageTime.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == yesterday) {
      timeText = 'Ontem';
    } else {
      // Format as date for older messages
      timeText = '${lastMessageTime.day}/${lastMessageTime.month}';
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MessagesView(chat: chat),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatar(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            chat.users[0],
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          timeText,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      chat.fromProperty.title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: accentColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (isLastMessageMine)
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.checkmark_alt,
                                size: 12,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                            ],
                          ),
                        Expanded(
                          child: Text(
                            chat.messages.last.body,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!isLastMessageMine && chat.messages.length > 1)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "1",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final propertyType = chat.fromProperty.type;
    final bgColors = {
      PropertyType.house: Colors.blue.shade100,
      PropertyType.rent: Colors.green.shade100,
      PropertyType.land: Colors.orange.shade100,
    };

    return Stack(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: bgColors[propertyType] ?? Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              chat.users[0][0].toUpperCase(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

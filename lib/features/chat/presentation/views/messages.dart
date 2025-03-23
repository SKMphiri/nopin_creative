import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nopin_creative/core/constants/assets.dart';
import 'package:nopin_creative/core/constants/colors.dart';
import 'package:nopin_creative/core/shared/responsive/responsive_layout.dart';
import 'package:nopin_creative/core/shared/widgets/property_attribure.dart';
import 'package:nopin_creative/features/chat/data/models/chat.dart';
import 'package:nopin_creative/features/home/data/models/property.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({super.key, required this.chat});

  final Chat chat;

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String _currentUserId = "user_1";
  bool _showPropertyInfo = false;
  bool _showPropertyReference = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.chat.messages.isNotEmpty) {
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage({bool includeProperty = false}) {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        widget.chat.messages.add(
          Message(
            from: _currentUserId,
            body: message,
            time: DateTime.now(),
            includesProperty: includeProperty,
          ),
        );
        _messageController.clear();
      });

      setState(() {
        _showPropertyReference = false;
      });

      // Scroll after the list has been updated
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  String _getPropertyImage() {
    switch (widget.chat.fromProperty.type) {
      case PropertyType.house:
        return AppImages.beachHouse;
      case PropertyType.rent:
        return AppImages.beachHouse2;
      case PropertyType.land:
        return AppImages.land;
      default:
        return AppImages.house;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveLayout.isTablet(context);
    final accentColor = AppColors.primary;
    final property = widget.chat.fromProperty;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: GestureDetector(
          onTap: () {
            setState(() {
              _showPropertyInfo = !_showPropertyInfo;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildContactAvatar(),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.chat.users[0],
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Online agora",
                      style: TextStyle(
                        fontSize: isTablet ? 12 : 11,
                        color: Colors.green,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.phone,
              color: accentColor,
              size: isTablet ? 24 : 22,
            ),
            onPressed: () {
              // Handle call action
            },
          ),
          IconButton(
            icon: Icon(
              CupertinoIcons.ellipsis_vertical,
              color: Colors.black87,
              size: isTablet ? 24 : 22,
            ),
            onPressed: () {
              // Show chat options
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Property info card - collapsible
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _showPropertyInfo ? (isTablet ? 120 : 100) : 0,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: _buildPropertyInfoCard(property, accentColor, isTablet),
            ),
          ),

          // Chat messages
          Expanded(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ListView.builder(
                controller: _scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: widget.chat.messages.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final message = widget.chat.messages[index];
                  final isMe = message.from == _currentUserId;

                  // Check if we should display the date header
                  final bool showDateHeader = index == 0 ||
                      !_isSameDay(
                          widget.chat.messages[index - 1].time, message.time);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (showDateHeader) _buildDateHeader(message.time),
                      _buildMessageBubble(message, isMe, accentColor),
                      if (message.includesProperty == true)
                        _buildPropertyReferenceCard(
                            property, accentColor, isTablet),
                    ],
                  );
                },
              ),
            ),
          ),

          // Property reference composer (when active)
          if (_showPropertyReference)
            _buildPropertyReferenceComposer(property, accentColor, isTablet),

          // Message input
          _buildMessageInputBar(accentColor, isTablet),
        ],
      ),
    );
  }

  Widget _buildContactAvatar() {
    final propertyType = widget.chat.fromProperty.type;
    final bgColors = {
      PropertyType.house: Colors.blue.shade100,
      PropertyType.rent: Colors.green.shade100,
      PropertyType.land: Colors.orange.shade100,
    };

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColors[propertyType] ?? Colors.grey.shade100,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          widget.chat.users[0][0].toUpperCase(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyInfoCard(
      Property property, Color accentColor, bool isTablet) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.asset(
              _getPropertyImage(),
              width: isTablet ? 100 : 80,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    property.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "MZN ${property.price.toStringAsFixed(0)}${property.type == PropertyType.rent ? '/mês' : ''}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.location_solid,
                        size: 12,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              CupertinoIcons.chevron_right,
              size: 20,
              color: Colors.grey.shade400,
            ),
            onPressed: () {
              // Navigate to property details
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyReferenceCard(
      Property property, Color accentColor, bool isTablet) {
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 16, left: 48, right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
              child: Image.asset(
                _getPropertyImage(),
                width: 60,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      property.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "MZN ${property.price.toStringAsFixed(0)}${property.type == PropertyType.rent ? '/mês' : ''}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.location_solid,
                          size: 10,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            property.location,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyReferenceComposer(
      Property property, Color accentColor, bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Referenciando propriedade",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  CupertinoIcons.xmark_circle_fill,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() {
                    _showPropertyReference = false;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  _getPropertyImage(),
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "MZN ${property.price.toStringAsFixed(0)}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(DateTime messageTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(
      messageTime.year,
      messageTime.month,
      messageTime.day,
    );

    String dateText;
    if (messageDate == today) {
      dateText = 'Hoje';
    } else if (messageDate == yesterday) {
      dateText = 'Ontem';
    } else {
      dateText = '${messageDate.day}/${messageDate.month}/${messageDate.year}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Divider(color: Colors.grey.shade300),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              dateText,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Divider(color: Colors.grey.shade300),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isMe, Color accentColor) {
    final time =
        '${message.time.hour}:${message.time.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            _buildMessageAvatar(),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              decoration: BoxDecoration(
                color: isMe ? accentColor : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isMe
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: isMe
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.body,
                    style: TextStyle(
                      fontSize: 15,
                      color: isMe ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 10,
                          color: isMe
                              ? Colors.white.withOpacity(0.7)
                              : Colors.grey.shade500,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          CupertinoIcons.checkmark_alt,
                          size: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildMessageAvatar() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          widget.chat.users[0][0].toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInputBar(Color accentColor, bool isTablet) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -1),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          _showPropertyReference
              ? IconButton(
                  icon: Icon(
                    CupertinoIcons.house_fill,
                    color: accentColor,
                    size: 22,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPropertyReference = false;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(
                    CupertinoIcons.house,
                    color: Colors.grey.shade600,
                    size: 22,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPropertyReference = true;
                    });
                  },
                ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Digite uma mensagem...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: accentColor,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () =>
                  _sendMessage(includeProperty: _showPropertyReference),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  CupertinoIcons.arrow_up,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

import 'package:flutter/material.dart';
import 'package:nopin_creative/core/constants/colors.dart';
import 'package:nopin_creative/features/chat/data/models/chat.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({super.key, required this.chat});

  final Chat chat;

  @override
  _MessagesViewState createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.users[0]),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: Column(
        children: [
          // Messages ListView
          Expanded(
            child: ListView.builder(
              itemCount: widget.chat.messages.length,
              itemBuilder: (context, index) {
                final message = widget.chat.messages[index];
                return ListTile(
                  title: Text(message.from),
                  subtitle: Text(message.body),
                  trailing: Text(
                    '${message.time.hour}:${message.time.minute < 10 ? '0${message.time.minute}' : message.time.minute}',
                  ),
                );
              },
            ),
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0 * 2, vertical: 8.0),
            decoration: BoxDecoration(color: Color(0xFFE9E9E9)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Digite uma mensagem...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                      )),
                  onPressed: () {
                    // Send message functionality
                    final message = _controller.text;
                    if (message.isNotEmpty) {
                      setState(() {
                        widget.chat.messages.add(
                          Message(
                            from: widget.chat.users[0],
                            body: message,
                            time: DateTime.now(),
                          ),
                        );
                        _controller.clear(); // Clear the input after sending
                      });
                    }
                  },
                  icon: Transform.scale(
                      scale: -1,
                      child: const Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

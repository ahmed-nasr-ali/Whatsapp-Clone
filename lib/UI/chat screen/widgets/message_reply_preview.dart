// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable, must_be_immutable

import 'package:flutter/material.dart';
import 'package:chat_app/provider/message%20reply/message_reply_provider.dart';
import 'package:provider/provider.dart';

class MessageReplyPreview extends StatefulWidget {
  const MessageReplyPreview({
    Key? key,
  }) : super(key: key);

  @override
  State<MessageReplyPreview> createState() => _MessageReplyPreviewState();
}

class _MessageReplyPreviewState extends State<MessageReplyPreview> {
  @override
  Widget build(BuildContext context) {
    final messageReply =
        Provider.of<MessageReplyProvider>(context, listen: false);
    return Container(
      width: 350,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  messageReply.isMe! ? "You" : "Oppsite",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Provider.of<MessageReplyProvider>(context, listen: false)
                      .setIsSwipe(false);
                },
                child: Icon(
                  Icons.close,
                  size: 16,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            messageReply.message!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

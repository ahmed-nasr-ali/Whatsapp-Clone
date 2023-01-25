// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, unused_local_variable

import 'package:chat_app/commons/enums/message_enum.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/provider/message%20reply/message_reply_provider.dart';
import 'package:chat_app/shared%20prefrence/shared_prefrence.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/UI/chat%20screen/widgets/my_message_card.dart';
import 'package:chat_app/UI/chat%20screen/widgets/sender_message_card.dart';
import 'package:chat_app/provider/chat%20methods/chat_methods.dart';

class ChatScreenBody extends StatefulWidget {
  String reciverId;
  ChatScreenBody({
    Key? key,
    required this.reciverId,
  }) : super(key: key);

  @override
  State<ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();

    messageController.dispose();
  }

  messageSwipeMethod(String message, bool isMe, MessageEnum messageEnum) {
    Provider.of<MessageReplyProvider>(context, listen: false).setIsSwipe(true);

    Provider.of<MessageReplyProvider>(context, listen: false)
        .setMessageReplyData(
      message,
      isMe,
      messageEnum,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: Provider.of<ChatMethodeProvider>(context, listen: false)
            .getChatStream(widget.reciverId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          });

          return ListView.builder(
              controller: messageController,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final messageData = snapshot.data![index];
                var timeSend = DateFormat.Hm().format(messageData.timeSent);
                if (messageData.senderId == UserData.getUserphoneNumber()) {
                  return MyMessageCard(
                    message: messageData.text,
                    date: timeSend,
                    type: messageData.type,
                    repliedText: messageData.repliedMessage,
                    username: messageData.repliedTo,
                    repliedMessageType: messageData.repliedMessageType,
                    onLeftSwipe: () => messageSwipeMethod(
                      messageData.text,
                      true,
                      messageData.type,
                    ),
                  );
                } else {
                  return SenderMessageCard(
                    message: messageData.text,
                    date: timeSend,
                    type: messageData.type,
                  );
                }
              });
        });
  }
}

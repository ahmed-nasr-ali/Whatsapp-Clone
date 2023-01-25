// ignore_for_file: prefer_const_constructors, must_be_immutable, unnecessary_string_interpolations

import 'package:chat_app/UI/chat%20screen/chat_screen_body.dart';
import 'package:chat_app/custom%20widgets/small%20text/small_text.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/provider/auth/auth_provider.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:chat_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/custom%20widgets/connectivity/network_indicator.dart';
import 'package:chat_app/custom%20widgets/safe_area/page_container.dart';
import 'package:provider/provider.dart';

import 'widgets/bottom_chat_field.dart';

class ChatScreen extends StatefulWidget {
  String userName;
  String userUid;
  ChatScreen({
    Key? key,
    required this.userName,
    required this.userUid,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    // print(widget.userName);

    // print(widget.userUid);
  }

  @override
  Widget build(BuildContext context) {
    return NetworkIndicator(
      child: PageContainer(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor,
            title: StreamBuilder<UserModel>(
                stream: Provider.of<AuthProvider>(context, listen: false)
                    .userData(widget.userUid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SmallText(text: "${widget.userName}");
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.userName),
                      SmallText(
                        text: snapshot.data!.isOnline ? 'online' : 'offline',
                        color: whiteColor,
                        size: 13,
                      )
                    ],
                  );
                }),
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.video_call),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.call),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                  child: ChatScreenBody(
                reciverId: widget.userUid,
              )),
              BottomChatField(
                reciverUserID: widget.userUid,
              )
            ],
          ),
        ),
      ),
    );
  }
}

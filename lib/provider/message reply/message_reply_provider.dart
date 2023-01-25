// ignore_for_file: avoid_print

import 'package:chat_app/commons/enums/message_enum.dart';
import 'package:flutter/cupertino.dart';

class MessageReplyProvider extends ChangeNotifier {
  bool isSwipe = false;

  String? message;
  bool? isMe;
  MessageEnum? messageEnum;

  setIsSwipe(bool swipeType) {
    isSwipe = swipeType;
    print(isSwipe);
    notifyListeners();
  }

  setMessageReplyData(
      String? messagetext, bool? isme, MessageEnum? messagetype) {
    message = messagetext;
    isMe = isme;
    messageEnum = messagetype;

    notifyListeners();
  }
}

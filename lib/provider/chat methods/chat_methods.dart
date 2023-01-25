// ignore_for_file: unused_local_variable, unused_element, prefer_const_constructors

import 'dart:io';

import 'package:chat_app/commons/common_firebase_method.dart';
import 'package:chat_app/commons/enums/message_enum.dart';
import 'package:chat_app/custom%20widgets/snakbar%20widget/snakbar.dart';
import 'package:chat_app/models/chat_contact.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/provider/message%20reply/message_reply_provider.dart';
import 'package:chat_app/shared%20prefrence/shared_prefrence.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class ChatMethodeProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId, // to get reciver user collection
    required UserModel senderUser,
    required MessageReplyProvider? messageReplyProvider,
  }) async {
    try {
      DateTime time = DateTime.now();

      var messageId = Uuid().v1();

      UserModel reciveruserData;

      var userDataMap =
          await firestore.collection("Users").doc(recieverUserId).get();

      reciveruserData =
          UserModel.fromMap(userDataMap.data()!); // get reciver user all data

      _saveDtaTOContactSubCollection(
        senderUser,
        reciveruserData,
        text,
        time,
        recieverUserId,
      );

      _saveMessageToMessageCollection(
        reciverUserId: recieverUserId,
        reciverUserName: reciveruserData.name,
        userName: senderUser.name,
        userId: senderUser.uid,
        text: text,
        timeSend: time,
        messageType: MessageEnum.text,
        messageId: messageId,
        messageReplyProvider: messageReplyProvider,
        senderUserName: senderUser.name,
        reciverUserDate: reciveruserData.name,
      );
    } catch (e) {
      snakBarWidget(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String reciverUserId,
    required UserModel senderUser,
    required MessageEnum messageEnum,
    required MessageReplyProvider? messageReplyProvider,
  }) async {
    try {
      var timeSent = DateTime.now();

      var messageId = const Uuid().v1();

      String imageUrl = await storeFileToFirebase(
        'Chat/${messageEnum.type}/${senderUser.uid}/$reciverUserId/$messageId',
        file,
      );

      UserModel reciverUserDate;

      var userDataMap =
          await firestore.collection("Users").doc(reciverUserId).get();

      reciverUserDate = UserModel.fromMap(userDataMap.data()!);

      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.video:
          contactMsg = '📸 Video';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵 Audio';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
        default:
          contactMsg = 'GIF';
      }
      _saveDtaTOContactSubCollection(
        senderUser,
        reciverUserDate,
        contactMsg,
        timeSent,
        reciverUserId,
      );

      _saveMessageToMessageCollection(
        reciverUserId: reciverUserId,
        reciverUserName: reciverUserDate.name,
        userName: senderUser.name,
        userId: senderUser.uid,
        text: imageUrl,
        timeSend: timeSent,
        messageId: messageId,
        messageType: messageEnum,
        messageReplyProvider: messageReplyProvider,
        senderUserName: senderUser.name,
        reciverUserDate: reciverUserDate.name,
      );
    } catch (e) {
      snakBarWidget(context: context, content: e.toString());
    }
  }

  _saveDtaTOContactSubCollection(
    UserModel senderUserData,
    UserModel recieverUserData,
    String text,
    DateTime timeSend,
    String reciveUserID,
  ) async {
    ///user -> reciver user id => Chat collection -> current user Id -> set data
    var reciverContactChat = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timeSent: timeSend,
      lastMessage: text,
    );

    firestore
        .collection("Users")
        .doc(reciveUserID)
        .collection("Chats")
        .doc(senderUserData.uid)
        .set(reciverContactChat.toMap());

    ///user -> current user Id => Chat collection -> reciver user id-> set data
    var senderContactChat = ChatContact(
      name: recieverUserData.name,
      profilePic: recieverUserData.profilePic,
      contactId: recieverUserData.uid,
      timeSent: timeSend,
      lastMessage: text,
    );

    firestore
        .collection("Users")
        .doc(senderUserData.uid)
        .collection("Chats")
        .doc(recieverUserData.uid)
        .set(senderContactChat.toMap());
  }

  _saveMessageToMessageCollection({
    required String reciverUserId,
    required String reciverUserName,
    required String userName,
    required String userId,
    required String text,
    required DateTime timeSend,
    required String messageId,
    required MessageEnum messageType,
    required MessageReplyProvider? messageReplyProvider,
    required String senderUserName,
    required String reciverUserDate,
  }) async {
    final message = Message(
      senderId: userId,
      recieverid: reciverUserId,
      text: text,
      type: messageType,
      timeSent: timeSend,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReplyProvider!.message == null
          ? ""
          : messageReplyProvider.message!,
      repliedTo: messageReplyProvider.isMe == null
          ? ""
          : messageReplyProvider.isMe!
              ? senderUserName
              : reciverUserDate,
      repliedMessageType: messageReplyProvider.messageEnum ?? MessageEnum.text,
    );

    ///User -> current user id => Chats collection -> reciver id => Message colloction -> message id -> store message
    await firestore
        .collection("Users")
        .doc(userId)
        .collection("Chats")
        .doc(reciverUserId)
        .collection("Messages")
        .doc(messageId)
        .set(message.toMap());

    ///User -> reciver user id => Chats collection -> current user id  => Message colloction -> message id -> store message

    await firestore
        .collection("Users")
        .doc(reciverUserId)
        .collection("Chats")
        .doc(userId)
        .collection("Messages")
        .doc(messageId)
        .set(message.toMap());
  }

  ///Get users List
  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection("Users")
        .doc(UserData.getUserphoneNumber())
        .collection("Chats")
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];

      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());

        var userData = await firestore
            .collection("Users")
            .doc(chatContact.contactId)
            .get();

        var user = UserModel.fromMap(userData.data()!);

        contacts.add(
          ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  Stream<List<Message>> getChatStream(String reciverUserId) {
    return firestore
        .collection("Users")
        .doc(UserData.getUserphoneNumber())
        .collection("Chats")
        .doc(reciverUserId)
        .collection("Messages")
        .orderBy("timeSent")
        .snapshots()
        .map((event) {
      List<Message> message = [];

      for (var document in event.docs) {
        message.add(
          Message.fromMap(
            document.data(),
          ),
        );
      }
      return message;
    });
  }
}

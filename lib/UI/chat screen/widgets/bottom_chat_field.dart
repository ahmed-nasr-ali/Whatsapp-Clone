// ignore_for_file: sort_child_properties_last, prefer_const_constructors, must_be_immutable, avoid_print, unused_local_variable, unused_field, unnecessary_null_comparison, unused_import

import 'dart:convert';
import 'dart:io';

import 'package:chat_app/UI/chat%20screen/widgets/message_reply_preview.dart';
import 'package:chat_app/commons/enums/message_enum.dart';
import 'package:chat_app/custom%20widgets/snakbar%20widget/snakbar.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/provider/message%20reply/message_reply_provider.dart';
import 'package:chat_app/shared%20prefrence/shared_prefrence.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/provider/chat%20methods/chat_methods.dart';
import 'package:chat_app/utils/color.dart';

class BottomChatField extends StatefulWidget {
  String reciverUserID;
  BottomChatField({
    Key? key,
    required this.reciverUserID,
  }) : super(key: key);

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  bool isShowSendButton = false;

  final TextEditingController _messageController = TextEditingController();

  FocusNode focusNode = FocusNode();

  bool isShowEmojiContainer = false;

  UserModel? usedModel;

  FlutterSoundRecorder? _soundRecorder;

  bool isRecorderInit = false;

  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    usedModel = UserModel.fromMap(json.decode(UserData.getUserModel()!));

    _soundRecorder = FlutterSoundRecorder();

    openAudio();
    // print(usedModel!.uid);
  }

  void openAudio() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      snakBarWidget(context: context, content: 'Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      final messageReply =
          Provider.of<MessageReplyProvider>(context, listen: false);

      Provider.of<ChatMethodeProvider>(context, listen: false).sendTextMessage(
        context: context,
        text: _messageController.text.trim(),
        recieverUserId: widget.reciverUserID,
        senderUser: usedModel!,
        messageReplyProvider: messageReply,
      );

      setState(() {
        _messageController.text = "";

        isShowSendButton = false;
      });
    } else {
      var tempDir = await getTemporaryDirectory();

      var path = '${tempDir.path}/flutter_sound.aac';

      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();

        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }

      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    final messageReply =
        Provider.of<MessageReplyProvider>(context, listen: false);

    Provider.of<ChatMethodeProvider>(context, listen: false).sendFileMessage(
      context: context,
      file: file,
      reciverUserId: widget.reciverUserID,
      senderUser: usedModel!,
      messageEnum: messageEnum,
      messageReplyProvider: messageReply,
    );
  }

  void selectImage() async {
    File? imageFile = await pickImageFromGallery(context);

    if (imageFile != null) {
      sendFileMessage(
        imageFile,
        MessageEnum.image,
      );
    }
  }

  void selectVideo() async {
    File? videoFile = await pickVideoFromGallery(context);

    if (videoFile != null) {
      sendFileMessage(
        videoFile,
        MessageEnum.video,
      );
    }
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  String serverToken =
      "AAAAPnWxVS0:APA91bG76xvgiqujkawASMhs42vg2Y6Fd1WbtjrBKMLtyR0ZHXWBDIw2e6AoPhLXhtoaBpeplb_myichuHo5OT2khX2Mp9GNKWIP448kaX762dVOhEGGaOHIXXpaPBSwFrWuQKSRwuwb";

  sendNotification(String title, String body, String id) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'name': 'ahmed'
          },
          'to': await FirebaseMessaging.instance.getToken(),
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<MessageReplyProvider>(builder: (context, value, child) {
          return value.isSwipe ? MessageReplyPreview() : SizedBox();
        }),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: _messageController,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: toggleEmojiKeyboardContainer,
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await sendNotification(
                                  "hi ahmed", 'welcome to chat app', "1");
                            },
                            icon: const Icon(
                              Icons.gif,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: selectVideo,
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
                right: 2,
                left: 2,
              ),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF128C7E),
                radius: 25,
                child: GestureDetector(
                  child: Icon(
                    isShowSendButton
                        ? Icons.send
                        : isRecording
                            ? Icons.close
                            : Icons.mic,
                    color: Colors.white,
                  ),
                  onTap: sendTextMessage,
                ),
              ),
            ),
          ],
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: ((category, emoji) {
                    setState(() {
                      _messageController.text =
                          _messageController.text + emoji.emoji;
                    });

                    if (!isShowSendButton) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    }
                  }),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

// ignore_for_file: must_be_immutable, prefer_const_constructors, unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/UI/chat%20screen/widgets/video_player_item.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chat_app/commons/enums/message_enum.dart';

class DisplayTextImageGif extends StatelessWidget {
  String message;
  MessageEnum type;
  DisplayTextImageGif({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;

    final AudioPlayer audioPlayer = AudioPlayer();

    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.audio
            ? StatefulBuilder(builder: (context, setState) {
                return IconButton(
                  constraints: BoxConstraints(
                    minWidth: 100,
                  ),
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();

                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      await audioPlayer.play(UrlSource(message));

                      setState(() {
                        isPlaying = true;
                      });
                    }
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_circle,
                  ),
                );
              })
            : type == MessageEnum.video
                ? VideoPlayerItem(videoUrl: message)
                : CachedNetworkImage(imageUrl: message);
  }
}

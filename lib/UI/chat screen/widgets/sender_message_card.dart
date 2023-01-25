// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:chat_app/UI/chat%20screen/widgets/display_text_image_gif.dart';
import 'package:chat_app/commons/enums/message_enum.dart';
import 'package:chat_app/utils/color.dart';
import 'package:flutter/material.dart';

class SenderMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;

  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: messageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: type == MessageEnum.text
                    ? EdgeInsets.only(
                        left: 10,
                        right: 30,
                        top: 5,
                        bottom: 20,
                      )
                    : EdgeInsets.only(
                        left: 5,
                        right: 5,
                        top: 5,
                        bottom: 25,
                      ),
                child: DisplayTextImageGif(
                  message: message,
                  type: type,
                ),
              ),
              Positioned(
                bottom: 2,
                right: 10,
                child: Text(
                  date,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    //  ConstrainedBox(
    //   constraints: BoxConstraints(
    //     maxWidth: MediaQuery.of(context).size.width - 45,
    //   ),
    //   child: Card(
    //     elevation: 1,
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    //     color: senderMessageColor,
    //     margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    //     child: Stack(
    //       children: [
    //         Padding(
    //           padding: type == MessageEnum.text
    //               ? const EdgeInsets.only(
    //                   left: 10,
    //                   right: 30,
    //                   top: 5,
    //                   bottom: 20,
    //                 )
    //               : const EdgeInsets.only(
    //                   left: 5,
    //                   top: 5,
    //                   right: 5,
    //                   bottom: 25,
    //                 ),
    //           child: Column(
    //             children: [SmallText(text: message)],
    //           ),
    //         ),
    //         Positioned(
    //           bottom: 2,
    //           right: 10,
    //           child: Text(
    //             date,
    //             style: TextStyle(
    //               fontSize: 13,
    //               color: Colors.grey[600],
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

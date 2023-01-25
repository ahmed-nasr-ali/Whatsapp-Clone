import 'package:chat_app/custom%20widgets/small%20text/small_text.dart';
import 'package:chat_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

void snakBarWidget({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: SmallText(
        text: content,
        size: 12,
        typeOfFontWieght: 1,
        color: whiteColor,
      ),
      backgroundColor: mainAppColor,
    ),
  );
}

// ignore_for_file: use_key_in_widget_constructors

import 'dart:io';
import 'package:chat_app/utils/color.dart';
import 'package:flutter/material.dart';

class PageContainer extends StatelessWidget {
  final Widget? child;
  const PageContainer({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Platform.isIOS ? Colors.white : backgroundColor,
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: child,
          ),
        ));
  }
}

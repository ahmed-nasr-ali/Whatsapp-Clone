// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, prefer_if_null_operators, deprecated_member_use, unnecessary_new, unnecessary_null_comparison, unnecessary_string_interpolations

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color btnColor;
  final String btnLbl;
  final bool enableHorizontalMargin;
  final bool enableVerticalMargin;
  final bool enableCircleBorder;
  final double? height;
  final double? width;
  final Function onPressedFunction;
  final TextStyle btnStyle;
  final Color borderColor;
  double horizontalMargin;
  double verticalMargin;
  double boderRaduis;

  CustomButton({
    required this.btnLbl,
    required this.onPressedFunction,
    required this.btnColor,
    required this.btnStyle,
    required this.borderColor,
    this.enableHorizontalMargin = true,
    this.enableVerticalMargin = true,
    this.enableCircleBorder = false,
    this.height,
    this.width,
    this.horizontalMargin = 0,
    this.verticalMargin = 0,
    this.boderRaduis = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height == null ? 50 : height,
        width: width == null ? 400 : width,
        margin: EdgeInsets.symmetric(
            horizontal: enableHorizontalMargin
                ? horizontalMargin == 0
                    ? MediaQuery.of(context).size.width * 0.05
                    : horizontalMargin
                : 0.0,
            vertical: enableVerticalMargin
                ? verticalMargin == 0
                    ? MediaQuery.of(context).size.height * 0.01
                    : verticalMargin
                : 0.0),
        child: Builder(
            builder: (context) => RaisedButton(
                  onPressed: () {
                    onPressedFunction();
                  },
                  elevation: 0,
                  shape: new RoundedRectangleBorder(
                      side: BorderSide(
                          color: borderColor != null
                              ? borderColor
                              : btnColor != null
                                  ? btnColor
                                  : Theme.of(context).primaryColor),
                      borderRadius: new BorderRadius.circular(enableCircleBorder
                          ? 25
                          : boderRaduis == 0
                              ? 10.0
                              : boderRaduis)),
                  color: btnColor != null
                      ? btnColor
                      : Theme.of(context).primaryColor,
                  child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$btnLbl',
                            style: btnStyle == null
                                ? Theme.of(context).textTheme.button
                                : btnStyle,
                          ),
                        ],
                      )),
                )));
  }
}

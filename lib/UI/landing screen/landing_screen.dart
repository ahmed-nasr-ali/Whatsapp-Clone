// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_app/UI/auth%20screens/auth_screen.dart';
import 'package:chat_app/custom%20widgets/bottom/custom_button.dart';
import 'package:chat_app/custom%20widgets/connectivity/network_indicator.dart';
import 'package:chat_app/custom%20widgets/safe_area/page_container.dart';
import 'package:chat_app/utils/color.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return NetworkIndicator(
      child: PageContainer(
        child: Scaffold(
          body: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'Welcome to WhatsApp',
                    style: TextStyle(
                      fontSize: 33,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: size.height / 9),
                  Image.asset(
                    'assets/bg.png',
                    height: 340,
                    width: 340,
                    color: tabColor,
                  ),
                  SizedBox(height: size.height / 9),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
                      style: TextStyle(color: greyColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                      enableVerticalMargin: false,
                      enableHorizontalMargin: true,
                      horizontalMargin: 50, //115
                      width: MediaQuery.of(context).size.width,
                      height: 50, //50
                      btnLbl: 'AGREE AND CONTINUE',
                      onPressedFunction: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AuthScreen(),
                          ),
                        );
                      },
                      btnColor: tabColor,
                      btnStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontSize: 14),
                      borderColor: tabColor),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: unused_local_variable, prefer_const_constructors, unused_element, avoid_print

import 'package:chat_app/custom%20widgets/bottom/custom_button.dart';
import 'package:chat_app/custom%20widgets/connectivity/network_indicator.dart';
import 'package:chat_app/custom%20widgets/safe_area/page_container.dart';
import 'package:chat_app/provider/auth/auth_provider.dart';
import 'package:chat_app/shared%20prefrence/shared_prefrence.dart';
import 'package:chat_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final phoneController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void sendPhoneNumberTofirebase() {
    String phoneNumber = phoneController.text.trim();
    print("+2$phoneNumber");
    Provider.of<AuthProvider>(context, listen: false)
        .signINwhitPhone(context, "+2$phoneNumber");

    UserData.setUserphoneNumber("+2$phoneNumber");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return NetworkIndicator(
      child: PageContainer(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Enter your phone number'),
            elevation: 0,
            backgroundColor: backgroundColor,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('WhatsApp will need to verify your phone number.'),
                  const SizedBox(height: 10),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text('+2'),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: size.width * 0.7,
                        child: TextField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                            hintText: 'phone number',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.6),
                  CustomButton(
                      enableVerticalMargin: false,
                      enableHorizontalMargin: true,
                      horizontalMargin: 100, //115
                      width: MediaQuery.of(context).size.width,
                      height: 50, //50
                      btnLbl: 'NEXT',
                      onPressedFunction: sendPhoneNumberTofirebase,
                      btnColor: tabColor,
                      btnStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          fontSize: 14),
                      borderColor: tabColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

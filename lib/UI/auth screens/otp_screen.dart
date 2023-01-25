// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:chat_app/custom%20widgets/connectivity/network_indicator.dart';
import 'package:chat_app/custom%20widgets/safe_area/page_container.dart';
import 'package:chat_app/provider/auth/auth_provider.dart';
import 'package:chat_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  String verficationId;
  OtpScreen({
    Key? key,
    required this.verficationId,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  void verfyOtp(BuildContext context, String userOTP) {
    Provider.of<AuthProvider>(context, listen: false).verfiyOtp(
      context: context,
      verificationId: widget.verficationId,
      userOtp: userOTP,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return NetworkIndicator(
        child: PageContainer(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Verifying your number'),
          elevation: 0,
          backgroundColor: backgroundColor,
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text('We have sent an SMS with a code.'),
              SizedBox(
                width: size.width * 0.5,
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: '- - - - - -',
                    hintStyle: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    if (val.length == 6) {
                      // verifyOTP(ref, context, val.trim());
                      verfyOtp(context, val.trim());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

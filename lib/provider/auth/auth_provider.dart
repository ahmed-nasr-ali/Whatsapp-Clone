// ignore_for_file: unused_local_variable, prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:chat_app/UI/auth%20screens/otp_screen.dart';
import 'package:chat_app/UI/auth%20screens/user_information.dart';
import 'package:chat_app/UI/home%20screen/home_screen.dart';
import 'package:chat_app/commons/common_firebase_method.dart';
import 'package:chat_app/custom%20widgets/snakbar%20widget/snakbar.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/shared%20prefrence/shared_prefrence.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  signINwhitPhone(BuildContext context, String phoneNumber) async {
    try {
      final auth = FirebaseAuth.instance;
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            throw Exception(e.message);
          },
          codeSent: ((String verficationId, int? resendToken) async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => OtpScreen(
                          verficationId: verficationId,
                        )));
          }),
          codeAutoRetrievalTimeout: (String verficationId) {});
    } on FirebaseAuthException catch (e) {
      snakBarWidget(context: context, content: e.message!);
    }
  }

  void verfiyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
  }) async {
    try {
      final auth = FirebaseAuth.instance;

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOtp,
      );
      await auth.signInWithCredential(credential);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => UserInformationScreen(),
          ),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      snakBarWidget(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirebase({
    required BuildContext context,
    required String name,
    required File? profilePic,
  }) async {
    try {
      ///(firebase firestore الجزء دا عشان نرفع صوره علي )
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';
      if (profilePic != null) {
        photoUrl = await storeFileToFirebase(
          "profilePic/${UserData.getUserphoneNumber()}",
          profilePic,
        );

        ///(firebase firestore الجزء دا خاص بتسجيل المستخدم علي )
        final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
        String uid = UserData.getUserphoneNumber() ?? "";

        var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: false,
          phoneNumber: UserData.getUserphoneNumber() ?? "",
          groupId: [],
        );
        await firebaseFirestore.collection("Users").doc(uid).set(user.toMap());

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreen(),
            ),
            (route) => false);

        UserData.setUserModel(user);

        UserData.setIsFrist(true);
      }
    } catch (e) {
      snakBarWidget(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String uid) {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    return firebaseFirestore
        .collection("Users")
        .doc(uid)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

  void setUserState(bool isOnline) async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    await firebaseFirestore
        .collection("Users")
        .doc(UserData.getUserphoneNumber())
        .update({
      "isOnline": isOnline,
    });
  }
}

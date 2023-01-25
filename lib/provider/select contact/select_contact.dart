// ignore_for_file: avoid_print, prefer_final_fields, unused_field, unused_local_variable, use_build_context_synchronously

import 'package:chat_app/UI/chat%20screen/chat_screen.dart';
import 'package:chat_app/custom%20widgets/snakbar%20widget/snakbar.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class SelectContactProvider extends ChangeNotifier {
  List<Contact> _contactsList = [];

  List<Contact> get contactList => _contactsList;
  Future<List<Contact>> getContacts() async {
    try {
      print("come here");
      if (await FlutterContacts.requestPermission()) {
        print("premssion called");
        _contactsList = await FlutterContacts.getContacts(withProperties: true);
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }

    return _contactsList;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      var userCollection = await firestore.collection('Users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        // print("for loop");
        var userData = UserModel.fromMap(document.data());
        String selectedPhoneNum = selectedContact.phones[0].number.replaceAll(
          ' ',
          '',
        );

        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                userName: userData.name,
                userUid: userData.uid,
              ),
            ),
          );
        }
      }
      if (!isFound) {
        snakBarWidget(context: context, content: "user is no in this app");
      }
    } catch (e) {
      snakBarWidget(
        context: context,
        content: e.toString(),
      );
    }
  }
}

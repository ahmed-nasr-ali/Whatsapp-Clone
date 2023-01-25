// ignore_for_file: prefer_const_constructors, avoid_print, unused_local_variable, prefer_const_literals_to_create_immutables, unnecessary_overrides, use_build_context_synchronously

import 'dart:convert';

import 'package:chat_app/UI/chat%20screen/chat_screen.dart';
import 'package:chat_app/UI/landing%20screen/landing_screen.dart';
import 'package:chat_app/UI/select%20contact%20screen/select_contact_screen.dart';
import 'package:chat_app/custom%20widgets/connectivity/network_indicator.dart';
import 'package:chat_app/custom%20widgets/safe_area/page_container.dart';
import 'package:chat_app/custom%20widgets/small%20text/small_text.dart';
import 'package:chat_app/models/chat_contact.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/provider/auth/auth_provider.dart';
import 'package:chat_app/provider/chat%20methods/chat_methods.dart';
import 'package:chat_app/provider/message%20reply/message_reply_provider.dart';
import 'package:chat_app/shared%20prefrence/shared_prefrence.dart';
import 'package:chat_app/utils/color.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        Provider.of<AuthProvider>(context, listen: false).setUserState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        Provider.of<AuthProvider>(context, listen: false).setUserState(false);
        break;
    }
  }

  var fbm = FirebaseMessaging.instance;

  ///in case press on notification when app is on kill
  initialMessage() async {
    var messgae = await FirebaseMessaging.instance.getInitialMessage();

    if (messgae != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => LandingScreen()));
    }
  }

  @override
  void initState() {
    super.initState();

    fbm.getToken().then((value) {
      print("======================================");
      print(value);
    });

    ///in case app is open
    FirebaseMessaging.onMessage.listen((event) {
      print("======================================");

      print(event.notification!.body);
      print(event.notification!.title);
      print(event.data);
    });

    ///in case press on notification when app is on background
    FirebaseMessaging.onMessageOpenedApp.listen((messgae) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => LandingScreen()));
    });

    ///in case press on notification when app is on kill
    initialMessage();

    UserModel usedModel =
        UserModel.fromMap(json.decode(UserData.getUserModel()!));

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return NetworkIndicator(
      child: PageContainer(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Home screen'),
            elevation: 0,
            backgroundColor: backgroundColor,
          ),
          body: StreamBuilder<List<ChatContact>>(
              stream: Provider.of<ChatMethodeProvider>(context, listen: false)
                  .getChatContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var chatContact = snapshot.data![index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Provider.of<MessageReplyProvider>(context,
                                      listen: false)
                                  .setIsSwipe(false);

                              Provider.of<MessageReplyProvider>(context,
                                      listen: false)
                                  .setMessageReplyData(null, null, null);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ChatScreen(
                                          userName: chatContact.name,
                                          userUid: chatContact.contactId)));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text(
                                  chatContact.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Text(
                                    chatContact.lastMessage,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(chatContact.profilePic),
                                ),
                                trailing: SmallText(
                                  text: DateFormat.Hm()
                                      .format(chatContact.timeSent),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    });
              }),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SelectContactScreen(),
                ),
              );
            },
            backgroundColor: tabColor,
            child: Icon(
              Icons.comment,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

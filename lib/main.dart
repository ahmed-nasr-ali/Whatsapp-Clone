// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:chat_app/provider/chat%20methods/chat_methods.dart';
import 'package:chat_app/provider/message%20reply/message_reply_provider.dart';
import 'package:chat_app/provider/select%20contact/select_contact.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/UI/home%20screen/home_screen.dart';
import 'package:chat_app/UI/landing%20screen/landing_screen.dart';
import 'package:chat_app/utils/color.dart';

import 'provider/auth/auth_provider.dart';
import 'shared prefrence/shared_prefrence.dart';

// Future backGroundMessage(RemoteMessage message) async {
//   print("===============================");
//   print(message.notification!.body);
//   print("fuck u");

//   // Navigator.of(context);
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(backGroundMessage);
  await UserData.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    run();
  });
}

void run() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SelectContactProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatMethodeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MessageReplyProvider(),
        ),
        // ChangeNotifierProvider(
        //   create: (_) => SetMessageReplyData(),
        // ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Whatsapp UI',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: const AppBarTheme(
            color: appBarColor,
          ),
        ),
        home: UserData.getIsFrist() ? HomeScreen() : LandingScreen(),
      ),
    );
  }
}

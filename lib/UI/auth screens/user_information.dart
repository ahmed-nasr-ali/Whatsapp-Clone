// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_print

import 'dart:io';

import 'package:chat_app/custom%20widgets/connectivity/network_indicator.dart';
import 'package:chat_app/custom%20widgets/safe_area/page_container.dart';
import 'package:chat_app/provider/auth/auth_provider.dart';
import 'package:chat_app/shared%20prefrence/shared_prefrence.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();

  File? image;

  @override
  void initState() {
    super.initState();
    print(UserData.getUserphoneNumber());
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {
      print(UserData.getUserphoneNumber());
    });
  }

  void storeUserDataToFirebase() async {
    String name = nameController.text.trim();

    if (name.isNotEmpty) {
      Provider.of<AuthProvider>(context, listen: false).saveUserDataToFirebase(
        context: context,
        name: name,
        profilePic: image,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return NetworkIndicator(
      child: PageContainer(
        child: Scaffold(
          body: Column(
            children: [
              Stack(
                children: [
                  image == null
                      ? const CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                          ),
                          radius: 64,
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(
                            image!,
                          ),
                          radius: 64,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: size.width * 0.85,
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: storeUserDataToFirebase,
                    icon: const Icon(
                      Icons.done,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

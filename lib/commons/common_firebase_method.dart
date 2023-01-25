// ignore_for_file: unused_local_variable

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> storeFileToFirebase(String ref, File file) async {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);

  TaskSnapshot snap = await uploadTask;

  String downloadUrl = await snap.ref.getDownloadURL();

  return downloadUrl;
}

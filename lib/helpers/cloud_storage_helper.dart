import 'package:author_registration/globals/globals.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class CloudStorageHelper {
  CloudStorageHelper._();
  static final CloudStorageHelper cloudStorageHelper = CloudStorageHelper._();

  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  static final Reference storageRef = FirebaseStorage.instance.ref();
  final imagesRef = storageRef.child("images");

  Future<void> storeImage({required XFile image, required String name}) async {
    await imagesRef.child(name).putFile(File(image.path));
    Global.imageURL = await imagesRef.child(name).getDownloadURL();
  }

  Future<void> deleteImage({required String name}) async {
    await imagesRef.child(name).delete();
  }
}

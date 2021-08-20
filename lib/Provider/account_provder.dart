import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/services/firebase_storage.dart';

class AccountProvider extends ChangeNotifier {
  File immage;
  File cameraimmage;
  File accountSettingImage;
  File get img => immage;
  File get accountImage => accountSettingImage;
  // ignore: non_constant_identifier_names
  File get CameraImage => cameraimmage;

  set setImgSt(File b) {
    immage = b;
    notifyListeners();
  }

  set acSetImg(File b) {
    accountSettingImage = b;
    notifyListeners();
  }

  Future<File> getImage() async {
    immage = await StorageFirebaseServices.getImage();
    return immage;
  }

  Future<File> getCameraImage() async {
    cameraimmage = await StorageFirebaseServices.getCameraImage();
    return cameraimmage;
  }
}

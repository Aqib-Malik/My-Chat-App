import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageFirebaseServices {
  ///****Pick image freom mob Gallery******/
  static Future<File> getImage() async {
    final picker = ImagePicker();
    File _image;
    final image = await picker.getImage(source: ImageSource.gallery);

    _image = File(image.path);
    return _image;
  }

  ///****Pick image freom mob camera******/
  static Future<File> getCameraImage() async {
    final picker = ImagePicker();
    File _image;
    final image = await picker.getImage(source: ImageSource.camera);

    _image = File(image.path);
    return _image;
  }

  ///****upload account pic on firebase Storage******/
  static Future<String> uploadImage(_image, email) async {
    var imagestatus = await FirebaseStorage.instance
        .ref()
        .child('images')
        .child(email)
        .putFile(_image) //await StorageFirebaseServices.getImage())
        .then((value) => value);
    String imageUrl = await imagestatus.ref.getDownloadURL();
    return imageUrl;

    // var url;
    // String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    // final Reference storageref =
    //     FirebaseStorage.instance.ref().child('images').child(email);
    // final UploadTask uploadTask =
    //     storageref.putFile(_image).catchError((error) {
    //   SomeMethods.toastShow(error.toString());
    // });
    // uploadTask.then((TaskSnapshot taskSnapshot) {
    //   taskSnapshot.ref.getDownloadURL().then((value) {
    //     url = value;

    //     print(url);
    //     SomeMethods.toastShow("Image uploaded successfully");
    //   });
    // }).catchError((error) {
    //   SomeMethods.toastShow(error.toString());
    // });
    // return url;
  }

  ///****send image for messagesfirebase Storage******/

}

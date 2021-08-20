import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Provider/account_provder.dart';
import 'package:flutter_auth/Provider/isloading_provider.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/models/user_details/currentUser.dart';
import 'package:flutter_auth/services/firebase_services.dart';
import 'package:flutter_auth/services/firebase_storage.dart';
import 'package:flutter_auth/services/some_methods/someMethods.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class settingAccount extends StatefulWidget {
  @override
  _settingAccountState createState() => _settingAccountState();
}

// ignore: camel_case_types
class _settingAccountState extends State<settingAccount> {
  final _userNameController =
      new TextEditingController(text: currentUser.name.toString());
  final _emailController =
      new TextEditingController(text: currentUser.email.toString());
  final _updateuserNameController = new TextEditingController();
  File _image;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Provider.of<AccountProvider>(context, listen: false).acSetImg = null;
        Navigator.pop(context);
        return;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Account Settings"),
            centerTitle: true,
          ),
          body: Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 90,
                            child: Consumer<AccountProvider>(
                              builder: (context, value, child) => ClipOval(
                                  child: value.accountSettingImage == null
                                      ? CachedNetworkImage(
                                          imageUrl: currentUser.photoUrl,
                                          width: 180,
                                          height: 180,
                                          fit: BoxFit.fill,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: CircularProgressIndicator(
                                                backgroundColor: Colors.white,
                                                strokeWidth: 4,
                                                value:
                                                    downloadProgress.progress),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        )
                                      : Image.file(
                                          _image,
                                          width: 180,
                                          height: 180,
                                          fit: BoxFit.fill,
                                        )),
                            ),
                          ),
                          Positioned(
                            top: 135,
                            left: 120,
                            child: GestureDetector(
                                onTap: () async {
                                  // _image =
                                  //     await context.read<AccountProvider>().getImage();
                                  // print("setstate");

                                  _image =
                                      await StorageFirebaseServices.getImage();
                                  Provider.of<AccountProvider>(context,
                                          listen: false)
                                      .acSetImg = _image;
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 15,
                      ),

                      TextFieldContainer(
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _userNameController,

                          //onChanged: onChanged,
                          cursorColor: kPrimaryColor,
                          autofocus: false,
                          readOnly: true,
                          decoration: InputDecoration(
                              icon: Icon(Icons.account_circle,
                                  color: kPrimaryColor),
                              hintText: 'userName',
                              border: InputBorder.none,
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    //_showModal();
                                  },
                                  child:
                                      Icon(Icons.edit, color: kPrimaryColor))),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),

                      TextFieldContainer(
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,

                          //onChanged: onChanged,
                          cursorColor: kPrimaryColor,
                          autofocus: false,
                          readOnly: true,
                          decoration: InputDecoration(
                            icon: Icon(Icons.email, color: kPrimaryColor),
                            hintText: 'userName',
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      //Image.network(currentUser.photoUrl),
                      // Text("Name : " + currentUser.name,
                      //     style: TextStyle(
                      //         fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 5,
                      ),

                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            if (await authServices.checkConnection()) {
                              // setState(() async {
                              //   _isloading = true;
                              // });
                              if (_image != null) {
                                Provider.of<IsLoadingProvider>(context,
                                        listen: false)
                                    .setSt = true;
                                var imagestatus = await FirebaseStorage.instance
                                    .ref()
                                    .child('images')
                                    .child(currentUser.email)
                                    .putFile(
                                        _image) //await StorageFirebaseServices.getImage())
                                    .then((value) => value);
                                String imageUrl =
                                    await imagestatus.ref.getDownloadURL();
                                authServices.updatePhoto(
                                    imageUrl, currentUser.email);
                                Provider.of<IsLoadingProvider>(context,
                                        listen: false)
                                    .setSt = false;

                                // /setState(() {

                                //   _isloading = false;
                                // });

                                SomeMethods.toastShow(
                                    "Change Profile Photo successfully");
                              }
                            } else {
                              SomeMethods.toastShow(
                                  "Make sure your internet in enabled");
                            }
                          },
                          child: Consumer<IsLoadingProvider>(
                            builder: (context, value, child) => Container(
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              //padding:
                              //EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                              width: 150,
                              height: 60,

                              alignment: Alignment.center,
                              // child: _isloading == false
                              //     ?
                              child: value.isLoadProfile == false
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.upload,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "change photo",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: SpinKitFadingCircle(
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: index.isEven
                                                  ? Colors.white
                                                  : Colors.amber,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  // ignore: unused_element
  void _showModal() {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Card(
          color: Colors.white,
          child: Container(
            height: MediaQuery.of(context).size.height / 3 +
                MediaQuery.of(context).viewInsets.bottom,
            child: Column(
              children: <Widget>[
                TextFieldContainer(
                  child: TextFormField(
                      controller: _updateuserNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please must enter User Name';
                        }
                        return null;
                      },
                      //onChanged: onChanged,
                      cursorColor: kPrimaryColor,
                      //autofocus: false,
                      //readOnly: true,
                      decoration: InputDecoration(
                        icon: Icon(Icons.account_circle, color: kPrimaryColor),
                        hintText: 'userName',
                        border: InputBorder.none,
                      )),
                ),
                RoundedButton(
                    text: "Update User Name",
                    press: () async {
                      if (await authServices.checkConnection()) {
                        authServices.updateName(
                            _updateuserNameController.text, currentUser.email);
                        _userNameController.text =
                            _updateuserNameController.text;
                      } else {
                        SomeMethods.toastShow(
                            "Make sure Your internet is enabled");
                      }
                    }),
              ],
            ),
          ),
        );
      },
    );
  }
}

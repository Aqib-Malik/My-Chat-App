import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Custom%20Widgets/custom_widgets.dart';
import 'package:flutter_auth/Provider/isloading_provider.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/models/user_details/currentUser.dart';
import 'package:flutter_auth/models/user_details/reciever.dart';
import 'package:flutter_auth/services/firebase_services.dart';
import 'package:flutter_auth/services/message_firbase_services.dart';
import 'package:flutter_auth/services/some_methods/someMethods.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SendImage extends StatelessWidget {
  List<String> _combineId = [currentUser.email + recieverUser.email];
  TextEditingController _captionControler = new TextEditingController();

  File imgUrl;
  SendImage({this.imgUrl});
  @override
  Widget build(BuildContext context) {
    //Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: CircleAvatar(
          backgroundImage: NetworkImage(recieverUser.photoUrl
              //'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSA65C8-sNxxoiwjic3K8ZOs-2oG6PC-wu1dw&usqp=CAU'
              ),
          maxRadius: 20,
        ),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Consumer<IsLoadingProvider>(
            builder: (context, value, child) => Center(
                child: value.isLoadMsgImgn == false
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Hero(
                          tag: 'imageHero',
                          child: Image.file(
                            imgUrl,
                            // width: 340,
                            // height: 400,
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomWidgets().spinKit(70),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Sending Image......",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _captionControler,
                        decoration: InputDecoration(
                            hintText: "Add Caption...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () async {
                        if (await authServices.checkConnection()) {
                          Provider.of<IsLoadingProvider>(context, listen: false)
                              .setMsgImgstate = true;
                          //callbacknew();

                          var imagestatus = await FirebaseStorage.instance
                              .ref()
                              .child('messages')
                              .child(Timestamp.now().toString())
                              .putFile(
                                  imgUrl) //await StorageFirebaseServices.getImage())
                              .then((value) => value);
                          String imageUrl =
                              await imagestatus.ref.getDownloadURL();
                          MessageFirebaseServices.callbacknew(
                              _captionControler.text,
                              SomeMethods.chatId(
                                  recieverUser.name, currentUser.name),
                              recieverUser.id,
                              FirebaseAuth.instance.currentUser.email,
                              currentUser.name,
                              recieverUser.name,
                              _combineId,
                              imageUrl)
                            ..then((value) {
                              Provider.of<IsLoadingProvider>(context,
                                      listen: false)
                                  .setMsgImgstate = false;
                              Navigator.pop(context);
                            });
                        } else {
                          SomeMethods.toastShow(
                              "Make sure your internet connection is enabled");
                        }
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: kPrimaryColor,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

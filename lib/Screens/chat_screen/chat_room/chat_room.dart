import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/Custom%20Widgets/custom_widgets.dart';
import 'package:flutter_auth/Provider/account_provder.dart';
import 'package:flutter_auth/Screens/chat_screen/chat_room/send_image.dart';
import 'package:flutter_auth/Screens/chat_screen/inhanceImage.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/models/user_details/reciever.dart';
import 'package:flutter_auth/services/firebase_services.dart';
import 'package:flutter_auth/services/message_firbase_services.dart';
import 'package:flutter_auth/services/some_methods/someMethods.dart';
import 'package:flutter_auth/models/user_details/currentUser.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class chatRoom extends StatefulWidget {
  //const chatRoom({ Key? key }) : super(key: key);

  @override
  _chatRoomState createState() => _chatRoomState();
}

// ignore: camel_case_types
class _chatRoomState extends State<chatRoom> {
  File _image;

  List<String> _combineId = [currentUser.email + recieverUser.email];
  ScrollController scrollController = ScrollController();

  TextEditingController _messageController = new TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  CircleAvatar(
                    child: ClipOval(
                      child: CustomWidgets()
                          .cahedImage(recieverUser.photoUrl, 4, 100, 100, 20),
                    ),
                    maxRadius: 20,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          recieverUser.name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          recieverUser.status.toString(),
                          style: TextStyle(
                              color: recieverUser.status == 'offline'
                                  ? Colors.grey.shade600
                                  : Colors.green,
                              fontWeight: recieverUser.status == 'offline'
                                  ? FontWeight.normal
                                  : FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.settings,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Messages')
                    .doc(
                        SomeMethods.chatId(recieverUser.name, currentUser.name))
                    .collection('userChats')
                    .orderBy('createdAt', descending: true)
                    // .limit(3)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("There is some error ${snapshot.hasError}");
                  }
                  // if(snapshot.data.docs.isNotEmpty)
                  // {

                  // }

                  switch (snapshot.connectionState) {
                    case (ConnectionState.waiting):
                      {
                        return Center(child: CircularProgressIndicator());
                      }
                    case (ConnectionState.none):
                      {
                        return Center(child: Text("There is no data present"));
                      }
                    case (ConnectionState.done):
                      {
                        return Center(child: Text("data present"));
                      }

                    //break;
                    default:
                      return new ListView(
                          reverse: true,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 10, bottom: 40),
                          //physics: NeverScrollableScrollPhysics(),
                          children: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                            return GestureDetector(
                              onLongPress: () async {
                                if (await onPressed()) {
                                  FirebaseFirestore.instance
                                      .collection('Messages')
                                      .doc(SomeMethods.chatId(
                                          recieverUser.name, currentUser.name))
                                      .collection('userChats')
                                      .doc(document.id)
                                      .delete()
                                      .then((value) => SomeMethods.toastShow(
                                          "Message deleted Successfully"));
                                }
                              },
                              child: Container(
                                child: Padding(
                                  padding:
                                      document['senderId'] != currentUser.email
                                          ? EdgeInsets.only(
                                              left: 14,
                                              right: 80,
                                              top: 10,
                                              bottom: 10)
                                          : EdgeInsets.only(
                                              left: 80,
                                              right: 14,
                                              top: 10,
                                              bottom: 10),
                                  child: Align(
                                    alignment: (document['senderId'] !=
                                            currentUser.email
                                        ? Alignment.topLeft
                                        : Alignment.topRight),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: document['senderId'] !=
                                                    currentUser.email
                                                ? Colors.grey.shade200
                                                : Colors.blue[200],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          margin: EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 5,
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(16),
                                                child: document[
                                                            'messageBody'] !=
                                                        ''
                                                    ? Text(
                                                        document['messageBody'],
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        width: 0,
                                                        height: 0,
                                                      ),
                                              ),
                                              document['msgPic'] != ""
                                                  ? GestureDetector(
                                                      onTap: () async {
                                                        if (await authServices
                                                            .checkConnection()) {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                                return DetailScreen(
                                                                  imgUrl: document[
                                                                      'msgPic'],
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(9.0),
                                                          child: CustomWidgets()
                                                              .cahedImage(
                                                                  document[
                                                                      'msgPic'],
                                                                  4,
                                                                  200,
                                                                  200,
                                                                  20)),
                                                    )
                                                  : SizedBox(
                                                      width: 0,
                                                      height: 0,
                                                    ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        5, 5, 5, 5),
                                                child: Text(
                                                  document['createdAt']
                                                      .toDate()
                                                      .toString()
                                                      .substring(0, 16),
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList());
                  }
                }),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            //emojis();
                            _image = await context
                                .read<AccountProvider>()
                                .getImage();
                            if (_image != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return SendImage(
                                      imgUrl: _image,
                                    );
                                  },
                                ),
                              );
                            }

                            // setState(() {
                            //   _image = context.read<AccountProvider>().img;
                            // });
                          },
                          child: Icon(
                            Icons.photo,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            //emojis();
                            _image = await context
                                .read<AccountProvider>()
                                .getCameraImage();
                            if (_image != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return SendImage(
                                      imgUrl: _image,
                                    );
                                  },
                                ),
                              );
                            }

                            // setState(() {
                            //   _image = context.read<AccountProvider>().img;
                            // });
                          },
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () async {
                        //callback();

                        if (await authServices.checkConnection()) {
                          //callbacknew();

                          MessageFirebaseServices.callbacknew(
                              _messageController.text,
                              SomeMethods.chatId(
                                  recieverUser.name, currentUser.name),
                              recieverUser.id,
                              FirebaseAuth.instance.currentUser.email,
                              currentUser.name,
                              recieverUser.name,
                              _combineId,
                              '')
                            ..then((value) {
                              _messageController.clear();
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                              SomeMethods.toastShow('Message sent');
                            });
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
          ],
        ),
      );

  Future<bool> onPressed() async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0)),
            child: Stack(
              // ignore: deprecated_member_use
              overflow: Overflow.visible,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 230,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                    child: Column(
                      children: [
                        Text(
                          'Delete',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Delete for everyone?',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ignore: deprecated_member_use
                            RaisedButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              color: kPrimaryColor,
                              child: Text(
                                'Yes',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            // ignore: deprecated_member_use
                            RaisedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                return false;
                              },
                              color: kPrimaryColor,
                              child: Text(
                                'No',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: -60,
                    child: CircleAvatar(
                      backgroundColor: kPrimaryColor,
                      radius: 60,
                      child: Icon(
                        Icons.delete_forever, //assistant_photo,
                        color: Colors.white,
                        size: 50,
                      ),
                    )),
              ],
            ));
      },
    );
  }
}

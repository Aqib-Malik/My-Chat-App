import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Custom%20Widgets/custom_widgets.dart';
import 'package:flutter_auth/Screens/chat_screen/chat_room/chat_room.dart';
import 'package:flutter_auth/Screens/chat_screen/inhanceImage.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/models/user_details/reciever.dart';
import 'package:flutter_auth/models/user_details/currentUser.dart';
import 'package:flutter_auth/services/firebase_services.dart';
import 'package:flutter_auth/services/some_methods/someMethods.dart';

// ignore: camel_case_types
class allFriends extends StatefulWidget {
  //const allFriends({ Key? key }) : super(key: key);

  @override
  _allFriendsState createState() => _allFriendsState();
}

// ignore: camel_case_types
class _allFriendsState extends State<allFriends> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where('email', isNotEqualTo: currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("There is some error ${snapshot.hasError}");
          }

          switch (snapshot.connectionState) {
            case (ConnectionState.waiting):
              {
                return Center(child: CustomWidgets().spinKit(70));
              }
            case (ConnectionState.none):
              {
                return Column(
                  children: <Widget>[
                    Text(
                      'There is no users',
                      // ignore: deprecated_member_use
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 200,
                        child: Image.asset(
                          "assets/images/main_top.png",
                          fit: BoxFit.cover,
                        )),
                  ],
                );
              }
            case (ConnectionState.done):
              {
                return Center(child: Text("data present"));
              }

            //break;
            default:
              return new ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                return GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 16, right: 16, top: 10, bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    if (await authServices.checkConnection()) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return DetailScreen(
                                              imgUrl: document['photoUrl'],
                                            );
                                          },
                                        ),
                                      );
                                    } else {
                                      SomeMethods.toastShow(
                                          "Make sure your internet is enables");
                                    }
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: kPrimaryColor,
                                    // backgroundImage:
                                    child: ClipOval(
                                      child: CustomWidgets().cahedImage(
                                          document['photoUrl'],
                                          4,
                                          100,
                                          100,
                                          20),
                                    ), //NetworkImage(document['photoUrl']),
                                    maxRadius: 30,
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      recieverUser.name =
                                          document['name'].toString();
                                      recieverUser.email =
                                          document['email'].toString();
                                      recieverUser.id = document.id;
                                      recieverUser.photoUrl =
                                          document['photoUrl'].toString();
                                      recieverUser.status =
                                          document['status'].toString();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return chatRoom();
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            document['name'],
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            document['status'],
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: document['status'] ==
                                                        'offline'
                                                    ? Colors.grey.shade600
                                                    : Colors.green,
                                                fontWeight:
                                                    document['status'] ==
                                                            'offline'
                                                        ? FontWeight.normal
                                                        : FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              recieverUser.name = document['name'].toString();
                              recieverUser.email = document['email'].toString();
                              recieverUser.id = document.id;
                              recieverUser.photoUrl =
                                  document['photoUrl'].toString();
                              recieverUser.status =
                                  document['status'].toString();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return chatRoom();
                                  },
                                ),
                              );
                            },
                            child: Icon(
                              Icons.message,
                              color: kPrimaryColor,
                              size: 30.0,
                            ),
                          ),
                          //Text(widget.time,style: TextStyle(fontSize: 12,fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),
                        ],
                      ),
                    ));
              }).toList());
          }
        });
  }
}

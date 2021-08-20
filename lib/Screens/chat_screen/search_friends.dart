import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Custom%20Widgets/custom_widgets.dart';
import 'package:flutter_auth/Screens/chat_screen/chat_room/chat_room.dart';
import 'package:flutter_auth/Screens/chat_screen/inhanceImage.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/models/user_details/reciever.dart';
import 'package:flutter_auth/models/user_details/currentUser.dart';

// ignore: camel_case_types
class searchFriends extends StatefulWidget {
  //const allFriends({ Key? key }) : super(key: key);

  @override
  _searchFriendsState createState() => _searchFriendsState();
}

// ignore: camel_case_types
class _searchFriendsState extends State<searchFriends> {
  String _searchString;
  TextEditingController _searchEditingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
              controller: _searchEditingController,
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  _searchString = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.white),
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    _searchEditingController.text = "";
                  },
                  child: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                ),
              )),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: (_searchString == null || _searchString.trim() == "")
                ? FirebaseFirestore.instance
                    .collection("users")
                    .where('email', isNotEqualTo: currentUser.email)
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection("users")
                    .where('searchIndex', arrayContains: _searchString)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text("There is some error ${snapshot.hasError}"));
              }

              switch (snapshot.connectionState) {
                case (ConnectionState.waiting):
                  {
                    return Center(child: CircularProgressIndicator());
                  }
                case (ConnectionState.none):
                  {
                    return new Center(
                      child: Text("no data"),
                    );
                  }
                case (ConnectionState.done):
                  {
                    return Center(child: Text("data present"));
                  }

                //break;
                default:
                  return new ListView(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
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
                                    onTap: () {
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
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: kPrimaryColor,
                                      //backgroundImage:
                                      child: ClipOval(
                                        child: CustomWidgets().cahedImage(
                                            document['photoUrl'],
                                            4,
                                            100,
                                            100,
                                            20),
                                      ),
                                      //NetworkImage(document['photoUrl']),
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
                              child: Icon(
                                Icons.message,
                                color: kPrimaryColor,
                                size: 30.0,
                              ),
                            ),
                            //Text(widget.time,style: TextStyle(fontSize: 12,fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),
                          ],
                        ),
                      ),
                    );
                  }).toList());
              }
            }));
  }
}

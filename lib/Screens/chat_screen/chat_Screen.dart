import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Custom%20Widgets/custom_widgets.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/Screens/chat_screen/all_friends.dart';
import 'package:flutter_auth/Screens/chat_screen/inhanceImage.dart';
import 'package:flutter_auth/Screens/chat_screen/search_friends.dart';
import 'package:flutter_auth/Screens/chat_screen/setting_account.dart';
import 'package:flutter_auth/Screens/start_up/start_up.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/services/firebase_services.dart';
import 'package:flutter_auth/models/user_details/currentUser.dart';
import 'package:flutter_auth/services/some_methods/someMethods.dart';
import 'package:shared_preferences/shared_preferences.dart';

//String searchString;

// ignore: camel_case_types
class chatScreen extends StatefulWidget {
  //const chatScreen({ Key? key }) : super(key: key);

  @override
  _chatScreenState createState() => _chatScreenState();
}

// ignore: camel_case_types
class _chatScreenState extends State<chatScreen> {
  String img =
      "https://media.istockphoto.com/vectors/circular-loading-sign-waiting-symbol-black-icon-isolated-on-white-vector-id1037711218?b=1&k=6&m=1037711218&s=612x612&w=0&h=8XRlYLtw-7etE-u2vlfe2Fd4s8z8Y3Dd0MaL06cf7P8=";
  String name = "", email = "";
  //'https://lh3.googleusercontent.com/a/AATXAJz770igKebCDUk9_GImbrenQ9PpBPHu9RzXIlkw=s96-c';
  Map data;
  fetchdata() {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection //(teach == false? 'students': 'users');
        ('users');

    collectionReference.doc(finalemail).snapshots().listen((snapshot) {
      setState(() {
        data = snapshot.data();
        if (data['photoUrl'] != null) {
          img = data['photoUrl'];
        }

        name = data['name'];
        email = data['email'];
        currentUser.name = data['name'];
        currentUser.email = data['email'];
        currentUser.photoUrl = data['photoUrl'];
      });
    });
  }

  @override
  void initState() {
    super.initState();

    fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _onBackpress();
        return;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Chat World"),
            centerTitle: true,
            actions: [
              img == ""
                  ? Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: CircleAvatar(
                        child: ClipOval(
                          child: Icon(Icons.person),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 10, top: 5),
                      child: GestureDetector(
                        onTap: () async {
                          if (await authServices.checkConnection()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DetailScreen(
                                    imgUrl: currentUser.photoUrl,
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
                          child: ClipOval(
                            child: CustomWidgets()
                                .cahedImage(img, 5, 500, 400, 80),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: kPrimaryColor,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => searchFriends()));
              },
              child: Icon(
                Icons.search,
              )),
          drawer: Drawer(
            child: ListView(children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(name.toString()),
                accountEmail: Text(finalemail),
                currentAccountPicture: img == ""
                    ? CircleAvatar(
                        child: ClipOval(
                          child: Icon(Icons.person),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          if (await authServices.checkConnection()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DetailScreen(
                                    imgUrl: currentUser.photoUrl,
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
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: img,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          backgroundColor: Colors.amber,
                                          strokeWidth: 8,
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Settings"),
                subtitle: Text("Account Settings"),
                trailing: Icon(Icons.settings),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return settingAccount();
                      },
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Logout"),
                subtitle: Text("You will be Logout"),
                trailing: Icon(Icons.logout),
                onTap: () {
                  _onBackpress();
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Delete"),
                subtitle: Text("You account will be"),
                trailing: Icon(Icons.delete),
                onTap: () {
                  //FirebaseAuth.instance.currentUser.delete();
                  authServices
                      .deleteAccount(currentUser.email)
                      .then((value) async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.remove('email');
                    currentUser.setnull();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return WelcomeScreen();
                        },
                      ),
                    );
                  });
                },
              ),
            ]),
          ),
          body: allFriends()
          //StreamBuilder<QuerySnapshot>(
          ),
    );
  }

  Future<bool> _onBackpress() async {
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
                          'Confirmation !!!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Are you sure you want to Logout this App?',
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
                              onPressed: () async {
                                authServices.signout().whenComplete(() async {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  sharedPreferences.remove('email');
                                  authServices.update(
                                      'offline', currentUser.email);
                                  currentUser.setnull();

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return WelcomeScreen();
                                      },
                                    ),
                                  );
                                });
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
                        Icons.logout, //assistant_photo,
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













// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_auth/Custom%20Widgets/custom_widgets.dart';
// import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
// import 'package:flutter_auth/Screens/chat_screen/all_friends.dart';
// import 'package:flutter_auth/Screens/chat_screen/inhanceImage.dart';
// import 'package:flutter_auth/Screens/chat_screen/search_friends.dart';
// import 'package:flutter_auth/Screens/chat_screen/setting_account.dart';
// import 'package:flutter_auth/Screens/start_up/start_up.dart';
// import 'package:flutter_auth/constants.dart';
// import 'package:flutter_auth/models/user_details/user.dart';
// import 'package:flutter_auth/services/firebase_services.dart';
// import 'package:flutter_auth/models/user_details/currentUser.dart';
// import 'package:flutter_auth/services/some_methods/someMethods.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// //String searchString;

// class chatScreen extends StatefulWidget {
//   //const chatScreen({ Key? key }) : super(key: key);

//   @override
//   _chatScreenState createState() => _chatScreenState();
// }

// // ignore: camel_case_types
// class _chatScreenState extends State<chatScreen> {
//   //String emaill = finalemail;
//   String img =
//       "https://media.istockphoto.com/vectors/circular-loading-sign-waiting-symbol-black-icon-isolated-on-white-vector-id1037711218?b=1&k=6&m=1037711218&s=612x612&w=0&h=8XRlYLtw-7etE-u2vlfe2Fd4s8z8Y3Dd0MaL06cf7P8=";
//   String name = "", email = "";

//   //'https://lh3.googleusercontent.com/a/AATXAJz770igKebCDUk9_GImbrenQ9PpBPHu9RzXIlkw=s96-c';
//   Map data;
//   fetchdata() {
//     CollectionReference collectionReference = FirebaseFirestore.instance
//         .collection //(teach == false? 'students': 'users');
//         ('users');

//     collectionReference.doc(finalemail).snapshots().listen((snapshot) {
//       setState(() {
//         data = snapshot.data();
//         //finalemail = data['email'];
//         if (data['photoUrl'] != null) {
//           img = data['photoUrl'];
//         }

//         name = data['name'];
//         email = data['email'];
//         currentUser.name = data['name'];
//         currentUser.email = data['email'];
//         currentUser.photoUrl = data['photoUrl'];
//       });
//     });
//   }

//   @override
//   void initState() {
//     super.initState();

//     fetchdata();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<UserDet>(context);
//     return WillPopScope(
//       onWillPop: () {
//         _onBackpress();
//         return;
//       },
//       child: Scaffold(
//           appBar: AppBar(
//             title: Text("Chat World"),
//             centerTitle: true,
//             actions: [
//               img == ""
//                   ? Padding(
//                       padding: const EdgeInsets.only(right: 10),
//                       child: CircleAvatar(
//                         backgroundColor: kPrimaryColor,
//                         child: ClipOval(
//                           child: Icon(Icons.person),
//                         ),
//                       ),
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.only(right: 10, top: 5),
//                       child: GestureDetector(
//                         onTap: () async {
//                           if (await authServices.checkConnection()) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) {
//                                   return DetailScreen(
//                                     imgUrl: currentUser.photoUrl,
//                                   );
//                                 },
//                               ),
//                             );
//                           } else {
//                             SomeMethods.toastShow(
//                                 "Make sure your internet is enables");
//                           }
//                         },
//                         child: CircleAvatar(
//                           child: ClipOval(
//                             child: CustomWidgets()
//                                 .cahedImage(img, 5, 500, 400, 80),
//                           ),
//                         ),
//                       ),
//                     ),
//             ],
//           ),
//           floatingActionButton: FloatingActionButton(
//               backgroundColor: kPrimaryColor,
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => searchFriends()));
//               },
//               child: Icon(
//                 Icons.search,
//               )),
//           drawer: Drawer(
//             child: ListView(children: <Widget>[
//               UserAccountsDrawerHeader(
//                 accountName: Text(name.toString()),
//                 accountEmail: Text(finalemail),
//                 currentAccountPicture: img == ""
//                     ? CircleAvatar(
//                         child: ClipOval(
//                           child: Icon(Icons.person),
//                         ),
//                       )
//                     : GestureDetector(
//                         onTap: () async {
//                           if (await authServices.checkConnection()) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) {
//                                   return DetailScreen(
//                                     imgUrl: currentUser.photoUrl,
//                                   );
//                                 },
//                               ),
//                             );
//                           } else {
//                             SomeMethods.toastShow(
//                                 "Make sure your internet is enables");
//                           }
//                         },
//                         child: CircleAvatar(
//                           backgroundColor: kPrimaryColor,
//                           child: ClipOval(
//                             child: CachedNetworkImage(
//                               imageUrl: img,
//                               width: 100,
//                               height: 100,
//                               fit: BoxFit.cover,
//                               progressIndicatorBuilder:
//                                   (context, url, downloadProgress) =>
//                                       CircularProgressIndicator(
//                                           backgroundColor: Colors.amber,
//                                           strokeWidth: 8,
//                                           value: downloadProgress.progress),
//                               errorWidget: (context, url, error) =>
//                                   Icon(Icons.error),
//                             ),
//                           ),
//                         ),
//                       ),
//               ),
//               ListTile(
//                 leading: Icon(Icons.person),
//                 title: Text("Settings"),
//                 subtitle: Text("Account Settings"),
//                 trailing: Icon(Icons.settings),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) {
//                         return settingAccount();
//                       },
//                     ),
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.person),
//                 title: Text("Logout"),
//                 subtitle: Text("You will be Logout"),
//                 trailing: Icon(Icons.logout),
//                 onTap: () {
//                   _onBackpress();
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.person),
//                 title: Text("Delete"),
//                 subtitle: Text("You account will be"),
//                 trailing: Icon(Icons.delete),
//                 onTap: () {
//                   //FirebaseAuth.instance.currentUser.delete();
//                   authServices.deleteAccount(finalemail).then((value) async {
//                     SharedPreferences sharedPreferences =
//                         await SharedPreferences.getInstance();
//                     sharedPreferences.remove('email');
//                     currentUser.setnull();
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) {
//                           return WelcomeScreen();
//                         },
//                       ),
//                     );
//                   });
//                 },
//               ),
//             ]),
//           ),
//           body: allFriends()
//           //StreamBuilder<QuerySnapshot>(
//           ),
//     );
//   }

//   Future<bool> _onBackpress() async {
//     return showDialog(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return Dialog(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(4.0)),
//             child: Stack(
//               overflow: Overflow.visible,
//               alignment: Alignment.topCenter,
//               children: [
//                 Container(
//                   height: 230,
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
//                     child: Column(
//                       children: [
//                         Text(
//                           'Confirmation !!!',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 20),
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           'Are you sure you want to Logout this App?',
//                           style: TextStyle(fontSize: 20),
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             RaisedButton(
//                               onPressed: () async {
//                                 authServices.signout().whenComplete(() async {
//                                   SharedPreferences sharedPreferences =
//                                       await SharedPreferences.getInstance();
//                                   sharedPreferences.remove('email');
//                                   authServices.update('offline', finalemail);
//                                   currentUser.setnull();

//                                   Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) {
//                                         return WelcomeScreen();
//                                       },
//                                     ),
//                                   );
//                                 });
//                               },
//                               color: kPrimaryColor,
//                               child: Text(
//                                 'Yes',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             RaisedButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               color: kPrimaryColor,
//                               child: Text(
//                                 'No',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                     top: -60,
//                     child: CircleAvatar(
//                       backgroundColor: kPrimaryColor,
//                       radius: 60,
//                       child: Icon(
//                         Icons.logout, //assistant_photo,
//                         color: Colors.white,
//                         size: 50,
//                       ),
//                     )),
//               ],
//             ));
//       },
//     );
//   }
// }

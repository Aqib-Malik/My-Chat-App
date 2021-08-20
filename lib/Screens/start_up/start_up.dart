// import 'package:flutter/material.dart';
// import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
// import 'package:flutter_auth/Screens/chat_screen/chat_Screen.dart';
// import 'package:flutter_auth/models/user_details/user.dart';
// import 'package:flutter_auth/brew_home/wshi.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// String finalemail;

// // ignore: camel_case_types
// class startUp extends StatefulWidget {
//   //const startUp({ Key? key }) : super(key: key);

//   @override
//   _startUpState createState() => _startUpState();
// }

// class _startUpState extends State<startUp> {
//   @override
//   void initState() {
//     getValidationData();

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<UserDet>(context);
//     print(user);
//     if (user == null) {
//       return WelcomeScreen();
//     } else {
//       return chatScreen();
//     }
//   }

//   Future getValidationData() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     var obtainEmail = sharedPreferences.getString('email');

//     finalemail = obtainEmail;

//     print(finalemail.toString());
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/Screens/chat_screen/chat_Screen.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

String finalemail;
String finalname;
String finalPhotoUrl;

// ignore: camel_case_types
class startUp extends StatefulWidget {
  //const startUp({ Key? key }) : super(key: key);

  @override
  _startUpState createState() => _startUpState();
}

// ignore: camel_case_types
class _startUpState extends State<startUp> {
  @override
  void initState() {
    getValidationData().whenComplete(() async {
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    finalemail == null ? WelcomeScreen() : chatScreen()));
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [kPrimaryColor, kPrimaryLightColor])),
          child: SpinKitSquareCircle(
            color: Colors.white,
            size: 50.0,
            //controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
          ) //CircularProgressIndicator(color:Colors.white,),
          ),
    ));
  }

  Future getValidationData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainEmail = sharedPreferences.getString('email');

    finalemail = obtainEmail;

    print(finalemail.toString());
  }
}

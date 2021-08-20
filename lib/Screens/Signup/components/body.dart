import 'dart:io';
import 'package:flutter_auth/Custom%20Widgets/custom_widgets.dart';
import 'package:flutter_auth/Provider/isloading_provider.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/services/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Provider/account_provder.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/components/background.dart';
import 'package:flutter_auth/Screens/Signup/components/or_divider.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/Screens/chat_screen/chat_Screen.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_auth/services/firebase_services.dart';
import 'package:flutter_auth/services/some_methods/someMethods.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String value;
  File _image;
  String url;
  final _formkey = GlobalKey<FormState>();
  Map<String, dynamic> userInfi;
  TextEditingController _emailcontroller = new TextEditingController();
  TextEditingController _passcontroller = new TextEditingController();
  TextEditingController _usernamecontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Consumer<AccountProvider>(
                  builder: (context, value, child) => CircleAvatar(
                    backgroundColor: kPrimaryColor,
                    child: value.immage == null
                        ?

                        //_image == null
                        //?
                        ClipOval(
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            ),
                          )
                        : ClipOval(
                            child: Image.file(
                              context.read<AccountProvider>().img,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                    radius: 40,
                  ),
                ),
                Container(
                  height: 50,
                  width: 150,
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: () async {
                      //onBackpress();
                      //_image = await context.read<AccountProvider>().getImage();
                      _image = await StorageFirebaseServices.getImage();
                      Provider.of<AccountProvider>(context, listen: false)
                          .setImgSt = _image;

                      // setState(() {
                      //   _image = context.read<AccountProvider>().img;
                      // });
                      //print(_image);
                      // _image = await StorageFirebaseServices.getImage();
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.upload,
                          color: kPrimaryColor,
                        ),
                        Text(
                          " Upload image",
                          style: TextStyle(
                            color: kPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    color: Colors.white,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFieldContainer(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'must enter user name';
                        }
                        return null;
                      },
                      controller: _usernamecontroller,
                      //onChanged: onChanged,
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        icon: Icon(Icons.person, color: kPrimaryColor),
                        hintText: 'Your Name',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextFieldContainer(
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'must enter email address';
                        }
                        return null;
                      },
                      controller: _emailcontroller,
                      //onChanged: onChanged,
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        icon: Icon(Icons.email, color: kPrimaryColor),
                        hintText: 'Your Email',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextFieldContainer(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'must enter password';
                        }
                        return null;
                      },
                      controller: _passcontroller,
                      obscureText: true,
                      //onChanged: onChanged,
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        hintText: "Password",
                        icon: Icon(
                          Icons.lock,
                          color: kPrimaryColor,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.visibility,
                            color: kPrimaryColor,
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(20)),
              margin: EdgeInsets.symmetric(vertical: 10),
              width: size.width * 0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                // ignore: deprecated_member_use
                child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    //color: Color(0xFF6F35A5), //(0xFF6F35A5),
                    onPressed: () async {
                      if (_formkey.currentState.validate()) {
                        if (await authServices.checkConnection()) {
                          Provider.of<IsLoadingProvider>(context, listen: false)
                              .setSignUpstate = true;
                          // var imageUrl = StorageFirebaseServices.uploadImage(
                          //_image, _emailcontroller.text);
                          var imagestatus = await FirebaseStorage.instance
                              .ref()
                              .child('images')
                              .child(_emailcontroller.text)
                              .putFile(
                                  _image) //await StorageFirebaseServices.getImage())
                              .then((value) => value);
                          String imageUrl =
                              await imagestatus.ref.getDownloadURL();

                          List<String> splitList =
                              _usernamecontroller.text.split(' ');
                          List<String> indexList = [];
                          indexList = SomeMethods.splitUserName(splitList);
                          if (indexList != null) {
                            /*final ref = FirebaseStorage.instance
                                .ref()
                                .child('images')
                                .child(_emailcontroller.text);
                            value = await ref.getDownloadURL().whenComplete(() {*/
                            userInfi = {
                              'name': _usernamecontroller.text,
                              'email': _emailcontroller.text,
                              'photoUrl': '$imageUrl' == null
                                  ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSA65C8-sNxxoiwjic3K8ZOs-2oG6PC-wu1dw&usqp=CAU'
                                  : '$imageUrl',
                              'searchIndex': indexList,
                              'status': 'offline'
                            };

                            authServices
                                .createStuwithemailandpass(
                                    //_emailcontroller.text,
                                    userInfi,
                                    _passcontroller.text,
                                    _emailcontroller
                                        .text) //_passcontroller.text, _usernamecontroller.text)
                                .then((value) {
                              Provider.of<IsLoadingProvider>(context,
                                      listen: false)
                                  .setSignUpstate = false;
                              value != false
                                  ? Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              WelcomeScreen()))
                                  // ignore: unnecessary_statements
                                  : "";
                            });
                          } else {
                            SomeMethods.toastShow("invalid username");
                          }
                        }
                      }
                    },
                    child: Consumer<IsLoadingProvider>(
                      builder: (context, value, child) => Container(
                          child: value.isLoadSignUp == false
                              ? Text(
                                  //value.isLoadSignUp ? 'Uploading Data...' :
                                  'Sign Up',
                                  style: TextStyle(color: Colors.white),
                                )
                              : Center(child: CustomWidgets().spinKit(38))),
                    )),
              ),
            ),
            OrDivider(),
            Container(
              height: 45,
              width: 250,
              child: GestureDetector(
                onTap: () async {
                  authServices.googleSignin().then((value) {
                    SomeMethods.toastShow("successfully google log in");
                    Provider.of<AccountProvider>(context, listen: false)
                        .setImgSt = null;
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => chatScreen()));
                  });
                },
                child: Image.asset(
                  "assets/images/googl_dign_logo.png",
                  //height: size.height * 0.35,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Provider.of<AccountProvider>(context, listen: false)
                      .setImgSt = null;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
              ),
            ),
            //SizedBox(height: 5),

            //OrDivider(),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/facebook.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/twitter.svg",
                  press: () {},
                ),
                SocalIcon(
                    iconSrc: "assets/icons/google-plus.svg",
                    press: () async {
                      authServices.googleSignin().then((value) {
                        SomeMethods.toastShow("successfully google log in");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => chatScreen()));
                      });
                    }),
              ],
            )*/
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_auth/Custom%20Widgets/custom_widgets.dart';
import 'package:flutter_auth/Screens/Login/components/background.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/Screens/chat_screen/chat_Screen.dart';
import 'package:flutter_auth/Screens/start_up/start_up.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/services/firebase_services.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Map data;
  //final authServices _auth = authServices();
  final _formkey = GlobalKey<FormState>();
  TextEditingController _emailcontroller = new TextEditingController();
  TextEditingController _passcontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            // RoundedInputField(
            //   hintText: "Your Email",
            //   onChanged: (value) {},
            // ),
            // RoundedPasswordField(
            //   onChanged: (value) {},
            // ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFieldContainer(
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailcontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please must enter Email';
                        }
                        return null;
                      },
                      //onChanged: onChanged,
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        icon: Icon(Icons.email, color: kPrimaryColor),
                        hintText: 'Your Email',
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  /*RoundedPasswordField(
              onChanged: (value) {},
            ),*/
                  TextFieldContainer(
                    child: TextFormField(
                      controller: _passcontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Password';
                        }
                        return null;
                      },
                      obscureText: true, //_obsecure == true ? true : false,
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
                          child: Container(
                            child: Icon(
                              Icons.visibility,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            RoundedButton(
                text: "LOGIN",
                press: () async {
                  if (_formkey.currentState.validate()) {
                    if (await authServices.checkConnection()) {
                      onBackpress();
                      dynamic result = authServices.signinwithemailandpass(
                          _emailcontroller.text, _passcontroller.text);
                      if (result != null) {
                        finalemail = _emailcontroller.text;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => chatScreen()));
                      }
                      // if (result != null) {
                      //   Navigator.pop(context);
                      // }
                      // bool _signin = await authServices.signinwithemailandpass(
                      //     _emailcontroller.text, _passcontroller.text);
                      // if (_signin == true) {
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => chatScreen()));
                      // } else {
                      //   Navigator.pop(context);
                      // }
                    }
                  }
                }),

            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onBackpress() {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CustomWidgets().alertDialog("Loading");
      },
    );
  }
}

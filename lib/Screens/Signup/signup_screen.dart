import 'package:flutter/material.dart';
import 'package:flutter_auth/Provider/account_provder.dart';
import 'package:flutter_auth/Screens/Signup/components/body.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Provider.of<AccountProvider>(context, listen: false).setImgSt = null;
        Navigator.pop(context);
        return;
      },
      child: Scaffold(
        body: Body(),
      ),
    );
  }
}

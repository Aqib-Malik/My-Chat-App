import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: size.width * 0.35,
                height: 100,
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(40),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(120),
                  ),
                  color: kPrimaryLightColor,
                ),
              )
              // Image.asset(
              //   "assets/images/main_top.png",
              //   width: size.width * 0.35,
              // ),
              ),
          Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: size.width * 0.4,
                height: 100,
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(40),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(120),
                    topRight: Radius.circular(70),
                  ),
                  color: kPrimaryLightColor,
                ),
              )
              // Image.asset(
              //   "assets/images/login_bottom.png",
              //   width: size.width * 0.4,
              // ),
              ),
          child,
        ],
      ),
    );
  }
}

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
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: size.width * 0.3,
                height: 100,
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(40),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomRight: Radius.circular(80),
                  ),
                  color: kPrimaryLightColor,
                ),
              )
              //Image.asset(
              //   "assets/images/main_top.png",
              //   width: size.width * 0.3,
              // ),
              ),
          Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: size.width * 0.2,
                height: 100,
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(40),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(80),
                  ),
                  color: kPrimaryLightColor,
                ),
              )
              // Image.asset(
              //   "assets/images/main_bottom.png",
              //   width: size.width * 0.2,
              // ),
              ),
          child,
        ],
      ),
    );
  }
}

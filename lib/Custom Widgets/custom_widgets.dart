import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomWidgets {
  Widget cahedImage(String url, double strokeWidth, double width, double hight,
      double spinSize) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: hight,
      fit: BoxFit.cover,
      progressIndicatorBuilder: (context, url, downloadProgress) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomWidgets().spinKit(spinSize)
          // CircularProgressIndicator(

          //     backgroundColor: Colors.white,
          //     strokeWidth: strokeWidth,
          //     value: downloadProgress.progress),
          ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  Widget spinKit(double size) {
    return SpinKitFadingCircle(
      size: size,
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? kPrimaryColor : kPrimaryLightColor,
          ),
        );
      },
    );
  }

  Widget alertDialog(String k) {
    return AlertDialog(
      //backgroundColor: kPrimaryColor,
      title: CustomWidgets().spinKit(50),
      content: Text(
        "$k",
        //style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}

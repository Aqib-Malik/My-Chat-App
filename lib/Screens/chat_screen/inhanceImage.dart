import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String imgUrl;
  DetailScreen({this.imgUrl});
  @override
  Widget build(BuildContext context) {
    //Size size=MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(imgUrl),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

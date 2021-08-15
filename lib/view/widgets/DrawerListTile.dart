import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final String name;
  final String imgpath;
  final Function ontap;

  const DrawerListTile({Key key, this.name, this.imgpath, this.ontap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(0.5, 2),
            blurRadius: 2,
            spreadRadius: 1.5,
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.blueGrey,
            Colors.blue,
          ],
        ),
      ),
      child: ListTile(
        onTap: ontap,
        leading: Image.asset(
          "assets/$imgpath",
          height: 40,
        ),
        contentPadding: EdgeInsets.only(
          left: 40,
          top: 5,
          bottom: 5,
        ),
        title: Text(
          "$name",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'rb',
              color: Colors.white),
        ),
      ),
    );
  }
}

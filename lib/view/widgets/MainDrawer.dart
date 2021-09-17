import 'package:flutter/material.dart';
import 'package:attendance_qr/view/Screens/add_student.dart';
import 'package:attendance_qr/view/Screens/home.dart';
import 'package:attendance_qr/view/Widgets/DrawerListTile.dart';
import 'package:attendance_qr/view/Screens/attendance.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DrawerListTile(
            imgpath: "home.png",
            name: "Home",
            ontap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Home(),
                ),
              );
            }),
        DrawerListTile(
          imgpath: "attendance.png",
          name: "Attendance",
          ontap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Attendance(),
              ),
            );
          },
        ),
        DrawerListTile(
          imgpath: "add_student.png",
          name: "Add Student",
          ontap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => AddStudent(),
              ),
            );
          },
        ),
      ],
    );
  }
}

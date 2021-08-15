import 'package:attendance_qr/controller/boxes.dart';
import 'package:attendance_qr/model/student.dart';
import 'package:attendance_qr/view/Widgets/show_customSnack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:attendance_qr/view/Widgets/appBar.dart';
import 'package:attendance_qr/view/Widgets/dialog.dart';
import 'package:attendance_qr/view/Widgets/drawerListTile.dart';
import 'package:attendance_qr/view/Widgets/mainDrawer.dart';

class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance>
    with SingleTickerProviderStateMixin {
  Animation animation, delayedAnimation, muchDelayedAnimation, leftCurve;
  AnimationController animationController;
  String _scannedData;
  List<Student> _students;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _students = Boxes.getStudents().values.toList();
    animationController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    delayedAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.2, 0.5, curve: Curves.fastOutSlowIn)));

    muchDelayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.3, 0.5, curve: Curves.fastOutSlowIn)));
  }

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    final double width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: CommonAppBar(
            title: "Take the Attendance",
            ontap: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          drawer: Drawer(
            elevation: 0,
            child: MainDrawer(),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Transform(
                  transform: Matrix4.translationValues(
                      muchDelayedAnimation.value * width, 0, 0),
                  child: DrawerListTile(
                      imgpath: "contact-book.png",
                      name: "Phone Number",
                      ontap: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => CustomDialog(
                            label: 'Phone Number',
                            icon: Icons.phone_android,
                            pressed: (String phoneNum) {
                              Student student = _students.firstWhere(
                                (element) =>
                                    element.phoneNum == phoneNum.trim(),
                                orElse: () => null,
                              );
                              if (student != null) {
                                student.addDate();
                                student.save();
                                showCustomSnack(
                                    _scaffoldKey.currentContext,
                                    'Attendance is taken successfully',
                                    Colors.green);
                              } else {
                                showCustomSnack(
                                    _scaffoldKey.currentContext,
                                    'No student with this phone number',
                                    Colors.red);
                              }
                            },
                          ),
                        );
                      }),
                ),
                Transform(
                  transform: Matrix4.translationValues(
                      muchDelayedAnimation.value * width, 0, 0),
                  child: DrawerListTile(
                      imgpath: "qr-code.png",
                      name: "Scan QR Code",
                      ontap: () async {
                        _scannedData = await FlutterBarcodeScanner.scanBarcode(
                            "#FFFFFF", "Cancel", false, ScanMode.QR);
                        if (_scannedData != '-1') {
                          _takeAttendanceById(
                              int.parse(_scannedData.split('/')[0]));
                        } else
                          showCustomSnack(
                            _scaffoldKey.currentContext,
                            'No qr code scanned',
                            Colors.red,
                          );
                      }),
                ),
                Transform(
                  transform: Matrix4.translationValues(
                      muchDelayedAnimation.value * width, 0, 0),
                  child: DrawerListTile(
                    imgpath: "id.png",
                    name: "ID Number",
                    ontap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => CustomDialog(
                          label: 'ID Number',
                          icon: Icons.person,
                          pressed: (String id) {
                            _takeAttendanceById(int.parse(id.trim()));
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _takeAttendanceById(int id) {
    Student student = _students.firstWhere(
      (element) => element.id == id,
      orElse: () => null,
    );
    if (student != null) {
      student.addDate();
      student.save();
      showCustomSnack(_scaffoldKey.currentContext,
          'Attendance is taken successfully', Colors.green);
    } else {
      showCustomSnack(
          _scaffoldKey.currentContext, 'No student with this ID', Colors.red);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

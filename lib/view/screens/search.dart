import 'package:attendance_qr/controller/boxes.dart';
import 'package:attendance_qr/model/student.dart';
import 'package:attendance_qr/view/Screens/attendance_screen.dart';
import 'package:attendance_qr/view/Screens/student_info.dart';
import 'package:attendance_qr/view/Widgets/AppBar.dart';
import 'package:attendance_qr/view/Widgets/show_customSnack.dart';
import 'package:flutter/material.dart';
import 'package:attendance_qr/view/Widgets/dialog.dart';
import 'package:attendance_qr/view/Widgets/drawerListTile.dart';
import 'package:attendance_qr/view/Widgets/mainDrawer.dart';
import 'package:intl/intl.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  Animation animation, delayedAnimation, muchDelayedAnimation, leftCurve;
  AnimationController animationController;
  final searchFieldController = TextEditingController();
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
            title: "Search",
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
              children: <Widget>[
                Transform(
                  transform: Matrix4.translationValues(
                      muchDelayedAnimation.value * width, 0, 0),
                  child: DrawerListTile(
                      imgpath: "contact-book.png",
                      name: "Phone Number",
                      ontap: () async {
                        return await showDialog(
                            context: context,
                            builder: (context) => CustomDialog(
                                  label: 'Phone Number',
                                  icon: Icons.phone_android,
                                  pressed: (String phoneNum) async {
                                    Student student = _students.firstWhere(
                                      (element) =>
                                          element.phoneNum == phoneNum.trim(),
                                      orElse: () => null,
                                    );
                                    if (student != null) {
                                      bool isDeleted = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StudentInfo(student)));
                                      if (isDeleted != null &&
                                          isDeleted == true) {
                                        _students.remove(student);
                                        showCustomSnack(
                                            _scaffoldKey.currentContext,
                                            'Student is deleted successfully',
                                            Colors.green);
                                      }
                                    } else {
                                      showCustomSnack(
                                          _scaffoldKey.currentContext,
                                          'No student with this phone number',
                                          Colors.red);
                                    }
                                  },
                                ));
                      }),
                ),
                Transform(
                    transform: Matrix4.translationValues(
                        muchDelayedAnimation.value * width, 0, 0),
                    child: DrawerListTile(
                        imgpath: "id.png",
                        name: "ID Number",
                        ontap: () async {
                          return await showDialog(
                              context: context,
                              builder: (context) => CustomDialog(
                                    label: 'ID Number',
                                    icon: Icons.person,
                                    pressed: (String id) async {
                                      int sId = int.parse(id.trim());
                                      Student student = _students.firstWhere(
                                        (element) => element.id == sId,
                                        orElse: () => null,
                                      );
                                      if (student != null) {
                                        bool isDeleted = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StudentInfo(student)));
                                        if (isDeleted != null &&
                                            isDeleted == true) {
                                          _students.remove(student);
                                          showCustomSnack(
                                              _scaffoldKey.currentContext,
                                              'Student is deleted successfully',
                                              Colors.green);
                                        }
                                      } else {
                                        showCustomSnack(
                                            _scaffoldKey.currentContext,
                                            'No student with this ID',
                                            Colors.red);
                                      }
                                    },
                                  ));
                        })),
                Transform(
                    transform: Matrix4.translationValues(
                        muchDelayedAnimation.value * width, 0, 0),
                    child: DrawerListTile(
                        imgpath: "calendar.png",
                        name: "Date of Registration",
                        ontap: () async {
                          DateTime date = await selectTimePicker(context);
                          if (date != null) {
                            String formattedDate =
                            DateFormat('d/M/yyyy').format(date);
                            List<Student> attendedStudents = [];
                            for (Student student in _students) {
                              if (student.attendanceList
                                  .firstWhere(
                                      (element) =>
                                  element.split(" ")[0] ==
                                      formattedDate,
                                  orElse: () => "")
                                  .isNotEmpty) {
                                attendedStudents.add(student);
                              }
                            }
                            if (attendedStudents.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AttendanceScreen(
                                      formattedDate, attendedStudents),
                                ),
                              );
                            } else {
                              showCustomSnack(
                                  context,
                                  'No students attended on this date',
                                  Colors.red);
                            }
                          }
                        })),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<DateTime> selectTimePicker(BuildContext context) async {
    DateTime date = DateTime.now();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
      return date;
    }
    return null;
  }
}

import 'package:attendance_qr/controller/boxes.dart';
import 'package:attendance_qr/controller/sheet_api.dart';
import 'package:attendance_qr/modalHud.dart';
import 'package:attendance_qr/model/student.dart';
import 'package:attendance_qr/view/Widgets/BouncingButton.dart';
import 'package:attendance_qr/view/Widgets/DashboardCards.dart';
import 'package:attendance_qr/view/Widgets/UserDetailCard.dart';
import 'package:attendance_qr/view/Widgets/show_customSnack.dart';
import 'package:flutter/material.dart';
import 'package:attendance_qr/view/Widgets/AppBar.dart';
import 'package:attendance_qr/view/Widgets/MainDrawer.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import '../../data_status.dart';
import 'add_student.dart';
import 'attendance.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  Animation animation, delayedAnimation, muchDelayedAnimation, leftCurve;
  AnimationController animationController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    delayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)));

    muchDelayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn)));

    leftCurve = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.5, 1.0, curve: Curves.easeInOut)));
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    animationController.forward();
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return Selector<ModalHud, bool>(
            selector: (context, modalHudProv) => modalHudProv.isLoading,
            builder: (context, isLoading, child) {
              return ModalProgressHUD(
                inAsyncCall: isLoading,
                child: Scaffold(
                  key: _scaffoldKey,
                  drawer: Drawer(
                    elevation: 0,
                    child: MainDrawer(),
                  ),
                  appBar: CommonAppBar(
                    ontap: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                    title: "Home",
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UserDetailCard(),
                      Expanded(
                        child: GridView(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 15.0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: width * 0.05,
                            crossAxisSpacing: width * 0.05,
                            childAspectRatio: 0.85,
                          ),
                          children: [
                            Transform(
                              transform: Matrix4.translationValues(
                                  muchDelayedAnimation.value * width, 0, 0),
                              child: Bouncing(
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Attendance(),
                                    ),
                                  );
                                },
                                child: DashboardCard(
                                  name: "Attendance",
                                  imgpath: "attendance.png",
                                ),
                              ),
                            ),
                            Transform(
                              transform: Matrix4.translationValues(
                                  muchDelayedAnimation.value * width, 0, 0),
                              child: Bouncing(
                                onPress: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            AddStudent(),
                                      ));
                                },
                                child: DashboardCard(
                                  name: "Add Student",
                                  imgpath: "add_student.png",
                                ),
                              ),
                            ),
                            Transform(
                              transform: Matrix4.translationValues(
                                  muchDelayedAnimation.value * width, 0, 0),
                              child: Bouncing(
                                onPress: () async {
                                  if (await _checkConnection(
                                      _scaffoldKey.currentContext)) {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          DeleteStudentDialog((value) async {
                                        Provider.of<ModalHud>(
                                                _scaffoldKey.currentContext,
                                                listen: false)
                                            .changeIsLoading(true);
                                        if (await SheetApi.deleteStudentById(
                                            int.parse(value.trim()))) {
                                          Provider.of<ModalHud>(
                                                  _scaffoldKey.currentContext,
                                                  listen: false)
                                              .changeIsLoading(false);
                                          showCustomSnack(
                                              _scaffoldKey.currentContext,
                                              "Student is deleted successfully from excel sheet",
                                              Colors.green);
                                        } else {
                                          Provider.of<ModalHud>(
                                                  _scaffoldKey.currentContext,
                                                  listen: false)
                                              .changeIsLoading(false);
                                          showCustomSnack(
                                              _scaffoldKey.currentContext,
                                              "Student isn\'t deleted from excel sheet",
                                              Colors.red);
                                        }
                                      }),
                                    );
                                  }
                                },
                                child: DashboardCard(
                                  name: "Delete Student",
                                  imgpath: "delete_student.png",
                                ),
                              ),
                            ),
                            Transform(
                              transform: Matrix4.translationValues(
                                  muchDelayedAnimation.value * width, 0, 0),
                              child: Bouncing(
                                onPress: () async {
                                  if (await _checkConnection(
                                      _scaffoldKey.currentContext)) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text(
                                                'Export Data',
                                              ),
                                              content:
                                                  Text('Data will be exported'),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    RaisedButton(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        color: Colors.blue,
                                                        textColor: Colors.white,
                                                        splashColor:
                                                            Colors.blue,
                                                        focusColor: Colors.blue,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              fontFamily: 'rb',
                                                              fontSize: 18),
                                                        )),
                                                    RaisedButton(
                                                      onPressed: () async {
                                                        Provider.of<ModalHud>(
                                                                _scaffoldKey
                                                                    .currentContext,
                                                                listen: false)
                                                            .changeIsLoading(
                                                                true);

                                                        Navigator.pop(context);

                                                        List<Student> students =
                                                            Boxes.getStudents()
                                                                .values
                                                                .toList();

                                                        if (students.isEmpty) {
                                                          Provider.of<ModalHud>(
                                                                  _scaffoldKey
                                                                      .currentContext,
                                                                  listen: false)
                                                              .changeIsLoading(
                                                                  false);
                                                          showCustomSnack(
                                                              _scaffoldKey
                                                                  .currentContext,
                                                              'No data to be exported',
                                                              Colors.red);
                                                        } else {
                                                          try {
                                                            switch (await SheetApi
                                                                .addData(
                                                                    students)) {
                                                              case DataStatus
                                                                  .done:
                                                                Provider.of<ModalHud>(
                                                                        _scaffoldKey
                                                                            .currentContext,
                                                                        listen:
                                                                            false)
                                                                    .changeIsLoading(
                                                                        false);
                                                                showCustomSnack(
                                                                    _scaffoldKey
                                                                        .currentContext,
                                                                    'Data is exported successfully',
                                                                    Colors
                                                                        .green);
                                                                break;

                                                              case DataStatus
                                                                  .no_update:
                                                                Provider.of<ModalHud>(
                                                                        _scaffoldKey
                                                                            .currentContext,
                                                                        listen:
                                                                            false)
                                                                    .changeIsLoading(
                                                                        false);
                                                                showCustomSnack(
                                                                    _scaffoldKey
                                                                        .currentContext,
                                                                    'No update to be exported',
                                                                    Colors.red);
                                                                break;

                                                              case DataStatus
                                                                  .wrong:
                                                                Provider.of<ModalHud>(
                                                                        _scaffoldKey
                                                                            .currentContext,
                                                                        listen:
                                                                            false)
                                                                    .changeIsLoading(
                                                                        false);
                                                                showCustomSnack(
                                                                    _scaffoldKey
                                                                        .currentContext,
                                                                    'Data isn\'t exported',
                                                                    Colors.red);
                                                                break;
                                                            }
                                                          } catch (ex) {
                                                            Provider.of<ModalHud>(
                                                                    _scaffoldKey
                                                                        .currentContext,
                                                                    listen:
                                                                        false)
                                                                .changeIsLoading(
                                                                    false);
                                                            showCustomSnack(
                                                                _scaffoldKey
                                                                    .currentContext,
                                                                'Data isn\'t exported',
                                                                Colors.red);
                                                          }
                                                        }
                                                      },
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      color: Colors.blue,
                                                      textColor: Colors.white,
                                                      splashColor: Colors.blue,
                                                      focusColor: Colors.blue,
                                                      child: Text(
                                                        'Confirm',
                                                        style: TextStyle(
                                                            fontFamily: 'rb',
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ));
                                  }
                                },
                                child: DashboardCard(
                                  name: "Export Data",
                                  imgpath: "csv_exp.png",
                                ),
                              ),
                            ),
                            Transform(
                              transform: Matrix4.translationValues(
                                  muchDelayedAnimation.value * width, 0, 0),
                              child: Bouncing(
                                onPress: () async {
                                  if (await _checkConnection(
                                      _scaffoldKey.currentContext)) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text(
                                                'Import Data',
                                              ),
                                              content: Text(
                                                'data will be imported from the excel sheet',
                                              ),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    RaisedButton(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        color: Colors.blue,
                                                        textColor: Colors.white,
                                                        splashColor:
                                                            Colors.blue,
                                                        focusColor: Colors.blue,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              fontFamily: 'rb',
                                                              fontSize: 18),
                                                        )),
                                                    RaisedButton(
                                                      onPressed: () async {
                                                        Provider.of<ModalHud>(
                                                                _scaffoldKey
                                                                    .currentContext,
                                                                listen: false)
                                                            .changeIsLoading(
                                                                true);

                                                        Navigator.pop(context);
                                                        if (Boxes.getStudents()
                                                            .values
                                                            .toList()
                                                            .isNotEmpty) {
                                                          Provider.of<ModalHud>(
                                                                  _scaffoldKey
                                                                      .currentContext,
                                                                  listen: false)
                                                              .changeIsLoading(
                                                                  false);
                                                          showCustomSnack(
                                                              context,
                                                              'LocalData isn\'t empty',
                                                              Colors.red);
                                                        } else {
                                                          try {
                                                            List<Student>
                                                                students =
                                                                await SheetApi
                                                                    .fetchData();
                                                            if (students
                                                                .isNotEmpty) {
                                                              final box = Boxes
                                                                  .getStudents();
                                                              students.forEach(
                                                                  (student) => box.put(
                                                                      student
                                                                          .id,
                                                                      student));
                                                              Provider.of<ModalHud>(
                                                                      _scaffoldKey
                                                                          .currentContext,
                                                                      listen:
                                                                          false)
                                                                  .changeIsLoading(
                                                                      false);
                                                              showCustomSnack(
                                                                  _scaffoldKey
                                                                      .currentContext,
                                                                  'Data has been imported successfully',
                                                                  Colors.green);
                                                            } else {
                                                              Provider.of<ModalHud>(
                                                                      _scaffoldKey
                                                                          .currentContext,
                                                                      listen:
                                                                          false)
                                                                  .changeIsLoading(
                                                                      false);
                                                              showCustomSnack(
                                                                  _scaffoldKey
                                                                      .currentContext,
                                                                  'No data has been imported',
                                                                  Colors.red);
                                                            }
                                                          } catch (ex) {
                                                            Provider.of<ModalHud>(
                                                                    _scaffoldKey
                                                                        .currentContext,
                                                                    listen:
                                                                        false)
                                                                .changeIsLoading(
                                                                    false);
                                                            showCustomSnack(
                                                                _scaffoldKey
                                                                    .currentContext,
                                                                'No data has been imported',
                                                                Colors.red);
                                                          }
                                                        }
                                                      },
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      color: Colors.blue,
                                                      textColor: Colors.white,
                                                      splashColor: Colors.blue,
                                                      focusColor: Colors.blue,
                                                      child: Text(
                                                        'Confirm',
                                                        style: TextStyle(
                                                            fontFamily: 'rb',
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ));
                                  }
                                },
                                child: DashboardCard(
                                  name: "Import Data",
                                  imgpath: "csv_imp.png",
                                ),
                              ),
                            ),
                            Transform(
                              transform: Matrix4.translationValues(
                                  muchDelayedAnimation.value * width, 0, 0),
                              child: Bouncing(
                                onPress: () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text(
                                              'Clear LocalData',
                                            ),
                                            content: Text(
                                                'Local data will be deleted',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  RaisedButton(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      color: Colors.blue,
                                                      textColor: Colors.white,
                                                      splashColor: Colors.blue,
                                                      focusColor: Colors.blue,
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                            fontFamily: 'rb',
                                                            fontSize: 18),
                                                      )),
                                                  RaisedButton(
                                                    onPressed: () async {
                                                      Provider.of<ModalHud>(
                                                              _scaffoldKey
                                                                  .currentContext,
                                                              listen: false)
                                                          .changeIsLoading(
                                                              true);

                                                      Navigator.pop(context);

                                                      if (Boxes.getStudents()
                                                          .values
                                                          .toList()
                                                          .isEmpty) {
                                                        Provider.of<ModalHud>(
                                                                _scaffoldKey
                                                                    .currentContext,
                                                                listen: false)
                                                            .changeIsLoading(
                                                                false);
                                                        showCustomSnack(
                                                            context,
                                                            'LocalData is already empty',
                                                            Colors.red);
                                                      } else {
                                                        Boxes.getStudents()
                                                            .clear();
                                                        Provider.of<ModalHud>(
                                                                _scaffoldKey
                                                                    .currentContext,
                                                                listen: false)
                                                            .changeIsLoading(
                                                                false);
                                                        showCustomSnack(
                                                            context,
                                                            'LocalData is deleted successfully',
                                                            Colors.green);
                                                      }
                                                    },
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    color: Colors.blue,
                                                    textColor: Colors.white,
                                                    splashColor: Colors.blue,
                                                    focusColor: Colors.blue,
                                                    child: Text(
                                                      'Confirm',
                                                      style: TextStyle(
                                                          fontFamily: 'rb',
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ));
                                },
                                child: DashboardCard(
                                  name: "Clear LocalData",
                                  imgpath: "delete.png",
                                ),
                              ),
                            ),
                            Transform(
                              transform: Matrix4.translationValues(
                                  muchDelayedAnimation.value * width, 0, 0),
                              child: Bouncing(
                                onPress: () async {
                                  if (await _checkConnection(
                                      _scaffoldKey.currentContext)) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text(
                                                'Clear ExcelSheet',
                                              ),
                                              content: Text(
                                                  'Excel sheet data will be deleted',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    RaisedButton(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        color: Colors.blue,
                                                        textColor: Colors.white,
                                                        splashColor:
                                                            Colors.blue,
                                                        focusColor: Colors.blue,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              fontFamily: 'rb',
                                                              fontSize: 18),
                                                        )),
                                                    RaisedButton(
                                                      onPressed: () async {
                                                        Provider.of<ModalHud>(
                                                                _scaffoldKey
                                                                    .currentContext,
                                                                listen: false)
                                                            .changeIsLoading(
                                                                true);

                                                        Navigator.pop(context);

                                                        try {
                                                          switch (await SheetApi
                                                              .deleteData()) {
                                                            case DataStatus
                                                                .done:
                                                              Provider.of<ModalHud>(
                                                                      _scaffoldKey
                                                                          .currentContext,
                                                                      listen:
                                                                          false)
                                                                  .changeIsLoading(
                                                                      false);
                                                              showCustomSnack(
                                                                  _scaffoldKey
                                                                      .currentContext,
                                                                  'Excel sheet data is deleted successfully',
                                                                  Colors.green);
                                                              break;
                                                            case DataStatus
                                                                .no_update:
                                                              Provider.of<ModalHud>(
                                                                      _scaffoldKey
                                                                          .currentContext,
                                                                      listen:
                                                                          false)
                                                                  .changeIsLoading(
                                                                      false);
                                                              showCustomSnack(
                                                                  _scaffoldKey
                                                                      .currentContext,
                                                                  'Worksheet is already empty',
                                                                  Colors.red);
                                                              break;
                                                            case DataStatus
                                                                .wrong:
                                                              Provider.of<ModalHud>(
                                                                      _scaffoldKey
                                                                          .currentContext,
                                                                      listen:
                                                                          false)
                                                                  .changeIsLoading(
                                                                      false);
                                                              showCustomSnack(
                                                                  _scaffoldKey
                                                                      .currentContext,
                                                                  'Excel sheet data isn\'t deleted',
                                                                  Colors.red);
                                                              break;
                                                          }
                                                        } catch (ex) {
                                                          Provider.of<ModalHud>(
                                                                  _scaffoldKey
                                                                      .currentContext,
                                                                  listen: false)
                                                              .changeIsLoading(
                                                                  false);
                                                          showCustomSnack(
                                                              _scaffoldKey
                                                                  .currentContext,
                                                              'Excel sheet data isn\'t deleted',
                                                              Colors.red);
                                                        }
                                                      },
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      color: Colors.blue,
                                                      textColor: Colors.white,
                                                      splashColor: Colors.blue,
                                                      focusColor: Colors.blue,
                                                      child: Text(
                                                        'Confirm',
                                                        style: TextStyle(
                                                            fontFamily: 'rb',
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ));
                                  }
                                },
                                child: DashboardCard(
                                  name: "Clear ExcelSheet",
                                  imgpath: "csv_del.png",
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  Future<bool> _checkConnection(BuildContext context) async {
    Provider.of<ModalHud>(context, listen: false).changeIsLoading(true);
    if (!await InternetConnectionChecker().hasConnection) {
      Provider.of<ModalHud>(context, listen: false).changeIsLoading(false);
      showSimpleNotification(
        Text("No Internet",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        background: Colors.red,
      );
      return false;
    }
    Provider.of<ModalHud>(context, listen: false).changeIsLoading(false);
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class DeleteStudentDialog extends StatefulWidget {
  final Function(String) _onPress;

  DeleteStudentDialog(this._onPress);

  @override
  _DeleteStudentDialogState createState() => _DeleteStudentDialogState();
}

class _DeleteStudentDialogState extends State<DeleteStudentDialog> {
  String _value = "";
  String _errText;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete Student',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Student will be deleted from excel sheet',
              style: TextStyle(color: Colors.red)),
          SizedBox(height: 14.0),
          TextField(
            onChanged: (val) => _value = val,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlue),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              prefixIcon: Icon(Icons.person_remove),
              hintText: 'Enter ID',
              filled: true,
              fillColor: Colors.grey[200],
              errorText: _errText,
            ),
          ),
        ],
      ),
      actions: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              color: Colors.blue,
              textColor: Colors.white,
              splashColor: Colors.blue,
              focusColor: Colors.blue,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(fontFamily: 'rb', fontSize: 18),
              )),
          RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              color: Colors.blue,
              textColor: Colors.white,
              splashColor: Colors.blue,
              focusColor: Colors.blue,
              onPressed: () async {
                if (_value.trim().isNotEmpty) {
                  Navigator.pop(context);
                  widget._onPress(_value);
                } else
                  setState(() {
                    _errText = "Please, enter student id";
                  });
              },
              child: Text(
                'Confirm',
                style: TextStyle(fontFamily: 'rb', fontSize: 18),
              )),
        ]),
      ],
    );
  }
}

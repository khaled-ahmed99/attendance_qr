import 'package:attendance_qr/controller/boxes.dart';
import 'package:attendance_qr/model/student.dart';
import 'package:attendance_qr/view/Widgets/show_customSnack.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:attendance_qr/view/Widgets/AppBar.dart';
import 'package:attendance_qr/view/Widgets/BouncingButton.dart';
import 'package:attendance_qr/view/Widgets/MainDrawer.dart';

class AddStudent extends StatefulWidget {
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent>
    with SingleTickerProviderStateMixin {
  Animation animation, delayedAnimation, muchDelayedAnimation, leftCurve;
  AnimationController animationController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _name, _phoneNum;
  String _selectedGrade = "";
  int _id;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _phoneNum = TextEditingController();
    _id = Boxes.getStudents().keys.isEmpty
        ? 1000
        : Boxes.getStudents().keys.last + 1;
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
    final double height = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        final GlobalKey<ScaffoldState> _scaffoldKey =
            new GlobalKey<ScaffoldState>();
        return Scaffold(
          key: _scaffoldKey,
          appBar: CommonAppBar(
            title: "Add Student",
            ontap: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          drawer: Drawer(
            elevation: 0,
            child: MainDrawer(),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment
                      .start, // remember to change it again when done
                  children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          muchDelayedAnimation.value * width, 0, 0),
                      child: Text(
                        "Choose Student Year",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          delayedAnimation.value * width, 0, 0),
                      child: DropdownSearch<String>(
                        validator: (v) => v == null ? "required field" : null,
                        onSaved: (v) => _selectedGrade = v,
                        hint: "Please Select Student Year",
                        mode: Mode.MENU,
                        items: [
                          "1st Secondary",
                          "2nd Secondary",
                          "3rd Secondary",
                        ],
                        showClearButton: true,
                        maxHeight: height / 3.5,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          muchDelayedAnimation.value * width, 0, 0),
                      child: Text(
                        "Add Student Name",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          delayedAnimation.value * width, 0, 0),
                      child: TextFormField(
                        controller: _name,
                        keyboardType: TextInputType.name,
                        onSaved: (v) => _name.text = v,
                        validator: (v) {
                          if (v.trim().isEmpty) return 'Please, enter a name';
                          if (RegExp(r'\d+').hasMatch(v.trim()))
                            return 'name must contain letters only';
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Student Name',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          muchDelayedAnimation.value * width, 0, 0),
                      child: Text(
                        "Add Student Phone Number",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          delayedAnimation.value * width, 0, 0),
                      child: TextFormField(
                        controller: _phoneNum,
                        keyboardType: TextInputType.phone,
                        onSaved: (v) => _phoneNum.text = v,
                        validator: (v) {
                          if (v.trim().isEmpty)
                            return 'Please, enter a phone number';
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Student Phone Number',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Transform(
                      transform: Matrix4.translationValues(
                          delayedAnimation.value * width, 0, 0),
                      child: Bouncing(
                        onPress: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            if (Boxes.getStudents().values.toList().firstWhere(
                                    (student) =>
                                student.phoneNum ==
                                    _phoneNum.text.trim(),
                                orElse: () => null) ==
                                null) {
                              Student student = Student(
                                  name: _name.text.trim(),
                                  phoneNum: _phoneNum.text.trim(),
                                  id: _id,
                                  year: _selectedGrade)
                                ..addDate();
                              Boxes.getStudents().put(_id, student);
                              _id++;
                              showCustomSnack(
                                  context,
                                  'Student is added successfully',
                                  Colors.green);
                            } else
                              showCustomSnack(context, 'Student already exists',
                                  Colors.red);
                            _name.clear();
                            _phoneNum.clear();
                          }                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.blue,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Add",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    _name.dispose();
    _phoneNum.dispose();
    super.dispose();
  }
}

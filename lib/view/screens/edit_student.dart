import 'package:attendance_qr/model/student.dart';
import 'package:attendance_qr/view/Widgets/show_customSnack.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:attendance_qr/view/Widgets/BouncingButton.dart';

class EditStudent extends StatefulWidget {
  static const String id = 'EditStudent';

  @override
  _EditStudentState createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent>
    with SingleTickerProviderStateMixin {
  Animation animation, delayedAnimation, muchDelayedAnimation, leftCurve;
  AnimationController animationController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name, _phoneNum;
  String _selectedGrade = "";
  Student _student;
  @override
  void initState() {
    super.initState();
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
    _student = ModalRoute.of(context).settings.arguments as Student;
    _name = _student.name;
    _phoneNum = _student.phoneNum;

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Edit Student",
              style: TextStyle(
                fontFamily: 'rb',
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
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
                        selectedItem: _student.year,
                        showSelectedItem: true,
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
                        keyboardType: TextInputType.name,
                        onSaved: (v) => _name = v,
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
                        initialValue: _name,
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
                        keyboardType: TextInputType.phone,
                        onSaved: (v) => _phoneNum = v,
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
                        initialValue: _phoneNum,
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
                            Student student = Student(
                                name: _name.trim(),
                                phoneNum: _phoneNum.trim(),
                                id: _student.id,
                                year: _selectedGrade);
                            if (student.name == _student.name &&
                                student.phoneNum == _student.phoneNum &&
                                student.year == _student.year) {
                              showCustomSnack(context,
                                  'No update has been done', Colors.red);
                            } else {
                              _student
                                ..name = student.name
                                ..phoneNum = student.phoneNum
                                ..year = student.year;
                              _student.save();
                              showCustomSnack(
                                  context,
                                  'Student is updated successfully',
                                  Colors.green);
                            }
                          }
                        },
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
                                "Edit",
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
    super.dispose();
  }
}

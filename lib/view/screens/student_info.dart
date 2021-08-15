import 'package:attendance_qr/model/student.dart';
import 'package:attendance_qr/view/Screens/edit_student.dart';
import 'package:attendance_qr/view/Widgets/show_customSnack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentInfo extends StatefulWidget {
  final Student _student;
  StudentInfo(this._student);

  @override
  _StudentInfoState createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<TextEditingController> _gradeValues = [];
  List<String> _errText = [];

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          height: height,
          child: Column(
            children: [
              Container(
                  padding:
                      EdgeInsets.only(top: statusBarHeight + 5, bottom: 8.0),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0, 2),
                        blurRadius: 2,
                        spreadRadius: 1.5,
                      ),
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
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13.0),
                        child: CircleAvatar(
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: Image.asset(
                              "assets/student.png",
                            ),
                          ),
                          radius: 26,
                          backgroundColor: Colors.yellow[200],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'name: ${widget._student.name}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'rb',
                                  color: Colors.white),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              'phone: ${widget._student.phoneNum}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'rb',
                                  color: Colors.white),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              'year: ${widget._student.year}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'rb',
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'id: ${widget._student.id}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'rb',
                              color: Colors.white),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                flex: 7,
                child: ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) {
                    String date = widget._student.attendanceList[index];
                    _gradeValues.add(TextEditingController());
                    _errText.add("");
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            offset: Offset(0, 2),
                            blurRadius: 7,
                          ),
                        ],
                      ),
                      child: ExpansionTile(
                        onExpansionChanged: (val) {
                          if (!val) {
                            _gradeValues[index].clear();
                            setState(() {
                              _errText[index] = "";
                            });
                          }
                        },
                        tilePadding: EdgeInsets.all(5.0),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'date: ${date.split(' ')[0]}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              'time: ${date.split(' ')[1]}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        childrenPadding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0)
                            .copyWith(top: 0.0),
                        children: [
                          Row(
                            children: [
                              Text(
                                "Grade: ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                width: 7.0,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _gradeValues[index],
                                  onChanged: (value) {
                                    _gradeValues[index].text = value;
                                    _gradeValues[index].selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: _gradeValues[index]
                                                .text
                                                .length));
                                  },
                                  enabled:
                                      widget._student.grades[index].isEmpty,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  decoration: InputDecoration(
                                    errorText: _errText[index].isEmpty
                                        ? null
                                        : _errText[index],
                                    hintText:
                                        widget._student.grades[index].isEmpty
                                            ? 'Enter grade'
                                            : widget._student.grades[index],
                                    hintStyle: TextStyle(
                                        color: widget
                                                ._student.grades[index].isEmpty
                                            ? Colors.grey
                                            : Colors.black),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide:
                                          BorderSide(color: Colors.blue),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                  ),
                                ),
                              ),
                              widget._student.grades[index].isEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 35.0,
                                      ),
                                      onPressed: () {
                                        if (_gradeValues[index]
                                            .text
                                            .trim()
                                            .isNotEmpty) {
                                          setState(() {
                                            widget._student.grades[index] =
                                                _gradeValues[index].text;
                                          });
                                          widget._student.save();
                                          showCustomSnack(
                                              context,
                                              "Grade is added successfully",
                                              Colors.green);
                                        } else {
                                          setState(() {
                                            _errText[index] =
                                                "Please, enter a grade";
                                          });
                                        }
                                      },
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: widget._student.attendanceList.length,
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  'Delete Student',
                                ),
                                content: Text('Student data will be deleted',
                                    style: TextStyle(color: Colors.red)),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
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
                                                fontFamily: 'rb', fontSize: 18),
                                          )),
                                      RaisedButton(
                                        onPressed: () async {
                                          widget._student.delete();
                                          Navigator.pop(context);
                                          Navigator.pop(
                                              _scaffoldKey.currentContext,
                                              true);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
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
                                              fontFamily: 'rb', fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                          child: Text('Delete'),
                          style: ElevatedButton.styleFrom(),
                        ),
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0, bottom: 5.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(
                              context,
                              EditStudent.id,
                              arguments: widget._student,
                            );
                          },
                          child: Text('Update'),
                          style: ElevatedButton.styleFrom(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _gradeValues.forEach((element) => element.dispose());
    super.dispose();
  }
}

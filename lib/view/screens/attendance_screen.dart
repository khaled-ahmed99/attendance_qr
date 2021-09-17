import 'package:attendance_qr/model/student.dart';
import 'package:flutter/material.dart';

class AttendanceScreen extends StatelessWidget {
  final String _date;
  final List<Student> _students;

  AttendanceScreen(this._date, this._students);

  @override
  Widget build(BuildContext context) {
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
          "Students Attended on $_date",
          style: TextStyle(
            fontFamily: 'rb',
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        itemCount: _students.length,
        itemBuilder: (context, index) {
          int dateIndex = _students[index]
              .attendanceList
              .indexWhere((element) => element.split(' ')[0] == _date);
          String time =
              _students[index].attendanceList[dateIndex].split(" ")[1];
          String grade = _students[index].grades[dateIndex];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.blueGrey,
                    Colors.blue,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Name: ",
                        style: TextStyle(
                          fontFamily: 'rb',
                          color: Colors.yellow[300],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "${_students[index].name}",
                        style: TextStyle(
                          fontFamily: 'rb',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "ID: ",
                        style: TextStyle(
                          fontFamily: 'rb',
                          color: Colors.yellow[300],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "${_students[index].id}",
                        style: TextStyle(
                          fontFamily: 'rb',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Phone Num: ",
                        style: TextStyle(
                          fontFamily: 'rb',
                          color: Colors.yellow[300],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "${_students[index].phoneNum}",
                        style: TextStyle(
                          fontFamily: 'rb',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Year: ",
                        style: TextStyle(
                          fontFamily: 'rb',
                          color: Colors.yellow[300],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "${_students[index].year}",
                        style: TextStyle(
                          fontFamily: 'rb',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Time: ",
                        style: TextStyle(
                          fontFamily: 'rb',
                          color: Colors.yellow[300],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "$time",
                        style: TextStyle(
                          fontFamily: 'rb',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  if (grade.isNotEmpty)
                    Row(
                      children: [
                        Text(
                          "Grade: ",
                          style: TextStyle(
                            fontFamily: 'rb',
                            color: Colors.yellow[300],
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "$grade",
                          style: TextStyle(
                            fontFamily: 'rb',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'dart:collection';
import 'package:attendance_qr/controller/sheet_api.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
part 'student.g.dart';

@HiveType(typeId: 0)
class Student extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String phoneNum;

  @HiveField(3)
  String year;

  @HiveField(4)
  List<String> _attendanceList = [];

  @HiveField(5)
  List<String> grades = [];

  Student({
    @required this.name,
    @required this.phoneNum,
    @required this.id,
    @required this.year,
  });

  Student.fromJson(Map<String, String> json) {
    id = int.parse(json[SheetApi.id]);
    name = json[SheetApi.name];
    phoneNum = '0' + json[SheetApi.phoneNum];
    year = json[SheetApi.year];
  }

  void addDate() {
    String date = DateFormat('d/M/yyyy HH:mm').format(DateTime.now());
    if (_attendanceList
        .firstWhere((element) => element.split(" ")[0] == date.split(" ")[0],
            orElse: () => "")
        .isEmpty) {
      _attendanceList.add(date);
      grades.add("");
    }
  }

  UnmodifiableListView<String> get attendanceList =>
      UnmodifiableListView(_attendanceList);

  Map<String, dynamic> toJson() => {
        SheetApi.id: this.id,
        SheetApi.name: this.name,
        SheetApi.phoneNum: this.phoneNum,
        SheetApi.year: this.year,
      };
}

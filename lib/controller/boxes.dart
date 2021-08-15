import 'package:hive/hive.dart';
import 'package:attendance_qr/model/student.dart';

class Boxes {
  static Box<Student> getStudents() => Hive.box<Student>('students');
}

import 'package:attendance_qr/controller/boxes.dart';
import 'package:attendance_qr/model/student.dart';
import 'package:gsheets/gsheets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data_status.dart';

class SheetApi {
  static const String _spreadSheetId =
      "1R9sYQege7HFdyLzT_sT3m__JchaeHxJcc1l2Opk37Ao";

  static const String _credentials = r'''
      {
  "type": "service_account",
  "project_id": "global-justice-321001",
  "private_key_id": "b782ede549f16151c566d0bbb363f464f182a56a",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCpzgAzf870KrfU\ni+fbgmSQ8C7ZvBDYgYcRiUbdKRLEKrV2HhE1pJ2O+nwSVOk5GY7dgDk7gGC+v9Je\n49sw54FTYGXiBaJSarkoNP56TlFWuqyo1lLopcyuhPPMnD/AzXURGPWg6iUmSgmI\n1zBVrXGkTf4N60mucYRg5PX41/V60fJ4vDe0HhYoel6XjESB9m8CL7Q5mfHAe/AO\nNzTPvTf+oVbuYSwlbqfrx2zvIlGaNK5WBkjnq4nmI2gE+pS1qy3KqU0MNw+KL0O0\n85j1YndlE5+Co9SwqM3AwgnGg34zVV1v/U/8OVuJKw5nSU6myXOe+UvMQNTe2FUF\nAHqqmBodAgMBAAECggEACb4UMeA75LN3alOqoQ65Vr2JGpyuj2rYb+T4nWN9ZvxC\nVBLD5FgxDWKJcC3SAcuEcGiqdU5XfqpCgjJAQcKOn3+GPkfEzptpSzQbLl5ETshq\nyUx0DlLGTHRms+R6c0VL2bLHvmH2HAfJxexUIsj5nmE2hIrtkSYvNQtTTOHrJ47r\nKxkMXT6ZEfBM16sQaQ79Q5CmzIzAZC9GVK0F53zyf3vuE80z7mWeLQG2vsIT1f2S\nyZPfiVWwKTdPYuK4uNf1xgh30zlWVVPZl4DB+TuqK+rglTFBdNKUiKZ83XeusQQJ\n/PrpjdrWnwCIRDhuYFJF5osOITEC+Y+VixoJemvO2wKBgQDis2z/XRiHl2aQrMez\ngsUUH6z7xbGzsaNmb5ZZ+zRxoaIhv4s5htVdSPja7c8vgxm6TTVbhiS0kgnJw7B1\nY0gt6mWb7QH+W0ecVik2Xvk5moq6dOJghfZpkAhN5GrGmxSwFBJe1FR8XIHnhb/2\nZDNDFGl9tV2o9CBHkaJFCnEaywKBgQC/wB7Wx/MkWEWNoITzHhMpTlXxb2M8mTvs\nzqiq3ZlsABTDTMXUmZGX46mhR7jru8Gzj8/dPiGkE+DAVujcGQD53NI4VMnG9mgv\n2dBVIW/Io5O+Em4oFGioKnuy4G/IiJ+bJVKbI3zDub002stVGYuzgnltpUtNmemw\nSlTsE7x5twKBgHKo43kpIe36gnKsIPlHK9yoxLo23FERiJ6X08jBCF5srO86zPUU\noDflX5CDdSYHvex/fnxDFa+KqY61/jrxMyGeCzRZJIf8rPSCk6efU5hx9LanxZOi\nTeZIZhrXa7X12/nOvRffdrfLphxuho/dUBweZ9if8bYxe14XZ6ZZyKkPAoGAJ+iM\ngpdK+52DnF50TUVNJ6OuL3nHZa1e04KPiEBm1huONreb1QvBSaOQgoiy7B0/y2d7\nE8kCp2ubs2xjOqvZkCdteVvsQwS12n+y5IT5BwFElqKvWpgk0BtHc4tSuKH21guG\njdNs/C+EOaPv/d47PTlCnJdyfMwz3wUZd6kD6TECgYAEX4K7FDtlaypw22sWX0FN\nVKvLSQO2YbWUiMlz4MqJM7+J0l7z0UCXGCRRAO1TmS7jy5Jafn7gzFBEC1PwUOts\nsuJ9qFLfWMl6HMJC87Vg+ufHTmK6WJxKu6JnBsaZkZT873HwuR4kfMklLHaEc5k9\nXBlVe5HyN2F7dSJp1r06mQ==\n-----END PRIVATE KEY-----\n",
  "client_email": "attendanceqr@global-justice-321001.iam.gserviceaccount.com",
  "client_id": "101023411303490085417",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/attendanceqr%40global-justice-321001.iam.gserviceaccount.com"
}
      ''';

  static final GSheets _gSheet = GSheets(_credentials);
  static Worksheet _worksheet;

  static const String id = "id";
  static const String name = "name";
  static const String phoneNum = "phone number";
  static const String year = "year";
  static const String qr = "qr code";

  static Future<void> init() async {
    final Spreadsheet spreadSheet = await _gSheet.spreadsheet(_spreadSheetId);
    _worksheet = spreadSheet.worksheetByTitle("students");
  }

  static Future<DataStatus> addData(List<Student> students) async {
    if (_worksheet == null) await init();
    final lastRow = await _worksheet.values.lastRow();
    if (lastRow == null) {
      List<Map<String, dynamic>> rows = await _createRowsMap(students);
      if (rows == null) return DataStatus.wrong;
      await _worksheet.values.insertRow(1, [id, name, phoneNum, year, qr]);
      return await _worksheet.values.map.appendRows(rows)
          ? DataStatus.done
          : DataStatus.wrong;
    } else {
      int rowId = int.tryParse(lastRow.first);
      if (rowId == students.last.id) {
        return DataStatus.no_update;
      } else {
        List<Map<String, dynamic>> rows;
        if (rowId == null) {
          rows = await _createRowsMap(students);
        } else {
          int startIndex = Boxes.getStudents()
                  .values
                  .toList()
                  .indexOf(Boxes.getStudents().get(rowId)) +
              1;
          rows = await _createRowsMap(students.sublist(startIndex));
        }
        if (rows == null) return DataStatus.wrong;
        return await _worksheet.values.map.appendRows(rows)
            ? DataStatus.done
            : DataStatus.wrong;
      }
    }
  }

  static Future<List<Student>> fetchData() async {
    if (_worksheet == null) await init();
    final lastRow = await _worksheet.values.lastRow();
    if (lastRow == null || int.tryParse(lastRow.first) == null)
      return <Student>[];

    final List<Map<String, String>> students =
        (await _worksheet.values.map.allRows())
            .where((element) => element[SheetApi.id] != "")
            .toList();
    return students == null
        ? <Student>[]
        : students.map((student) => Student.fromJson(student)).toList();
  }

  static Future<DataStatus> deleteData() async {
    if (_worksheet == null) await init();
    final lastRow = await _worksheet.values.lastRow();
    if (lastRow == null || int.tryParse(lastRow.first) == null)
      return DataStatus.no_update;
    return await _worksheet.clear() ? DataStatus.done : DataStatus.wrong;
  }

  static Future<bool> deleteStudentById(int id) async {
    if (_worksheet == null) await init();
    final index = await _worksheet.values.rowIndexOf(id);
    if (index == -1) return false;
    return await _worksheet.deleteRow(index);
  }

  static Future<List<Map<String, dynamic>>> _createRowsMap(
      List<Student> students) async {
    List<Map<String, dynamic>> rows = [];
    Map<String, dynamic> row;
    for (Student student in students) {
      row = student.toJson();
      row[qr] = await _createQr(student);
      if (row[qr] == null) return null;
      print(student.id);
      print(row[qr]);
      rows.add(row);
      await Future.delayed(Duration(seconds: 1));
    }
    return rows;
  }

  static Future _createQr(Student student) async {
    http.Response res = await http.get(
      Uri.parse('https://codzz-qr-cods.p.rapidapi.com/getQrcode').replace(
        queryParameters: <String, String>{
          'value':
              '${student.id}/${student.name}/${student.phoneNum}/${student.year}',
          'type': 'text',
        },
      ),
      headers: {
        'x-rapidapi-key': 'a5902fc2dcmsh3ece743970bca2fp18c009jsn180569cf39ef',
        'x-rapidapi-host': 'codzz-qr-cods.p.rapidapi.com',
      },
    );
    if (res.statusCode == 200) {
      return json.decode(res.body)['url'];
    }
    return null;
  }
}

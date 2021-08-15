import 'package:attendance_qr/modalHud.dart';
import 'package:attendance_qr/view/Screens/edit_student.dart';
import 'package:attendance_qr/view/Screens/loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:attendance_qr/view/Screens/home.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:attendance_qr/model/student.dart';
import 'package:provider/provider.dart';
import 'controller/boxes.dart';
import 'controller/sheet_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(StudentAdapter());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: ChangeNotifierProvider<ModalHud>(
        create: (context) => ModalHud(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Dr. Mahmoud Elsherif',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: FutureBuilder(
            future: Hive.openBox<Student>('students'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done)
                return Home();
              return LoadingScreen();
            },
          ),
          routes: {
            EditStudent.id: (context) => EditStudent(),
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    Boxes.getStudents().compact();
    Hive.close();
    super.dispose();
  }
}

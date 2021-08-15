import 'package:attendance_qr/view/Widgets/AppBar.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        ontap: () {},
        isLoading: true,
        title: "Home",
      ),
      body: Center(
        child: SizedBox(
          height: 40,
          width: 40,
          child: CircularProgressIndicator(
            strokeWidth: 5.0,
          ),
        ),
      ),
    );
  }
}

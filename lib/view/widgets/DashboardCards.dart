import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String name;
  final String imgpath;

  const DashboardCard({Key key, this.name, this.imgpath});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(0, 2),
            blurRadius: 7,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/$imgpath",
            width: 53,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              "$name",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'rb',
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

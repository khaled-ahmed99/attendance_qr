import 'package:attendance_qr/view/Screens/search.dart';
import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Function ontap;
  final bool isLoading;
  const CommonAppBar({
    Key key,
    this.title,
    this.ontap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "$title",
        style: TextStyle(
          fontFamily: 'rb',
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        color: Colors.black,
        onPressed: ontap,
        icon: Icon(
          Icons.menu,
        ),
      ),
      actions: [
        InkWell(
          onTap: () {
            isLoading
                ? null
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Search(),
                    ),
                  );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 13.0),
            child: Image.asset(
              "assets/search.png",
              width: 30,
            ),
          ),
        )
      ],
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(50);
}

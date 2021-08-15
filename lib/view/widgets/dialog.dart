import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomDialog extends StatefulWidget {
  final String label;
  final IconData icon;
  final Function(String) pressed;

  CustomDialog(
      {@required this.label, @required this.icon, @required this.pressed});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  String _value = "";
  String _errText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '${widget.label}',
      ),
      content: TextField(
        onChanged: (val) => _value = val,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.lightBlue),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          prefixIcon: Icon(widget.icon),
          hintText: 'Enter Number',
          filled: true,
          fillColor: Colors.grey[200],
          errorText: _errText,
        ),
      ),
      contentPadding: EdgeInsets.all(32),
      actions: [
        RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            color: Colors.blue,
            textColor: Colors.white,
            splashColor: Colors.blue,
            focusColor: Colors.blue,
            onPressed: () {
              if (_value.trim().isNotEmpty) {
                Navigator.pop(context);
                widget.pressed(_value);
              } else
                setState(() {
                  _errText = "Please, enter ${widget.label.toLowerCase()}";
                });
            },
            child: Text(
              'Confirm',
              style: TextStyle(fontFamily: 'rb', fontSize: 18),
            )),
      ],
    );
  }
}

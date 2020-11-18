import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDialogBox extends StatefulWidget {
  final Widget title;
  final Widget body;
  final String cancelText;
  final String acceptText;
  final Function onPressed;

  CustomDialogBox({
    @required this.title,
    @required this.body,
    @required this.cancelText,
    @required this.acceptText,
    @required this.onPressed,
  });

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  StateSetter _setState;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        _setState = setState;
        return AlertDialog(
          key: UniqueKey(),
          title: widget.title,
          content: widget.body,
          contentPadding: EdgeInsets.all(10),
          actions: <Widget>[
            FlatButton(
              child: Text(
                widget.cancelText,
                style: TextStyle(
                  color: Colors.green[900],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                widget.acceptText,
                style: TextStyle(
                  color: Colors.green[900],
                ),
              ),
              onPressed: widget.onPressed,
            ),
          ],
        );
      },
    );
  }
}

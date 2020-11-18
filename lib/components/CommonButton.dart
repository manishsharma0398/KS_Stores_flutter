import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final Function onPressed;
  final String btnText;

  CommonButton({
    @required this.onPressed,
    @required this.btnText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 11),
        onPressed: onPressed,
        child: Text(
          btnText,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            fontFamily: "Lato",
          ),
        ),
      ),
    );
  }
}

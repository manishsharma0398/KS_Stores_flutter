import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final FocusNode currentFocusNode;
  final FocusNode nextFocusNode;
  final TextEditingController controller;
  final String placeholder;
  final String label;
  final TextInputType keyboardType;
  final int maxLines;

  CustomTextFormField({
    @required this.placeholder,
    @required this.label,
    @required this.currentFocusNode,
    this.nextFocusNode,
    @required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  _fieldFocusChange(
    BuildContext context,
    FocusNode currentFocus,
    FocusNode nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void removeFocus() {
    FocusScope.of(context).unfocus();
    FocusScope.of(context).requestFocus();
    FocusManager.instance.primaryFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: removeFocus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(widget.currentFocusNode);
            },
            child: Text(
              widget.label,
              // style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(widget.currentFocusNode);
            },
            child: Container(
              color: Colors.grey[200],
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 12,
                bottom: 8,
              ),
              child: TextFormField(
                autofocus: false,
                controller: widget.controller,
                focusNode: widget.currentFocusNode,
                keyboardType: widget.maxLines > 1
                    ? TextInputType.multiline
                    : widget.keyboardType,
                textInputAction:
                    widget.maxLines == 1 && widget.nextFocusNode == null
                        ? TextInputAction.done
                        : widget.maxLines > 1
                            ? TextInputAction.newline
                            : TextInputAction.next,
                maxLines: widget.maxLines,
                onFieldSubmitted: (_) {
                  if (widget.nextFocusNode != null) {
                    _fieldFocusChange(
                        context, widget.currentFocusNode, widget.nextFocusNode);
                  } else {
                    removeFocus();
                  }
                },
                decoration: InputDecoration.collapsed(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: widget.placeholder,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

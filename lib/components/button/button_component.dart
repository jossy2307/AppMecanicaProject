import 'package:flutter/material.dart';

class ButtonComponent extends StatefulWidget {
  final String text;
  final bool validate;
  final Function() callback;

  const ButtonComponent(
      {super.key,
      required this.text,
      required this.validate,
      required this.callback});

  @override
  ButtonComponentState createState() => ButtonComponentState();
}

class ButtonComponentState extends State<ButtonComponent> {
  _callback() {
    return widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.validate
          ? () {
              _callback();
            }
          : null,
      style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFDC252C),
          foregroundColor: const Color(0xFFF3F2F2),
          disabledForegroundColor:const Color(0xFFF3F2F2) ,
          disabledBackgroundColor: const Color(0xFFF5686C) ,
          padding: const EdgeInsets.all(10)
      ),
      child: Text(widget.text),
    );
  }
}

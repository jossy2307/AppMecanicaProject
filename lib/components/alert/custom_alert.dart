import 'package:app_registro_movil/components/button/button_component.dart';
import 'package:flutter/material.dart';

class CustomAlert extends StatelessWidget {
  final String message;
  final String title;
  final VoidCallback callback;

  const CustomAlert(
      {super.key,
      required this.message,
      required this.callback,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        ButtonComponent(
            text: 'OK',
            validate: true,
            callback: () {
              Navigator.pop(context);
              callback();
            }),
      ],
    );
  }
}

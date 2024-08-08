import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;
  final IconData? iconButton;

  const CustomButton(
      {super.key,
      required this.text,
      required this.iconButton,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        callback();
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFFDC252C), // Color del texto del botón
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Align(
          alignment: Alignment.center,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            iconButton != null
                ? Icon(
                    iconButton,
                    size: 40,
                  )
                : const Text(''),
            const SizedBox(
              width: 12,
              height: 10,
            ),
            Text(
              text,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            const Icon(
                    Icons.navigate_next,
                    size: 40,
                  )
          ])),
    );
  }
}

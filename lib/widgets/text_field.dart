// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hint;
  final TextInputType textInputType;
  const TextInputField({super.key, required this.textEditingController, required this.hint, required this.textInputType});

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: this.widget.textEditingController,
        keyboardType: this.widget.textInputType,
        obscureText: this.widget.textInputType == TextInputType.visiblePassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: this.widget.hint,
        ),
      ),
    );
  }
}

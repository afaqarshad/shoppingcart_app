import 'package:flutter/material.dart';

class MyTextFormFields extends StatelessWidget {
  final String hintText;
  TextEditingController? textController = TextEditingController();
  bool? obsText;

  MyTextFormFields(
      {super.key,
      required this.hintText,
      this.textController,
      required this.obsText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: textController,
      obscureText: obsText!,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.black,
            ),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
  }
}

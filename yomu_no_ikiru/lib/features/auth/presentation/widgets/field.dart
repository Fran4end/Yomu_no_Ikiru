import 'package:flutter/material.dart';

class Field extends StatelessWidget {
  const Field({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
  });

  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        color: Colors.transparent,
        child: TextFormField(
          obscureText: isObscureText,
          decoration: InputDecoration(
            hintText: hintText,
          ),
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "$hintText is missing";
            }
            return null;
          },
        ),
      ),
    );
  }
}

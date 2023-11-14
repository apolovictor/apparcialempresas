import 'package:flutter/material.dart';

Widget registerFieldWidget(
  TextEditingController controller,
  String fieldName,
  BuildContext context,
) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
      hintText: fieldName,
      fillColor: Colors.white.withOpacity(0.4),
      // fillColor: const Color(0xFFD7D7F4),
      filled: true,
    ),
  );
}

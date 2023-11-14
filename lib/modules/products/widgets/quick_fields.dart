import 'package:flutter/material.dart';

Widget fieldWidget(TextEditingController controller, String fieldName,
    BuildContext context, Color secondaryColor) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
      hintText: fieldName,
      fillColor: secondaryColor,
      // fillColor: const Color(0xFFD7D7F4),
      filled: true,
    ),
  );
}

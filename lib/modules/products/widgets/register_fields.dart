import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';

//
Widget registerFieldWidget(
  TextEditingController controller,
  String fieldName,
  BuildContext context,
) {
  return fieldName == "Preço"
      ? TextFormField(
          inputFormatters: [
              CurrencyTextInputFormatter.currency(
                  locale: 'pt_Br', symbol: 'R\$', decimalDigits: 2)
            ],
          controller: controller,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12)),
            hintText: fieldName,
            fillColor: Colors.white.withOpacity(0.4),
            // fillColor: const Color(0xFFD7D7F4),
            hintStyle: const TextStyle(color: Colors.white),
            filled: true,
          ),
          keyboardType: TextInputType.number)
      : TextFormField(
          controller: controller,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12)),
            hintText: fieldName,
            fillColor: Colors.white.withOpacity(0.4),
            // fillColor: const Color(0xFFD7D7F4),
            hintStyle: const TextStyle(color: Colors.white),
            filled: true,
          ),
          keyboardType:
              fieldName == "Nome" ? TextInputType.text : TextInputType.number);
}

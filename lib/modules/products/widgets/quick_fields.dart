import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';

Widget fieldWidget(TextEditingController controller, String fieldName,
    String hintText, BuildContext context, Color secondaryColor) {
  return fieldName == 'Preço' || fieldName == 'Promoção'
      ? TextFormField(
          inputFormatters: [
              CurrencyTextInputFormatter(
                  locale: 'pt_Br', symbol: 'R\$', decimalDigits: 2)
            ],
          controller: controller,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12)),
            hintText: hintText,
            fillColor: secondaryColor,
            // fillColor: const Color(0xFFD7D7F4),
            filled: true,
          ),
          keyboardType: TextInputType.number)
      : TextFormField(
          controller: controller,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12)),
            hintText: hintText,
            fillColor: secondaryColor,
            // fillColor: const Color(0xFFD7D7F4),
            filled: true,
          ),
          keyboardType:
              fieldName == "Nome" ? TextInputType.text : TextInputType.number);
}

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';

Widget fieldWidget(TextEditingController controller, String fieldName,
    String hintText, BuildContext context, Color secondaryColor) {
  return fieldName == 'Preço' ||
          fieldName == 'Promoção' ||
          fieldName == 'Preço Unitário'
      ? TextFormField(
          inputFormatters: [
              CurrencyTextInputFormatter.currency(
                  locale: 'pt_Br', symbol: 'R\$', decimalDigits: 2)
            ],
          controller: controller,
          style: const TextStyle(fontSize: 18),
          decoration: InputDecoration(
            label: Text(fieldName),
            labelStyle: const TextStyle(fontSize: 16, color: Colors.black54),
            focusColor: Colors.black54,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12)),
            hintText: hintText == 'null' ? '' : hintText,
            fillColor: secondaryColor,
            // fillColor: const Color(0xFFD7D7F4),
            filled: true,
          ),
          keyboardType: TextInputType.number)
      : TextFormField(
          controller: controller,
          style: const TextStyle(fontSize: 18),
          decoration: InputDecoration(
            label: Text(fieldName),
            labelStyle: const TextStyle(fontSize: 16, color: Colors.black54),
            focusColor: Colors.black54,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(12)),
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

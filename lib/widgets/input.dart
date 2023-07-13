import 'package:flutter/material.dart';

import '../helper/constant.dart';

class TextInput extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType inputType;
  final String label;
  final bool focus;
  final bool secure;
  final bool readonly;
  final Widget? suffixIcon, prefixIcon;
  final Function(String x)? onChange;
  final Function()? onTap;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onEditingComplete;

  const TextInput({
    super.key,
    this.controller,
    this.inputType = TextInputType.text,
    required this.label,
    this.focus = false,
    this.secure = false,
    this.readonly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChange,
    this.onTap,
    this.validator,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: secure,
      autofocus: focus,
      readOnly: readonly,
      decoration: InputDecoration(
        filled: true,
        // fillColor: Colors.grey[200],
        hintText: label,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: lightGreyColor),
          borderRadius: BorderRadius.circular(5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: lightGreyColor),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onChanged: onChange,
      onTap: onTap,
      validator: validator,
    );
  }
}

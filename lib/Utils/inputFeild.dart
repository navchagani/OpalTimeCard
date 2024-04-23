import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final Widget? icon;
  final String labelText;
  final bool? toHide, enabled, noFill;
  final String hintText;
  final TextEditingController? controller;
  final Function(String value)? onChanged;
  final int? maxLines;
  final TextInputType? inputType;

  const CustomInputField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.controller,
    this.toHide,
    this.onChanged,
    this.maxLines,
    this.inputType,
    this.enabled,
    this.noFill,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled ?? true,
      controller: controller,
      obscureText: toHide ?? false,
      onChanged: onChanged,
      maxLines: maxLines ?? 1,
      keyboardType: inputType ?? TextInputType.text,
      decoration: InputDecoration(
        // icon: icon,
        isDense: true,
        filled: noFill ?? true ? true : false,
        suffixText: labelText,
        suffixIcon: icon,
        suffixStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: const EdgeInsets.all(16),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}

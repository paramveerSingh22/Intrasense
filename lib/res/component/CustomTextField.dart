import 'package:flutter/material.dart';
import 'package:intrasense/utils/AppColors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final bool obscureText;
  final int minLines;
  final int maxLines;
  final TextInputType? keyboardType; // Optional input type
  final Function(String)? onChanged; // Added onChanged callback

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.controller,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.obscureText = false,
    this.minLines = 1,  // Default to 1 line
    this.maxLines = 1,  // Default to 1 line, keeps it single-line by default
    this.keyboardType, // Optional input type parameter
    this.onChanged, // Accept onChanged as parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      obscureText: obscureText,
      keyboardType: keyboardType, // Set the keyboard type
      style: const TextStyle(
        fontFamily: 'PoppinsRegular',
        fontSize: 13.0,
      ),
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppColors.hintColor,
          fontSize: 13.0,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: AppColors.editFieldBorderColour,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: AppColors.editFieldBorderColour,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: AppColors.editFieldBorderColour,
            width: 1.0,
          ),
        ),
        suffixIcon: suffixIcon != null
            ? Container(
          width: 20,  // Desired width
          height: 20,  // Desired height
          alignment: Alignment.center,
          child: suffixIcon,  // Ensure the icon is centered
        )
            : null,
      ),
      onChanged: onChanged, // Handle the onChanged callback
    );
  }
}
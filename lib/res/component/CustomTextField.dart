import 'package:flutter/material.dart';
import 'package:intrasense/utils/AppColors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final bool obscureText; // Add obscureText property

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.controller,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.obscureText = false, // Default is false for normal text input
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      obscureText: obscureText,  // Use the obscureText property
      style: const TextStyle(
        fontFamily: 'PoppinsRegular',
        fontSize: 14.0,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: AppColors.grey,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: AppColors.grey,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: AppColors.grey,
            width: 2.0,
          ),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/AppColors.dart';

class CustomSearchTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final bool obscureText;

  const CustomSearchTextField({
    Key? key,
    required this.hintText,
    this.controller,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      obscureText: obscureText,
      style: const TextStyle(
        fontFamily: 'PoppinsRegular',
        fontSize: 14.0,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppColors.hintColor,
          fontSize: 14.0,
        ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 8.0,
          ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: AppColors.grey,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: AppColors.grey,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(
            color: AppColors.grey,
            width: 1.0,
          ),
        ),
        // Force the icon size using a Container
        suffixIcon: suffixIcon != null
            ? Container(
          width: 20, // Desired width
          height: 20, // Desired height
          alignment: Alignment.center,
          child: suffixIcon, // Ensure the icon is centered
        )
            : null,
      ),
    );
  }
}
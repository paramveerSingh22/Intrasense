import 'package:flutter/material.dart';
import 'package:intrasense/utils/Images.dart';

import '../../utils/AppColors.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final String hint;
  final bool enabled; // New parameter to control the enabled state

  const CustomDropdown({
    Key? key,
    this.value,
    required this.items,
    this.onChanged,
    required this.hint,
    this.enabled = true, // Default to true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        filled: true,
        fillColor: enabled ? AppColors.white : AppColors.lightGrey, // Change background
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0, // Reduced vertical padding to decrease dropdown height
          horizontal: 22.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: AppColors.editFieldBorderColour, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: AppColors.editFieldBorderColour, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: AppColors.editFieldBorderColour, width: 1.0),
        ),
      ),
      dropdownColor: AppColors.white,
      items: items.map((String value) {
        bool isHeader = value.startsWith('**') && value.endsWith('**');

        return DropdownMenuItem<String>(
          value: isHeader ? null : value, // Disable selection for headers
          enabled: !isHeader && enabled, // Make header non-selectable, respect enabled state
          child: Text(
            value.replaceAll('**', ''), // Remove asterisks for display
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'PoppinsRegular',
              fontWeight: isHeader ? FontWeight.normal : FontWeight.normal,
              color: isHeader ? AppColors.secondaryOrange : Colors.black, // Header styling
            ),
            overflow: TextOverflow.ellipsis, // Prevent text overflow
            softWrap: true, // Enable soft wrapping
          ),
        );
      }).toList(),
      onChanged: enabled ? onChanged : null, // Disable onChanged when not enabled
      hint: Padding(
        padding: const EdgeInsets.only(left: 0.0),
        child: Text(
          hint,
          style: const TextStyle(
            color: AppColors.hintColor,
            fontSize: 13.0,
            fontFamily: 'PoppinsRegular',
          ),
        ),
      ),
      isExpanded: true, // Ensure the dropdown takes full width
      icon: Images.dropDownIcon != null
          ? Image.asset(
        Images.dropDownIcon,
        width: 16, // Adjust width as needed
        height: 16, // Adjust height as needed
        fit: BoxFit.contain, // Optional: ensures the image fits well
      )
          : Icon(Icons.arrow_drop_down),
    );
  }
}
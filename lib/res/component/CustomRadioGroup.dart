import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/AppColors.dart';

class CustomRadioGroup extends StatefulWidget {
  final List<String> options;
  final Function(String?) onChanged;
  final String? groupValue;

  const CustomRadioGroup({
    Key? key,
    required this.options,
    required this.onChanged,
    this.groupValue,
  }) : super(key: key);

  @override
  _CustomRadioGroupState createState() => _CustomRadioGroupState();
}

class _CustomRadioGroupState extends State<CustomRadioGroup> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      children: widget.options.map((String value) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0), // Adjust vertical spacing here
          child: GestureDetector(
            onTap: () {
              widget.onChanged(value);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16, // Increased size for better visibility
                  height: 16, // Increased size for better visibility
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.groupValue == value
                        ? AppColors.secondaryOrange // Selected color
                        : Colors.transparent, // Unselected color
                    border: Border.all(
                      color: AppColors.secondaryOrange, // Border color
                      width: 2,
                    ),
                  ),
                  child: widget.groupValue == value
                      ? Center(
                    child: Container(
                      width: 12, // Inner circle size when selected
                      height: 12, // Inner circle size when selected
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondaryOrange,
                          border: Border.all(
                            color: AppColors.white, // Border color
                            width: 2,
                          )

                      ),
                    ),
                  )
                      : null,
                ),
                const SizedBox(width: 8), // Space between the radio button and text
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor,
                    fontFamily: 'PoppinsMedium',
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intrasense/utils/AppColors.dart';

class CheckboxWithLabel extends StatefulWidget {
  final String label;
  final bool initialValue;
  final Function(bool?)? onChanged;
  final bool isDisabled;

  const CheckboxWithLabel({
    Key? key,
    required this.label,
    this.initialValue = false,
    this.onChanged,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  _CheckboxWithLabelState createState() => _CheckboxWithLabelState();
}

class _CheckboxWithLabelState extends State<CheckboxWithLabel> {
  bool isChecked;

  _CheckboxWithLabelState() : isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
       // Replace with your color
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            activeColor: AppColors.primaryColor,
            onChanged: widget.isDisabled
                ? null:(bool? value) {
              setState(() {
                isChecked = value?? false;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
          ),
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black, // Replace with your color
              fontFamily: 'PoppinsMedium', // Replace with your font family
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<String>(
                value: value,
                groupValue: widget.groupValue,
                onChanged: widget.onChanged,
              ),
              Text(value),
            ],
          ),
        );
      }).toList(),
    );
  }
}
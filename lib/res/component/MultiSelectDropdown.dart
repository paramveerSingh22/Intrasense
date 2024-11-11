import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/utils/Images.dart';
import '../../utils/AppColors.dart';

class MultiSelectDropdown extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  final ValueChanged<List<String>> onChanged;
  final String hint;

  MultiSelectDropdown({
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    required this.hint,
  });

  @override
  _MultiSelectDropdownState createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.editFieldBorderColour),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<List<String>>(
          isExpanded: true,
          hint: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(widget.hint,
            maxLines: 1,
            overflow: TextOverflow.ellipsis
            ,style: TextStyle(
                  color: widget.selectedItems.isEmpty ? AppColors.hintColor : AppColors.textColor,
                  fontSize: 14.0,
                  fontFamily: 'PoppinsRegular',
                )),
          ),
          icon: Padding(
            padding: const EdgeInsets.only(right: 12.0), // Right padding
            child: Image.asset(
              Images.dropDownIcon,
              color: AppColors.secondaryOrange,
              width: 16,
              height: 16,
              fit: BoxFit.contain,
            ),
          ),

          items: [
            // Add the Done button
            DropdownMenuItem<List<String>>(
              value: [],
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.secondaryOrange,
                  ),
                  child: const Text('Done'),
                ),
              ),
            ),
            ...widget.items.map((item) {
              return DropdownMenuItem<List<String>>(
                value: widget.selectedItems,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return CheckboxListTile(
                      title: Text(item),
                      value: widget.selectedItems.contains(item),
                      activeColor: Colors.blue, // Change checkbox color
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            widget.selectedItems.add(item);
                          } else {
                            widget.selectedItems.remove(item);
                          }
                          widget.onChanged(widget.selectedItems);
                        });
                      },
                    );
                  },
                ),
              );
            }).toList(),
          ],
          onChanged: (_) {},
        ),
      ),
    );
  }
}
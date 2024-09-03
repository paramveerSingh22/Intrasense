import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../res/component/CheckboxWithLabel.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomRadioGroup.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';

class CreateMeeting extends StatefulWidget{
  @override
  _CreateMeeting createState() => _CreateMeeting();

}
class _CreateMeeting extends State<CreateMeeting>{
  String? selectGroupsValue;
  String? selectTimeZoneValue;
  String? priorityValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.headerBg),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 30),
              child: Align(
                alignment: Alignment.topLeft,
                // Top left alignment set karne ke liye
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  // Row ka size content ke hisaab se set karne ke liye
                  children: const [
                    Icon(
                      Icons.arrow_back, // Back icon ka code
                      color: Colors.white, // Icon ka color
                    ),
                    SizedBox(width: 8),
                    // Icon aur text ke beech thoda space dene ke liye
                    Text(
                      'Create Meeting',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'PoppinsRegular',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 90,
            left: 0,
            child: Stack(
              children: [
                Image.asset(
                  Images.curveOverlay,
                  width: MediaQuery.of(context).size.width,
                ),
                const Positioned(
                  top: 20, // Adjust the position of the text as needed
                  left: 30, // Adjust the position of the text as needed
                  child: Text(
                    'Create Meeting',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryOrange,
                        fontFamily: 'PoppinsMedium'),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              Images.curveBg,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 140,
            left: 20,
            right: 20,
            bottom: 0,
            child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Meeting Topic',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsMedium'),
                        )),
                    const SizedBox(height: 5),
                   const CustomTextField(hintText: 'UI/UX Meeting'),
                    const SizedBox(height: 15),

                    CheckboxWithLabel(
                      label: 'Select Group',
                      onChanged: (bool? value) {
                        setState(() {
                          // Handle checkbox change
                        });
                      },
                    ),
                    CheckboxWithLabel(
                      label: 'Select Individuals',
                      onChanged: (bool? value) {
                        setState(() {
                          // Handle checkbox change
                        });
                      },
                    ),
                    CheckboxWithLabel(
                      label: 'Select Client',
                      onChanged: (bool? value) {
                        setState(() {
                          // Handle checkbox change
                        });
                      },
                    ),

                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Select Groups',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsMedium'),
                        )),
                    const SizedBox(height: 5),
                    CustomDropdown(
                      value: selectGroupsValue,
                      items: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectGroupsValue = newValue;
                        });
                      },
                      hint: 'Select an option',
                    ),
                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                            flex: 10,
                            child: Container(
                              child: const Text(
                                'Date',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsRegular',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Container()),
                        const Expanded(
                            flex: 10,
                            child: Text(
                              'Time',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsRegular',
                                fontWeight: FontWeight.w500,
                              ),
                            ))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 10,
                            child: Container(
                              child: CustomTextField(
                                hintText: 'Date',
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Container()),
                        Expanded(
                            flex: 10,
                            child: Container(
                              child: CustomTextField(
                                hintText: 'Time',
                              ),
                            ))
                      ],
                    ),
                    const SizedBox(height: 15),

                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Time Zone',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsMedium'),
                        )),
                    const SizedBox(height: 5),
                    CustomDropdown(
                      value: selectTimeZoneValue,
                      items: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectTimeZoneValue = newValue;
                        });
                      },
                      hint: 'Select an option',
                    ),

                    const SizedBox(height: 15),

                    CheckboxWithLabel(
                      label: 'Recurring meeting',
                      onChanged: (bool? value) {
                        setState(() {
                          // Handle checkbox change
                        });
                      },
                    ),
                    CheckboxWithLabel(
                      label: 'Enable zoom meeting',
                      onChanged: (bool? value) {
                        setState(() {
                          // Handle checkbox change
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Priority',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primaryColor,
                            fontFamily: 'PoppinsMedium',
                          ),
                        )),

                    const SizedBox(height: 5),
                    CustomRadioGroup(
                      options: ['high Priority', 'Important', 'Low Priority'],
                      groupValue: priorityValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          priorityValue = newValue;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    CustomElevatedButton(
                      onPressed: () {
                        /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );*/
                      },
                      buttonText: 'SUBMIT',
                    ),

                  ],
                )),
          )
        ],
      ),
    );
  }
}
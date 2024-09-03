import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../res/component/CheckboxWithLabel.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomRadioGroup.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';

class CreateTask extends StatefulWidget {
  @override
  _CreateTask createState() => _CreateTask();
}

class _CreateTask extends State<CreateTask> {
  String? selectProjectValue;
  String? selectTaskTitleValue;
  String? selectTaskTypeValue;
  String? fromValue;
  String? toValue;
  String? selectStatusValue;
  String? radioGroupValue;

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
                      'Edit task',
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
                    'Edit Task',
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
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Select Project',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsMedium'),
                        )),
                    SizedBox(height: 5),
                    CustomDropdown(
                      value: selectProjectValue,
                      items: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectProjectValue = newValue;
                        });
                      },
                      hint: 'Select an option',
                    ),
                    SizedBox(height: 15),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Task Title',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsMedium'),
                        )),
                    SizedBox(height: 5),
                    CustomDropdown(
                      value: selectTaskTitleValue,
                      items: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectTaskTitleValue = newValue;
                        });
                      },
                      hint: 'Select an option',
                    ),
                    SizedBox(height: 15),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Select Task Type',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsMedium'),
                        )),
                    SizedBox(height: 5),
                    CustomDropdown(
                      value: selectTaskTypeValue,
                      items: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectTaskTypeValue = newValue;
                        });
                      },
                      hint: 'Select an option',
                    ),
                    SizedBox(height: 15),
                    Container(
                      color: AppColors.lightBlue,
                      padding: const EdgeInsets.all(8.0),
                      // Padding ko yahan define kiya gaya hai
                      child: Text(
                        'Enter Details of Communication Received',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsMedium',
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'From',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsMedium'),
                        )),
                    SizedBox(height: 5),
                    CustomDropdown(
                      value: fromValue,
                      items: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
                      onChanged: (String? newValue) {
                        setState(() {
                          fromValue = newValue;
                        });
                      },
                      hint: 'Select an option',
                    ),
                    SizedBox(height: 15),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'To',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsMedium'),
                        )),
                    SizedBox(height: 5),
                    CustomDropdown(
                      value: toValue,
                      items: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
                      onChanged: (String? newValue) {
                        setState(() {
                          toValue = newValue;
                        });
                      },
                      hint: 'Select an option',
                    ),
                    SizedBox(height: 15),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Email Subject',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsMedium'),
                        )),
                    CustomTextField(
                      hintText: 'Subject of Email',
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                            flex: 10,
                            child: Container(
                              child: Text(
                                'Start Date',
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
                        Expanded(
                            flex: 10,
                            child: Text(
                              'Due Date',
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
                                hintText: 'Start Date',
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Container()),
                        Expanded(
                            flex: 10,
                            child: Container(
                              child: CustomTextField(
                                hintText: 'Due Date',
                              ),
                            ))
                      ],
                    ),
                    SizedBox(height: 15),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Hours',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsMedium'),
                        )),
                    CustomTextField(
                      hintText: 'HH',
                    ),

                    SizedBox(height: 15),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Status',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsMedium'),
                        )),
                    CustomDropdown(
                      value: selectStatusValue,
                      items: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectStatusValue = newValue;
                        });
                      },
                      hint: 'Select an option',
                    ),

                    SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      color: AppColors.lightBlue,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Priority',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsMedium',
                        ),
                      ),
                    ),

                    SizedBox(height: 5),
                    CustomRadioGroup(
                      options: ['high Priority', 'Important', 'Low Priority'],
                      groupValue: radioGroupValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          radioGroupValue = newValue;
                        });
                      },
                    ),

                    SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      color: AppColors.lightBlue,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Alert',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsMedium',
                        ),
                      ),
                    ),

                    CheckboxWithLabel(
                      label: 'One week before',
                      onChanged: (bool? value) {
                        setState(() {
                          // Handle checkbox change
                        });
                      },
                    ),
                    CheckboxWithLabel(
                      label: 'Two days before',
                      onChanged: (bool? value) {
                        setState(() {
                          // Handle checkbox change
                        });
                      },
                    ),
                    CheckboxWithLabel(
                      label: 'One day before',
                      onChanged: (bool? value) {
                        setState(() {
                          // Handle checkbox change
                        });
                      },
                    ),

                    SizedBox(height: 15),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Enter Comments',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsMedium'),
                        )),
                    CustomTextField(
                      hintText: 'Enter Comments',
                    ),

                    SizedBox(height: 15),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';

class AddProjectScreen extends StatefulWidget{
 _AddProjectScreen createState() => _AddProjectScreen();

}

class _AddProjectScreen extends State<AddProjectScreen> {
  String? selectClientValue;
  String? selectSubClientValue;
  String? selectProjectManagerValue;

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
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 50, left: 30),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Add Project',
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
                  top: 20,
                  left: 30,
                  child: Text(
                    'Add Project',
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
          // Scrollable content wrapped with Expanded widget
          Positioned(
            top: 140,
            left: 20,
            right: 20,
            bottom: 70, // Make space for the button at the bottom
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Title',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  const CustomTextField(
                    hintText: 'Title',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Short Name(3 character)',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  const CustomTextField(
                    hintText: 'Short Name(3 character)',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Client',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  CustomDropdown(
                    value: selectClientValue,
                    items: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectClientValue = newValue;
                      });
                    },
                    hint: 'Select Client',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Sub-Client',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  CustomDropdown(
                    value: selectSubClientValue,
                    items: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectSubClientValue = newValue;
                      });
                    },
                    hint: 'Select Sub Client',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'P.O Number',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  const CustomTextField(
                    hintText: 'P.O Number',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Client Contact',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  const CustomTextField(
                    hintText: 'Client Contact',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Project Type',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  const CustomTextField(
                    hintText: 'Project Type',
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                          flex: 10,
                          child: Container(
                            child: Text(
                              'Hours',
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
                            'Amount',
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
                              hintText: 'Hours',
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container()),
                      Expanded(
                          flex: 10,
                          child: Container(
                            child: CustomTextField(
                              hintText: 'Amount',
                            ),
                          ))
                    ],
                  ),

                  SizedBox(height: 15),

                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Create Quotation',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  const CustomTextField(
                    hintText: '',
                  ),
                  const SizedBox(height: 15),

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
                            'End date',
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
                              hintText: 'Start date',
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container()),
                      Expanded(
                          flex: 10,
                          child: Container(
                            child: CustomTextField(
                              hintText: 'End date',
                            ),
                          ))
                    ],
                  ),

                  SizedBox(height: 15),

                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Project Manager',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  CustomDropdown(
                    value: selectProjectManagerValue,
                    items: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectProjectManagerValue = newValue;
                      });
                    },
                    hint: 'Select Project Manager',
                  ),
                  const SizedBox(height: 15),
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Description',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                  const CustomTextField(
                    hintText: 'Description',
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 15, // Space from the bottom of the screen
            left: 20,
            right: 20,
            child: CustomElevatedButton(
              onPressed: () {
              },
              buttonText: 'Save Project',
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';

class CreateTimeSheet extends StatefulWidget {
  @override
  _CreateTimeSheet createState() => _CreateTimeSheet();
}

class _CreateTimeSheet extends State<CreateTimeSheet> {
  String? selectActivityValue;
  String? selectBillingTypeValue;
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
                      'Create Timesheet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'PoppinsRegular',
                      ),
                    )
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
            top: 120,
            left: 20,
            right: 20,
            bottom: 0,
            child: SingleChildScrollView(
                child: Column(
              children: [
                  Align(
                  alignment: Alignment.topLeft,
             child:   Text(
                  'Create Timesheet',
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryOrange,
                      fontFamily: 'PoppinsMedium'),
                )),
                Align(
                  alignment: Alignment.topLeft,
                  child:Text(
                  '[MINML2002184-ADE]',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryColor,
                    fontFamily: 'PoppinsRegular',
                  ),
                )),
                Align(
                  alignment: Alignment.topLeft,
                 child:  Text(
                  'ACME Mobile app design & development',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textColor,
                    fontFamily: 'PoppinsRegular',
                  ),
                )),
                Align(
                  alignment: Alignment.topLeft,
              child:   Text(
                  '12 April MON',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.black,
                    fontFamily: 'PoppinsRegular',
                  ),
                )),
                SizedBox(height: 15),
                Container(
                  color: AppColors.lightBlue,
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Enter Details of Timesheet',
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
                      'Activity',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                SizedBox(height: 5),
                CustomDropdown(
                  value: selectActivityValue,
                  items: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
                  onChanged: (String? newValue) {
                    setState(() {
                      selectActivityValue = newValue;
                    });
                  },
                  hint: 'Select an option',
                ),
                SizedBox(height: 15),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Billing Type',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                SizedBox(height: 5),
                CustomDropdown(
                  value: selectBillingTypeValue,
                  items: ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
                  onChanged: (String? newValue) {
                    setState(() {
                      selectBillingTypeValue = newValue;
                    });
                  },
                  hint: 'Select an option',
                ),
                SizedBox(height: 15),

                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Time Range',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                Row(
                  children: [
                    Expanded(
                        flex: 10,
                        child: Container(
                          child: Text(
                            'From',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )),
                    Expanded(flex: 1, child: Container()),
                    Expanded(
                        flex: 10,
                        child: Text(
                          'To',
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
                            hintText: 'From',
                          ),
                        )),
                    Expanded(flex: 1, child: Container()),
                    Expanded(
                        flex: 10,
                      child: CustomTextField(
                        hintText: 'To',
                      ),)
                  ],
                ),

                SizedBox(height: 15),

                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Timesheet description',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                CustomTextField(
                  hintText: 'Timesheet description',
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

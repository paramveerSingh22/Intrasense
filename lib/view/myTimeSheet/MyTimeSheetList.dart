import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intrasense/view/myTimeSheet/CreateTimeSheet.dart';

import '../../utils/AppColors.dart';
import '../../utils/Images.dart';

class Mytimesheetlist extends StatefulWidget {
  @override
  _Mytimesheetlist createState() => _Mytimesheetlist();
}

class _Mytimesheetlist extends State<Mytimesheetlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: Column(
                  children: <Widget>[
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Text(
                              'My Timesheet - Review Timesheet',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryOrange,
                                  fontFamily: 'PoppinsMedium'),
                            ))),
                    const SizedBox(height: 20),
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.lightBlue,
                      ),
                      child: Padding(
                        padding:
                        const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: DropdownButton<String>(
                                    dropdownColor: Colors.white,
                                    underline: Container(
                                      height: 2,
                                      color: Colors.white,
                                    ),
                                    items: <String>[
                                      'Option 1',
                                      'Option 2',
                                      'Option 3',
                                      'Option 4'
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {},
                                    hint: const Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text('Select an option'),
                                    ),
                                    isExpanded: true,
                                  ),
                                )),
                            const SizedBox(height: 20),
                            Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      Images.leftArrow,
                                      fit: BoxFit.cover,
                                      width: 30,
                                      height: 30,
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 20.0),
                                        child: Text(
                                          '12 - 18 APR 22',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.black,
                                              fontFamily: 'PoppinsMedium'),
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 20.0),
                                        child: Image.asset(
                                          Images.rightArrow,
                                          fit: BoxFit.cover,
                                          width: 30,
                                          height: 30,
                                        ))
                                  ],
                                )),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 20.0),
                                    child: Text(
                                      '[MINMLI2002181-ADE]',
                                      textAlign: TextAlign.left,
                                      // Align text to the left
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.primaryColor,
                                        fontFamily: 'PoppinsRegular',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 5.0),
                                    child: Text(
                                      'ACME Mobile app Design',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textColor,
                                        fontFamily: 'PoppinsRegular',
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.0, top: 10.0),
                                          child: Container(
                                            width: 50,
                                            child: Text(
                                              'Date & Day',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: AppColors.black,
                                                fontFamily: 'PoppinsMedium',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.0, top: 10.0),
                                          child: Container(
                                            width: 80,
                                            child: Text(
                                              'Add Timesheet',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: AppColors.black,
                                                fontFamily: 'PoppinsMedium',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.0, top: 10.0),
                                          child: Container(
                                            width: 100,
                                            child: Text(
                                              'Work Hours Total',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: AppColors.black,
                                                fontFamily: 'PoppinsMedium',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      return CustomMyTimeSheetTile();
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateTimeSheet()));
                // Add your login logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Images.buttonBg),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 40.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'CREATE TIMESHEET',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'PoppinsRegular'),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomMyTimeSheetTile extends StatelessWidget {
  const CustomMyTimeSheetTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        color: Colors.white, // White color set kiya gaya hai
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          '12 Apr',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsRegular',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'MON',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryOrange,
                            fontFamily: 'PoppinsRegular',
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    // Center the image within the container
                    child: Image.asset(
                      Images.blueRoundPlus,
                      width: 35,
                      height: 35,
                      fit: BoxFit
                          .contain, // Ensure the image fits within 30x30 without distortion
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.secondaryOrange, // Border color
                        ),
                      ),
                      padding: EdgeInsets.all(8), // Adjust padding as needed
                      child: Text(
                        '8:00',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryOrange,
                          fontFamily: 'PoppinsRegular',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DividerColor extends StatelessWidget {
  const DividerColor({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColors.grey,
      height: 0.5,
    );
  }
}

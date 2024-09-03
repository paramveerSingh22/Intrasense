import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/view/manageMeetings/CreateMeeting.dart';

import '../../res/component/CustomElevatedButton.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';

class MyMeetingslist extends StatefulWidget {
  @override
  _MyMeetingslist createState() => _MyMeetingslist();
}

class _MyMeetingslist extends State<MyMeetingslist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 30.0,
            // Adjust this value as needed
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                    padding: EdgeInsets.only(left: 0.0),
                                    child: Text(
                                      'Meeting List',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.secondaryOrange,
                                          fontFamily: 'PoppinsMedium'),
                                    ))),
                          ],
                        )),
                    SizedBox(height: 20),
                    Expanded(
                      child: Container(
                          color: AppColors.lightBlue,
                          child: ListView.separated(
                            itemCount: 5,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(
                                  height:
                                      10); // List items ke beech mein 10 dp ka gap
                            },
                            itemBuilder: (context, index) {
                              return CustomMeetingListTile();
                            },
                          )),
                    ),
                    SizedBox(height: 20),
                    CustomElevatedButton(
                      onPressed: () {
                        Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateMeeting(),
                      ),
                    );
                      },
                      buttonText: 'CREATE MEETING',
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class CustomMeetingListTile extends StatelessWidget {
  const CustomMeetingListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.only(bottom: 20, top: 10, left: 20, right: 20),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Text(
                        'UI/UX Meetings',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsRegular',
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Image.asset(
                            Images.eyeIcon,
                            width: 20.0,
                            height: 20.0, // Update with your asset path
                          ),
                          SizedBox(width: 10),
                          Image.asset(
                            Images.editIcon,
                            width: 20.0,
                            height: 20.0,
                            // Update with your asset path
                          ),
                          SizedBox(width: 10),
                          Image.asset(
                            Images.threeDotsRed,
                            width: 12.0,
                            height: 20.0, // Update with your asset path
                          )
                        ],
                      )),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Text(
                        '22 Feb 2022',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular',
                          fontWeight: FontWeight.w500,
                        ),
                      ))
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.topLeft,
                          child: Container(
                            child: Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsRegular',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                      ),),
                  Expanded(
                      flex: 1,
                      child: Text(
                        'Mostrud exercitation by ullamco laboris nisi nostrud lorem ipsum.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular',
                          fontWeight: FontWeight.w500,
                        ),
                      ))
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          'Status',
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
                      child: Text(
                        'START SOON',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsRegular',
                          fontWeight: FontWeight.w500,
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

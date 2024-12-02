import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/utils/AppColors.dart';
import '../../model/timesheet/TimeSheetModel.dart';
import '../../model/user_model.dart';
import '../../utils/Images.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../utils/Utils.dart';
import '../../view_models/time_sheet_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'CreateTimeSheet.dart';

class TimeSheetDetail extends StatefulWidget {
  final dynamic taskDetail;

  const TimeSheetDetail({Key? key, this.taskDetail}) : super(key: key);

  @override
  _TimeSheetDetail createState() => _TimeSheetDetail();
}

class _TimeSheetDetail extends State<TimeSheetDetail> {
  List<TimeSheetModel> timeSheetList = [];
  List<TimeSheetModel>? weekData;
  UserModel? userData;
  DateTime currentWeekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

  @override
  void initState() {
    getUserDetails(context);
    super.initState();
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    userData = await getUserData();
    if (kDebugMode) {
      print(userData);
    }
    currentWeekStart = currentWeekStart.add(const Duration(days: 0));
    fetchWeekData(currentWeekStart);

  }

  List<Map<String, String>> getCurrentWeekDates(DateTime weekStart) {
    return List.generate(7, (index) {
      DateTime date = weekStart.add(Duration(days: index));
      return {
        'fullDate': DateFormat('yyyy-MM-dd').format(date),
        'date': DateFormat('dd MMM').format(date),
        'day': DateFormat('EEE').format(date),
        'workHours': '0:00',
      };
    });
  }

  Future<void> fetchWeekData(DateTime weekStart) async {
    final weekEnd = weekStart.add(Duration(days: 6)); // End of the week
    String startDate = DateFormat('yyyy-MM-dd').format(weekStart);
    String endDate = DateFormat('yyyy-MM-dd').format(weekEnd);
    try {
      Utils.toastMessage("API call start");
      Utils.showLoadingDialog(context);
      Map data = {
        'user_id': userData?.data?.userId,
        'usr_role_track_id': userData?.data?.roleTrackId,
        'usr_customer_track_id': userData?.data?.customerTrackId,
        'from_date': startDate.toString(),
        'to_date': endDate.toString(),
        'project_id': widget.taskDetail.taskDetail![0].projectId,
        'token': userData?.token,
      };
      final timesheetViewModel = Provider.of<TimeSheetViewModel>(context, listen: false);
      final response = await timesheetViewModel.getTimeSheetListApi(data, context);

      if(response!=null){
        //timeSheetList= response.toList();
        if (kDebugMode) {
          print("API Response-----Date1: ${jsonEncode(response)}");
        }

        /*for (var timeSheet in response) {
          String date = timeSheet.data[0].date;

          // Print or process the date as needed
          if (kDebugMode) {
            print("Api repo-----Date: $date");
          }
        }*/
      }
      Utils.hideLoadingDialog(context);


    /*   setState(() {
         if (response != null) {
           weekData = response;
           List<Map<String, String>> weekDates = getCurrentWeekDates(weekStart);

           for (var dayData in weekDates) {
             String date = dayData['fullDate']!;

             // Find the matching entry in the weekData
             var matchingEntry = weekData?.firstWhere(
                   (entry) {
                 // Check if the entry is a map and contains the 'date' key
                     if (entry is Map<String, dynamic> && entry.containsKey('date')) {
                   // Compare date strings after formatting both dates to strings
                   return entry['date'] == date;
                 }
                 return false; // Return false if 'date' key is missing or entry is not a Map
               },
               orElse: () => null, // Return null if no match is found
             );

             // If a matching entry is found, update the dayData with 'workHours'
             if (matchingEntry != null) {
               String timeSpent = matchingEntry['timespent'] ?? '0:00'; // Replace with actual field name
               dayData['workHours'] = timeSpent;
             }
           }
         }
        });*/
    } catch (error) {
      if (kDebugMode) {
        print("Api Error fetching week data: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> weekDates = getCurrentWeekDates(currentWeekStart);
    String weekRange = "${DateFormat('dd').format(currentWeekStart)}-${DateFormat('dd MMM yy').format(currentWeekStart.add(Duration(days: 6)))}";

    void changeWeek(int days) {
      setState(() {
        currentWeekStart = currentWeekStart.add(Duration(days: days));
      });
      weekRange = "${DateFormat('dd').format(currentWeekStart)}-${DateFormat('dd MMM yy').format(currentWeekStart.add(Duration(days: 6)))}";
      fetchWeekData(currentWeekStart);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          ),
          Positioned(
            top: 90,
            left: 0,
            child: Stack(
              children: [
                Image.asset(
                  Images.curveOverlay,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
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
            top: 36,
            left: 30,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "My Timesheet",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'PoppinsMedium',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 110.0,
            left: 0.0,
            right: 0.0,
            bottom: 10.0,
            // Reserve space for the button
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      //color: AppColors.secondaryOrange.withOpacity(0.1),
                      ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 15,
                                child: Text(
                                  "[${widget.taskDetail.taskDetail![0].taskUniqueId} - ${widget.taskDetail.taskDetail![0].projectShortName}]",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.skyBlueTextColor,
                                    fontFamily: 'PoppinsRegular',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            widget.taskDetail.taskDetail[0].taskTitle
                                .toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: AppColors.lightBlue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Image.asset(
                          Images.leftArrow,
                          width: 30,
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                        onPressed: () => changeWeek(-7), // Go to previous week
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        weekRange,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10.0),
                      IconButton(
                        icon: Image.asset(
                          Images.rightArrow,
                          width: 30,
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                        onPressed: () => changeWeek(7), // Go to next week
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                const Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Text('Date\n& Day',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.black,
                                fontFamily: 'PoppinsMedium',
                              ),
                              textAlign: TextAlign.center),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text('Add\nTimesheet',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.black,
                                fontFamily: 'PoppinsMedium',
                              ),
                              textAlign: TextAlign.center),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text('Work Hours\nTotal',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.black,
                                fontFamily: 'PoppinsMedium',
                              ),
                              textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                    child: ListView.builder(
                      itemCount: weekDates.length,
                      itemBuilder: (context, index) {
                        final dayData = weekDates[index];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Date & Day Column
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        Text(
                                          "${dayData['date']}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.textColor,
                                            fontFamily: 'PoppinsRegular',
                                          ),
                                        ),
                                        Text(
                                          "${dayData['day']}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.secondaryOrange,
                                            fontFamily: 'PoppinsRegular',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Builder(
                                      builder: (context) {
                                        final String fullDateString = "${dayData['fullDate']}";
                                        final DateTime fullDate = DateTime.parse(fullDateString);
                                        final DateTime currentDate = DateTime.now();
                                        final bool isClickable = !fullDate.isAfter(currentDate);

                                        return IconButton(
                                          icon: Opacity(
                                            opacity: isClickable ? 1.0 : 0.5,
                                            child: Image.asset(
                                              Images.blueRoundPlus,
                                              width: 35,
                                              height: 35,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          onPressed: isClickable
                                              ? () async {
                                            Navigator.pop(context);
                                            final createDate = "${dayData['fullDate']}";
                                            final createDay = "${dayData['day']}";
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => CreateTimeSheet(
                                                  taskDetail: widget.taskDetail,
                                                  taskCreateDate: createDate,
                                                  createTaskDayName: createDay,
                                                ),
                                              ),
                                            );
                                            if (result == true) {
                                              // onTaskUpdated();
                                            }
                                          }
                                              : null,
                                        );
                                      },
                                    ),
                                  ),
                                 /* Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        color: Colors.white,
                                        border: Border.all(
                                          color: AppColors.secondaryOrange,
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        "${dayData['workHours']}",
                                        style: const TextStyle(
                                          color: AppColors.secondaryOrange,
                                          fontSize: 14.0,
                                          fontFamily: 'PoppinsRegular',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),*/
                                  Expanded(
                                    flex: 3,
                                    child: Center(
                                      child: SizedBox(
                                        width: 60, // Fixed width
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5.0),
                                            color: Colors.white,
                                            border: Border.all(
                                              color: AppColors.secondaryOrange,
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            "${dayData['workHours']}",
                                            style: const TextStyle(
                                              color: AppColors.secondaryOrange,
                                              fontSize: 14.0,
                                              fontFamily: 'PoppinsRegular',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Add a divider after each item except the last one
                            if (index < weekDates.length - 1)
                              const Divider(
                                color: AppColors.dividerColor, // Set the color of the divider
                                thickness: 1, // Set the thickness of the divider

                              ),
                          ],
                        );
                      },
                    ),
                ))
              ],
            ),
          ),
        ],
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

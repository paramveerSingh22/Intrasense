import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/tasks/TasksListModel.dart';
import 'package:intrasense/res/component/ButtonOrangeBorder.dart';
import 'package:intrasense/utils/AppColors.dart';
import '../../model/timesheet/TimeSheetModel.dart';
import '../../model/user_model.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomTextField.dart';
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
      String fullDate = DateFormat('yyyy-MM-dd').format(date);

      int totalMinutes = timeSheetList
          .where((entry) => entry.timesheetDate == fullDate) // Match the date
          .map((entry) {
        return int.tryParse(entry.timespent ?? '0') ?? 0;
      })
          .fold(0, (sum, minutes) => sum + minutes); // Sum the minutes

      String workHours = "${totalMinutes ~/ 60}:${(totalMinutes % 60).toString().padLeft(2, '0')}";


      return {
        'fullDate': DateFormat('yyyy-MM-dd').format(date),
        'date': DateFormat('dd MMM').format(date),
        'day': DateFormat('EEE').format(date),
        'workHours': workHours,
      };
    });
  }

  Future<void> fetchWeekData(DateTime weekStart) async {
    final weekEnd = weekStart.add(Duration(days: 6)); // End of the week
    String startDate = DateFormat('yyyy-MM-dd').format(weekStart);
    String endDate = DateFormat('yyyy-MM-dd').format(weekEnd);
    try {
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
        if (kDebugMode) {
          print("API Response-----Date1: ${jsonEncode(response)}");
        }
        setState(() {
          timeSheetList= response;
        });

      }
      Utils.hideLoadingDialog(context);

    } catch (error) {
      if (kDebugMode) {
        print("Api Error fetching week data: $error");
      }
    }
  }

  void timeSheetDialog(List<TimeSheetModel> specificDateSheetList, String taskCreateDate, String taskCreateDay) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: AppColors.secondaryOrange.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Timesheet-Work Hours Total',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryOrange,
                        fontFamily: 'PoppinsMedium'),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.textColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: specificDateSheetList.isEmpty
                  ? const Center(
                child: Text(
                  'No data found',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'PoppinsMedium',
                  ),
                ),
              )
                  : ListView.separated(
                itemCount: specificDateSheetList.length,
                separatorBuilder:
                    (BuildContext context, int index) {
                      return const Divider(
                        color: AppColors.dividerColor,
                        height: 1,
                        thickness: 1,
                      );
                },
                itemBuilder: (context, index) {
                  final item = specificDateSheetList[index];
                  currentWeekStart = currentWeekStart.add(const Duration(days: 0));

                  return DialogTimeSheetTile(taskDetail:widget.taskDetail, item:item,taskCreateDate:taskCreateDate,
                      taskCreateDay:taskCreateDay,onTimeSheetUpdated: () {
                       initState();
                  });
                },
              ),
            ),
          ],
        );
      },
    );
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

                                            }
                                          }
                                              : null,
                                        );
                                      },
                                    ),
                                  ),

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
                                          child: GestureDetector(
                                            onTap: () {
                                              final createDate = "${dayData['fullDate']}";
                                              List<TimeSheetModel> specificDateSheetList = [];
                                              specificDateSheetList = timeSheetList.where((timeSheet) {
                                                return timeSheet.timesheetDate == createDate;
                                              }).toList();
                                              final taskCreateDate = "${dayData['fullDate']}";
                                              final taskCreateDay = "${dayData['day']}";

                                              if("${dayData['workHours']}"!="0:00"){
                                                timeSheetDialog(specificDateSheetList,taskCreateDate,taskCreateDay);
                                              }
                                            },
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

class DialogTimeSheetTile extends StatelessWidget {
  final TaskListModel taskDetail ;
  final TimeSheetModel item ;
  final String taskCreateDate ;
  final String taskCreateDay ;
  final VoidCallback onTimeSheetUpdated;

  const DialogTimeSheetTile({
    super.key,
    required this.taskDetail,
    required this.item,
    required this.taskCreateDate,
    required this.taskCreateDay,
    required this.onTimeSheetUpdated,
  });

  String convertMinutesToHours(String minutes) {
    // Assuming item.timespent is a string that contains time in minutes
    int totalMinutes = int.parse(minutes);
    int hours = totalMinutes ~/ 60; // Integer division to get hours
    int remainingMinutes = totalMinutes % 60; // Get the remainder minutes

    // Format minutes to always have two digits
    String formattedMinutes = remainingMinutes.toString().padLeft(2, '0');

    // Return the formatted string in "hours:minutes" format
    return "$hours:$formattedMinutes";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2), // Container padding added
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(5.0),
                  decoration: const BoxDecoration(
                    color: AppColors.lightBlue,
                    shape: BoxShape.circle, // Circular shape
                  ),
                  child:  Center( // Center widget to align text
                    child: Text(
                      convertMinutesToHours(item.timespent), // Static time display
                      style: const TextStyle(
                        color: AppColors.skyBlueTextColor, // Text color
                        fontSize: 12.0, // Text size
                        fontFamily: 'PoppinsMedium',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        "[${item.projectShortname} - ${item.taskName}]",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.skyBlueTextColor,
                          fontFamily: 'PoppinsRegular',
                        ),
                      ),
                      const SizedBox(height: 4), // Add spacing between rows
                      Text(
                        item.activityName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular',
                        ),
                      ),
                      const SizedBox(height: 4), // Add spacing between rows
                      Text(
                        item.workDescription,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular',
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 100,
                        child: ButtonOrangeBorder(
                          onPressed: () async {
                            Navigator.pop(context);
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreateTimeSheet(
                                        taskDetail: taskDetail,
                                        taskCreateDate: taskCreateDate,
                                        createTaskDayName: taskCreateDay,
                                        timesheetDetail: item),
                              ),
                            );
                            if (result == true) {
                              onTimeSheetUpdated();
                            }
                          },
                          buttonText: 'Edit',
                        ),
                      )

                    ],
                  ),
                ),
              ],
            ),
            onTap: () async {
              // Add your onTap logic here
            },
          ),
        ),
      ],
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

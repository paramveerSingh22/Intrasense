import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intrasense/model/timesheet/TimeSheetModel.dart';
import 'package:intrasense/view/myTimeSheet/CreateTimeSheet.dart';
import 'package:intrasense/view_models/time_sheet_view_model.dart';
import '../../model/projects/ProjectListModel.dart';
import '../../model/tasks/TasksListModel.dart';
import '../../model/user_model.dart';
import '../../res/component/CustomDropdown.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/projects_view_model.dart';
import '../../view_models/tasks_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'TimeSheetDetail.dart';

class Mytimesheetlist extends StatefulWidget {
  @override
  _Mytimesheetlist createState() => _Mytimesheetlist();
}

class _Mytimesheetlist extends State<Mytimesheetlist> {
  UserModel? userData;
  bool _isLoading = false;
  List<ProjectListModel> projectList = [];
  List<String> projectNamesList = [];
  String? selectProjectName;
  String? selectProjectId;
  List<TaskListModel> tasksList = [];

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
    getProjectsList();
  }

  Future<void> getProjectsList() async {
    setLoading(true);
    try {
      Map data = {
        'user_id': userData?.data?.userId,
        'usr_role_track_id': userData?.data?.roleTrackId,
        'usr_customer_track_id': userData?.data?.customerTrackId,
        'token': userData?.token,
      };
      final projectViewModel =
          Provider.of<ProjectsViewModel>(context, listen: false);
      final response = await projectViewModel.getProjectListApi(data, context);
      if (response != null) {
        setState(() {
          projectList = response;
          if (projectList.isNotEmpty) {
            projectNamesList =
                projectList.map((item) => item.prName.toString()).toList();
            selectProjectName = projectList[0].prName.toString();
            selectProjectId = projectList[0].projectId.toString();
            getTasksList(selectProjectId.toString());
          }
          setLoading(false);
        });
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching employee list: $error');
      }
    } finally {
      setLoading(false);
    }
  }

  Future<void> getTasksList(String projectId) async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': userData?.data?.userId,
        'usr_role_track_id': userData?.data?.roleTrackId,
        'usr_customer_track_id': userData?.data?.customerTrackId,
        'project_id': projectId,
        'token': userData?.token,
      };
      final taskViewModel = Provider.of<TasksViewModel>(context, listen: false);
      final response = await taskViewModel.getTasksListApi(data, context);
      Utils.hideLoadingDialog(context);
      setState(() {
        if (response != null) {
          tasksList = response
              .where((item) =>
                  item.taskDetail != null && item.taskDetail!.isNotEmpty)
              .toList();
        }
      });
    } catch (error) {
      Utils.hideLoadingDialog(context);
      print('Error fetching tasks list: $error');
    }
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 30.0, right: 20.0),
                  child: const Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 0.0),
                          child: Text(
                            'My Timesheet - Review Timesheet',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.secondaryOrange,
                              fontFamily: 'PoppinsMedium',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    color: AppColors.lightBlue,
                    padding: const EdgeInsets.only(left: 26.0, right: 26.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        CustomDropdown(
                          value: selectProjectName,
                          items: projectNamesList,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectProjectName = newValue;
                              selectProjectId = projectList
                                  .firstWhere((item) => item.prName == newValue)
                                  .projectId;
                              getTasksList(selectProjectId.toString());
                            });
                          },
                          hint: 'Select an option',
                        ),
                        const SizedBox(height: 2),
                        Expanded(
                          child: tasksList.isEmpty
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
                                  itemCount: tasksList.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(height: 10);
                                  },
                                  itemBuilder: (context, index) {
                                    final item = tasksList[index];
                                    return CustomMyTaskListTile(
                                        item: item, index: index,userData:userData!);
                                  },
                                ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomMyTaskListTile extends StatelessWidget {
  final TaskListModel item;
  final int index;
  final UserModel userData;

  const CustomMyTaskListTile({
    super.key,
    required this.item,
    required this.index,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TasksViewModel>(context);
    if (item.taskDetail == null || item.taskDetail!.isEmpty) {
      return const SizedBox();
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: index % 2 == 0
                ? AppColors.secondaryOrange.withOpacity(0.1)
                : AppColors.white,
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 15,
                          child: Text(
                            "["
                            "${item.taskDetail![0].taskUniqueId} - ${item.taskDetail![0].projectShortName}"
                            "]",
                            style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.skyBlueTextColor,
                                fontFamily: 'PoppinsRegular'),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    item.taskDetail![0].taskTitle.toString(),
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textColor,
                        fontFamily: 'PoppinsRegular'),
                  ),
                ),
              ],
            ),
            onTap: () async {
              //showWeekPopup(context, item,userData);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimeSheetDetail(taskDetail: item)),
              );
              if (result == true) {
              }
            },
          ),
        ),
      ],
    );
  }
}

void showWeekPopup(BuildContext context, TaskListModel item, UserModel userDetail) {
  List<TimeSheetModel> timeSheetList = [];

  DateTime _currentWeekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

  List<Map<String, String>> getCurrentWeekDates(DateTime weekStart) {
    return List.generate(7, (index) {
      DateTime date = weekStart.add(Duration(days: index));
      return {
        'fullDate': DateFormat('yyyy-MM-dd').format(date),
        'date': DateFormat('dd MMM').format(date),
        'day': DateFormat('EEE').format(date),
        'workHours': '8:00', // Example work hours
      };
    });
  }

  Future<void> fetchWeekData(DateTime weekStart, StateSetter setState) async {
    final weekEnd = weekStart.add(Duration(days: 6)); // End of the week
    String startDate = DateFormat('yyyy-MM-dd').format(weekStart);
    String endDate = DateFormat('yyyy-MM-dd').format(weekEnd);
      try {
        Utils.toastMessage("API call start");
        Utils.showLoadingDialog(context);
        Map data = {
          'user_id': userDetail.data?.userId,
          'usr_role_track_id': userDetail.data?.roleTrackId,
          'usr_customer_track_id': userDetail.data?.customerTrackId,
          'from_date': startDate.toString(),
          'to_date': endDate.toString(),
          'project_id': item.taskDetail![0].projectId,
          'token': userDetail.token,
        };
       Utils.toastMessage("api---Before API call");
        final timesheetViewModel = Provider.of<TimeSheetViewModel>(context, listen: true);
        final response = await timesheetViewModel.getTimeSheetListApi(data, context);
        Utils.toastMessage("api---after API call");
        Utils.hideLoadingDialog(context);
       /* setState(() {
          if (response != null) {
            timeSheetList = response.toList();
          }
        });*/

       /* if (response != null) {
          Future.delayed(Duration.zero, () {
            setState(() {
              timeSheetList = response.toList();
            });
          });
        }*/
    } catch (error) {
      if (kDebugMode) {
        print("Api Error fetching week data: $error");
      }
    }
  }

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          List<Map<String, String>> weekDates =
              getCurrentWeekDates(_currentWeekStart);
          String weekRange = "${DateFormat('dd').format(_currentWeekStart)}-${DateFormat('dd MMM yy').format(_currentWeekStart.add(Duration(days: 6)))}";

          fetchWeekData(_currentWeekStart, setState);

          void _changeWeek(int days) {
            setState(() {
              _currentWeekStart = _currentWeekStart.add(Duration(days: days));
            });
            weekRange =
            "${DateFormat('dd').format(_currentWeekStart)}-${DateFormat('dd MMM yy').format(_currentWeekStart.add(Duration(days: 6)))}";
            fetchWeekData(_currentWeekStart, setState);
          }

          return Dialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondaryOrange.withOpacity(0.1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 15,
                                  child: Text(
                                    "["
                                    "${item.taskDetail![0].taskUniqueId} - ${item.taskDetail![0].projectShortName}"
                                    "]",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.skyBlueTextColor,
                                        fontFamily: 'PoppinsRegular'),
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            item.taskDetail![0].taskTitle.toString(),
                            style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsRegular'),
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
                          onPressed: () =>
                              _changeWeek(-7), // Go to previous week
                        ),
                        Text(
                          weekRange,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Image.asset(
                            Images.rightArrow,
                            width: 30,
                            height: 30,
                            fit: BoxFit.contain,
                          ),
                          onPressed: () => _changeWeek(7), // Go to next week
                        ),
                      ],
                    )),
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
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: SizedBox(
                    height: 400,
                    child: ListView.builder(
                      itemCount: weekDates.length,
                      itemBuilder: (context, index) {
                        final dayData = weekDates[index];
                        return Padding(
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
                                    )
                                  ],
                                ),
                              ),

                              Expanded(
                                flex: 3,
                                child: Builder(
                                  builder: (context) {
                                    final String fullDateString =
                                        "${dayData['fullDate']}"; // Assuming this is in a parsable format
                                    final DateTime fullDate = DateTime.parse(
                                        fullDateString); // Parse the string to DateTime
                                    final DateTime currentDate =
                                        DateTime.now(); // Current date
                                    final bool isClickable =
                                        !fullDate.isAfter(currentDate);

                                    return IconButton(
                                      icon: Opacity(
                                        opacity: isClickable ? 1.0 : 0.5,
                                        // Reduce opacity if not clickable
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
                                              final createDate =
                                                  "${dayData['fullDate']}";
                                              final createDay =
                                                  "${dayData['day']}";
                                              final result =
                                                  await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateTimeSheet(
                                                    taskDetail: item,
                                                    taskCreateDate: createDate,
                                                    createTaskDayName:
                                                        createDay,
                                                  ),
                                                ),
                                              );
                                              if (result == true) {
                                                // onTaskUpdated();
                                              }
                                            }
                                          : null, // Disable the button if not clickable
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: AppColors.secondaryOrange,
                                      // Secondary orange color
                                      width: 1, // Border thickness
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
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
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

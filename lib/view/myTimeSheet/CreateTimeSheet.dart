import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/timesheet/TimeSheetActivityModel.dart';
import 'package:intrasense/view_models/time_sheet_view_model.dart';

import '../../model/user_model.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CreateTimeSheet extends StatefulWidget {
  final dynamic taskDetail;
  final dynamic taskCreateDate;
  final dynamic createTaskDayName;

  const CreateTimeSheet({Key? key, this.taskDetail, this.taskCreateDate, this.createTaskDayName}) : super(key: key);

  @override
  _CreateTimeSheet createState() => _CreateTimeSheet();
}

class _CreateTimeSheet extends State<CreateTimeSheet> {
  String? selectActivityValue;
  String? selectActivityTrackId;
  String? selectBillingTypeValue;
  String? selectTaskTypeValue;
  String? fromValue;
  String? toValue;
  String? selectStatusValue;
  String? radioGroupValue;
  UserModel? _userData;
  bool _isLoading = false;
  List<TimeSheetActivityModel> timeSheetActivityList = [];
  List<String> timeSheetActivityNameList = [];
  String? selectedHours;
  String? selectedMinutes;
  final TextEditingController _fromTimeController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController();
  final TextEditingController _desController = TextEditingController();

  @override
  void initState() {
    getUserDetails(context);
    super.initState();
  }

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
    getTimeSheetActivity();
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  Future<void> getTimeSheetActivity() async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'customer_id': _userData?.data?.customerTrackId,
        'token': _userData?.token,
      };
      final timeSheetViewModel =
          Provider.of<TimeSheetViewModel>(context, listen: false);
      final response =
          await timeSheetViewModel.getTimeSheetActivityApi(data, context);
      Utils.hideLoadingDialog(context);
      setState(() {
        if (response != null) {
          timeSheetActivityList = response.toList();
          timeSheetActivityNameList =
              timeSheetActivityList.map((item) => item.activityName).toList();
        }
      });
    } catch (error) {
      Utils.hideLoadingDialog(context);
      print('Error fetching leaves list: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeSheetViewModel = Provider.of<TimeSheetViewModel>(context);
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
            left: 20,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Create Timesheet",
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
            top: 110,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
                child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Create Timesheet',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryOrange,
                            fontFamily: 'PoppinsMedium'),
                      )),
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "["
                            "${widget.taskDetail.taskDetail![0].taskUniqueId} - ${widget.taskDetail.taskDetail![0].projectShortName}"
                            "]",
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.skyBlueTextColor,
                          fontFamily: 'PoppinsRegular',
                        ),
                      )),
                ),
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.taskDetail.taskDetail[0].taskTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular',
                        ),
                      )),
                ),
                const SizedBox(height: 5.0),
                 Row(
                   children: [
                     Padding(
                       padding: const EdgeInsets.only(left: 20.0),
                       child: Align(
                           alignment: Alignment.topLeft,
                           child: Text(
                             DateFormat('dd MMM').format(DateTime.parse(widget.taskCreateDate)),
                             style: const TextStyle(
                               fontSize: 16,
                               color: AppColors.black,
                               fontFamily: 'PoppinsMedium',
                             ),
                           )),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 10.0),
                       child: Align(
                           alignment: Alignment.topLeft,
                           child: Text(
                             widget.createTaskDayName,
                             style: const TextStyle(
                               fontSize: 16,
                               color: AppColors.secondaryOrange,
                               fontFamily: 'PoppinsMedium',
                             ),
                           )),
                     )
                   ],
                 ),
                const SizedBox(height: 15),
                Container(
                  color: AppColors.lightBlue,
                  padding: const EdgeInsets.only(top:12.0,bottom: 12.0,left: 20.0,right: 20.0),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Enter Details of Timesheet',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.skyBlueTextColor,
                      fontFamily: 'PoppinsMedium',
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Activity',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: CustomDropdown(
                    value: selectActivityValue,
                    items: timeSheetActivityNameList,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectActivityValue = newValue;
                        selectActivityTrackId = timeSheetActivityList
                            .firstWhere((item) =>
                                item.activityName == selectActivityValue)
                            .activityId;
                      });
                    },
                    hint: 'Select an option',
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 10,
                          child: Container(
                            child: const Text(
                              'Hrs',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsRegular',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )),
                      Expanded(flex: 1, child: Container()),
                      const Expanded(
                          flex: 10,
                          child: Text(
                            'Mins',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w500,
                            ),
                          ))
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 10,
                          child: CustomDropdown(
                            value: selectedHours,
                            items: const [
                              '1',
                              '2',
                              '3',
                              '4',
                              '5',
                              '6',
                              '7',
                              '8',
                              '9',
                              '10',
                              '11',
                              '12'
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedHours = newValue;
                              });
                            },
                            hint: 'HRS',
                          )),
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                          flex: 10,
                          child: CustomDropdown(
                            value: selectedMinutes,
                            items: [
                              '5',
                              '10',
                              '15',
                              '20',
                              '25',
                              '30',
                              '35',
                              '40',
                              '45',
                              '50'
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedMinutes = newValue;
                              });
                            },
                            hint: 'MNS',
                          ))
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Billing Type',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: CustomDropdown(
                    value: selectBillingTypeValue,
                    items: const [
                      'Billable',
                      'Internal Billable',
                      'Non-Billable'
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectBillingTypeValue = newValue;
                      });
                    },
                    hint: 'Select an option',
                  ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Time Range',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.skyBlueTextColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 10,
                          child: Container(
                            child: const Text(
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
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 10,
                          child: CustomTextField(
                            controller: _fromTimeController,
                            hintText: 'From',
                            suffixIcon: Image.asset(
                              Images.clockIcon,
                              height: 24,
                              width: 24,
                            ),
                            readOnly: true,
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              if (pickedTime != null) {
                                // Format the time to display in HH:mm format
                                final formattedTime = pickedTime.format(context);
                                setState(() {
                                  _fromTimeController.text = formattedTime;
                                });
                              }
                            },
                          )),
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                          flex: 10,
                          child: CustomTextField(
                            controller: _toTimeController,
                            hintText: 'To',
                            suffixIcon: Image.asset(
                              Images.clockIcon,
                              height: 24,
                              width: 24,
                            ),
                            readOnly: true,
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              if (pickedTime != null) {
                                // Format the time to display in HH:mm format
                                final formattedTime = pickedTime.format(context);
                                setState(() {
                                  _toTimeController.text = formattedTime;
                                });
                              }
                            },
                          ))
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Timesheet description',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                            fontFamily: 'PoppinsMedium'),
                      )),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: CustomTextField(
                      hintText: 'Timesheet description',
                      controller: _desController,
                      minLines: 4,
                      maxLines: 4),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: CustomElevatedButton(
                      onPressed: () {
                        if (selectActivityValue == null) {
                          Utils.toastMessage("Please select activity type");
                        } else if (selectedHours == null) {
                          Utils.toastMessage("Please select hours");
                        } else if (selectedMinutes == null) {
                          Utils.toastMessage("Please select minutes");
                        } else if (selectBillingTypeValue == null) {
                          Utils.toastMessage("Please select billing type");
                        } else if (_fromTimeController.text.isEmpty) {
                          Utils.toastMessage("Please select from time");
                        } else if (_toTimeController.text.isEmpty) {
                          Utils.toastMessage("Please select to time");
                        } else if (_desController.text.isEmpty) {
                          Utils.toastMessage("Please enter description");
                        } else {
                          Map data = {
                            'user_id': _userData?.data?.userId.toString(),
                            'usr_role_track_id':
                                _userData?.data?.roleTrackId.toString(),
                            'usr_customer_track_id':
                                _userData?.data?.customerTrackId.toString(),
                            'project_track_id': widget.taskDetail.taskDetail[0].projectId,
                            'task_track_id': widget.taskDetail.taskDetail[0].id,
                            'activity_track_id': selectActivityTrackId.toString(),
                            'hours': selectedHours.toString(),
                            'minutes': selectedMinutes.toString(),
                            'timesheet_date': widget.taskCreateDate,
                            'worktype': selectBillingTypeValue.toString(),
                            'work_description': _desController.text.toString(),
                            'time_range':
                                "${_fromTimeController.text}-${_toTimeController.text}",
                            'token': _userData?.token.toString(),
                          };
                          timeSheetViewModel.addTimeSheetApi(data, context);
                        }
                      },
                      buttonText: 'SAVE TIMESHEET',
                      loading: timeSheetViewModel.loading),
                ),
              ],
            )),
          )
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/leave/LeaveListModel.dart';
import 'package:intrasense/model/leave/LeaveTypeModel.dart';
import 'package:intrasense/utils/Utils.dart';
import '../../model/user_model.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import 'package:file_picker/file_picker.dart';
import '../../view_models/leave_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class ApplyLeave extends StatefulWidget {
  final dynamic leaveDetail;

  const ApplyLeave({Key? key, this.leaveDetail}) : super(key: key);

  @override
  _ApplyLeave createState() => _ApplyLeave();
}

class _ApplyLeave extends State<ApplyLeave> {
  bool isUpdate = false;
  String? selectLeaveTypeValue;
  String? selectLeaveTypeId;
  List<LeaveTypeModel> leaveTypeList = [];
  List<String> leaveTypeNameList = [];

  String? selectLeavePurposeValue;
  List<String> leavePurposeList = [
    "Short Sick Leave",
    "Medical Emergency",
    "Personal Work",
    "Family Emergency",
    "Other"
  ];

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _selectDateController = TextEditingController();
  final TextEditingController _desController = TextEditingController();

  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  String? selectedFilePath;
  String? selectedFileName;

  UserModel? _userData;
  bool _isLoading = false;

  @override
  void initState() {
    getUserDetails(context);
    if (widget.leaveDetail != null) {
      isUpdate = true;
      selectLeavePurposeValue = widget.leaveDetail.levPurpose.toString();
      _desController.text = widget.leaveDetail.levAppliedComment.toString();
      selectLeaveTypeValue = widget.leaveDetail.levType.toString();

      if(selectLeaveTypeValue=="Half Day"||selectLeaveTypeValue=="Short leave"){
        _selectDateController.text= widget.leaveDetail.levStartDate.toString();
        _startTimeController.text= widget.leaveDetail.levStartTime.toString();
        _endTimeController.text= widget.leaveDetail.levEndTime.toString();
      }
      else{
        _fromDateController.text = widget.leaveDetail.levStartDate.toString();
        _toDateController.text = widget.leaveDetail.levEndDate.toString();
      }

       /* selectLeaveTypeId = leaveTypeList
            .firstWhere(
                (item) => item.leaveType == selectLeaveTypeValue)
            .leaveTypeId;*/

    }

    super.initState();
  }

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
    getLeaveTypeList();
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedFilePath = result.files.single.path;
        setState(() {
          selectedFileName = result.files.single.name;
        });
      });
    } else {
      // User canceled the picker
    }
  }

  Future<void> getLeaveTypeList() async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'customer_id': _userData?.data?.customerTrackId,
        'token': _userData?.token,
      };
      final leaveViewModel =
          Provider.of<LeaveViewModel>(context, listen: false);
      final response = await leaveViewModel.getLeaveTypeListApi(data, context);
      Utils.hideLoadingDialog(context);
      setState(() {
        if (response != null) {
          leaveTypeList = response.toList();
          leaveTypeNameList = leaveTypeList.map((item) => item.leaveType).toList();
          if(isUpdate== true){
            selectLeaveTypeId = leaveTypeList
                .firstWhere(
                    (item) => item.leaveType == selectLeaveTypeValue)
                .leaveTypeId;
          }
        }
      });
    } catch (error) {
      Utils.hideLoadingDialog(context);
      print('Error fetching leaves list: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final leaveViewModel = Provider.of<LeaveViewModel>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                 Text(
                  isUpdate ? 'Update leave' : 'Apply for leave',
                  style: const TextStyle(
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
            bottom: 60,
            // Adjust the bottom to leave space for the button
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                         Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              isUpdate ? 'Update leave' : 'Apply for leave',
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryOrange,
                                  fontFamily: 'PoppinsMedium'),
                            )),
                        const SizedBox(height: 15),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Select Leave Type',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),
                        const SizedBox(height: 5),
                        CustomDropdown(
                          value: selectLeaveTypeValue,
                          items: leaveTypeNameList,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectLeaveTypeValue = newValue;
                              selectLeaveTypeId = leaveTypeList
                                  .firstWhere(
                                      (item) => item.leaveType == newValue)
                                  .leaveTypeId;
                            });
                          },
                          hint: 'Select Leave',
                        ),
                        const SizedBox(height: 15),
                        if (selectLeaveTypeValue == "Half Day" ||
                            selectLeaveTypeValue == "Short leave") ...[
                          Column(
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
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
                              const SizedBox(height: 5),
                              CustomTextField(
                                controller: _selectDateController,
                                hintText: 'DD/MM/YYYY',
                                suffixIcon: Image.asset(
                                  Images.calenderIcon,
                                  height: 24,
                                  width: 24,
                                ),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365 * 100)),
                                  );

                                  if (pickedDate != null) {
                                    String formattedDate =
                                        "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                                    setState(() {
                                      _selectDateController.text =
                                          formattedDate;
                                    });
                                  }
                                },
                              )
                            ],
                          )
                        ] else ...[
                          Row(
                            children: [
                              const Expanded(
                                  flex: 10,
                                  child: Text(
                                    'From',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textColor,
                                      fontFamily: 'PoppinsRegular',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )),
                              Expanded(flex: 1, child: Container()),
                              const Expanded(
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
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                  flex: 10,
                                  child: CustomTextField(
                                    controller: _fromDateController,
                                    hintText: 'DD/MM/YYYY',
                                    suffixIcon: Image.asset(
                                      Images.calenderIcon,
                                      height: 24,
                                      width: 24,
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(
                                            const Duration(days: 365 * 100)),
                                      );

                                      if (pickedDate != null) {
                                        String formattedDate =
                                            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                                        setState(() {
                                          _fromDateController.text =
                                              formattedDate;
                                        });
                                      }
                                    },
                                  )),
                              Expanded(flex: 1, child: Container()),
                              Expanded(
                                  flex: 10,
                                  child: CustomTextField(
                                      controller: _toDateController,
                                      hintText: 'DD/MM/YYYY',
                                      suffixIcon: Image.asset(
                                        Images.calenderIcon,
                                        height: 24,
                                        width: 24,
                                      ),
                                      readOnly: true,
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now().add(
                                              const Duration(days: 365 * 100)),
                                        );

                                        if (pickedDate != null) {
                                          String formattedDate =
                                              "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                                          setState(() {
                                            _toDateController.text =
                                                formattedDate;
                                          });
                                        }
                                      }))
                            ],
                          ),
                          const SizedBox(height: 15),
                        ],
                        if (selectLeaveTypeValue == "Half Day" ||
                            selectLeaveTypeValue == "Short leave") ...[
                          Column(
                            children: [
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  const Expanded(
                                      flex: 10,
                                      child: Text(
                                        'Start Time',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textColor,
                                          fontFamily: 'PoppinsRegular',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )),
                                  Expanded(flex: 1, child: Container()),
                                  const Expanded(
                                      flex: 10,
                                      child: Text(
                                        'End Time',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textColor,
                                          fontFamily: 'PoppinsRegular',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ))
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 10,
                                      child: CustomTextField(
                                        controller: _startTimeController,
                                        hintText: 'Select start time',
                                        suffixIcon: Image.asset(
                                          Images.clockIcon,
                                          height: 24,
                                          width: 24,
                                        ),
                                        readOnly: true,
                                        onTap: () async {
                                          TimeOfDay? pickedTime =
                                              await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );

                                          if (pickedTime != null) {
                                            // Format the time to display in HH:mm format
                                            final formattedTime =
                                                pickedTime.format(context);
                                            setState(() {
                                              _startTimeController.text =
                                                  formattedTime;
                                            });
                                          }
                                        },
                                      )),
                                  Expanded(flex: 1, child: Container()),
                                  Expanded(
                                      flex: 10,
                                      child: CustomTextField(
                                        controller: _endTimeController,
                                        hintText: 'Select end time',
                                        suffixIcon: Image.asset(
                                          Images.clockIcon,
                                          height: 24,
                                          width: 24,
                                        ),
                                        readOnly: true,
                                        onTap: () async {
                                          TimeOfDay? pickedTime =
                                              await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );

                                          if (pickedTime != null) {
                                            // Format the time to display in HH:mm format
                                            final formattedTime =
                                                pickedTime.format(context);
                                            setState(() {
                                              _endTimeController.text =
                                                  formattedTime;
                                            });
                                          }
                                        },
                                      ))
                                ],
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ],
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Select Purpose',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textColor,
                                  fontFamily: 'PoppinsMedium'),
                            )),
                        const SizedBox(height: 5),
                        CustomDropdown(
                          value: selectLeavePurposeValue,
                          items: leavePurposeList,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectLeavePurposeValue = newValue;
                            });
                          },
                          hint: 'Select Purpose',
                        ),
                        if (selectLeavePurposeValue == "Medical Emergency") ...[
                          Column(
                            children: [
                              const SizedBox(height: 15),
                              const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Upload documents',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textColor,
                                        fontFamily: 'PoppinsMedium'),
                                  )),
                              const SizedBox(height: 5),
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                    color: AppColors.lightBlue,
                                    border: Border.all(
                                      color: AppColors.lightBlue,
                                      width: 1.0,
                                    ),
                                  ),
                                  height: 100,
                                  child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Row(children: [
                                        const SizedBox(width: 10),
                                        IconButton(
                                          icon: Image.asset(
                                            Images.uploadIcon,
                                            height: 50,
                                            width: 50,
                                          ),
                                          onPressed: () {
                                            pickFile();
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                        const Align(
                                            alignment: Alignment.topCenter,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'UPLOAD FILE',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: AppColors
                                                          .skyBlueTextColor,
                                                      fontFamily:
                                                          'PoppinsMedium'),
                                                ),
                                                Text(
                                                  'Add upto 25 mb',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          AppColors.textColor,
                                                      fontFamily:
                                                          'PoppinsRegular',
                                                      fontStyle:
                                                          FontStyle.italic),
                                                )
                                              ],
                                            ))
                                      ]))),
                              const SizedBox(height: 5),
                              if (selectedFileName != null) ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedFileName.toString(),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.hintColor,
                                        fontFamily: 'PoppinsRegular',
                                      ),
                                    ),
                                    IconButton(
                                      icon: Image.asset(
                                        Images.orangeRoundCrossIcon,
                                        height: 30,
                                        width: 30,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          selectedFileName = null;
                                          selectedFilePath = null;
                                        });
                                      },
                                    ),
                                  ],
                                )
                              ]
                            ],
                          ),
                        ],
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            children: [
                              const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Description (Min 20 Characters)',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textColor,
                                        fontFamily: 'PoppinsMedium'),
                                  )),
                              const SizedBox(height: 5),
                              CustomTextField(
                                  controller: _desController,
                                  hintText: 'Enter description...',
                                  minLines: 4,
                                  maxLines: 4),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Place the button at the bottom of the screen
          Positioned(
            left: 0,
            right: 0,
            bottom: 0, // Position button at the bottom of the screen
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: CustomElevatedButton(
                onPressed: () async {
                  if (selectLeaveTypeValue == null) {
                    Utils.toastMessage("Please select leave type");
                  } else if ((selectLeaveTypeValue == "Half Day" ||
                          selectLeaveTypeValue == "Short leave") &&
                      _selectDateController.text.isEmpty) {
                    Utils.toastMessage("Please select date");
                  } else if ((selectLeaveTypeValue == "Half Day" ||
                          selectLeaveTypeValue == "Short leave") &&
                      _startTimeController.text.isEmpty) {
                    Utils.toastMessage("Please select start time");
                  } else if ((selectLeaveTypeValue == "Half Day" ||
                          selectLeaveTypeValue == "Short leave") &&
                      _endTimeController.text.isEmpty) {
                    Utils.toastMessage("Please select end time");
                  } else if ((selectLeaveTypeValue != "Half Day" &&
                          selectLeaveTypeValue != "Short leave") &&
                      _fromDateController.text.isEmpty) {
                    Utils.toastMessage("Please select from date");
                  } else if ((selectLeaveTypeValue != "Half Day" &&
                          selectLeaveTypeValue != "Short leave") &&
                      _toDateController.text.isEmpty) {
                    Utils.toastMessage("Please select to date");
                  } else if (selectLeavePurposeValue == null) {
                    Utils.toastMessage("Please select purpose");
                  } else if (selectLeavePurposeValue == "Medical Emergency" &&
                      selectedFilePath == null) {
                    Utils.toastMessage("Please upload medical document");
                  } else if (_desController.text.isEmpty) {
                    Utils.toastMessage("Please enter description");
                  } else if (_desController.text.characters.length < 20) {
                    Utils.toastMessage(
                        "Please enter description min 20 characters");
                  } else {
                    Map data = {
                      'user_id': _userData?.data?.userId.toString(),
                      'usr_role_track_id':
                          _userData?.data?.roleTrackId.toString(),
                      'usr_customer_track_id':
                          _userData?.data?.customerTrackId.toString(),
                      'leave_type': selectLeaveTypeId,
                      'leave_purpose': selectLeavePurposeValue,
                      'leave_description': _desController.text.toString(),
                      'token': _userData?.token.toString(),
                      if (selectLeaveTypeValue == "Half Day" ||
                          selectLeaveTypeValue == "Short leave") ...{
                        'start_time': _startTimeController.text.toString(),
                        'end_time': _endTimeController.text.toString(),
                        'from_date': _selectDateController.text.toString(),
                      } else ...{
                        'from_date': _fromDateController.text.toString(),
                        'to_date': _toDateController.text.toString(),
                      },
                      if(isUpdate==true)...{
                        'leave_id': widget.leaveDetail.leaveId.toString(),
                      }

                    };
                    leaveViewModel.applyLeaveWithFileApi(data,context,selectedFilePath);
                    /*if(selectedFilePath!=null){
                      leaveViewModel.applyLeaveWithFileApi(data,context,selectedFilePath);
                    }
                    else{
                      //leaveViewModel.applyLeaveApi(data, context);
                    }*/
                  }
                },
                buttonText: isUpdate ? 'UPDATE LEAVE' : 'APPLY FOR LEAVE',
                loading: leaveViewModel.loading,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

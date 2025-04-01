import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/TimeZoneModel.dart';
import 'package:intrasense/model/meeting/MeetingGroupListModel.dart';

import '../../model/client_list_model.dart';
import '../../model/meeting/MeetingDetailModel.dart';
import '../../model/teams/EmployeesListModel.dart';
import '../../model/user_model.dart';
import '../../res/component/CheckboxWithLabel.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomRadioGroup.dart';
import '../../res/component/CustomTextField.dart';
import '../../res/component/MultiSelectDropdown.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/client_view_model.dart';
import '../../view_models/common_view_model.dart';
import 'package:provider/provider.dart';
import '../../view_models/meeting_view_model.dart';
import '../../view_models/teams_view_model.dart';
import '../../view_models/user_view_model.dart';

class CreateMeeting extends StatefulWidget {
  final dynamic meetingDetail;

  const CreateMeeting({Key? key, this.meetingDetail}) : super(key: key);

  @override
  _CreateMeeting createState() => _CreateMeeting();
}

class _CreateMeeting extends State<CreateMeeting> {
  String? selectGroupNameValue;
  String? selectIndividualValue;
  String? selectClientValue;
  String? selectTimeZoneValue;
  String? priorityValue;
  final TextEditingController _meetingTopicController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _meetingLinkController = TextEditingController();

  List<String> timeZoneList = [];
  bool enableZoomMeeting = false;
  bool recurringMeeting = false;

  bool selectGroup = true;
  bool selectIndividuals = false;
  bool selectClient = false;

  UserModel? _userData;
  bool _isLoading = false;
  List<MeetingGroupListModel> meetingGroupList = [];
  List<String> groupNamesList = [];
  List<String> selectedGroupsNames = [];

  List<EmployeesListModel> employeesList = [];
  List<String> employeeNamesList = [];
  List<String> selectedEmployeesNames = [];

  List<ClientListModel> clientList = [];
  List<String> clientNameList = [];
  List<String> selectedClientNames = [];
  bool isUpdate = false;
  late MeetingDetailModel meetingDetail;

  @override
  void initState() {
    super.initState();
    fetchTimeZoneList();
    getUserDetails(context);
  }

  void fetchTimeZoneList() async {
    final commonViewModel =
        Provider.of<CommonViewModel>(context, listen: false);
    await commonViewModel.timeZoneListApi(context);
    setState(() {
      timeZoneList = commonViewModel.timeZoneList;
    });
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    setState(() {});
    if (kDebugMode) {
      print(_userData);
    }
    getGroupListAPi();
    getEmployeesList();
    getClientList();
    if (widget.meetingDetail != null) {
      isUpdate = true;
      getMeetingDetailApi();

    }
  }

  void getGroupListAPi() async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'token': _userData?.token,
      };
      final meetingViewModel =
          Provider.of<MeetingViewModel>(context, listen: false);
      final response =
          await meetingViewModel.getMeetingGroupListApi(data, context);
      if (response != null) {
        setState(() {
          meetingGroupList = response.toList();
          groupNamesList =
              meetingGroupList.map((item) => item.groupName).toList();
        });
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load client list')),
      );
    } finally {
      Utils.hideLoadingDialog(context);
    }
  }

  void getEmployeesList() async {
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'customer_id': _userData?.data?.customerTrackId,
        'token': _userData?.token,
      };
      final teamViewModel = Provider.of<TeamsViewModel>(context, listen: false);
      final response = await teamViewModel.getEmployeesListApi(data, context);
      setState(() {
        if (response != null) {
          employeesList = response;
          if (employeesList.isNotEmpty) {
            employeesList.removeWhere((employee) => employee.empId == "2");
            employeeNamesList = employeesList
                .map((item) => "${item.userFirstName} ${item.userLastName}")
                .toList();
          }
        }
      });
    } catch (error) {
      print('Error fetching employee list: $error');
    }
  }

  void getClientList() async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'customer_id': _userData?.data?.customerTrackId,
        'cmp_name': "",
        'cmp_industry': "",
        'cmp_country': "",
        'token': _userData?.token,
      };
      final clientViewModel =
          Provider.of<ClientViewModel>(context, listen: false);
      final response = await clientViewModel.getClientListApi(data, context);
      setState(() {
        if (response != null) {
          clientList = response.toList();
          clientNameList = clientList.map((item) => item.cmpName.toString()).toList();
        }
      });
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load client list')),
      );
    } finally {
      Utils.hideLoadingDialog(context);
    }
  }

  void getMeetingDetailApi() async {
    Utils.showLoadingDialog(context);
    setLoading(true);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'meeting_id': widget.meetingDetail.meetingId,
        'token': _userData?.token,
      };
      final meetingViewModel =
      Provider.of<MeetingViewModel>(context, listen: false);
      final response =
      await meetingViewModel.getMeetingDetailApi(data, context);
      if (response != null) {
        setState(() {
          meetingDetail = response[0];
          setMeetingData();
        });
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load client list')),
      );
    } finally {
      Utils.hideLoadingDialog(context);
    }
  }

  void setMeetingData() {
    _meetingTopicController.text= meetingDetail.meetingTitle.toString();
    _dateController.text= meetingDetail.meetingDate.toString();
    _timeController.text= meetingDetail.meetingTime.toString();
    _meetingLinkController.text= meetingDetail.zoomLink.toString();
    selectTimeZoneValue= meetingDetail.meetingTimeZone;

    if(meetingDetail.meetingRecurring=="1"){
      recurringMeeting= true;
    }
    else{
      recurringMeeting= false;
    }

    if(meetingDetail.zoomMeeting=="1"){
      enableZoomMeeting= true;
    }
    else{
      enableZoomMeeting= false;
    }

    if(meetingDetail.userDetails.isNotEmpty){
      selectIndividuals= true;
      selectedEmployeesNames = meetingDetail.userDetails.map((user) {
        String firstName = user.firstName ?? "";
        String lastName = user.lastName ?? "";
        return "$firstName $lastName";
      }).toList();
    }
    else{
      selectIndividuals= false;
    }

    if(meetingDetail.groupDetails.isNotEmpty){
      selectGroup= true;
      selectedGroupsNames = meetingDetail.groupDetails
          .map((group) => group.groupName)
          .where((name) => name != null)
          .map((name) => name!)
          .toList();
    }
    else{
      selectGroup= false;
    }

    if(meetingDetail.clientDetails.isNotEmpty){
      selectClient= true;
      selectedClientNames = meetingDetail.clientDetails.map((client) {
        return client.companyName ?? "";
      }).toList();
    }
    else{
      selectClient= false;
    }

    switch (meetingDetail.meetingPriority) {
      case "1":
        priorityValue=  'High Priority';
        break;
      case "2":
        priorityValue= 'Important';
        break;
      case "3":
        priorityValue= 'Low Priority';
        break;
      default:
        priorityValue= 'Low Priority';
        break;
    }
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final meetingViewModel = Provider.of<MeetingViewModel>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery
                .of(context)
                .size
                .height,
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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
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
                  isUpdate ? 'Update Meeting' : 'Create Meeting',
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
            top: 140,
            left: 20,
            right: 20,
            bottom: 0,
            child: SingleChildScrollView(
                child: Column(
              children: [
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Meeting Topic',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'Enter Meeting Topic',
                  controller: _meetingTopicController,
                ),
                const SizedBox(height: 15),
                CheckboxWithLabel(
                  label: 'Select Group',
                  value: selectGroup,
                  onChanged: (bool? value) {
                    setState(() {
                      selectGroup = value ?? false;
                      if (selectGroup == false && selectIndividuals == false && selectClient == false) {
                        selectGroup = true;
                        selectedGroupsNames.clear();
                        selectedEmployeesNames.clear();
                        selectedClientNames.clear();
                      }
                    });
                  },
                ),
                CheckboxWithLabel(
                  label: 'Select Individuals',
                  value: selectIndividuals,
                  onChanged: (bool? value) {
                    setState(() {
                      selectIndividuals = value ?? false;
                      if (selectGroup == false && selectIndividuals == false && selectClient == false) {
                        selectGroup = true;
                        selectedGroupsNames.clear();
                        selectedEmployeesNames.clear();
                        selectedClientNames.clear();
                      }
                    });
                  },
                ),
                CheckboxWithLabel(
                  label: 'Select Client',
                  value: selectClient,
                  onChanged: (bool? value) {
                    setState(() {
                      selectClient = value ?? false;
                      if (selectGroup == false && selectIndividuals == false && selectClient == false) {
                        selectGroup = true;
                        selectedGroupsNames.clear();
                        selectedEmployeesNames.clear();
                        selectedClientNames.clear();
                      }
                    });
                  },
                ),
                if (selectGroup) ...{
                  Column(
                    children: [
                      const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Select Groups',
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium'),
                          )),
                      const SizedBox(height: 5),
                      MultiSelectDropdown(
                        items: groupNamesList,
                        selectedItems: selectedGroupsNames,
                        onChanged: (selectedItems) {
                          setState(() {
                            //employeeNames = selectedItems;
                          });
                        },
                        hint: "Select Groups",
                      )
                     /* CustomDropdown(
                        value: selectGroupNameValue,
                        items: groupNamesList,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectGroupNameValue = newValue;
                          });
                        },
                        hint: 'Select Groups',
                      )*/,
                    ],
                  ),
                  const SizedBox(height: 15)
                },
                if (selectIndividuals) ...{
                  Column(
                    children: [
                      const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Select Individuals',
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium'),
                          )),
                      const SizedBox(height: 5),
                      MultiSelectDropdown(
                        items: employeeNamesList,
                        selectedItems: selectedEmployeesNames,
                        onChanged: (selectedItems) {
                          setState(() {
                            //employeeNames = selectedItems;
                          });
                        },
                        hint: "Select Individuals",
                      )

                      /*CustomDropdown(
                        value: selectIndividualValue,
                        items: employeeNamesList,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectIndividualValue = newValue;
                          });
                        },
                        hint: 'Select Individuals',
                      )*/,
                    ],
                  ),
                  const SizedBox(height: 15)
                },
                if (selectClient) ...{
                  Column(
                    children: [
                      const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Select Client',
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium'),
                          )),
                      const SizedBox(height: 5),
                      MultiSelectDropdown(
                        items: clientNameList,
                        selectedItems: selectedClientNames,
                        onChanged: (selectedItems) {
                          setState(() {
                            //employeeNames = selectedItems;
                          });
                        },
                        hint: "Select Client",
                      ),
                      /*CustomDropdown(
                        value: selectClientValue,
                        items: clientNameList,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectClientValue = newValue;
                          });
                        },
                        hint: 'Select Client',
                      ),*/
                    ],
                  ),
                  const SizedBox(height: 15)
                },
                Row(
                  children: [
                    Expanded(
                        flex: 10,
                        child: Container(
                          child: const Text(
                            'Date',
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
                          'Time',
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
                        child: CustomTextField(
                          controller: _dateController,
                          hintText: 'DD/MM/YYYY',
                          suffixIcon: Image.asset(
                            Images.calenderIcon,
                            height: 20,
                            width: 20,
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
                              // Format date with leading zeros in month and day
                              String formattedDate =
                                  "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                              setState(() {
                                _dateController.text = formattedDate;
                              });
                            }
                          },
                        )),
                    Expanded(flex: 1, child: Container()),
                    Expanded(
                        flex: 10,
                        child: CustomTextField(
                          controller: _timeController,
                          hintText: 'Select start time',
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
                                _timeController.text = formattedTime;
                              });
                            }
                          },
                        ))
                  ],
                ),
                const SizedBox(height: 15),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Time Zone',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
                const SizedBox(height: 5),
                CustomDropdown(
                  value: selectTimeZoneValue,
                  items: timeZoneList,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectTimeZoneValue = newValue;
                    });
                  },
                  hint: 'Select an option',
                ),
                const SizedBox(height: 15),
                CheckboxWithLabel(
                  label: 'Recurring meeting',
                  value: recurringMeeting,
                  onChanged: (bool? value) {
                    setState(() {
                      recurringMeeting = value ?? false;
                    });
                  },
                ),
                CheckboxWithLabel(
                  label: 'Enable zoom meeting',
                  value: enableZoomMeeting,
                  onChanged: (bool? value) {
                    setState(() {
                      enableZoomMeeting = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: 15),
                if (enableZoomMeeting) ...{
                  Column(
                    children: [
                      const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Enter Meeting Link',
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium'),
                          )),
                      const SizedBox(height: 5),
                       CustomTextField(
                          hintText: 'Enter Meeting Link',
                        controller: _meetingLinkController,
                      ),
                      const SizedBox(height: 15),
                    ],
                  )
                },
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Priority',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryColor,
                        fontFamily: 'PoppinsMedium',
                      ),
                    )),
                const SizedBox(height: 5),
                CustomRadioGroup(
                  options: ['High Priority', 'Important', 'Low Priority'],
                  groupValue: priorityValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      priorityValue = newValue;
                    });
                  },
                ),
                const SizedBox(height: 15),
                CustomElevatedButton(
                  onPressed: () {
                    if (_meetingTopicController.text.toString().isEmpty) {
                      Utils.toastMessage("Please enter meeting topic");
                    } else if (selectGroup == true &&
                        selectedGroupsNames.isEmpty) {
                      Utils.toastMessage("Please select at least one group");
                    } else if (selectIndividuals == true &&
                        selectedEmployeesNames.isEmpty) {
                      Utils.toastMessage("Please select at least one individuals");
                    } else if (selectClient == true &&
                        selectedClientNames.isEmpty) {
                      Utils.toastMessage("Please select at least one client");
                    } else if (_dateController.text.toString().isEmpty == true) {
                      Utils.toastMessage("Please select date");
                    } else if (_timeController.text.toString().isEmpty == true) {
                      Utils.toastMessage("Please select time");
                    } else if (selectTimeZoneValue?.isEmpty == true) {
                      Utils.toastMessage("Please select time zone");
                    }
                    else if(enableZoomMeeting== true && _meetingLinkController.text.toString().isEmpty){
                      Utils.toastMessage("Please enter meeting link");
                    }

                    else if (priorityValue?.isEmpty == true) {
                      Utils.toastMessage("Please select priority");
                    } else {
                      String priority="";
                      if(priorityValue=="High Priority"){
                        priority="0";
                      }
                      else  if(priorityValue=="Important"){
                        priority="1";
                      }
                      else  if(priorityValue=="Low Priority"){
                        priority="2";
                      }

                      Map data = {
                        'user_id': _userData?.data?.userId.toString(),
                        'usr_customer_track_id':
                        _userData?.data?.customerTrackId.toString(),
                        'usr_role_track_id':
                        _userData?.data?.roleTrackId.toString(),
                        'meeeing_title': _meetingTopicController.text.toString(),
                        'meeting_date': _dateController.text.toString(),
                        'meeting_time': _timeController.text.toString(),
                        'meeeing_timeZone': selectTimeZoneValue,
                        'meeeing_recurring': recurringMeeting ? "1" : "0",
                        'zoom_meeting_check': enableZoomMeeting ? "1" : "0",
                        'zoom_link': _meetingLinkController.text.toString(),
                        'meeeing_priority': priority,
                        'userFullname': "${_userData?.data?.firstName} ${_userData?.data?.lastName}",
                        'token': _userData?.token.toString(),
                      };

                      for (int i = 0; i < selectedGroupsNames.length; i++) {
                        var group = meetingGroupList.firstWhere((group) => group.groupName == selectedGroupsNames[i]);
                        data['group_ids[$i]'] = group.groupId;
                      }

                     /* for (int i = 0; i < selectedEmployeesNames.length; i++) {
                        var employee = employeesList.firstWhere((employee) => "${employee.userFirstName} ${employee.userLastName}" == selectedEmployeesNames[i]);
                        data['users_ids[$i]'] = employee.empId;
                      }*/

                      for (int i = 0; i < selectedEmployeesNames.length; i++) {
                        try {
                          // Trim whitespace from selected employee name
                          var employee = employeesList.firstWhere(
                                (employee) => "${employee.userFirstName} ${employee.userLastName}".trim() == selectedEmployeesNames[i].trim(),

                          );

                          if (employee != null) {
                            data['users_ids[$i]'] = employee.empId;
                          } else {
                            // Handle case when employee is not found
                            print('Employee not found: ${selectedEmployeesNames[i]}');
                          }
                        } catch (e) {
                          print("Error while processing employee at index $i: $e");
                        }
                      }

                      for (int i = 0; i < selectedClientNames.length; i++) {
                        var client = clientList.firstWhere((client) => client.cmpName == selectedClientNames[i]);
                        data['client_ids[$i]'] = client.companyId;
                      }

                      if(isUpdate==true){
                        data['meeting_id'] = meetingDetail.meetingId;
                      }

                      meetingViewModel.addMeetingApi(data, context);
                    }
                  },
                  buttonText: isUpdate ? 'UPDATE' : 'SUBMIT',
                  loading: meetingViewModel.loading,
                ),
              ],
            )),
          )
        ],
      ),
    );
  }


}

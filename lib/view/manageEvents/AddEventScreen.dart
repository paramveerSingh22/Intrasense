import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/view_models/event_view_model.dart';

import '../../model/client_list_model.dart';
import '../../model/meeting/MeetingGroupListModel.dart';
import '../../model/teams/EmployeesListModel.dart';
import '../../model/user_model.dart';
import '../../res/component/CheckboxWithLabel.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomTextField.dart';
import '../../res/component/MultiSelectDropdown.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/client_view_model.dart';
import '../../view_models/common_view_model.dart';
import '../../view_models/meeting_view_model.dart';
import '../../view_models/teams_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class AddEventScreen extends StatefulWidget{
  @override
  _AddEventScreen createState() => _AddEventScreen();

}

class _AddEventScreen extends State<AddEventScreen>{
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _googleMapUrlController = TextEditingController();
  final TextEditingController _desController = TextEditingController();
  final TextEditingController _organizerNameController = TextEditingController();

  UserModel? _userData;
  bool _isLoading = false;


  String? selectGroupNameValue;
  String? selectIndividualValue;
  String? selectClientValue;
  String? selectTimeZoneValue;
  List<String> timeZoneList = [];

  List<MeetingGroupListModel> meetingGroupList = [];
  List<String> groupNamesList = [];
  List<String> selectedGroupsNames = [];

  List<EmployeesListModel> employeesList = [];
  List<String> employeeNamesList = [];
  List<String> selectedEmployeesNames = [];

  List<ClientListModel> clientList = [];
  List<String> clientNameList = [];
  List<String> selectedClientNames = [];

  bool selectGroup = false;
  bool selectIndividuals = true;
  bool selectClient = false;


  @override
  void initState() {
    super.initState();
    fetchTimeZoneList();
    getUserDetails(context);
  }

  void fetchTimeZoneList() async {
    final commonViewModel = Provider.of<CommonViewModel>(context, listen: false);
    await commonViewModel.timeZoneListApi(context);
    setState(() {
      timeZoneList = commonViewModel.timeZoneList;
    });
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    _organizerNameController.text= "${_userData?.data?.firstName} ${_userData?.data?.lastName}";
    setState(() {});
    if (kDebugMode) {
      print(_userData);
    }
    getGroupListAPi();
    getEmployeesList();
    getClientList();
    /*if (widget.meetingDetail != null) {
      isUpdate = true;
      getMeetingDetailApi();

    }*/
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

  @override
  Widget build(BuildContext context) {
    final eventViewModel = Provider.of<EventViewModel>(context);
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
               const Text(
                 'Add Event',
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
           top: 140,
           left: 20,
           right: 20,
           bottom: 0,
           child: SingleChildScrollView(
               child: Column(
                 children: [
                   const Align(
                       alignment: Alignment.centerLeft,
                       child: Text(
                         "Add Event",
                         style: TextStyle(
                             fontSize: 14,
                             color: AppColors.secondaryOrange,
                             fontFamily: 'PoppinsMedium'),
                       )),
                   const SizedBox(height: 10),
                   const Align(
                       alignment: Alignment.topLeft,
                       child: Text(
                         'Title',
                         style: TextStyle(
                             fontSize: 14,
                             color: AppColors.textColor,
                             fontFamily: 'PoppinsMedium'),
                       )),
                   const SizedBox(height: 5),
                   CustomTextField(
                     hintText: 'Title',
                     controller: _titleController,
                   ),
                   const SizedBox(height: 15),
                   const Align(
                       alignment: Alignment.topLeft,
                       child: Text(
                         'Date',
                         style: TextStyle(
                             fontSize: 14,
                             color: AppColors.textColor,
                             fontFamily: 'PoppinsMedium'),
                       )),
                   const SizedBox(height: 5),
                   CustomTextField(
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
                   ),
                   const SizedBox(height: 15),
                   const Align(
                       alignment: Alignment.topLeft,
                       child: Text(
                         'Venue',
                         style: TextStyle(
                             fontSize: 14,
                             color: AppColors.textColor,
                             fontFamily: 'PoppinsMedium'),
                       )),
                   const SizedBox(height: 5),
                   CustomTextField(
                     hintText: 'Address1',
                     controller: _address1Controller,
                   ),
                   const SizedBox(height: 15),
                   Row(
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
                             controller: _startTimeController,
                             hintText: 'Select End time',
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
                                   _startTimeController.text = formattedTime;
                                 });
                               }
                             },
                           )),
                       Expanded(flex: 1, child: Container()),
                       Expanded(
                           flex: 10,
                           child: CustomTextField(
                             controller: _endTimeController,
                             hintText: 'Select End time',
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
                                   _endTimeController.text = formattedTime;
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

                   const Align(
                       alignment: Alignment.topLeft,
                       child: Text(
                         'Google Map URL',
                         style: TextStyle(
                             fontSize: 14,
                             color: AppColors.textColor,
                             fontFamily: 'PoppinsMedium'),
                       )),
                   const SizedBox(height: 5),
                   CustomTextField(
                     hintText: '',
                     controller: _googleMapUrlController,
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
                   const SizedBox(height: 5),
                   CustomTextField(
                       controller: _desController,
                       hintText: 'Enter description...',
                       minLines: 4,
                       maxLines: 4),
                   const SizedBox(height: 15),

                   CheckboxWithLabel(
                     label: 'Select User',
                     value: selectIndividuals,
                     onChanged: (bool? value) {
                       setState(() {
                         selectIndividuals = value ?? false;
                         if (selectGroup == false && selectIndividuals == false && selectClient == false) {
                           selectIndividuals = true;
                           selectedGroupsNames.clear();
                           selectedEmployeesNames.clear();
                           selectedClientNames.clear();
                         }
                       });
                     },
                   ),

                   CheckboxWithLabel(
                     label: 'Select Group',
                     value: selectGroup,
                     onChanged: (bool? value) {
                       setState(() {
                         selectGroup = value ?? false;
                         if (selectGroup == false && selectIndividuals == false && selectClient == false) {
                           selectIndividuals = true;
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
                           selectIndividuals = true;
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
                         ),
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
                               'Select Users',
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
                           hint: "Select Users",
                         ),
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
                       ],
                     ),
                     const SizedBox(height: 15)
                   },

                   const SizedBox(height: 15),

                   const Align(
                       alignment: Alignment.topLeft,
                       child: Text(
                         'Organiser(s)',
                         style: TextStyle(
                             fontSize: 14,
                             color: AppColors.textColor,
                             fontFamily: 'PoppinsMedium'),
                       )),
                   const SizedBox(height: 5),
                   CustomTextField(
                     hintText: 'Organiser name',
                     controller: _organizerNameController,
                     readOnly:true
                   ),
                   const SizedBox(height: 15),

                   CustomElevatedButton(
                     onPressed: () {
                       if (_titleController.text.toString().isEmpty) {
                         Utils.toastMessage("Please enter event title");
                       }
                      else if (_dateController.text.toString().isEmpty) {
                         Utils.toastMessage("Please select date");
                       }
                       else if (_address1Controller.text.toString().isEmpty) {
                         Utils.toastMessage("Please enter venue");
                       }
                       else if (_startTimeController.text.toString().isEmpty) {
                         Utils.toastMessage("Please select start time");
                       }
                       else if (_endTimeController.text.toString().isEmpty) {
                         Utils.toastMessage("Please select end time");
                       }
                       else if (selectTimeZoneValue?.isEmpty == true) {
                         Utils.toastMessage("Please select time zone");
                       }
                       else if (_googleMapUrlController.text.toString().isEmpty) {
                         Utils.toastMessage("Please enter google map url");
                       }
                       else if (_desController.text.toString().isEmpty) {
                         Utils.toastMessage("Please enter description");
                       }
                       else if (selectIndividuals == true &&
                           selectedEmployeesNames.isEmpty) {
                         Utils.toastMessage("Please select at least one individuals");
                       }
                       else if (selectGroup == true &&
                           selectedGroupsNames.isEmpty) {
                         Utils.toastMessage("Please select at least one group");
                       }  else if (selectClient == true &&
                           selectedClientNames.isEmpty) {
                         Utils.toastMessage("Please select at least one client");
                       }

                       else {
                         Map data = {
                           'user_id': _userData?.data?.userId.toString(),
                           'usr_role_track_id':
                           _userData?.data?.roleTrackId.toString(),
                           'deviceToken': "WEB",
                           'deviceType':"WEB",
                           'title': _titleController.text.toString(),
                           'eventdate': _dateController.text.toString(),
                           'venue':_address1Controller.text.toString(),
                           'timefrom':_startTimeController.text.toString(),
                           'timeto':_endTimeController.text.toString(),
                           'timezone':selectTimeZoneValue,
                           'googlemapurl':_googleMapUrlController.text.toString(),
                           'description':_desController.text.toString(),
                           'token': _userData?.token.toString(),
                         };

                         for (int i = 0; i < selectedGroupsNames.length; i++) {
                           var group = meetingGroupList.firstWhere((group) => group.groupName == selectedGroupsNames[i]);
                           data['group_id[$i]'] = group.groupId;
                         }

                          for (int i = 0; i < selectedEmployeesNames.length; i++) {
                          var employee = employeesList.firstWhere((employee) => "${employee.userFirstName} ${employee.userLastName}" == selectedEmployeesNames[i]);
                          data['attendees_userid[$i]'] = employee.empId;
                      }

                         for (int i = 0; i < selectedEmployeesNames.length; i++) {
                           try {
                             var employee = employeesList.firstWhere(
                                   (employee) => "${employee.userFirstName} ${employee.userLastName}".trim() == selectedEmployeesNames[i].trim(),

                             );

                             if (employee != null) {
                               data['attendees_userid[$i]'] = employee.empId;
                             } else {
                               print('Employee not found: ${selectedEmployeesNames[i]}');
                             }
                           } catch (e) {
                             print("Error while processing employee at index $i: $e");
                           }
                         }

                         for (int i = 0; i < selectedClientNames.length; i++) {
                           var client = clientList.firstWhere((client) => client.cmpName == selectedClientNames[i]);
                           data['client_id[$i]'] = client.companyId;
                         }

                        /* if(isUpdate==true){
                           data['meeting_id'] = meetingDetail.meetingId;
                         }*/

                         eventViewModel.addEventApi(data, context);
                       }
                     },
                     buttonText: 'SUBMIT',
                     loading: eventViewModel.loading,
                   ),
                 ],
               )),
         )
       ],
     ),
   );
  }

}
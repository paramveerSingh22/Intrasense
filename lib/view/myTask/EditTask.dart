import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/tasks/TasksListModel.dart';
import '../../model/client_list_model.dart';
import '../../model/contact_list_model.dart';
import '../../model/projects/ProjectListModel.dart';
import '../../model/projects/ProjectTypesModel.dart';
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
import 'package:provider/provider.dart';

import '../../utils/Utils.dart';
import '../../view_models/client_view_model.dart';
import '../../view_models/projects_view_model.dart';
import '../../view_models/tasks_view_model.dart';
import '../../view_models/teams_view_model.dart';
import '../../view_models/user_view_model.dart';

class EditTask extends StatefulWidget {
  final TaskListModel taskDetail;

  const EditTask ({
    Key? key,
    required this.taskDetail

  }): super(key: key);

  @override
  _EditTask createState() => _EditTask();
}

class _EditTask extends State<EditTask> {
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _commDateController = TextEditingController();
  final TextEditingController _budgetedHoursController = TextEditingController();
  final TextEditingController _budgetedMinutesController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  final TextEditingController _selectTeamNamesController = TextEditingController();

  final List<String> minutesOptions = [
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
  ];

  String? commSelectedHours;
  String? commSelectedMinutes;

  String? budgetedSelectedMinutes;

  String? selectStatusValue;
  String? selectPriorityValue;
  String? selectAlertValue;
  UserModel? _userData;

  String? selectTaskTypeValue;
  String? selectTaskTypeId;
  List<ProjectTypesModel> projectTypesList = [];
  List<String> projectTypesNamesList = [];

  String? selectClientValue;
  String? selectClientId;
  List<ClientListModel> clientList = [];
  List<String> clientNamesList = [];

  String? selectProjectValue;
  String? selectProjectId;
  List<ProjectListModel> projectList = [];
  List<String> projectNamesList = [];

  String? selectEmployeeValue;
  String? selectEmployeeId;
  List<EmployeesListModel> employeesList = [];
  List<String> employeeNamesList = [];

  List<String> selectedTeamMemberNames = [];
  List<String> selectedTeamMemberIds = [];

  String? selectContactValue;
  String? selectContactId;
  List<ContactListModel> contactList = [];
  List<String> contactNamesList = [];

  bool _isIndividualSelected = false;

  @override
  void initState() {
    _selectTeamNamesController.text = "Select Employees";
    _taskTitleController.text= widget.taskDetail.taskDetail![0].taskTitle.toString();
    _emailController.text= widget.taskDetail.taskDetail![0].emailSubject.toString();
    _commDateController.text= widget.taskDetail.taskDetail![0].communicationDate.toString();
    _startDateController.text= widget.taskDetail.taskDetail![0].taskStartDate.toString();
    _dueDateController.text= widget.taskDetail.taskDetail![0].taskEndDate.toString();
    _commentsController.text= widget.taskDetail.taskDetail![0].taskComments.toString();

    selectTaskTypeId= widget.taskDetail.taskDetail![0].taskTypeId.toString();
    selectClientId= widget.taskDetail.taskDetail![0].clientId.toString();
    selectProjectId= widget.taskDetail.taskDetail![0].projectId.toString();
    selectContactId= widget.taskDetail.taskDetail![0].communicationReceivedFrom.toString();
    selectEmployeeId=  widget.taskDetail.taskDetail![0].communicationSendTo.toString();

    String communicationHourMin = widget.taskDetail.taskDetail![0].communicationHourMin.toString();

    List<String> timeParts = communicationHourMin.split(":");
    commSelectedHours = timeParts[0];
    if (minutesOptions.contains(timeParts[1])) {
      commSelectedMinutes = timeParts[1];
    } else {
      commSelectedMinutes = "5";
    }

    var totalMinutes = int.tryParse(widget.taskDetail.taskDetail![0].taskHours ?? '0') ?? 0;


    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    _budgetedHoursController.text= hours.toString();
    if (minutesOptions.contains(minutes.toString())) {
      budgetedSelectedMinutes=minutes.toString();
    } else {
      budgetedSelectedMinutes = "5";
    }
   // _budgetedHoursController.text=widget.taskDetail.taskDetail![0].taskHours.toString();

    var taskStatus=widget.taskDetail.taskDetail![0].taskStatus.toString();
    Map<String, String> statusMap = {
      "1": "Pending",
      "2": "InProgress",
      "3": "Complete",
      "4": "Cancel",
      "5": "Cancel"
    };
    if (statusMap.containsKey(taskStatus)) {
      selectStatusValue = statusMap[taskStatus]!;
    } else {
      selectStatusValue = null;
    }

    var priority= widget.taskDetail.taskDetail![0].taskPriority.toString();
    Map<String, String> priorityMap = {
      "1": "High Priority",
      "2": "Important",
      "3": "Low Priority"
    };
    selectPriorityValue = priorityMap[priority] ?? "Unknown Priority";

    var alert= widget.taskDetail.taskDetail![0].taskAlertRequire.toString();
    Map<String, String> AlertMap = {
      "1": "One week before",
      "2": "Two days before",
      "3": "One day before"
    };
    selectAlertValue = AlertMap[alert] ?? "Unknown Alert";

    getUserDetails(context);
    super.initState();
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
    getTaskDetailsApi();
    getProjectTypesList();
    getClientList();
    getEmployeesList();
  }
  void getProjectTypesList() async {
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'token': _userData?.token,
      };
      final projectViewModel =
      Provider.of<ProjectsViewModel>(context, listen: false);
      final response = await projectViewModel.getProjectTypesApi(data, context);

      if (response != null) {
        setState(() {
          projectTypesList = response;
          for (var item in projectTypesList) {
            projectTypesNamesList.add('**${item.moduleCatTitle}**');
            for (var itemCategory in item.categoryType) {
              projectTypesNamesList.add(itemCategory.moduleCatTitle);
            }
          }
        });

        //// for auto select task type ////
        selectTaskTypeValue = projectTypesList
            .firstWhere((item) =>
            item.categoryType.any((category) => category.moduleCategoryId == selectTaskTypeId))
            .categoryType
            .firstWhere((category) => category.moduleCategoryId == selectTaskTypeId)
            .moduleCatTitle;


      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }


  void getTaskDetailsApi() async {
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'task_id': widget.taskDetail.taskId.toString(),
        'token': _userData?.token,
      };
      final taskViewModel =
      Provider.of<TasksViewModel>(context, listen: false);
      final response = await taskViewModel.getTasksDetailApi(data, context);

      if (response != null) {
        setState(() {
         var team =  response.userInfo;
         team.removeWhere((employee) => employee.usersId == "2");
         if(team.isNotEmpty){
           selectedTeamMemberNames = team.map((user) => '${user.firstName} ${user.lastName}').toList();
           selectedTeamMemberIds = team.map((user) => user.usersId).toList();
           _selectTeamNamesController.text =
               selectedTeamMemberNames.join(", ");
           _isIndividualSelected= true;
         }
         else{
         }
        });
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load task detail')),
      );
    }
  }

  void getClientList() async {
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'customer_id': _userData?.data?.customerTrackId,
        'token': _userData?.token,
      };
      final clientViewModel =
      Provider.of<ClientViewModel>(context, listen: false);
      await clientViewModel.getClientListApi(data, context);
      clientList = clientViewModel.clientList;
      setState(() {
        clientNamesList = clientList.map((item) => item.cmpName).toList();

        if(selectClientId!=null){
          selectClientValue = clientList
              .firstWhere((item) => item.companyId == selectClientId)
              .cmpName;

          selectProjectValue = null;
          getProjectsList(selectClientId);
          getContactList(selectClientId);
        }


      });
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load client list')),
      );
    }
  }

  Future<void> getProjectsList(String? selectClientId) async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,
        'client_id': selectClientId,
        'token': _userData?.token,
      };
      final projectViewModel =
      Provider.of<ProjectsViewModel>(context, listen: false);
      final response = await projectViewModel.getProjectListApi(data, context);
      Utils.hideLoadingDialog(context);
      setState(() {
        if (response != null) {
          projectList = response;
          if (projectList.isNotEmpty) {
            projectNamesList = projectList.map((item) => item.prName.toString()).toList();

            if(selectProjectId!=null){
              selectProjectValue = projectList
                  .firstWhere((item) => item.projectId == selectProjectId)
                  .prName;
            }

          } else {
            projectList = [];
            projectNamesList = [];
            selectProjectId = "";
          }
        }
        else {
          projectList = [];
          projectNamesList = [];
          selectProjectId = "";
        }
      });
    } catch (error) {
      Utils.hideLoadingDialog(context);
      if (kDebugMode) {
        print('Error fetching employee list: $error');
      }
    }
  }

  Future<void> getContactList(String? selectClientId) async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'client_id': selectClientId,
        'token': _userData?.token,
      };
      final clientViewModel =
      Provider.of<ClientViewModel>(context, listen: false);
      final response = await clientViewModel.getContactListApi(data, context);
      setState(() {
        if (response != null) {
          contactList = response;
          if (contactList.isNotEmpty) {
            contactNamesList = contactList.map((item) => item.contactName.toString()).toList();
            if(selectContactId!=null){
              selectContactValue = contactList
                  .firstWhere((item) => item.contactId == selectContactId)
                  .contactName;
            }

          } else {
            contactList = [];
            contactNamesList = [];
            selectContactId = "";
          }
        }
        else {
          contactList = [];
          contactNamesList = [];
          selectContactId = "";
        }
      });


      Utils.hideLoadingDialog(context);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load contact list')),
      );
      // setLoading(false);
      Utils.hideLoadingDialog(context);
    }
  }

  Future<void> getEmployeesList() async {
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
          employeesList.removeWhere((employee) => employee.empId == "2");
          if (employeesList.isNotEmpty) {
            employeeNamesList = employeesList
                .map((item) => "${item.userFirstName} ${item.userLastName}")
                .toList();

            if (selectEmployeeId != null) {
              final selectedEmployee = employeesList
                  .firstWhere((item) => item.empId == selectEmployeeId);
              selectEmployeeValue = "${selectedEmployee.userFirstName} ${selectedEmployee.userLastName}";
            }

          } else {
            employeesList = [];
            employeeNamesList = [];
            selectEmployeeId = "";
          }
        }
      });
    } catch (error) {
      print('Error fetching employee list: $error');
    }
  }

  void updateSelectedEmployeeIds() {
    selectedTeamMemberIds.clear();

    for (var selectedName in selectedTeamMemberNames) {
      var employee = employeesList.firstWhere(
            (employee) =>
        "${employee.userFirstName} ${employee.userLastName}" == selectedName,
        orElse: () => EmployeesListModel
            .empty(), // Return an empty object if no match is found
      );

      if (employee.empId != null) {
        selectedTeamMemberIds.add(employee.empId.toString());
      } else {
        if (kDebugMode) {
          print("No employee found for selected name: $selectedName");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TasksViewModel>(context);
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
                  'Edit Task',
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        children: [
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Edit Task',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.secondaryOrange,
                                    fontFamily: 'PoppinsMedium'),
                              )
                          ),
                          const SizedBox(height: 5),
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Task Title',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontFamily: 'PoppinsMedium'),
                              )),
                          const SizedBox(height: 5),
                          CustomTextField(
                            controller: _taskTitleController,
                            hintText: 'Enter Title',
                          ),
                          const SizedBox(height: 15),
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Select Task Type',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontFamily: 'PoppinsMedium'),
                              )),
                          const SizedBox(height: 5),
                          CustomDropdown(
                            value: selectTaskTypeValue,
                            items: projectTypesNamesList,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectTaskTypeValue = newValue;
                                selectTaskTypeId = projectTypesList
                                    .firstWhere((item) => item.categoryType
                                    .any((category) => category.moduleCatTitle == newValue))
                                    .categoryType
                                    .firstWhere((category) => category.moduleCatTitle == newValue)
                                    .moduleCategoryId;

                              });
                            },
                            hint: 'Select an option',
                          ),
                          const SizedBox(height: 15),
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
                          CustomDropdown(
                            value: selectClientValue,
                            items: clientNamesList,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectClientValue = newValue;
                                selectClientId = clientList.firstWhere((item) =>
                                item.cmpName == newValue).companyId;
                                selectProjectValue = null;
                                getProjectsList(selectClientId);
                                getContactList(selectClientId);

                              });
                            },
                            hint: 'Select an option',
                            enabled: false,
                          ),
                          const SizedBox(height: 15),
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Select Project',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontFamily: 'PoppinsMedium'),
                              )),
                          const SizedBox(height: 5),
                          CustomDropdown(
                            value: selectProjectValue,
                            items: projectNamesList,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectProjectValue = newValue;
                                selectProjectId = projectList
                                    .firstWhere((item) =>
                                item.prName == newValue)
                                    .projectId;
                              });
                            },
                            hint: 'Select an option',
                            enabled: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      color: AppColors.lightBlue,
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
                      child: const Text(
                        'Enter Details of Communication Received',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsMedium',
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        children: [
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'From',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontFamily: 'PoppinsMedium'),
                              )),
                          const SizedBox(height: 5),
                          CustomDropdown(
                            value: selectContactValue,
                            items: contactNamesList,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectContactValue = newValue;
                                selectContactId = contactList
                                    .firstWhere((item) =>
                                item.contactName == newValue)
                                    .contactId;
                              });
                            },
                            hint: 'Select an option',
                          ),
                          const SizedBox(height: 15),
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'To',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontFamily: 'PoppinsMedium'),
                              )),
                          const SizedBox(height: 5),
                          CustomDropdown(
                            value: selectEmployeeValue,
                            items: employeeNamesList,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectEmployeeValue = newValue;
                                selectEmployeeId = employeesList
                                    .firstWhere((item) =>
                                "${item.userFirstName} ${item.userLastName}" ==
                                    newValue)
                                    .empId;
                              });
                            },
                            hint: 'Select an option',
                          ),
                          const SizedBox(height: 15),
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Email Subject',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontFamily: 'PoppinsMedium'),
                              )),
                          const SizedBox(height: 5),
                          CustomTextField(
                            controller: _emailController,
                            hintText: 'Subject of Email',
                          ),
                          const SizedBox(height: 15),

                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Date and Timestamp of communication',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontFamily: 'PoppinsMedium'),
                              )),
                          const SizedBox(height: 5),
                          CustomTextField(
                              controller: _commDateController,
                              hintText: 'DD/MM/YYYY',
                              suffixIcon: Image.asset(
                                Images.calenderIcon,
                                height: 24, // Optional: Adjust size as needed
                                width: 24,),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                      const Duration(days: 365 * 100)),
                                );

                                if (pickedDate != null) {
                                  String formattedDate = "${pickedDate
                                      .year}-${pickedDate.month}-${pickedDate
                                      .day}";
                                  setState(() {
                                    _commDateController.text = formattedDate;
                                  });
                                }
                              }
                          ),

                          const SizedBox(height: 5),

                          Row(
                            children: [
                              Expanded(
                                  flex: 10,
                                  child: CustomDropdown(
                                    value: commSelectedHours,
                                    items: [
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
                                        commSelectedHours = newValue;
                                      });
                                    },
                                    hint: 'HH',
                                  )),
                              Expanded(flex: 1, child: Container()),
                              Expanded(
                                  flex: 10,
                                  child: CustomDropdown(
                                    value: commSelectedMinutes,
                                    items: minutesOptions,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        commSelectedMinutes = newValue;
                                      });
                                    },
                                    hint: 'MM',
                                  ))
                            ],
                          ),

                          const SizedBox(height: 15),

                          Row(
                            children: [
                              const Expanded(
                                  flex: 10,
                                  child: Text(
                                    'Start Date',
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
                                    'Due Date',
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
                                    controller: _startDateController,
                                    hintText: 'Start Date',
                                    suffixIcon: Image.asset(
                                      Images.calenderIcon,
                                      height: 24,
                                      // Optional: Adjust size as needed
                                      width: 24,),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(
                                            const Duration(days: 365 * 100)),
                                      );

                                      if (pickedDate != null) {
                                        String formattedDate = "${pickedDate
                                            .year}-${pickedDate
                                            .month}-${pickedDate.day}";
                                        setState(() {
                                          _startDateController.text =
                                              formattedDate;
                                        });
                                      }
                                    },
                                  )),
                              Expanded(flex: 1, child: Container()),
                              Expanded(
                                  flex: 10,
                                  child: CustomTextField(
                                      controller: _dueDateController,
                                      hintText: 'Due Date',
                                      suffixIcon: Image.asset(
                                        Images.calenderIcon,
                                        height: 24,
                                        // Optional: Adjust size as needed
                                        width: 24,),
                                      readOnly: true,
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now().add(
                                              const Duration(days: 365 * 100)),
                                        );

                                        if (pickedDate != null) {
                                          String formattedDate = "${pickedDate
                                              .year}-${pickedDate
                                              .month}-${pickedDate.day}";
                                          setState(() {
                                            _dueDateController.text =
                                                formattedDate;
                                          });
                                        }
                                      }
                                  ))
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Budgeted Hours',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontFamily: 'PoppinsMedium'),
                              )),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                  flex: 10,
                                  child: CustomTextField(
                                      controller: _budgetedHoursController,
                                      hintText: 'HH')),
                              Expanded(flex: 1, child: Container()),
                              Expanded(
                                  flex: 10,
                                  child: CustomDropdown(
                                    value: budgetedSelectedMinutes,
                                    items:minutesOptions,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        budgetedSelectedMinutes = newValue;
                                      });
                                    },
                                    hint: 'MM',
                                  )),
                            ],
                          )
                          ,
                          const SizedBox(height: 15),
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Status',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontFamily: 'PoppinsMedium'),
                              )),
                          const SizedBox(height: 5),
                          CustomDropdown(
                            value: selectStatusValue,
                            items: const [
                              'Pending',
                              'InProgress',
                              'Complete',
                              'Cancel'
                            ],
                            onChanged: (String? newValue) {
                              setState(() {
                                selectStatusValue = newValue;
                              });
                            },
                            hint: 'Select an option',
                          ),

                          const SizedBox(height: 15),
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Add Team',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontFamily: 'PoppinsMedium'),
                              )
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Transform.translate(
                                  offset: Offset(-10, 0),
                                  child: Checkbox(
                                    value: _isIndividualSelected,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isIndividualSelected = value ?? false;
                                      });
                                    },
                                    materialTapTargetSize: MaterialTapTargetSize
                                        .shrinkWrap, // Reduces checkbox's extra space
                                  ),
                                ),
                                const Text('Select Individuals',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textColor,
                                        fontFamily: 'PoppinsMedium')),
                              ],
                            ),
                          ),
                          if (_isIndividualSelected)
                            MultiSelectDropdown(
                              items: employeeNamesList,
                              selectedItems: selectedTeamMemberNames,
                              onChanged: (selectedItems) {
                                setState(() {
                                  if (selectedTeamMemberNames.isEmpty) {
                                    _selectTeamNamesController.text =
                                    "Select Employees";
                                  }
                                  else {
                                    _selectTeamNamesController.text =
                                        selectedTeamMemberNames.join(", ");
                                  }
                                  //employeeNames = selectedItems;
                                });
                              },
                              hint: _selectTeamNamesController.text.toString(),
                            )

                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      color: AppColors.lightBlue,
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
                      child: const Text(
                        'Priority',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsMedium',
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Align(
                      alignment: Alignment.topLeft,
                      // Aligning the radio group to the left
                      child: CustomRadioGroup(
                        options: ['High Priority', 'Important', 'Low Priority'],
                        groupValue: selectPriorityValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectPriorityValue = newValue;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      color: AppColors.lightBlue,
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
                      child: const Text(
                        'Alert',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsMedium',
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.topLeft,
                      // Aligning the radio group to the left
                      child: CustomRadioGroup(
                        options: [
                          'One week before',
                          'Two days before',
                          'One day before'
                        ],
                        groupValue: selectAlertValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectAlertValue = newValue;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Enter Comments',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontFamily: 'PoppinsMedium'),
                              )),
                          const SizedBox(height: 5),
                          CustomTextField(
                              controller: _commentsController,
                              hintText: 'Enter Comments',
                              minLines: 4,
                              // Sets the minimum height for the text field
                              maxLines: 4),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: CustomElevatedButton(
                        onPressed: () {
                          if (_taskTitleController.text.isEmpty) {
                            Utils.toastMessage("Please enter task title");
                          }
                          else if (selectTaskTypeValue == null) {
                            Utils.toastMessage("Please select task type");
                          }

                          else if (selectClientValue == null) {
                            Utils.toastMessage("Please select client");
                          }

                          else if (selectContactValue == null) {
                            Utils.toastMessage("Please select From");
                          }

                          else if (selectEmployeeValue == null) {
                            Utils.toastMessage("Please select To");
                          }
                          else if (_emailController.text.isEmpty) {
                            Utils.toastMessage("Please enter subject of email");
                          }
                          else if (_commDateController.text.isEmpty) {
                            Utils.toastMessage(
                                "Please select date of communication");
                          }
                          else if (commSelectedHours == null) {
                            Utils.toastMessage(
                                "Please select hours of communication");
                          }
                          else if (commSelectedMinutes == null) {
                            Utils.toastMessage(
                                "Please select minutes of communication");
                          }
                          else if (_startDateController.text.isEmpty) {
                            Utils.toastMessage("Please select start date");
                          }
                          else if (_dueDateController.text.isEmpty) {
                            Utils.toastMessage("Please select due date");
                          }
                          else if (_budgetedHoursController.text.isEmpty) {
                            Utils.toastMessage("Please select budgeted hours");
                          }
                          else if (budgetedSelectedMinutes == null) {
                            Utils.toastMessage(
                                "Please select budgeted minutes");
                          }
                          else if (selectStatusValue == null) {
                            Utils.toastMessage("Please select status");
                          }
                          else if (selectPriorityValue == null) {
                            Utils.toastMessage("Please select priority");
                          }
                          else if (_commentsController.text.isEmpty) {
                            Utils.toastMessage("Please enter comments");
                          }
                          else {
                            updateSelectedEmployeeIds();

                            /// for task status////
                            var taskStatus = "0";
                            if (selectStatusValue == "Pending") {
                              taskStatus = "1";
                            }
                            else if (selectStatusValue == "InProgress") {
                              taskStatus = "2";
                            }
                            else if (selectStatusValue == "Complete") {
                              taskStatus = "3";
                            }
                            else if (selectStatusValue == "Cancel") {
                              taskStatus = "4";
                            }

                            //// select Priority Value////
                            var taskPriority = "0";
                            if (selectPriorityValue == "High Priority") {
                              taskPriority = "1";
                            }
                            else if (selectPriorityValue == "Important") {
                              taskPriority = "2";
                            }
                            else if (selectPriorityValue == "Low Priority") {
                              taskPriority = "3";
                            }

                            //// select Alert Value////
                            var taskAlert = "0";
                            if (selectAlertValue == "One week before") {
                              taskAlert = "1";
                            }
                            else if (selectAlertValue == "Two days before") {
                              taskAlert = "2";
                            }
                            else if (selectAlertValue == "One day before") {
                              taskAlert = "3";
                            }

                            final budgetedHours = int.tryParse(_budgetedHoursController.text) ?? 0;
                            final budgetedMinutes = int.tryParse(_budgetedMinutesController.text) ?? 0;
                            final totalMinutes = (budgetedHours * 60) + budgetedMinutes;

                            Map data = {
                              'user_id': _userData?.data?.userId.toString(),
                              'usr_role_track_id':
                              _userData?.data?.roleTrackId.toString(),
                              'usr_customer_track_id':
                              _userData?.data?.customerTrackId.toString(),
                              'task_title': _taskTitleController.text.toString(),
                              'task_type_id': selectTaskTypeId,
                              'client_id': selectClientId,
                              'project_id': selectProjectId,
                              'communication_received_from': selectContactId,
                              'communication_send_to': selectEmployeeId,
                              'email_subject': _emailController.text.toString(),
                              'communication_date': _commDateController.text
                                  .toString(),
                              'communication_hourmin': "$commSelectedHours:$commSelectedMinutes",
                              'task_start_date': _startDateController.text
                                  .toString(),
                              'task_end_date': _dueDateController.text
                                  .toString(),
                              'task_hours': totalMinutes.toString(),
                              'task_status': taskStatus,
                              'task_priority': taskPriority,
                              'task_alert_require': taskAlert,
                              'task_comments': _commentsController.text.toString(),
                              'task_id': widget.taskDetail.taskId,
                              'token': _userData?.token.toString(),
                            };

                            for (int i = 0; i <
                                selectedTeamMemberIds.length; i++) {
                              data['taskuser_ids[$i]'] =
                              selectedTeamMemberIds[i];
                            }
                            taskViewModel.addTaskApi(data, context);
                          }
                        },
                        buttonText: 'UPDATE TASK',
                        loading: taskViewModel.loading,
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                )),
          )
        ],
      ),
    );
  }
}
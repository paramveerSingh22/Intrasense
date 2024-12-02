import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/tasks/TasksListModel.dart';
import 'package:intrasense/res/component/ButtonOrangeBorder.dart';
import 'package:intrasense/res/component/CustomDropdown.dart';
import 'package:intrasense/res/component/CustomElevatedButton.dart';
import 'package:intrasense/res/component/CustomSearchTextField.dart';
import 'package:intrasense/utils/Utils.dart';
import 'package:intrasense/view/myTask/CreateTask.dart';
import 'package:intrasense/view_models/tasks_view_model.dart';
import '../../model/projects/ProjectListModel.dart';
import '../../model/user_model.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../view_models/UserProvider.dart';
import '../../view_models/projects_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

import 'EditTask.dart';

class MyTaskList extends StatefulWidget {
  const MyTaskList({super.key});

  @override
  _MyTaskList createState() => _MyTaskList();
}

class _MyTaskList extends State<MyTaskList> {
  String? selectProjectName;
  String? selectProjectId;
  UserModel? _userData;
  List<TaskListModel> tasksList = [];
  bool _isLoading = false;
  List<ProjectListModel> projectList = [];
  List<String> projectNamesList = [];

  @override
  void initState() {
    getUserDetails(context);
    super.initState();
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
    getProjectsList();
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  Future<void> getProjectsList() async {
    setLoading(true);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,
        'token': _userData?.token,
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
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,
        'project_id': projectId,
        'token': _userData?.token,
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

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 20.0,
            left: 0.0,
            right: 0.0,
            bottom: 10.0, // Reserve space for the button
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 30.0,right: 20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomSearchTextField(
                              hintText: 'Search',
                              suffixIcon: SizedBox(
                                height: 16,
                                width: 16,
                                child: Image.asset(Images.searchIconOrange),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: SizedBox(
                              height: 45,
                              width: 45,
                              child: Image.asset(Images.filterIcon),
                            ),
                            onPressed: () {
                              // Filter action
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 0.0),
                          child: Text(
                            'My Tasks List',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.secondaryOrange,
                              fontFamily: 'PoppinsMedium',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    color: AppColors.lightBlue,
                    padding: const EdgeInsets.only(left: 26.0,right: 26.0),
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
                        const SizedBox(height: 10),
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
                                item: item,
                                onDelete: () {
                                  deleteTaskApi(
                                      context, item.taskId.toString());
                                },
                                onTaskUpdated: () {
                                  getTasksList(
                                      selectProjectId.toString());
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 10.0,
                  child:
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26.0),
                    child: CustomElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateTask()),
                        );
                        if (result == true) {
                          getTasksList(selectProjectId.toString());
                        }
                      },
                      buttonText: 'CREATE TASK',
                    ),
                  ),
                )
              ],
            ),


          ),


        ],
      ),
    );
  }

  void deleteTaskApi(BuildContext context, String taskId) async {
    Utils.showLoadingDialog(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUserData();
    try {
      Map data = {
        'user_id': userProvider.user?.data?.userId,
        'usr_role_track_id': userProvider.user?.data?.roleTrackId,
        'usr_customer_track_id': userProvider.user?.data?.customerTrackId,
        'task_id': taskId,
        'token': userProvider.user?.token,
      };
      final taskViewModel = Provider.of<TasksViewModel>(context, listen: false);
      await taskViewModel.deleteTaskApi(data, context);
      Utils.hideLoadingDialog(context);
      Navigator.pop(context);
      getTasksList(selectProjectId.toString());
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete this client')),
      );
      Utils.hideLoadingDialog(context);
    }
  }
}

class CustomMyTaskListTile extends StatelessWidget {
  final TaskListModel item;
  final Function onDelete;
  final VoidCallback onTaskUpdated;

  const CustomMyTaskListTile({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onTaskUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TasksViewModel>(context);
    if (item.taskDetail == null || item.taskDetail!.isEmpty) {
      return const SizedBox();
    }

    String getStatusText(String status) {
      switch (status) {
        case "1":
          return 'PENDING';
        case "2":
          return 'IN PROGRESS';
        case "3":
          return 'COMPLETED';
        case "4":
          return 'CANCEL';
        default:
          return 'CANCEL';
      }
    }

    void deleteDialog(BuildContext context) {
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
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 12.0, left: 10.0, right: 15.0),
                      // Adjust the padding value as needed
                      child: Text(
                        'Delete Task',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryOrange,
                          fontFamily: 'PoppinsMedium',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                Images.deleteIconAlert,
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Delete Task!',
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.skyBlueTextColor,
                          fontFamily: 'PoppinsRegular'),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Are you sure, you want to delete this task?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.black,
                          fontFamily: 'PoppinsRegular',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Expanded(
                        flex: 10,
                        child: ButtonOrangeBorder(
                          onPressed: () {
                            onDelete();
                          },
                          buttonText: 'YES',
                          loading: taskViewModel.loading,
                        )),
                    Expanded(flex: 1, child: Container()),
                    Expanded(
                        flex: 10,
                        child: CustomElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          buttonText: 'NO',
                        ))
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          );
        },
      );
    }

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: Colors.white, // White color set kiya gaya hai
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 15,
                          child: Text(
                          "[""${item.taskDetail![0].taskUniqueId} - ${item.taskDetail![0].projectShortName}""]",
                            style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.skyBlueTextColor,
                                fontFamily: 'PoppinsRegular'),
                          )),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTapDown: (TapDownDetails details) {
                            showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(
                                details.globalPosition.dx,
                                details.globalPosition.dy,
                                details.globalPosition.dx,
                                details.globalPosition.dy + 20,
                              ),
                              items: [
                                const PopupMenuItem(
                                  value: 1,
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
                                  value: 2,
                                  child: Text('Delete'),
                                ),
                              ],
                            ).then((value) async {
                              if (value != null) {
                                if (value == 1) {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditTask(taskDetail: item),
                                    ),
                                  );
                                  if (result == true) {
                                    onTaskUpdated();
                                  }
                                } else {
                                  deleteDialog(context);
                                }
                              }
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Transform.translate(
                              offset: Offset(0, 8), // Move down by 8 pixels
                              child: Image.asset(
                                Images.threeDotsRed,
                                width: 20.0,
                                height: 20.0,
                              ),
                            ),
                          ),
                        ),
                      )
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
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                          width: 100,
                          child: const Text(
                            'Client',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                      Text(
                        item.taskDetail![0].companyName.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium',
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const DividerColor(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                          width: 100,
                          child: const Text(
                            'Project',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                      Text(
                        item.taskDetail![0].projectName.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium',
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const DividerColor(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                          width: 100,
                          child: const Text(
                            'Start Date',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                      Text(
                        item.taskDetail![0].taskStartDate.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium',
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const DividerColor(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                          width: 100,
                          child: const Text(
                            'Due Date',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                      Text(
                        item.taskDetail![0].taskEndDate.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium',
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const DividerColor(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                          width: 100,
                          child: const Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                      Text(
                        getStatusText(item.taskDetail![0].taskStatus!),
                        style:  TextStyle(
                          fontSize: 14,
                          color: getStatusText(item.taskDetail![0].taskStatus!) == 'COMPLETED'
                              ? AppColors.skyBlueTextColor
                              : AppColors.secondaryOrange,
                          fontFamily: 'PoppinsMedium',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        IgnorePointer(
          ignoring: true,
          child: Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 73,
              decoration: BoxDecoration(
                color: AppColors.secondaryOrange.withOpacity(0.1),
                // Making it semi-transparent
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class DividerColor extends StatelessWidget {
  const DividerColor({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: AppColors.dividerColor,
      height: 0.5,
    );
  }
}

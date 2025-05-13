import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../model/documents/MyFoldersModel.dart';
import '../../model/projects/ProjectListModel.dart';
import '../../model/teams/EmployeesListModel.dart';
import '../../model/user_model.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomSearchTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Constants.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/documents_view_model.dart';
import '../../view_models/projects_view_model.dart';
import '../../view_models/teams_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class FragmentSharedWithMe extends StatefulWidget{
  @override
  _FragmentSharedWithMe createState() => _FragmentSharedWithMe();

}

class _FragmentSharedWithMe extends State<FragmentSharedWithMe>{
  UserModel? _userData;
  bool _isLoading = false;
  List<MyFoldersModel> myFilesList = [];
  List<MyFoldersModel> filteredList = [];
  TextEditingController searchController = TextEditingController();

  List<ProjectListModel> projectList = [];
  List<String> projectTypeNameList = [];
  String? selectProjectValue;
  String? selectProjectId;

  String? bookmarkedType="";

  List<String> documentTypeList = [
    "All",
    "Bookmarked",
    "Not Bookmarked",
  ];
  String? selectDocumentTypeValue;

  List<EmployeesListModel> employeesList = [];
  List<String> employeeNamesList = [];
  String? selectEmployeeValue;
  String? selectEmployeeId;

  @override
  void initState() {
    getUserDetails(context);
    super.initState();
    searchController.addListener(_filterList);
  }

  @override
  void dispose() {
    Utils.hideLoadingDialog(context);
    searchController.removeListener(_filterList);
    searchController.dispose();
    super.dispose();
  }

  void _filterList() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = myFilesList
          .where((item) =>
      item.name.toString().toLowerCase().contains(query) ||
          item.projectName.toString().toLowerCase().contains(query) ||
          item.userFirstname.toString().toLowerCase().contains(query)||
          item.userLastname.toString().toLowerCase().contains(query)||
          item.createdOn.toString().toLowerCase().contains(query))
          .toList();
    });
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
    getMyFilesList();
    getProjectsList();
    getEmployeesList();
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void getMyFilesList() async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'customer_id': _userData?.data?.customerTrackId,
        'deviceToken': Constants.deviceToken,
        'deviceType': Constants.deviceType,
        'doc_type': bookmarkedType,
        'project_id': selectProjectId,
        'shared_userid': selectEmployeeId,
        'token': _userData?.token,
      };
      final documentViewModel = Provider.of<DocumentsViewModel>(context, listen: false);
      final response = await documentViewModel.getSharedWithMeListApi(data, context);
      setState(() {
        if (response != null) {
          myFilesList = response.toList();
          filteredList = myFilesList;
        }
      });
      Utils.hideLoadingDialog(context);
    } catch (error, stackTrace) {
      Utils.hideLoadingDialog(context);
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load shared me list')),
      );
    } finally {
      setLoading(false);
    }
  }

  void getProjectsList() async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,
        'token': _userData?.token,
      };
      final projectsViewModel = Provider.of<ProjectsViewModel>(context, listen: false);
      final response = await projectsViewModel.getProjectListApi(data, context);
      setState(() {
        if (response != null) {
          projectList = response.toList();
          projectTypeNameList = projectList.map((item) => item.prName.toString()).toList();

        }
      });
      Utils.hideLoadingDialog(context);
    } catch (error, stackTrace) {
      Utils.hideLoadingDialog(context);
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load client list')),
      );
    } finally {
      setLoading(false);
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

  void openFilterDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        final projectViewModel = Provider.of<ProjectsViewModel>(context, listen: false);
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: AppColors.secondaryOrange.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Search by Filter',
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Select Project',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: CustomDropdown(
                  value: selectProjectValue,
                  items: projectTypeNameList,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectProjectValue = newValue;
                      selectProjectId = projectList
                          .firstWhere((item) => item.prName == newValue)
                          .projectId;
                    });
                  },
                  hint: 'Select Project',
                ),
              ),
              const SizedBox(height: 15),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Document Type',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: CustomDropdown(
                  value: selectDocumentTypeValue,
                  items: documentTypeList,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectDocumentTypeValue = newValue;
                      if(selectDocumentTypeValue=="All"){
                        bookmarkedType="";
                      }
                      else if(selectDocumentTypeValue=="Bookmarked"){
                        bookmarkedType="1";
                      }
                      else{
                        bookmarkedType="0";
                      }
                    });
                  },
                  hint: 'Select Document Type',
                ),
              ),
              const SizedBox(height: 15),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Shared To',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsMedium'),
                    )),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: CustomDropdown(
                  value: selectEmployeeValue,
                  items: employeeNamesList,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectEmployeeValue = newValue;
                      selectEmployeeId = employeesList
                          .firstWhere((item) => "${item.userFirstName} ${item.userLastName}" == newValue)
                          .empId;
                    });
                  },
                  hint: 'Select Project',
                ),
              ),
              const SizedBox(height: 15),

              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: CustomElevatedButton(
                  onPressed: () async {
                    getMyFilesList();
                    Navigator.pop(context);
                  },
                  buttonText: 'SEARCH',
                  loading: projectViewModel.loading,
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomSearchTextField(
                        controller: searchController,
                        hintText: 'Search',
                        suffixIcon: SizedBox(
                          height: 16,
                          width: 16,
                          child:
                          Image.asset(Images.searchIconOrange),
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
                        //openFilterDialog();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filteredList.isEmpty ? const Center(
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
                    : Align(
                  alignment: Alignment.topCenter,
                  child: ListView.separated(
                    padding: const EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                    itemCount: filteredList.length,
                    separatorBuilder:
                        (BuildContext context, int index) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return CustomFileListTile(
                        item: item,
                      );
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

}

class CustomFileListTile extends StatelessWidget {
  final MyFoldersModel item;

  const CustomFileListTile(
      {super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              color: Colors.white,
              border: Border.all(
                color: AppColors.dividerColor,
                width: 1.0,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.only(
                bottom: 10,
                top: 0,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 10,
                            child: Text(
                              item.name.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.skyBlueTextColor,
                                fontFamily: 'PoppinsMedium',
                              ),
                              maxLines: 1,
                            )),

                        const SizedBox(width: 20.0),
                        Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  IconButton(
                                      icon: SizedBox(
                                        height: 20.0,
                                        width: 20.0,
                                        child: Image.asset(Images.threeDotsRed),
                                      ),
                                      onPressed: () async {
                                        /* final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EventDetailScreen(
                                                      eventDetail: item)),
                                        );
                                        if (result == true) {
                                          // onTaskUpdated();
                                        }*/
                                      }),
                                ],
                              )),
                        ),

                        /* Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: SizedBox(
                                      height: 20.0,
                                      width: 20.0,
                                      child: Image.asset(Images.editIcon),
                                    ),
                                    onPressed: () async {
                                     *//* final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddEventScreen(
                                                      eventDetail: item
                                                  )
                                          )
                                      );
                                      if (result == true) {
                                        //onUpdate();
                                      }*//*
                                    },
                                  ),
                                ],
                              )),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 0.0),
                          child: Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: SizedBox(
                                      height: 20.0,
                                      width: 20.0,
                                      child: Image.asset(Images.deleteIcon),
                                    ),
                                    onPressed: () {
                                      //deleteClientPopUp(context);

                                    },
                                  ),
                                ],
                              )),
                        )*/

                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: const Text(
                              'Project Name',
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
                              item.projectName.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const DividerColor(),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                child: const Text(
                                  'Owner',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textColor,
                                    fontFamily: 'PoppinsRegular',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )),
                        ),
                        Expanded(
                            flex: 1,
                            child: Text(
                              "${item.userFirstname} ${item.userLastname}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const DividerColor(),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
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
                        Expanded(
                            flex: 1,
                            child: Text(
                              item.createdOn.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: IgnorePointer(
            ignoring: true,
            child: Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.secondaryOrange.withOpacity(0.1),
                  // Making it semi-transparent
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                  ),
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
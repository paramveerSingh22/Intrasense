import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/model/projects/ProjectListModel.dart';
import 'package:intrasense/model/projects/ProjectTypesModel.dart';
import 'package:intrasense/view/manageProjects/AddProjectScreen.dart';
import 'package:intrasense/view_models/projects_view_model.dart';

import '../../model/client_list_model.dart';
import '../../model/user_model.dart';
import '../../res/component/ButtonOrangeBorder.dart';
import '../../res/component/CustomDropdown.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../res/component/CustomSearchTextField.dart';
import '../../res/component/CustomTextField.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/UserProvider.dart';
import '../../view_models/client_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

class MyProjectListScreen extends StatefulWidget {
  @override
  _MyProjectListScreen createState() => _MyProjectListScreen();
}

class _MyProjectListScreen extends State<MyProjectListScreen> {
  UserModel? _userData;
  bool _isLoading = false;
  List<ProjectListModel> allProjectList = [];
  List<ProjectListModel> projectList = [];
  List<String> projectTypeNameList = [];
  List<ProjectListModel> filteredList = [];
  List<ClientListModel> clientList = [];
  List<String> clientNameList = [];

  List<String> projectStatusList = [
    "In Progress",
    "On Hold",
    "Complete",
    "Cancel",
  ];

  String? selectProjectValue;
  String? selectProjectId;

  String? selectClientIdValue;
  String? selectClientNameValue;

  String? selectProjectStatusValue;

  TextEditingController searchController = TextEditingController();
  final TextEditingController _filterFromDateController = TextEditingController();
  final TextEditingController _filterToDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserDetails(context);
    searchController.addListener(_filterList);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterList);
    searchController.dispose();
    super.dispose();
  }

  void _filterList() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = projectList
          .where((item) =>
      item.prName.toLowerCase().contains(query) ||
          item.clientName.toLowerCase().contains(query) ||
          item.projectManagerName.toLowerCase().contains(query)||
          item.prStartDate.toLowerCase().contains(query)||
          item.prEndDate.toLowerCase().contains(query)||
          item.prBudgetedHours.toLowerCase().contains(query)||
          item.prShortName.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
    getProjectsList(false);
    getClientList();
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  String getStatusText(String status) {
    switch (status) {
      case "In Progress":
        return '1';
      case "On Hold":
        return '2';
      case "Complete":
        return '3';
      case "Cancel":
        return '4';
      default:
        return '4';
    }
  }

  void getProjectsList(bool filter) async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,

        if(selectClientIdValue?.isNotEmpty==true)...{
          'client_id': selectClientIdValue??""
        },
        if (selectProjectId?.isNotEmpty==true)...{
          'project_id': selectProjectId??""
        },
        if(_filterFromDateController.text.isNotEmpty)...{
          'fromDate': _filterFromDateController.text.toString()
        },
        if(_filterToDateController.text.isNotEmpty)...{
          'toDate': _filterToDateController.text.toString()
        },
        if(selectProjectStatusValue?.isNotEmpty==true)...{
          'status':getStatusText(selectProjectStatusValue.toString())
        },
        'token': _userData?.token,
      };
      final projectsViewModel = Provider.of<ProjectsViewModel>(context, listen: false);
      final response = await projectsViewModel.getProjectListApi(data, context);
      setState(() {
        if (response != null) {
          projectList = response.toList();
          filteredList = projectList;
          if(filter==false){
            allProjectList = response.toList();
            projectTypeNameList = allProjectList.map((item) => item.prName).toList();
          }
        }
      });
      if(filter==true){
        Navigator.pop(context);
      }

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

  void getClientList() async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'customer_id': _userData?.data?.customerTrackId,
        'token': _userData?.token,
      };
      final clientViewModel = Provider.of<ClientViewModel>(context, listen: false);
      final response = await clientViewModel.getClientListApi(data, context);
      setState(() {
        if (response != null) {
          clientList = response.toList();
          clientNameList = clientList.map((item) => item.cmpName).toList();
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

  void deleteProjectApi(BuildContext context, String projectId) async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'project_id': projectId,
        'token': _userData?.token,
      };

      final projectViewModel = Provider.of<ProjectsViewModel>(context, listen: false);
      await projectViewModel.deleteProjectApi(data, context);
      Utils.hideLoadingDialog(context);

      Navigator.pop(context);
      getProjectsList(false);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete this client')),
      );
      Utils.hideLoadingDialog(context);
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
                      'Select Project Name',
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
                      'Select Client',
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
                  value: selectClientNameValue,
                  items: clientNameList,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectClientNameValue = newValue;
                      selectClientIdValue = clientList
                          .firstWhere((item) => item.cmpName == newValue)
                          .companyId;
                    });
                  },
                  hint: 'Select Client',
                ),
              ),
              const SizedBox(height: 15),

              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Select Status',
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
                  value: selectProjectStatusValue,
                  items: projectStatusList,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectProjectStatusValue = newValue;
                    });
                  },
                  hint: 'Select Status',
                ),
              ),
              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
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
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 10,
                        child: CustomTextField(
                          controller: _filterFromDateController,
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
                              firstDate: DateTime.now()
                                  .add(const Duration(days: -365 * 100)),
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365 * 100)),
                            );

                            if (pickedDate != null) {
                              String formattedDate =
                                  "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                              setState(() {
                                _filterFromDateController.text = formattedDate;
                              });
                            }
                          },
                        )),
                    Expanded(flex: 1, child: Container()),
                    Expanded(
                        flex: 10,
                        child: CustomTextField(
                            controller: _filterToDateController,
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
                                  _filterToDateController.text = formattedDate;
                                });
                              }
                            }))
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: CustomElevatedButton(
                  onPressed: () async {
                    getProjectsList(true);

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
                  "My Projects",
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
            bottom: 70.0,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          children: [
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "My Projects",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.secondaryOrange,
                                      fontFamily: 'PoppinsMedium'),
                                )),
                            const SizedBox(height: 10),
                            Row(
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
                                    openFilterDialog();
                                  },
                                ),
                              ],
                            ),
                          ],
                        )),
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
                        ): Align(
                          alignment: Alignment.topCenter,
                          child: ListView.separated(
                            padding: const EdgeInsets.only(top: 10.0),
                            itemCount: filteredList.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 10);
                            },
                            itemBuilder: (context, index) {
                              final item = filteredList[index];
                              return CustomProjectListTile(
                                  item: item,
                                  onDelete: () {
                                    deleteProjectApi(
                                        context, item.projectId.toString());
                                  },
                              );
                            },
                          ),
                        )
                    ),
                  ],
                )),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: CustomElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddProjectScreen()),
                  );
                  if (result == true) {
                    getProjectsList(false);
                  }
                },
                buttonText: 'ADD NEW PROJECT',
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomProjectListTile extends StatelessWidget {
  final ProjectListModel item;
  final Function onDelete;

  const CustomProjectListTile(
      {super.key, required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {

    String getStatusText(String status) {
      switch (status) {
        case "1":
          return 'IN PROGRESS';
        case "2":
          return 'ON HOLD';
        case "3":
          return 'COMPLETED';
        case "4":
          return 'CANCEL';
        default:
          return 'CANCEL';
      }
    }

    final projectViewModel = Provider.of<ProjectsViewModel>(context);

    void deleteProjectPopUp(BuildContext context) {
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
                        'Delete Project',
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
                      'Delete Project!',
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.skyBlueTextColor,
                          fontFamily: 'PoppinsRegular'),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Are you sure, you wan't be able to revert this!",
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
                          loading: projectViewModel.loading,
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

    void projectDetailDialog() {
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: AppColors.secondaryOrange.withOpacity(0.1),
                    padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PROJECT DETAIL - ${item.prName}',
                          style: const TextStyle(
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
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'Title',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              item.prName.toString(),
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'Short Name',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              item.prShortName.toString(),
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'Client',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              item.clientName.toString(),
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'Sub-Client',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              item.clientName.toString(),
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'P.O Number',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              item.prPoNumber.toString(),
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'Client Contact',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              item.prContactNumber.toString(),
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
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'Start Date',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              item.prStartDate.toString(),
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
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'Due Date',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              item.prEndDate.toString(),
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
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textColor,
                              fontFamily: 'PoppinsRegular',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            flex: 1,
                            child: Text(
                              ":",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              item.prComments.toString(),
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      );
    }

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
                              item.prShortName,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.secondaryOrange,
                                fontFamily: 'PoppinsRegular',
                              ),
                            )),
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
                                        child: Image.asset(Images.eyeIcon),
                                      ),
                                      onPressed: () async {
                                        projectDetailDialog();
                                      }),
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
                                      child: Image.asset(Images.editIcon),
                                    ),
                                    onPressed: () async {
                                       final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddProjectScreen(
                                                      projectId: item.projectId
                                                  )
                                          )
                                      );
                                      if (result == true) {
                                        //onUpdate();
                                      }
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
                                      deleteProjectPopUp(context);
                                    },
                                  ),
                                ],
                              )),
                        )
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
                              'Name',
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
                              item.prName,
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
                              'Client',
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
                              item.clientName,
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
                                  'Project Manager',
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
                              item.projectManagerName,
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
                                'Start date',
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
                              item.prStartDate,
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
                                'Delivery Date',
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
                              item.prEndDate,
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
                                'Hours',
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
                              item.prBudgetedHours,
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
                        const Expanded(
                            flex: 1,
                            child: Text(
                              'Status',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsRegular',
                                fontWeight: FontWeight.w400,
                              ),
                            )),
                        Expanded(
                            flex: 1,
                            child: Text(
                              getStatusText(item.status),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor,
                                fontFamily: 'PoppinsMedium',
                                fontWeight: FontWeight.w500,
                              ),
                            ))
                      ],
                    ),
                  )
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

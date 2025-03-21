import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/view/manageTeam/AddNewTeam.dart';
import 'package:intrasense/view/manageTeam/EditTeamScreen.dart';
import 'package:intrasense/view/manageTeam/TeamDetailScreen.dart';

import '../../model/teams/EmployeesListModel.dart';
import '../../model/user_model.dart';
import '../../res/component/ButtonOrangeBorder.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../utils/AppColors.dart';
import '../../utils/Constants.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/teams_view_model.dart';
import '../../view_models/user_view_model.dart';
import 'package:provider/provider.dart';

import '../Home/HomeScreen.dart';

class ManageTeamScreen extends StatefulWidget {
  @override
  _ManageTeamScreenState createState() => _ManageTeamScreenState();
}

class _ManageTeamScreenState extends State<ManageTeamScreen> {
  UserModel? _userData;
  List<EmployeesListModel> employeesList = [];

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
    getEmployeesList();
  }

  Future<void> getEmployeesList() async {
    Utils.showLoadingDialog(context);
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
        }
      });
    } catch (error) {
      print('Error fetching employee list: $error');
    } finally {
      Utils.hideLoadingDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            left: 30,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Manage Team",
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
                        child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Manage Team",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryOrange,
                                  fontFamily: 'PoppinsMedium'),
                            ))),
                    Expanded(
                        child: employeesList.isEmpty
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
                            : Align(
                                alignment: Alignment.topCenter,
                                child: ListView.separated(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  itemCount: employeesList.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(height: 10);
                                  },
                                  itemBuilder: (context, index) {
                                    final item = employeesList[index];
                                    return CustomTeamListTile(
                                        item: item,
                                        onListUpdated: () {
                                          getEmployeesList();
                                        },
                                        userDetail: _userData);
                                  },
                                ),
                              )),
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
                    MaterialPageRoute(builder: (context) => AddNewTeam()),
                  );
                  if (result == true) {
                    getEmployeesList();
                  }
                },
                buttonText: 'ADD NEW MEMBER',
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomTeamListTile extends StatelessWidget {
  final EmployeesListModel item;
  final VoidCallback onListUpdated;
  final userDetail;

  const CustomTeamListTile(
      {super.key,
      required this.item,
      required this.onListUpdated,
      required this.userDetail});

  void deleteTeamApi(BuildContext context, String empId) async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': userDetail?.data?.userId,
        'customer_id': userDetail?.data?.customerTrackId,
        'employee_id': empId,
        'token': userDetail?.token,
      };

      final teamsViewModel =
          Provider.of<TeamsViewModel>(context, listen: false);
      await teamsViewModel.deleteTeamApi(data, context);
      Utils.hideLoadingDialog(context);
      Navigator.pop(context);
      onListUpdated();
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

  @override
  Widget build(BuildContext context) {
    final teamViewModel = Provider.of<TeamsViewModel>(context);

    void deleteTeamPopUp(BuildContext context) {
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
                        'Delete Team Member',
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
                      'Are you sure!',
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.skyBlueTextColor,
                          fontFamily: 'PoppinsRegular'),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "you wan't be able to revert this!",
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
                            deleteTeamApi(context, item.empId.toString());
                          },
                          buttonText: 'YES',
                          loading: teamViewModel.loading,
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
                              "${item.userFirstName} ${item.userLastName}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.darkBlueTextColor,
                                fontFamily: 'PoppinsMedium',
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
                                        final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TeamDetailScreen(
                                                        employeeId:
                                                            item.empId)));
                                        if (result == true) {
                                          onListUpdated();
                                        }
                                      }),
                                ],
                              )),
                        ),
                        if (userDetail?.data?.roleTrackId==Constants.roleProjectManager||userDetail?.data?.roleTrackId==Constants.roleHR)...{
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
                                                    AddNewTeam(
                                                        employeeId:
                                                            item.empId)));
                                        if (result == true) {
                                          onListUpdated();
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
                                        deleteTeamPopUp(context);
                                      },
                                    ),
                                  ],
                                )),
                          )
                        }
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
                              'Email',
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
                              item.usrEmail.toString(),
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
                              'Mobile',
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
                              item.usrMobile.toString(),
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
                              'Designation',
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
                              item.usrDesignation.toString(),
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
                                  'Location',
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
                              '${item.usrCity} ${item.usrCountry}',
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

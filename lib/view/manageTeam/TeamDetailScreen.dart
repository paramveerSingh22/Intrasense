import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intrasense/data/network/app_url.dart';
import 'package:intrasense/utils/Utils.dart';

import '../../model/RoleListModel.dart';
import '../../model/teams/EmployeesListModel.dart';
import '../../model/user_model.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../view_models/teams_view_model.dart';
import 'package:provider/provider.dart';

import '../../view_models/user_view_model.dart';

class TeamDetailScreen extends StatefulWidget{
  final dynamic employeeId;
  const TeamDetailScreen({Key? key, this.employeeId}) : super(key: key);

  @override
  _TeamDetailScreen createState() => _TeamDetailScreen();

}

class _TeamDetailScreen extends State<TeamDetailScreen>{
  UserModel? _userData;
  bool _isLoading = false;
  EmployeesListModel? employeeDetail ;
  String? _profileImageUrl;

  List<RoleListModel> roleList = [];
  List<String> roleNamesList = [];

  @override
  void initState() {
    super.initState();
    getUserDetails(context);
  }

  Future<UserModel> getUserData() => UserViewModel().getUser();

  void getUserDetails(BuildContext context) async {
    _userData = await getUserData();
    if (kDebugMode) {
      print(_userData);
    }
   getRoleList();
  }

  void getRoleList() async {
    setLoading(true);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'token': _userData?.token,
      };
      final teamViewModel = Provider.of<TeamsViewModel>(context, listen: false);
      await teamViewModel.getRoleListApi(data, context);
      setState(() {
        roleList = teamViewModel.roleList;
        if (roleList.isNotEmpty) {
          roleNamesList = roleList.map((item) => item.roleName.toString()).toList();
        }
        getEmployeeDetail();
      });

    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load Role list')),
      );
    } finally {
      setLoading(false);
    }
  }

  void getEmployeeDetail() async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'customer_id': _userData?.data?.customerTrackId,
        'employee_id': widget.employeeId,
        'token': _userData?.token,
      };
      final teamViewModel = Provider.of<TeamsViewModel>(context, listen: false);
      final response = await teamViewModel.getEmployeeDetailApi(data, context);

      if (response != null) {
        setState(() {
          employeeDetail = response[0];
          if(employeeDetail!=null){
            _profileImageUrl = AppUrl.imageUrl + (employeeDetail?.profilePicture?.toString() ?? "");
          }
        });
      }
    }
    catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load employee detail')),
      );
    } finally {
      Utils.hideLoadingDialog(context);
    }

  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  String? _getRoleName(String? usrRoleTrackId) {
    final role = roleList.firstWhere(
          (role) => role.roleId == usrRoleTrackId
    );

    return role.roleName;  // Return the roleName if a matching role is found, else null
  }

  @override
  Widget build(BuildContext context) {
    final teamViewModel = Provider.of<TeamsViewModel>(context);
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
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 50, left: 30),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Team Detail',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'PoppinsRegular',
                        ),
                      ),
                    ],
                  ),
                ),
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
                ),
                const Positioned(
                  top: 20,
                  left: 30,
                  child: Text(
                    'Team Detail',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryOrange,
                        fontFamily: 'PoppinsMedium'),
                  ),
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
          // Scrollable content wrapped with Expanded widget
          Positioned(
            top: 140,
            left: 20,
            right: 20,
            bottom: 10,
            // Make space for the button at the bottom
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:_profileImageUrl != null
                          ? NetworkImage(_profileImageUrl.toString())  // Load image from URL
                          : AssetImage(Images.profileIcon) as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 15),
                  if(employeeDetail!=null)...{
                    Container(
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
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Name',
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
                                      "${employeeDetail?.userFirstName?.toString() ?? ""} ${employeeDetail?.userLastName?.toString() ?? ""}",
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
                            padding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Designation',
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
                                      employeeDetail?.usrDesignation?.toString() ??"",
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
                            padding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Department',
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
                                      employeeDetail?.userDepartment?.toString() ??"",
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
                            padding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Date of Joining',
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
                                      employeeDetail?.usrDoj?.toString() ??"",
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
                            padding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Role',
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
                                      _getRoleName(employeeDetail?.usrRoleTrackId.toString())??"",
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
                            padding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Manager',
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
                                      "",
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
                            padding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Emp ID',
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
                                      employeeDetail?.empId?.toString() ??"",
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
                            padding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Mobile',
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
                                      employeeDetail?.usrMobile?.toString() ??"",
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
                            padding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Email',
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
                                      employeeDetail?.usrEmail?.toString() ??"",
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
                            padding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Skype ID',
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
                                      employeeDetail?.usrSkypeId?.toString() ??"",
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
                            padding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Marriage Anniversary',
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
                                      employeeDetail?.usrDoa?.toString() ??"",
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
                            padding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Date of Birth',
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
                                      employeeDetail?.usrDob?.toString() ??"",
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
                            padding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Address 1',
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
                                      employeeDetail?.usrAddress?.toString() ??"",
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
                            padding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Address 2',
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
                                      employeeDetail?.usrAddress2?.toString() ??"",
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
                            padding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Country',
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
                                      employeeDetail?.usrCountry?.toString() ??"",
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
                            padding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'State',
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
                                      employeeDetail?.usrState?.toString() ??"",
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
                            padding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'Zipcode',
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
                                      employeeDetail?.usrZipcode?.toString() ??"",
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
                            padding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'ID Proof',
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
                                      employeeDetail?.usrDob?.toString() ??"",
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
                    )
                  }
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
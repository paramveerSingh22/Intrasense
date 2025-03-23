import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../data/network/app_url.dart';
import '../../model/client_list_model.dart';
import '../../model/teams/EmployeesListModel.dart';
import '../../model/teams/GroupListModel.dart';
import '../../model/teams/SelectedClientsModel.dart';
import '../../model/teams/SelectedEmployeesModel.dart';
import '../../model/user_model.dart';
import '../../res/component/ButtonOrangeBorder.dart';
import '../../res/component/CustomElevatedButton.dart';
import '../../utils/AppColors.dart';
import '../../utils/Images.dart';
import '../../utils/Utils.dart';
import '../../view_models/client_view_model.dart';
import '../../view_models/teams_view_model.dart';
import 'package:provider/provider.dart';

import '../../view_models/user_view_model.dart';
import 'TeamDetailScreen.dart';

class GroupDetailScreen extends StatefulWidget{

  final GroupListModel groupDetails;


  const GroupDetailScreen({super.key, required this.groupDetails});

  _GroupDetailScreen createState() => _GroupDetailScreen();

}

class _GroupDetailScreen extends State<GroupDetailScreen>{
  UserModel? _userData;
  bool isDataLoaded= false;
  List<SelectedClientsModel> clientList = [];
  List<SelectedEmployeesModel> employeeList =[];

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
    getGroupDetails();

  }

  void getGroupDetails() async {
    Utils.showLoadingDialog(context);
    try {
      Map data = {
        'user_id': _userData?.data?.userId,
        'usr_role_track_id': _userData?.data?.roleTrackId,
        'usr_customer_track_id': _userData?.data?.customerTrackId,
        'group_id': widget.groupDetails.groupId,
        'token': _userData?.token,
      };
      final teamViewModel = Provider.of<TeamsViewModel>(context, listen: false);
      final response = await teamViewModel.getGroupDetailsApi(data, context);

      if (response != null) {
        if (response is Map<String, dynamic>) {
          if (response['data'] != null && response['data'] is List) {
            employeeList =
            (response['data'] as List)
                .map((item) => SelectedEmployeesModel.fromJson(item))
                .toList();

            if (response['clientdata'] != null &&
                response['clientdata'] is List) {
              clientList =
              (response['clientdata'] as List)
                  .map((item) => SelectedClientsModel.fromJson(item))
                  .toList();
            }
          }
        }
         isDataLoaded= true;
        setState(() {});
      }
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
    }
    finally{
      Utils.hideLoadingDialog(context);
    }
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
                  "Group Detail",
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
          if(isDataLoaded)...{
            Positioned(
              top: 110.0,
              left: 0.0,
              right: 0.0,
              bottom: 20.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView( // Wrap everything in a SingleChildScrollView
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Team List",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.secondaryOrange,
                              fontFamily: 'PoppinsMedium',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Employee list section
                      employeeList.isEmpty
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
                          : Container(
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
                        child: ListView.separated(
                          shrinkWrap: true,
                          // Ensures the ListView only takes up necessary space
                          padding: const EdgeInsets.only(top: 10.0),
                          itemCount: employeeList.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            final item = employeeList[index];
                            return CustomTeamListTile(
                                item: item,
                                index: index,
                                size: employeeList.length,
                                userData: _userData
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Client list section
                      Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Client List",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.secondaryOrange,
                              fontFamily: 'PoppinsMedium',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Client list section
                      clientList.isEmpty
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
                          : Container(
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
                        child: ListView.separated(
                          shrinkWrap: true,
                          // Ensures the ListView only takes up necessary space
                          padding: const EdgeInsets.only(top: 10.0),
                          itemCount: clientList.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            final item = clientList[index];
                            return CustomClientListTile(item: item,
                                index: index,
                                size: clientList.length,
                                userData: _userData);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          }
        ],
      ),
    );
  }
}

class CustomTeamListTile extends StatelessWidget {
  final SelectedEmployeesModel item;
  final int index;
  final int size;
  final UserModel? userData;

  const CustomTeamListTile({super.key,required this.item, required this.index, required this.size, required this.userData});


  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align to the left
                    children: [
                      Text(
                        "${item.firstName} ${item.lastName}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.darkBlueTextColor,
                          fontFamily: 'PoppinsMedium',
                        ),
                      ),
                      Text(
                        item.usrDesignation,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textColor,
                          fontFamily: 'PoppinsRegular',
                        ),
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
                // Spacer to separate the two sections
                const Spacer(),
                // Icon button
                IconButton(
                  icon: SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: Image.asset(Images.dropdownRightArrow),
                  ),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TeamDetailScreen(
                                    employeeId:
                                    item.userId)));
                  },
                ),
              ],
            ),
            if (index != size - 1)...{
              const Divider(
                color: AppColors.dividerColor,
                thickness: 1,
              )
            }
            ,
          ],
        )
      ],
    );
  }
}

class CustomClientListTile extends StatelessWidget {
  final SelectedClientsModel item;
  final int index;
  final int size;
  final UserModel? userData;

  const CustomClientListTile({super.key,required this.item,
    required this.index, required this.size,
    required this.userData});

  void clientDetailPopUp(BuildContext context,ClientListModel item) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: AppColors.secondaryOrange.withOpacity(0.1),
              padding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    item.cmpName.toString(),
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
            Padding(
              padding: const EdgeInsets.all(15.0),
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
                              'Company Name',
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
                                item.cmpName.toString(),
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
                              'No of Projects',
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
                                "0",
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
                              'Industry',
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
                                item.industryName.toString(),
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
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

   void  getClientDetailApi(UserModel? userData, String? companyId) async {
      Utils.showLoadingDialog(context);
      try {
        Map data = {
          'user_id': userData?.data?.userId,
          'customer_id': userData?.data?.customerTrackId,
          'usr_role_track_id': userData?.data?.roleTrackId,
          'company_id': companyId,
          'token': userData?.token,
        };
        final clientViewModel = Provider.of<ClientViewModel>(context, listen: false);
        final response=  await clientViewModel.editClientApi(data, context);

        if (response != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            clientDetailPopUp(context, response);
          });
        }

      } catch (error) {
        if (kDebugMode) {
          print(error);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load contact list')),
        );
      }
      finally{
        Utils.hideLoadingDialog(context);
      }
    }

    return Stack(
      children: [
        Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align to the left
                    children: [
                      Text(
                        item.companyName.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.darkBlueTextColor,
                          fontFamily: 'PoppinsMedium',
                        ),
                      ),
                     const SizedBox(height: 10)
                    ],
                  ),
                ),
                // Spacer to separate the two sections
                const Spacer(),
                // Icon button
                IconButton(
                  icon: SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: Image.asset(Images.dropdownRightArrow),
                  ),
                  onPressed: () async {
                    //deleteGroupPopUp(context);
                    getClientDetailApi(userData,item.companyId);
                  },
                ),
              ],
            ),
            if(index!= size-1)...{
              const Divider(
                color: AppColors.dividerColor,
                thickness: 1,
              )
            },
          ],
        )
      ],
    );
  }

}